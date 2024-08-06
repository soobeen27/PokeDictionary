//
//  Extension.swift
//  PokeDictionary
//
//  Created by Soo Jang on 8/6/24.
//

import UIKit

extension UIColor {
    static let mainRed = UIColor(red: 190/255, green: 30/255, blue: 40/255, alpha: 1.0)
    static let darkRed = UIColor(red: 120/255, green: 30/255, blue: 30/255, alpha: 1.0)
    static let cellBackground = UIColor(red: 245/255, green: 245/255, blue: 235/255, alpha: 1.0)
}

extension String {
    var getPokeID: String? {        
        guard let num = self.split(separator: "/").last else { return nil}
        return String(num)
    }
}
