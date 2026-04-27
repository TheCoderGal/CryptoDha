//
//  HomeView.swift
//  CryptoDha
//
//  Created by Rosh on 25/04/26.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showPortfolio = false
    @EnvironmentObject var homeVM: HomeViewModel
    
    var body: some View {
        ZStack {
            Color.theme.background
            VStack {
                header
                SearchBarView(searchText: $homeVM.searchText)
                coinList
                Spacer(minLength: 0)
            }
        }
    }
}

#Preview {
    NavigationView {
        HomeView()
            .environmentObject(Preview.dev.homeVM)
            .navigationBarHidden(true)
    }
}

extension HomeView {
    
    private var header: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(Color.theme.accent)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var coinList: some View {
        List {
            ForEach(homeVM.allcoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: showPortfolio ? true : false)
            }
        }
        .transition(.move(edge: showPortfolio ? .leading : .trailing))
    }
}
