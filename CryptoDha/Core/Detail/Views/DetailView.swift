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
                .onAppear {
                    print("Selected name \(coin.name)")
                }
                
        }
    }
}

struct DetailView: View {
    
    let coin: Coin
    @StateObject var vm: CoinDetailViewModel
    
    let columns: [GridItem] = [.init(.flexible()), .init(.flexible())]
    
    init(coin: Coin) {
        self.coin = coin
        self._vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
        print("initialising coin \(coin.name) view")
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("")
                    .frame(height: 250)
                titleView(text: "Overview")
                Divider()
                overViewGridView
                titleView(text: "Additional Details")
                Divider()
                additionalGridView
            }
            .padding()
        }
//        .navigationTitle(coin.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                toolBarTrailingItem
            }
        }
    }
}

#Preview {
        DetailView(coin: Preview.dev.coin)

}

extension DetailView {
    
    private var toolBarTrailingItem: some View {
        HStack {
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(.accent)
            CoinImageView(coin: coin)
                .frame(width: 25, height: 25)
        }
    }
    
    private func titleView(text: String) -> some View {
        Text(text)
            .font(.title)
            .bold()
            .foregroundStyle(.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overViewGridView: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 30) {
            ForEach(vm.overViewDetails) { stat in
                StatisticsView(stat: stat)
            }
        }
    }
    
    private var additionalGridView: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 30) {
            ForEach(vm.additionalDetails) { stat in
                StatisticsView(stat: stat)
            }
        }
    }
}
