//
//  Color.swift
//  CryptoDha
//
//  Created by Rosh on 25/04/26.
//

import Foundation
import SwiftUI

struct ColorTheme {
    
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")

}

extension Color {
    static let theme = ColorTheme()
}
