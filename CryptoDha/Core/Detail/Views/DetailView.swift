//
//  DetailView.swift
//  CryptoDha
//
//  Created by Rosh on 30/04/26.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: Coin?
    
    var body: some View {
        if let coin = coin {
            DetailView(coin: coin)
                
        }
    }
}

struct DetailView: View {
    
    let coin: Coin
    @StateObject var vm: CoinDetailViewModel
    
    init(coin: Coin) {
        self.coin = coin
        self._vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
        print("initialising coin \(coin.name) view")
    }
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    DetailView(coin: Preview.dev.coin)
}
