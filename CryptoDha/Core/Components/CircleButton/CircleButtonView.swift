//
//  CircleButtonView.swift
//  CryptoDha
//
//  Created by Rosh on 25/04/26.
//
import SwiftUI

struct CircleButtonView: View {
    
    let iconName: String
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundStyle(Color.theme.accent)
            .frame(width: 50, height: 50)
            .background {
                Circle()
                    .foregroundStyle(Color.theme.background)
                    
            }
            .shadow(color: Color.theme.accent.opacity(0.25), radius: 10)
            
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    Group {
        CircleButtonView(iconName: "info")
        
        CircleButtonView(iconName: "plus")
            .colorScheme(.dark)
    }
}
