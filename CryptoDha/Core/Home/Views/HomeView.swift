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

    @State private var showDetailView = false
    @State private var selectedCoin: Coin? = nil
    
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
                columnTitle
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
        .navigationDestination(isPresented: $showDetailView) {
            DetailLoadingView(coin: $selectedCoin)
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
    
    private func segue(coin: Coin) {
        selectedCoin = coin
        showDetailView = true
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(homeVM.allcoins) { coin in

                CoinRowView(coin: coin, showHoldingsColumn: showPortfolio ? true : false)
                    .onTapGesture {
                        segue(coin: coin)
                        print("Selected coin")
                    }
            }
        }
        .refreshable(action: {homeVM.reloadData()})
        .listStyle(.plain)

    }
    
    private var portfolioList: some View {
        List {
            ForEach(homeVM.portfoliocoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: showPortfolio ? true : false)
            }
        }
        .refreshable(action: {homeVM.reloadData()})
        .listStyle(.plain)
    }
    
    private var columnTitle: some View {
        HStack {
//            Image(systemName: "line.3.horizontal.decrease.circle")
////                .resizable()
//                .frame(width: 30)
//                .font(.headline)
//                .padding(.leading)
//                .contextMenu(menuItems: {
//                    List(homeVM.sortOption.allCases, id: ./self) { option in
//                        Button(action: {
//                            homeVM.sortOption = option
//                        }) {
//                            Text(option.rawValue)
//                        }
//                    }
//                })
//                .onTapGesture {
//                    <#code#>
//                }
            HStack {
                Text("Coin")
                    .font(.caption)
                    .foregroundStyle(.secondaryText)
                Image(systemName: "chevron.down")
                    .font(.caption)
                    .foregroundStyle(.secondaryText)
                    .opacity((homeVM.sortOption == .rank || homeVM.sortOption == .rankReversed) ? 1 : 0)
                    .rotationEffect(Angle(degrees: homeVM.sortOption == .rank ? 0 : 180))
            }
            .padding(.horizontal)

            .onTapGesture {
                withAnimation(.bouncy) {
                    
                    homeVM.sortOption = homeVM.sortOption == .rank ? .rankReversed : .rank
                    print("Sort option \(homeVM.sortOption)")
                }
            }
            Spacer()
            if showPortfolio {
                HStack {
                    Text("Holdings")
                        .font(.caption)
                        .foregroundStyle(.secondaryText)
                    Image(systemName: "chevron.down")
                       
                        .opacity((homeVM.sortOption == .holdings || homeVM.sortOption == .holdingsReversed) ? 1 : 0)
                        .rotationEffect(Angle(degrees: homeVM.sortOption == .holdings ? 0 : 180))
                }
                .padding(.horizontal)

                .onTapGesture {
                    withAnimation(.bouncy) {
                        homeVM.sortOption = homeVM.sortOption == .holdings ? .holdingsReversed : .holdings
                        
                        print("Sort option \(homeVM.sortOption)")
                    }
                }
            }
            Spacer()
            HStack {
                Text("Price")
                    .font(.caption)
                    .foregroundStyle(.secondaryText)
                Image(systemName: "chevron.down")
                   
                    .opacity((homeVM.sortOption == .price || homeVM.sortOption == .priceReversed) ? 1 : 0)
                    .rotationEffect(Angle(degrees: homeVM.sortOption == .price ? 0 : 180))
            }
            .padding(.horizontal)
            .onTapGesture {
                withAnimation(.bouncy) {
                    
                    homeVM.sortOption = homeVM.sortOption == .price ? .priceReversed : .price
                    print("Sort option \(homeVM.sortOption)")
                }
            }
        }
    }
}
