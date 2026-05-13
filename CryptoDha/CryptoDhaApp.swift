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
    @State private var showLaunchView = true

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : Color.theme.accent]
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : Color.theme.accent]

    }
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack {
                    HomeView()
                        .environmentObject(vm)
                        .navigationBarHidden(true)
                }
                ZStack {
                    LaunchView(showLaunchView: $showLaunchView)
                }.zIndex(2)
            }
        }
    }
}
