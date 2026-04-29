//
//  PortfolioView.swift
//  CryptoDha
//
//  Created by Rosh on 28/04/26.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var selectedCoin: Coin? = nil
    @State private var holdingQuantity: String = ""
    @State private var showCheckmark = false
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(searchText: $homeVM.searchText)
                coinsHorizontalView
                if let coin = selectedCoin {
                    VStack {
                        HStack() {
                            Text("Current price of \(coin.name):")
                            Spacer()
                            Text("\(coin.currentPrice.asCurrencyWith6DigitsInString())")
                        }
                        .font(.headline)
                        .foregroundStyle(.accent)
                        .padding()

                        Divider()
                        
                        HStack() {
                            Text("Quantity selected:")
                            Spacer()
                            TextField("Ex: 1.4", text: $holdingQuantity)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.numberPad)
                        }
                        .font(.headline)
                        .foregroundStyle(.accent)
                        .padding()
                        
                        HStack() {
                            Text("Current Value:")
                            Spacer()
                            Text("\(getCurrentValue.asCurrencyWith6DigitsInString())")
                        }
                        .font(.headline)
                        .foregroundStyle(.accent)
                        .padding()

                    }
                }
                Spacer()
            }
            .onChange(of: homeVM.searchText, { _, _ in
                removeSelectedCoin()
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "multiply")
                            .frame(width: 30)
                            .font(.headline)
                    }
                }
                ToolbarItem(placement: .topBarTrailing, content: {trailingNavButton()})
            }
        }
    }
}

#Preview {
    PortfolioView()
        .environmentObject(Preview.dev.homeVM)
}

extension PortfolioView {
    
    private var coinsHorizontalView: some View {
        ScrollView(.horizontal) {
            
            HStack(spacing: 10) {
                ForEach(homeVM.allcoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(.vertical, 10)
                        .onTapGesture(perform: {
                            withAnimation(.easeOut) {
                                selectedCoin = coin
                                print("selectedCoin: \(selectedCoin?.name ?? "")")
                            }
                        })
                        .background(content: {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear, lineWidth: 2)
                        })
                        .padding(.horizontal, 10)
                }
            }
        }
    }
    
    private var getCurrentValue: Double {
        guard let quantity = Double(holdingQuantity), let coin = selectedCoin else { return 0 }
        return quantity * coin.currentPrice
    }
    
    func trailingNavButton() -> some View {
        HStack {
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1 : 0)
            Button(action: {
                saveButtonPressed()
            }, label: {
                Text("SAVE")
            })
            .opacity((selectedCoin != nil && selectedCoin?.currentHoldings != Double(holdingQuantity)) ? 1 : 0)
        }
       
    }
    
    func saveButtonPressed() {
        guard let coin = selectedCoin, let amount = Double(holdingQuantity) else { return }
        
        //Update coredata entity
        homeVM.updatePortfolio(coin: coin, amount: amount)
        
        //animate checkmark
        withAnimation {
//            showCheckmark = true
//            removeSelectedCoin()

        }
        UIApplication.shared.endEditing()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
////            showCheckmark = false
//        })
    }
    
    func removeSelectedCoin() {
        selectedCoin = nil
        homeVM.searchText = ""
    }
    
}
