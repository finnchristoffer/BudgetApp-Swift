//
//  BudgetCategory+CoreDataClass.swift
//  BugdetApp
//
//  Created by Finn Christoffer Kurniawan on 29/01/23.
//

import Foundation
import CoreData


@objc(BudgetCategory)
public class BudgetCategory: NSManagedObject {
    var transactionTotal: Double {
        let transactionArray:[Transaction] = transactions?.toArray() ?? []
        return transactionArray.reduce(0) { next, transaction in
            next + transaction.amount
        }
    }
    
    var remainingAmout: Double {
        amount - transactionTotal
    }
}
