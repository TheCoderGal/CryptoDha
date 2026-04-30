//
//  CoinDetailViewModel.swift
//  CryptoDha
//
//  Created by Rosh on 30/04/26.
//

import Foundation
import Combine


class CoinDetailViewModel: ObservableObject {
    
    @Published var detail: CoinDetail?
    let coin: Coin
    let coinDetailDataService: CoinDetailDataService?
    private var cancellables = Set<AnyCancellable>()
    init(coin: Coin) {
        self.coin = coin
        self.coinDetailDataService = CoinDetailDataService(coin: coin)
    }
    
    func addSubscribers() {
        coinDetailDataService?.$detail
            .sink(receiveValue: { [weak self]coinDetail in
                self?.detail = coinDetail
            })
            .store(in: &cancellables)
    }
}
