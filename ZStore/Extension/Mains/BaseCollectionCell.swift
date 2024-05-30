//
//  BaseCollectionCell.swift
//  ZStore
//
//  Created by Apple on 27/05/24.
//

import UIKit

class BaseCollectionCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initalSetup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initalSetup(){
        backgroundColor = .clear
    }
}
