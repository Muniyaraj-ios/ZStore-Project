//
//  AttributedString+Extension.swift
//  ZStore
//
//  Created by Apple on 30/05/24.
//

import UIKit

extension String{
    @available(iOS 15, *)
    func setAttributedText(offer_price: String,originalPrice: String)->NSAttributedString{
        var attributedString = AttributedString(self)
        if let range1 = attributedString.range(of: offer_price) {
            attributedString[range1].font = UIFont.boldSystemFont(ofSize: 19)
        }
        
        if let range2 = attributedString.range(of: originalPrice) {
            
            /*attributedString[range2].font = UIFont.systemFont(ofSize: 14)
            attributedString[range2].strikethroughStyle = Text.LineStyle.single
            attributedString[range2].foregroundColor = UIColor.gray
            attributedString[range2].strikethroughColor = UIColor.gray*/
            
            var container = AttributeContainer()
            container.font = UIFont.systemFont(ofSize: 14)
            container.strikethroughStyle = .thick
            container.foregroundColor = UIColor.gray
            container.strikethroughColor = UIColor.gray
            attributedString[range2].setAttributes(container)
        }
        return NSAttributedString(attributedString)
    }
}
