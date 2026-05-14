//
//  LaunchScreen.swift
//  CryptoDha
//
//  Created by Rosh on 13/05/26.
//

import SwiftUI

struct LaunchView: View {
    
   @State var loadingText: [String] = "Loading your portfolio".map { String($0)}
    @State var showLoadingText = false
    @State var counter = 0
    @State var loops = 0
    @Binding var showLaunchView: Bool

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                if showLoadingText {
                    HStack {
                        ForEach(loadingText.indices) { i in
                            Text(loadingText[i])
                                .font(.caption)
                                .foregroundStyle(Color.theme.accent)
                                .offset(y: counter == i ? -5 : 0)
                        }
                    }
                }
            }
        }
        .background(Color.theme.background)
        .onAppear {
            showLoadingText.toggle()
        }
        .onReceive(timer, perform: { output in
            withAnimation(.spring) {
                                let lastIndex = loadingText.count-1
                if lastIndex == counter {
                    counter = 0
                    loops += 1
                    if loops >= 2 {
                        showLaunchView = false
                    }
                } else {
                    counter += 1
                    
                }
              
            }
        })
    }
}

#Preview {
    LaunchView(showLaunchView: .constant(true))
}
