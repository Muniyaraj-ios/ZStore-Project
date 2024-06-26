//
//  Utility.swift
//  ZStore
//
//  Created by Apple on 27/05/24.
//

import UIKit

public struct Constant{
    static let ruppes = "₹"
}

extension UIColor{
    static let BlackColor = UIColor(named: "BlackColor") ?? .black
    static let WhiteColor = UIColor(named: "WhiteColor") ?? .white
    static let Black = UIColor(named: "Black") ?? .black
    static let White = UIColor(named: "White") ?? .white
    static let darkColor = UIColor(named: "darkColor") ?? .systemGray
    static let WhiteOpacity = UIColor(named: "WhiteOpacity") ?? .systemGray
    static let Green = UIColor(named: "Green") ?? .systemGray
    static let Orange = UIColor(named: "Orange") ?? .systemGray
    static let OrangeBg = UIColor(named: "OrangeBg") ?? .systemGray
    static let Blue = UIColor(named: "Blue") ?? .systemGray
    static let BlueSub = UIColor(named: "BlueSub") ?? .systemGray
}
extension Double{
    func removeZerosFromEnd(min minVal: Int = 0,max maxVal: Int = 2) -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = minVal
        formatter.maximumFractionDigits = maxVal
        return String(formatter.string(from: number) ?? "")
    }
}
