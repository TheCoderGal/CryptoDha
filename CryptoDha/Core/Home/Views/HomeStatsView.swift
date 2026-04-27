//
//  HomeStatsView.swift
//  CryptoDha
//
//  Created by Rosh on 27/04/26.
//

import SwiftUI

struct HomeStatsView: View {
    
    @EnvironmentObject var homeVM: HomeViewModel
    @Binding var showPortfolio: Bool
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack(alignment: .top) {
                ForEach(homeVM.stats) {
                    StatisticsView(stat: $0)
                        .frame(width: UIScreen.main.bounds.width * 0.33)
                }
            }
            .frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading)
        }
    }
}

#Preview {
    HomeStatsView(showPortfolio: .constant(true))
        .environmentObject(Preview.dev.homeVM)
}
