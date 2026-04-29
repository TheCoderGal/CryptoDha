//
//  Double.swift
//  CryptoDha
//
//  Created by Rosh on 25/04/26.
//

import Foundation

extension Double {
    
    ///Converts a double into a currency with 2-6 decimal places
    /// ``` Converts 1234.56 to $1,234.56
    ///Converts 123.456 to $123.456
    ///Converts 12.3456 to $12.3456
    ///Converts 0.123456 to $0.123456
    ///```
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        formatter.numberStyle = .currency
        return formatter
    }
    
    ///Returns String of Double
    /// ``` Converts 1234.56 to "$1,234.56"
    ///Converts 0.123456 to "$0.123456"
    ///```
    func asCurrencyWith6DigitsInString() -> String {
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
    
    func asNumberStringRoundedTo2() -> String {
        return String(format: "%.2f", self)
    }
    
    func asPercentageString() -> String {
        return asNumberStringRoundedTo2() + "%"
    }
    
    /// Convert a Double to a String with K, M, Bn, Tr abbreviations.
    /// ```
    /// Convert 12 to 12.00
    /// Convert 1234 to 1.23K
    /// Convert 123456 to 123.45K
    /// Convert 12345678 to 12.34M
    /// Convert 1234567890 to 1.23Bn
    /// Convert 123456789012 to 123.45Bn
    /// Convert 12345678901234 to 12.34Tr
    /// ```
    func formattedWithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberStringRoundedTo2()
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asNumberStringRoundedTo2()
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asNumberStringRoundedTo2()
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.asNumberStringRoundedTo2()
            return "\(sign)\(stringFormatted)K"
        case 0...:
            return self.asNumberStringRoundedTo2()

        default:
            return "\(sign)\(self)"
        }
    }
}

