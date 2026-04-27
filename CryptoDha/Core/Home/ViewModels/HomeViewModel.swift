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
    @Published var searchText = ""
    private let coinDataService = CoinDataService()
    
    var cancellable = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        ///this gets updated if wither searchtext or allcoins change/update
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map (filterCoins)
            .sink { [weak self] list in
                self?.allcoins = list
            }
            .store(in: &cancellable)
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
