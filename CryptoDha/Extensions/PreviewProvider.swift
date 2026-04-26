//
//  PreviewProvider.swift
//  CryptoDha
//
//  Created by Rosh on 25/04/26.
//

import SwiftUI

extension Preview {
    
    static var dev: DevPreviewProvider {
        return DevPreviewProvider.instance
    }
}

class DevPreviewProvider {
    static var instance = DevPreviewProvider()
   
    private init() {}
    
    let coin = Coin(id: "bitcoin", symbol: "btc", name: "Bitcoin", image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579", currentPrice: 58908, marketCap: 25, marketCapRank: 1, fullyDilutedValuation: nil, totalVolume: 2317632876, high24H: 32123, low24H: 43422, priceChange24H: 3476.43, priceChangePercentage24H: 1.39234, marketCapChange24H: 6.7, marketCapChangePercentage24H: 6.7, circulatingSupply: 1213234, totalSupply: 4324, maxSupply: 3454, ath: 432, athChangePercentage: 4, athDate: "324", atl: 3242, atlChangePercentage: 3423, atlDate: "435", lastUpdated: "", sparklineIn7D: SparklineIn7D(price: [
        57812.96915967891,
        57504.33531773738,
      ]), priceChangePercentage24HInCurrency: 4, currentHoldings: 2)
    
    let homeVM = HomeViewModel()
}
