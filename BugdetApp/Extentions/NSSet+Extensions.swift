//
//  NSSet+Extensions.swift
//  BugdetApp
//
//  Created by Finn Christoffer Kurniawan on 29/01/23.
//

import Foundation

extension NSSet {
    
    func toArray<T>() -> [T] {
        let array = self.map { $0 as! T}
            return array
    }
}
