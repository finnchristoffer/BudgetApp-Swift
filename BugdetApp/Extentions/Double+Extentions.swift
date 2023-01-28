//
//  Double+Extentions.swift
//  BugdetApp
//
//  Created by Finn Christoffer Kurniawan on 28/01/23.
//

import Foundation

extension Double {
    
    func formatAsCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self)) ?? "0.00"
    }
}
