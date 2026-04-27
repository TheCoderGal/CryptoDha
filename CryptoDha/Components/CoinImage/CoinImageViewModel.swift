//
//  CoinImageViewMdel.swift
//  CryptoDha
//
//  Created by Rosh on 26/04/26.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    
    @Published var image: UIImage?
    @Published var isLoading = false
    let coinImageDataService: CoinImageDataService
    let coin: Coin
    var cancellable = Set<AnyCancellable>()
    
    
    init(coin: Coin) {
        self.coin = coin
        coinImageDataService = CoinImageDataService(coin: coin)
        self.isLoading = true
        getCoinImageData()
    }
    
    func getCoinImageData() {
        coinImageDataService.$image
            .sink { [weak self]image in
                self?.isLoading = false
                self?.image = image
            }
            .store(in: &cancellable)
    }
    
}
