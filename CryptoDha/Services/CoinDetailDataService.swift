//
//  CoinDetailDataService.swift
//  CryptoDha
//
//  Created by Rosh on 30/04/26.
//

import Foundation
import Combine

class CoinDetailDataService {
    
    var cancellable: AnyCancellable?
    @Published var detail: CoinDetail?
    @Published var error: Error?
    let coin: Coin
    init(coin: Coin) {
        self.coin = coin
        getCoinDetail(coin: coin)
    }
    
    func getCoinDetail(coin: Coin) {
        let component: URLComponents = URLComponents(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false")!
        guard let url = component.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("CG-HP55tofR2kpRLqN5w9WUqJtY", forHTTPHeaderField: "x-cg-demo-api-key")
        cancellable =
            NetworkManager.download(url: request)
            .decode(type: CoinDetail.self, decoder: JSONDecoder())
            .sink { response in
                switch response {
                case .finished:
                    print("Finished")
                case .failure(let error):
                    self.error = error
                    print("Error: \(error)")
                    print("Response: \(response)")

                }
            } receiveValue: { [weak self] coinDetail in
                self?.detail = coinDetail
                self?.cancellable?.cancel()
            }
            
    }
}

