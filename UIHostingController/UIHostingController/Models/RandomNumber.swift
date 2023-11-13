//
//  TableModel.swift
//  UITableView
//
//  Created by 김건우 on 11/5/23.
//

import Foundation

struct RandomNumber {
    let tensDigit: Int
    var numbers: [Int] = []
    
    static func generateData() -> [RandomNumber] {
        var randomNumbers = [RandomNumber]()
        
        var numbers = [Int]()
        for _ in 0...100 {
            numbers.append(Int.random(in: 1...99))
        }
        
        for index in 0...9 {
            var randomNumber = RandomNumber(tensDigit: index)
            randomNumber.numbers.append(contentsOf: numbers.filter({
                return ($0 / 10) == index
            }))
            randomNumbers.append(randomNumber)
        }
        
        return randomNumbers
    }
}
