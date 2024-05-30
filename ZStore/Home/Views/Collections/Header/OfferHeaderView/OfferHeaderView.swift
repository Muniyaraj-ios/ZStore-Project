//
//  OfferHeaderView.swift
//  ZStore
//
//  Created by Apple on 27/05/24.
//

import UIKit

class OfferHeaderView: UICollectionReusableView {
    
    lazy var headIcon = UIImageView(cornerRadius: 0)
    lazy var headLbl = UILabel(text: "Offers", textColor: .Orange, font: .systemFont(ofSize: 18, weight: .semibold))
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        let horiStack = HorizontalStack(arrangedSubViews: [headIcon,headLbl], spacing: 8, alignment: .center, distribution: .fill)
        addSubview(horiStack)
        horiStack.makeEdgeConstraints(toView: self,edge: .init(top: 0, left: 12, bottom: 0, right: 0))
        headIcon.image = UIImage(systemName: "checkmark.seal.fill")
        headIcon.tintColor = .Orange
        headIcon.equalSizeConstrinats(25)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
