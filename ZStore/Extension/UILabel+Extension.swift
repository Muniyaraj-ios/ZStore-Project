//
//  UILabel+Extension.swift
//  ZStore
//
//  Created by Apple on 30/05/24.
//

import UIKit

class CustomLabel: UILabel{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var intrinsicContentSize: CGSize{
        let originalContentsize = super.intrinsicContentSize
        let height = originalContentsize.height + 6
        layer.cornerRadius = height / 2
        layer.masksToBounds = true
        return CGSize(width: originalContentsize.width+14, height: height)
    }
}
    
