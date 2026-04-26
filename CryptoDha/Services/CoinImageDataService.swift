//
//  CoinImageDataService.swift
//  CryptoDha
//
//  Created by Rosh on 26/04/26.
//

import Combine
import Foundation

class CoinImageDataService {
    
    let coin: Coin
    var cancellable: AnyCancellable?
    @Published var error: Error?
    @Published var imageData: Data?
    
    init(coin: Coin) {
        self.coin = coin
        self.fetchCoinImageData()
        
    }
    
    func fetchCoinImageData() {
        guard let url = URL(string: coin.image) else { return }
        let urlRequest = URLRequest(url: url)
        cancellable = NetworkManager.download(url: urlRequest).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self.error = error
            }
        }, receiveValue: { [weak self] data in
            self?.imageData = data
            self?.cancellable?.cancel()
        })
        
    }
    
}
