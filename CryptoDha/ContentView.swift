//
//  ContentView.swift
//  CryptoDha
//
//  Created by Rosh on 25/04/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .foregroundStyle(Color.theme.red)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
