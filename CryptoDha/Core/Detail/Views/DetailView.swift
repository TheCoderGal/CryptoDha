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
    @State var didReadMore = false
    
    let columns: [GridItem] = [.init(.flexible()), .init(.flexible())]
    
    init(coin: Coin) {
        self.coin = coin
        self._vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
        print("initialising coin \(coin.name) view")
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                ChartView(coin: coin)
                titleView(text: "Overview")
                Divider()
                VStack(alignment: .leading) {
                    Text(vm.coinDetailDescription)
                        .font(.callout)
                        .foregroundStyle(Color.theme.secondaryText)
                        .lineLimit(didReadMore ? nil : 3)
                    Button(action: {
                        withAnimation(.easeInOut) {
                            didReadMore.toggle()
                        }
                    }) {
                        Text(didReadMore ? "See less..." : "Read More...")
                            .font(.caption)
                            .foregroundStyle(.blue)
                    }
                }
                overViewGridView
                titleView(text: "Additional Details")
                Divider()
                additionalGridView
                if let link = vm.websiteURL, let url = URL(string: link) {
                    Link(destination: url) {
                        Text("Website")
                            .font(.caption)
                            .foregroundStyle(.blue)
                    }
                }
                if let link = vm.redditURL, let url = URL(string: link) {
                    Link(destination: url) {
                        Text("Reddit")
                            .font(.caption)
                            .foregroundStyle(.blue)
                    }
                }
            }
            .padding()
        }
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
