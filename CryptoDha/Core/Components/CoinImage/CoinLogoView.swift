//
//  CoinLogoView.swift
//  CryptoDha
//
//  Created by Rosh on 28/04/26.
//

import SwiftUI

struct CoinLogoView: View {
    let coin: Coin
    var body: some View {
        VStack(alignment: .center) {
            CoinImageView(coin: coin)
                .frame(width: 50, height: 50)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(coin.name)
                .font(.caption)
                .foregroundStyle(.secondaryText)
        }
    }
}

#Preview {
    CoinLogoView(coin: Preview.dev.coin)
}
