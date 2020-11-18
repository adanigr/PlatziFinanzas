//
//  Shadow.swift
//  PlatziFinanzas
//
//  Created by Adan Reséndiz on 1/31/19.
//  Copyright © 2019 Adan Reséndiz. All rights reserved.
//

import UIKit

extension UIView {
    var borderUIColor: UIColor{
        get{
            guard  let color = layer.borderColor else {
                return UIColor.black
            }
            return UIColor(cgColor: color)
        }
        set{
            layer.borderColor = newValue.cgColor
        }
    }
}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//extension Float {
//    var convertAsLocaleCurrency :String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.locale = Locale.current
//        return formatter.string(from: self as NSNumber)!
//    }
//}
