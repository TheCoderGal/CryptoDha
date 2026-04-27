//
//  StatisticsView.swift
//  CryptoDha
//
//  Created by Rosh on 27/04/26.
//

import SwiftUI

struct StatisticsView: View {
    
    let stat: Statistics
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(stat.title)
                .font(.caption)
                .foregroundStyle(.secondaryText)
            Text(stat.value)
                .font(.headline)
            if let delta = stat.percentageChange {
                HStack(spacing: 0) {
                    Image(systemName: "triangle.fill")
                        .rotationEffect(Angle(degrees: delta >= 0.0 ? 0 : 180))
                        .font(.caption)
                    Text("\(delta.asNumberStringRoundedTo2()) %")
                       
                        .font(.caption)
                }
                .foregroundStyle(delta >= 0.0 ? Color.theme.green : Color.theme.red)
            }
        }
    }
}

#Preview {
    StatisticsView(stat: Preview.dev.stat)
}
