//
//  Currency.swift
//  PlatziFinanzas
//
//  Created by Adan Reséndiz on 2/19/19.
//  Copyright © 2019 Adan Reséndiz. All rights reserved.
//

import Foundation

extension Numeric {
    func toCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        guard let formatted = formatter.string(from: self as! NSNumber) else {
            return "\(self)"
        }
        
        return formatted
    }
}
