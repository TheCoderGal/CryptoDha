//
//  UIApplication.swift
//  CryptoDha
//
//  Created by Rosh on 27/04/26.
//

import UIKit

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
