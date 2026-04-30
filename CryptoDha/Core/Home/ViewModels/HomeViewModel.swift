//
//  HomeViewModel.swift
//  CryptoDha
//
//  Created by Rosh on 25/04/26.
//

import SwiftUI
import Combine

enum SortOption: CaseIterable, Hashable {
    case rank, rankReversed, price, priceReversed, holdings, holdingsReversed
}

class HomeViewModel: ObservableObject {
    
    @Published var allcoins: [Coin] = []
    @Published var portfoliocoins: [Coin] = []
    @Published var searchText = ""
    @Published var stats: [Statistics] = []
    @Published var sortOption: SortOption = .rank
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()

    var cancellable = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        //subscribing search & all markets coins data fetch updates
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map (filterAndSort)
            .sink { [weak self] list in
                self?.allcoins = list
            }
            .store(in: &cancellable)
        
        //subscribing portfolio updates
        $allcoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapPortfolioEntitiesToCoins)
            .sink { [weak self] coins in
                guard let self = self else { return }
                self.portfoliocoins = self.sortIfNeeded(coins: coins, by: sortOption)
            }
            .store(in: &cancellable)
        
        //subscribing global market data updates
        marketDataService.$marketData
            .combineLatest($portfoliocoins)
            .map(mapGlobalDataToStats)
            .sink { [weak self] stats in
                self?.stats = stats
            }
            .store(in: &cancellable)
    }
    
    func sortIfNeeded(coins: [Coin], by sort: SortOption) -> [Coin] {
        switch sort {
        case .holdings:
           return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        case .holdingsReversed:
           return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        default:
            return coins
        }
    }
    
    func reloadData() {
        coinDataService.fetchAllCoins()
        marketDataService.getMarketData()
    }
    
    private func mapGlobalDataToStats(marketData: MarketDataModel?, portfolioCoins: [Coin]) -> [Statistics] {
        var stats = [Statistics]()
        guard let data = marketData else { return [] }
        let marketCap = Statistics(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        stats.append(marketCap)


        let volume = Statistics(title: "24h Volume", value: data.volume)
        
        stats.append(volume)
        let btcDominance = Statistics(title: "BTC Dominance", value: data.btcDominance, percentageChange: data.marketCapChangePercentage24HUsd)
        stats.append(btcDominance)
        
        let portfolioValue =
            portfolioCoins
            .map({$0.currentHoldingsValue})
            .reduce(0, +)
        
        let previousValue = portfolioCoins
            .map{( coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
                let previousValue = currentValue/(1+percentChange)
                return previousValue
            }
            .reduce(0, +)

        let percentChange = ((portfolioValue-previousValue)/previousValue) * 100
        
        let portfolio = Statistics(title: "Portfolio", value: "\(portfolioValue.asNumberStringRoundedTo2())", percentageChange: percentChange)
        stats.append(portfolio)

        
        return stats
    }
    
    private func mapPortfolioEntitiesToCoins(coins: [Coin], entities: [PortfolioEntity]) -> [Coin] {
        coins
            .compactMap { coin in
                guard let entity = entities.first(where: {$0.coinID == coin.id}) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updateSavedEntity(coin: coin, amount: amount)
    }
    
    private func filterAndSort(text: String, coins: [Coin], sort: SortOption) -> [Coin] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        self.sortCoins(&updatedCoins, by: sort)
        return updatedCoins
    }
    
    //This is employed on allCoins, hence holdings doesnt hold any value
    func sortCoins(_ coins: inout [Coin], by sort: SortOption) {
        switch sort {
        case .rank, .holdings:
             coins.sort { $0.rank < $1.rank }
        case .price:
             coins.sort { $0.currentPrice < $1.currentPrice }
        case .rankReversed, .holdingsReversed:
             coins.sort { $0.rank > $1.rank }
        case .priceReversed:
             coins.sort { $0.currentPrice > $1.currentPrice }
        }
    }
    
    private func filterCoins(text: String, coins: [Coin]) -> [Coin] {
        guard !text.isEmpty else {
            return coins
        }
        let lowercasedText = text.lowercased()
        return coins.filter { coin in
            coin.id.lowercased().contains(lowercasedText) || coin.symbol.lowercased().contains(lowercasedText) || coin.name.lowercased().contains(lowercasedText)
        }
    }
}
