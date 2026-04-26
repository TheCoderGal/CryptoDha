//
//  CoinRowView.swift
//  CryptoDha
//
//  Created by Rosh on 25/04/26.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: Coin
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack {
            leftColumn
            Spacer()
            if showHoldingsColumn {
                middleColumn
            }
            rightColumn
        }
        .font(.subheadline)
    }
}

#Preview {
    CoinRowView(coin: Preview.dev.coin, showHoldingsColumn: true)
}


extension CoinRowView {
    
    private var leftColumn: some View {
        HStack {
            Text("\(coin.rank)")
                .foregroundStyle(Color.theme.secondaryText)
                .font(.caption)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .frame(minWidth: 30)

        }
    }
    
    private var middleColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith6DigitsInString())
            Text((coin.currentHoldings ?? 0).asNumberStringRoundedTo2())
        }
        .foregroundStyle(Color.theme.accent)
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6DigitsInString())
            Text(coin.priceChangePercentage24H?.asPercentageString() ?? "")
                .foregroundStyle((coin.priceChangePercentage24HInCurrency ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
        }
        .frame(width: UIScreen.main.bounds.width/3.5, alignment: .trailing)
    }
}
