//
//  RegularExpression.swift
//  AccountBook
//
//  Created by 김동준 on 2022/05/06.
//

import Foundation

protocol WriteExpressionCheckable{
    func checkPrice(price: String) -> Bool
}
struct RegularExpression{
    private func isPriceExpression(price: String) -> Bool{
        let regEx: String = "^[0-9]*$"
        let regExTest = NSPredicate(format:"SELF MATCHES %@", regEx)
        return regExTest.evaluate(with: price)
    }
}
extension RegularExpression: WriteExpressionCheckable{
    func checkPrice(price: String) -> Bool{
        return isPriceExpression(price: price)
    }
}
