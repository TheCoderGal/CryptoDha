//
//  HomeViewModel.swift
//  CryptoDha
//
//  Created by Rosh on 25/04/26.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allcoins: [Coin] = []
    @Published var portfoliocoins: [Coin] = []

    @Published var searchText = ""
    @Published var stats: [Statistics] = []
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
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map (filterCoins)
            .sink { [weak self] list in
                self?.allcoins = list
            }
            .store(in: &cancellable)
        
        //subscribing global market data updates
        marketDataService.$marketData
            .map({ (marketData) -> [Statistics] in
                var stats = [Statistics]()
                guard let data = marketData else { return [] }
                let marketCap = Statistics(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
                stats.append(marketCap)


                let volume = Statistics(title: "24h Volume", value: data.volume)
                
                stats.append(volume)
                let btcDominance = Statistics(title: "BTC Dominance", value: data.btcDominance, percentageChange: data.marketCapChangePercentage24HUsd)
                stats.append(btcDominance)

                let portfolio = Statistics(title: "Portfolio", value: "0.00", percentageChange: 0)
                stats.append(portfolio)

                
                return stats
            })
            .sink { stats in
                self.stats = stats
            }
            .store(in: &cancellable)
        
        //subscribing portfolio updates
        $allcoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map{(coins, entities) -> [Coin] in
                coins
                    .compactMap { coin in
                        guard let entity = entities.first(where: {$0.coinID == coin.id}) else {
                            return nil
                        }
                        return coin
                    }
            }
            .sink { coins in
                self.portfoliocoins = coins
            }
            .store(in: &cancellable)
           
    }
    
    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updateSavedEntity(coin: coin, amount: amount)
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
