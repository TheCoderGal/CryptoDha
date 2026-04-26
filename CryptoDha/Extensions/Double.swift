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
}

