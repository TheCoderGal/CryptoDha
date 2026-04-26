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
    private let coinDataService = CoinDataService()
    
    var cancellable = Set<AnyCancellable>()
    
    init() {
        getAllCoins()
    }
    
    func getAllCoins() {
        coinDataService.$allCoins.sink {[weak self]coins in
            self?.allcoins = coins
        }
        .store(in: &cancellable)
    }
    
}
