//
//  CommonUtility.swift
//  ZStore
//
//  Created by Apple on 27/05/24.
//

import Foundation

class CommonUtility {
    class func readJSON(forName name: JsonFile) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name.rawValue, ofType: "json") {
                return try String(contentsOfFile: bundlePath).data(using: .utf8)
            }
        } catch {
            print(error)
        }
        return nil
    }
}

enum JsonFile: String{
    case data = "data"
}
