//
//  ProductColorCollectionCell.swift
//  ZStore
//
//  Created by Apple on 27/05/24.
//

import UIKit

class ProductColorCollectionCell: BaseCollectionCell {
    
    lazy var colorView: UIView = UIView()
    
    override func initalSetup() {
        super.initalSetup()
        addSubview(colorView)
        colorView.makeEdgeConstraints(toView: self,edge: .init(top: 0, left: 0, bottom: 0, right: 0))
        colorView.cornerRadiusWithBorder(isRound: true,isBorder: false)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        colorView.cornerRadiusWithBorder(isRound: true,isBorder: false)
    }
    
    static var colorNames: [String: UIColor]{
        get{
            [
                "black" : .black,
                "green" : .green,
                "blue" : .blue,
                "orange" : .orange,
                "white" : .white,
                "gray" : .gray,
                "yellow" : .yellow,
                "red" : .red,
                "purple" : .purple,
                "maroon" : .brown,
                "teal" : .systemTeal,
            ]
        }
    }
}
