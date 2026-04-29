//
//  SearchBarView.swift
//  CryptoDha
//
//  Created by Rosh on 27/04/26.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.accent)
                .padding()
            TextField("Search by Coin name...", text: $searchText)
                .font(.subheadline)
                .foregroundStyle(.accent)
                .overlay (
                    Image(systemName: "xmark")
                        .padding()
                        .foregroundStyle(.accent)
                        .opacity(searchText.isEmpty ? 0 : 1)
                        .onTapGesture {
                            searchText = ""
                            UIApplication.shared.endEditing()
                        }
                    , alignment: .trailing)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.theme.background)
                .shadow(color: .accent.opacity(0.15), radius: 5, x: 0, y: 0)
        )
        .font(.headline)
        .padding()

    }
}

#Preview{
    Group {
        SearchBarView(searchText: .constant(""))
            .colorScheme(.light)
        SearchBarView(searchText: .constant(""))
            .colorScheme(.dark)

    }
        
}
