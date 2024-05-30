//
//  CategoryCollectionCell.swift
//  ZStore
//
//  Created by Apple on 27/05/24.
//

import UIKit

class CategoryCollectionCell: BaseCollectionCell {
    
    let bgView = UIView()
    let categoryLbl = UILabel(text: "Books", textColor: .darkColor, font: .setFont(size: 15, weight: .medium))
    
    var isChoosed: Bool = false{
        didSet{
            bgView.cornerRadiusWithBorder(isRound: true,borWidth: 1,borColor: isChoosed ? .Orange : .lightGray)
            categoryLbl.textColor = isChoosed ? .Orange : .darkColor
            bgView.backgroundColor = isChoosed ? .OrangeBg : .clear
        }
    }
    override func initalSetup() {
        super.initalSetup()
        bgView.addSubview(categoryLbl)
        categoryLbl.makeEdgeConstraints(toView: bgView,edge: .init(top: 6, left: 10, bottom: 6, right: 10))
        addSubview(bgView)
        bgView.makeEdgeConstraints(toView: self,edge: .init(top: 5, left: 5, bottom: 5, right: 5))
        bgView.cornerRadiusWithBorder(isRound: true,borWidth: 1,borColor: .lightGray)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.cornerRadiusWithBorder(isRound: true,borWidth: 1,borColor: isChoosed ? .Orange : .lightGray)
    }
}
extension UIView{
    func cornerRadiusWithBorder(corner radius: CGFloat = 8,isRound: Bool = false,isBorder: Bool = true,borWidth borderWidth: CGFloat = 1,borColor borderColor: UIColor = .darkColor){
        layer.cornerRadius = isRound ? (layer.frame.height / 2) : radius
        if isBorder{
            layer.borderWidth = borderWidth
            layer.borderColor = borderColor.cgColor
        }
//        clipsToBounds = true
    }
}
