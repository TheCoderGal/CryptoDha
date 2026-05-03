//
//  CoinDetailViewModel.swift
//  CryptoDha
//
//  Created by Rosh on 30/04/26.
//

import Foundation
import Combine


class CoinDetailViewModel: ObservableObject {
    
    @Published var additionalDetails: [Statistics] = []
    @Published var overViewDetails: [Statistics] = []

    @Published var coin: Coin
    
    let coinDetailDataService: CoinDetailDataService?
    private var cancellables = Set<AnyCancellable>()
    init(coin: Coin) {
        self.coin = coin
        self.coinDetailDataService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    func addSubscribers() {
        coinDetailDataService?.$detail
            .combineLatest($coin)
            .map(mapDetailsToStatsView)
            .sink(receiveValue: { [weak self] returnedArrays in
                self?.overViewDetails = returnedArrays.overView
                self?.additionalDetails = returnedArrays.additional
            })
            .store(in: &cancellables)
    }
    
    private func getOverViewData(coin: Coin) -> [Statistics] {
        var overViewDetails: [Statistics] = []
        
        let price = coin.currentPrice.asCurrencyWith6DigitsInString()
        let percentChange = coin.priceChangePercentage24H
        let priceStat = Statistics(title: "Current Price", value: price, percentageChange: percentChange)
        
        let marketCap = coin.marketCap?.formattedWithAbbreviations() ?? ""
        let marketChange = coin.marketCapChangePercentage24H
        let marketCapStat = Statistics(title: "Market Capitalization", value: marketCap, percentageChange: marketChange)
        
        let rank = "\(coin.rank)"
        let rankStat = Statistics(title: "Rank", value: rank)
        
        let volume = "\(coin.totalVolume?.formattedWithAbbreviations() ?? "")"
        let volStat = Statistics(title: "Volume", value: volume)
        
        overViewDetails.append(contentsOf: [priceStat, marketCapStat, rankStat, volStat])
        return overViewDetails
    }
    
    private func getAdditionalDetailsData(coinDetail: CoinDetail?, coin: Coin) -> [Statistics] {
        var additionalDetails: [Statistics] = []

        let high =  coin.high24H?.asCurrencyWith6DigitsInString() ?? "n/a"
        let highStat = Statistics(title: "High", value: high)

        let low =  coin.low24H?.asCurrencyWith6DigitsInString() ?? "n/a"
        let lowStat = Statistics(title: "Low", value: low)

        let priceChange =  coin.priceChange24H?.asCurrencyWith6DigitsInString() ?? "n/a"
        let pricePercentChange = coin.priceChangePercentage24H
        let priceChangeStat = Statistics(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange)
        
        let marketCapChange =  coin.marketCapChange24H?.asCurrencyWith6DigitsInString() ?? "n/a"
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        let marketCapChangeStat = Statistics(title: "24h MarketCap Change", value: marketCapChange, percentageChange: marketCapPercentChange)
        
        let blockTime = coinDetail?.blockTimeInMinutes ?? 0
        let blockTimeStr = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockTimeStat = Statistics(title: "Block Time", value: blockTimeStr)

        let hashing = coinDetail?.hashingAlgorithm ?? "n/a"
        let hashingStat = Statistics(title: "Hashing Algo", value: hashing)
        additionalDetails.append(contentsOf: [highStat, lowStat, priceChangeStat, marketCapChangeStat, blockTimeStat, hashingStat])

        return additionalDetails
    }
    
    private func mapDetailsToStatsView(coinDetail: CoinDetail?, coin: Coin) -> (overView: [Statistics], additional: [Statistics]) {
        let overView = getOverViewData(coin: coin)
        let additional = getAdditionalDetailsData(coinDetail: coinDetail, coin: coin)
        return (overView: overView, additional: additional)
    }
}
