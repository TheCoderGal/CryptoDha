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
    @State private var editPortfolio = false

    var body: some View {
        ZStack {
            Color.theme.background
                .sheet(isPresented: $editPortfolio) {
                    PortfolioView()
                }
            VStack {
                header
                HomeStatsView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $homeVM.searchText)
                if !showPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))

                } else {
                    portfolioList
                        .transition(.move(edge: .trailing))
                }
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
                .onTapGesture {
                    if showPortfolio {
                        editPortfolio = true
                    }
                }
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
    
    private var allCoinsList: some View {
        List {
            ForEach(homeVM.allcoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: showPortfolio ? true : false)
            }
        }
    }
    
    private var portfolioList: some View {
        List {
            ForEach(homeVM.portfoliocoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: showPortfolio ? true : false)
            }
        }
    }
}
