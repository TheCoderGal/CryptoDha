//
//  Statistics.swift
//  CryptoDha
//
//  Created by Rosh on 27/04/26.
//

import Foundation

struct Statistics: Identifiable, Codable {
    var id = UUID().uuidString
    var title: String
    var value: String
    var percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}
