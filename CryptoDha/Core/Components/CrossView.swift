//
//  CrossView.swift
//  CryptoDha
//
//  Created by Rosh on 28/04/26.
//

import SwiftUI

struct CrossView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "multiply")
                .frame(width: 30)
                .font(.headline)
        }
    }
}

#Preview {
    CrossView()
}
