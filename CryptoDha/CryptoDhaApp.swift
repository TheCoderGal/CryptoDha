//
//  CryptoDhaApp.swift
//  CryptoDha
//
//  Created by Rosh on 25/04/26.
//

import SwiftUI

@main
struct CryptoDhaApp: App {
    @StateObject private var vm = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .environmentObject(vm)
                    .navigationBarHidden(true)
            }
        }
    }
}
