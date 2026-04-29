//
//  CoinImageView.swift
//  CryptoDha
//
//  Created by Rosh on 26/04/26.
//

import SwiftUI

struct CoinImageView: View {
    @StateObject var vm: CoinImageViewModel
    
    init(coin: Coin) {
        _vm = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        if let uiimage = vm.image{
            Image(uiImage: uiimage)
                .resizable()
                .scaledToFit()
        } else if vm.isLoading {
            ProgressView()
        } else {
            Image(systemName: "questionmark")
                .foregroundStyle(.secondaryText)
        }
    }
}

#Preview {
    CoinImageView(coin: Preview.dev.coin)
}
