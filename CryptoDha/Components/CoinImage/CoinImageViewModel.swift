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
    
    @Published var imageData: Data?
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
        coinImageDataService.$imageData
            .sink { [weak self]data in
                self?.isLoading = false
                self?.imageData = data
            }
            .store(in: &cancellable)
    }
    
}
