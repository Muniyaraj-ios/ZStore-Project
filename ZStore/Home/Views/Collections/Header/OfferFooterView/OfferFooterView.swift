//
//  OfferFooterView.swift
//  ZStore
//
//  Created by Apple on 27/05/24.
//

import UIKit

class OfferFooterView: UICollectionReusableView {
    
    lazy var appliedLbl = UILabel(text: "Applied: ", textColor: .BlackColor, font: .systemFont(ofSize: 15, weight: .regular))
    lazy var selectedOfferLbl = UILabel(text: "HDFC Bank Credit Card", textColor: .Blue, font: .systemFont(ofSize: 15, weight: .regular))
    lazy var cancelBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        button.tintColor = .BlueSub
        return button
    }()
    lazy var HoriStack = HorizontalStack(arrangedSubViews: [appliedLbl,selectedOfferLbl,cancelBtn], spacing: 3, alignment: .center, distribution: .fill)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        HoriStack.layoutMargins = .init(top: 3, left: 12, bottom: 3, right: 12)
        HoriStack.clipsToBounds = true
        
        HoriStack.isLayoutMarginsRelativeArrangement = true
        addSubview(HoriStack)
        HoriStack.makeEdgeConstraints(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor,edge: .init(top: 10, left: 6, bottom: 10, right: 8))
        HoriStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10).isActive = true
        cancelBtn.equalSizeConstrinats(20)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        HoriStack.cornerRadiusWithBorder(isRound: true, isBorder: true, borWidth: 2, borColor: .BlueSub)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
