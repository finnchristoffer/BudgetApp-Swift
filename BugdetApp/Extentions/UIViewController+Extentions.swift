//
//  UIViewController+Extentions.swift
//  BugdetApp
//
//  Created by Finn Christoffer Kurniawan on 29/01/23.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}
