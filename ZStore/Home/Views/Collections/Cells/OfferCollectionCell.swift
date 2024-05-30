//
//  OfferCollectionCell.swift
//  ZStore
//
//  Created by Apple on 27/05/24.
//

import UIKit
import SDWebImage

class OfferCollectionCell: BaseCollectionCell {
    
    let bgContainerView = UIView()
    
    let titleLbl = UILabel(text: "HDFC Bank Credit Card", textColor: .White, font: .setFont(size: 18, weight: .semibold), line: 1)
    let SubtitleLbl = UILabel(text: "Flat 10% cashback on No Cost EMI and many more benefits!", textColor: .White, font: .setFont(size: 16, weight: .regular), line: 2)
    let OfferLbl = UILabel(text: "Upto $5000 Cashback", textColor: .White, font: .setFont(size: 20, weight: .bold), line: 2)
    
    let iconBgView = UIView()
    let icon = UIImageView(cornerRadius: 0,mode: .scaleAspectFill)
    
    override func initalSetup() {
        super.initalSetup()
        addSubview(bgContainerView)
        bgContainerView.makeEdgeConstraints(toView: self,edge: .init(top: 0, left: 0, bottom: 0, right: 25))
        
        iconBgView.addSubview(icon)
        icon.makeEdgeConstraints(toView: iconBgView,edge: .init(top: 10, left: 10, bottom: 10, right: 10))
        addSubview(iconBgView)
        iconBgView.makeEdgeConstraints(top: topAnchor, leading: nil, trailing: trailingAnchor, bottom: bottomAnchor, edge: .init(top: 10, left: 0, bottom: 15, right: 0),width: 100)
        icon.image = UIImage(named: "health")
        iconBgView.backgroundColor = .WhiteOpacity
        iconBgView.cornerRadiusWithBorder(corner: 10,isBorder: false)
        
        let titleVertical = VerticalStack(arrangedSubViews: [titleLbl,SubtitleLbl,OfferLbl], spacing: 6, alignment: .leading, distribution: .fill)
        bgContainerView.addSubview(titleVertical)
        titleVertical.makeEdgeConstraints(top: bgContainerView.topAnchor, leading: bgContainerView.leadingAnchor, trailing: iconBgView.leadingAnchor, bottom: nil,edge: .init(top: 13, left: 10, bottom: 10, right: 10))
        titleVertical.bottomAnchor.constraint(lessThanOrEqualTo: bgContainerView.bottomAnchor, constant: -10).isActive = true
        bgContainerView.backgroundColor = .BlueSub
//        setGradientBackground(topColor: .BlueSub, bottomColor: .Blue)
        bgContainerView.cornerRadiusWithBorder(corner: 10, isBorder: false)
    }
    func setupConfigure(_ offer: CardOfferModel){
        titleLbl.text = offer.card_name
        SubtitleLbl.text = offer.offer_desc
        OfferLbl.text = offer.max_discount
        //print("offer image_url : \(offer.image_url)")
        guard let url = URL(string: offer.image_url) else{return}
        let place = UIImage(named: "health")
        icon.sd_setImage(with: url, placeholderImage: place)
    }
    func setupConfigure(_ offer: CardOfferEntity){
        titleLbl.text = offer.card_name
        SubtitleLbl.text = offer.offer_desc
        OfferLbl.text = offer.max_discount
        //print("offer image_url : \(offer.image_url)")
        guard let url = URL(string: offer.image_url ?? "") else{return}
        let place = UIImage(named: "health")
        icon.sd_setImage(with: url, placeholderImage: place)
    }
}

extension UIView {
    func setGradientBackground(topColor: UIColor, bottomColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
