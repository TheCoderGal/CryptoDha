//
//  CoinDataService.swift
//  CryptoDha
//
//  Created by Rosh on 25/04/26.
//

import Combine
import Foundation

/// CoinDataService fetches data from
///```https://pro-api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=bitcoin&names=Bitcoin&symbols=btc&category=layer-1&price_change_percentage=1h
///
class CoinDataService {
    
    var cancellable: AnyCancellable?
    @Published var allCoins: [Coin] = []
    @Published var error: Error?
    
    init() {
        fetchAllCoins()
    }
    
    func fetchAllCoins() {
        var components = URLComponents(string: "https://api.coingecko.com/api/v3/coins/markets")!
        
        components.queryItems = [
            URLQueryItem(name: "vs_currency", value: "usd"),
            URLQueryItem(name: "ids", value: "bitcoin"),
            URLQueryItem(name: "names", value: "Bitcoin"),
            URLQueryItem(name: "symbols", value: "btc"),
            URLQueryItem(name: "category", value: "layer-1"),
            URLQueryItem(name: "price_change_percentage", value: "1h")
            
        ]
        guard let url = components.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("CG-HP55tofR2kpRLqN5w9WUqJtY", forHTTPHeaderField: "x-cg-demo-api-key")
        cancellable = NetworkManager.download(url: request)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink { response in
                switch response {
                case .finished:
                    print("Finished")
                case .failure(let error):
                    self.error = error
                    print("Error: \(error)")
                }
            } receiveValue: { coinData in
                self.allCoins = coinData
                self.cancellable?.cancel()
            }
        
    }
    
}

