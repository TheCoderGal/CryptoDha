//
//  MarketCapDataService.swift
//  CryptoDha
//
//  Created by Rosh on 28/04/26.
//

import Foundation
import Combine

class MarketDataService {
    var cancellable: AnyCancellable?
    @Published var marketData: MarketDataModel?
    @Published var error: Error?
    
    init() {
        getMarketData()
    }
    
    func getMarketData() {
        var components = URLComponents(string: "https://api.coingecko.com/api/v3/global")!
        guard let url = components.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("CG-HP55tofR2kpRLqN5w9WUqJtY", forHTTPHeaderField: "x-cg-demo-api-key")
        cancellable = NetworkManager.download(url: request)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink { response in
                switch response {
                case .finished:
                    print("Finished")
                case .failure(let error):
                    self.error = error
                    print("Error: \(error)")
                    print("Response: \(response)")

                }
            } receiveValue: { [weak self] marketData in
                self?.marketData = marketData.data
                self?.cancellable?.cancel()
            }
        
    }
    
}
