//
//  ProductItemCollectionCell.swift
//  ZStore
//
//  Created by Apple on 27/05/24.
//

import UIKit
import SDWebImage
import Cosmos

class ProductItemCollectionCell: BaseCollectionCell {
    
    lazy var productIcon = UIImageView(cornerRadius: 0, mode: .scaleAspectFill)
    
    var addEditFav: ((Bool)->Void)?
    
    let cornerFavView = UIView()
    
    let titleLbl = UILabel(text: "The Power of Your Subconscious Mind", textColor: .BlackColor, font: .setFont(size: 17.5, weight: .bold), line: 4)
    
    let ratingLbl = UILabel(text: "4.3", textColor: .orange, font: .setFont(size: 13, weight: .regular))
    let reviewLbl = UILabel(text: "(3748)", textColor: .darkColor, font: .setFont(size: 13, weight: .regular))
    
    lazy var starRatingView: CosMos = {
        let view = CosMos()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.filledImage = UIImage(named: "star.fill")
        view.emptyImage = UIImage(named: "star")
        view.filledColor = UIColor.orange
        view.emptyColor = UIColor.gray
        view.starSize = 16
        view.updateOnTouch = false
        return view
    }()
    
    let originalPriceLbl = UILabel(text: "\(Constant.ruppes)62,999", textColor: .BlackColor, font: .setFont(size: 19, weight: .bold))
    let offerPriceLbl = CustomLabel(text: "Save \(Constant.ruppes)2,000", textColor: .White, font: .setFont(size: 11.5, weight: .regular),alignment: .center)
    let deliveryInstrLbl = UILabel(text: "Free Delivery | Get by Sunday, 5 November", textColor: .darkColor, font: .setFont(size: 14, weight: .regular),line: 3)
    
    var isFavourite: Bool = false{
        didSet{
            AddfavBgView.isHidden = isFavourite
            cornerFavView.isHidden = !isFavourite
        }
    }
    
    let AddfavBgView = UIView()
    lazy var heartIcon: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(systemName: "heart")
        logo.tintColor = .darkColor
        return logo
    }()
    lazy var FavheartIcon: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(systemName: "heart.fill")
        logo.tintColor = .white
        return logo
    }()
    lazy var addFavLbl = UILabel(text: "Add to Fav", textColor: .darkColor, font: .setFont(size: 14, weight: .regular), alignment: .left, line: 1)
    
    lazy var reviewStacks = HorizontalStack(arrangedSubViews: [ratingLbl,starRatingView,reviewLbl], spacing: 3, alignment: .center, distribution: .fill)
    
    lazy var priceStacks = HorizontalStack(arrangedSubViews: [originalPriceLbl,offerPriceLbl], spacing: 3, alignment: .center, distribution: .fill)
    
    lazy var verticalStack = VerticalStack(arrangedSubViews: [titleLbl,reviewStacks,priceStacks,deliveryInstrLbl], spacing: 10, alignment: .leading, distribution: .fill)
    
    lazy var AddfavStackView = VerticalStack(arrangedSubViews: [AddfavBgView], spacing: 0, alignment: .leading, distribution: .fill)
    
    override func initalSetup() {
        super.initalSetup()
        cornerRadiusWithBorder(corner: 12, isBorder: true, borWidth: 0.5, borColor: .lightGray)
        clipsToBounds = true
        addSubview(productIcon)
        productIcon.makeEdgeConstraints(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil)
        productIcon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45).isActive = true
        productIcon.image = UIImage(named: "health")

        addSubview(verticalStack)
        verticalStack.makeEdgeConstraints(top: productIcon.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil,edge: .init(top: 12, left: 6, bottom: 0, right: 6))

//        addSubview(AddfavBgView)
        addSubview(AddfavStackView)
//        AddfavBgView.makeEdgeConstraints(top: verticalStack.bottomAnchor, leading: leadingAnchor, trailing: nil, bottom: nil,edge: .init(top: 14, left: 12, bottom: 0, right: 0))
        AddfavStackView.makeEdgeConstraints(top: verticalStack.bottomAnchor, leading: leadingAnchor, trailing: nil, bottom: nil,edge: .init(top: 14, left: 12, bottom: 0, right: 0))
//        AddfavBgView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10).isActive = true
        AddfavStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10).isActive = true

        let favStack = HorizontalStack(arrangedSubViews: [heartIcon,addFavLbl], spacing: 3, alignment: .center, distribution: .fill)
        AddfavBgView.addSubview(favStack)
        favStack.makeEdgeConstraints(toView: AddfavBgView,edge: .init(top: 8, left: 8, bottom: 8, right: 8))

        heartIcon.equalSizeConstrinats(20)
        AddfavBgView.cornerRadiusWithBorder(corner: 10, isBorder: true, borWidth: 0.8, borColor: .lightGray)

        addSubview(cornerFavView)
        cornerFavView.makeEdgeConstraints(top: topAnchor, leading: nil, trailing: trailingAnchor, bottom: nil,width: 40,height: 40)
        cornerFavView.addSubview(FavheartIcon)
        FavheartIcon.makeCenterConstraints(toView: cornerFavView)
        FavheartIcon.equalSizeConstrinats(20)

        cornerFavView.backgroundColor = .systemPink
        cornerFavView.layer.maskedCorners = [.layerMinXMaxYCorner]
        cornerFavView.layer.cornerRadius = 25
        offerPriceLbl.backgroundColor = .Green
        offerPriceLbl.lineBreakMode = .byTruncatingHead
        
        AddfavBgView.addTap { [weak self] in
            self?.addEditFav?(true)
        }
        cornerFavView.addTap { [weak self] in
            self?.addEditFav?(false)
        }
    }
    func configureUI(_ prod:ProductsDataModel){
        ratingLbl.text = prod.rating.description
        reviewLbl.text = "(\(prod.review_count.description))"
        originalPriceLbl.text = "\(Constant.ruppes)"+prod.price.description
//        offerPriceLbl.text = ""
//        offerPriceLbl.isHidden = true
        deliveryInstrLbl.text = prod.description
        titleLbl.text = prod.name
        starRatingView.rating = prod.rating
        
        AddfavBgView.isHidden = prod.isFavourite ?? false
        cornerFavView.isHidden = !AddfavBgView.isHidden
        
        guard let url = URL(string: prod.image_url) else{return}
        let place = UIImage(named: "health")
        productIcon.sd_setImage(with: url, placeholderImage: place)
    }
    func configureUI(_ prod:ProductsEntity?,sel_card_id: CardOfferEntity?){
        guard let prod = prod else{return}
        ratingLbl.text = prod.rating.description
        reviewLbl.text = "(\(prod.review_count.description))"
        setupPrice(prod, sel_card_id: sel_card_id)
        deliveryInstrLbl.text = prod.desc
        titleLbl.text = prod.name
        starRatingView.rating = prod.rating
        AddfavBgView.isHidden = prod.isFavourite
        cornerFavView.isHidden = !AddfavBgView.isHidden
        
        guard let url = URL(string: prod.image_url ?? "") else{return}
        let place = UIImage(named: "health")
        productIcon.sd_setImage(with: url, placeholderImage: place)
    }
    private func setupPrice(_ prod:ProductsEntity,sel_card_id: CardOfferEntity?){
        let card_offers = prod.card_offer_ids?.components(separatedBy: ",") ?? []
        if let sel_card_id,card_offers.contains(sel_card_id.id ?? ""){
            let originalPrice = prod.price
            let discountPercentage = sel_card_id.percentage
            
            let discountAmount = originalPrice * discountPercentage / 100
            let offerPrice = originalPrice - discountAmount
            let savedAmount = discountAmount
            let offerText = "\(Constant.ruppes)\(offerPrice.removeZerosFromEnd())"
            let originalText = "\(Constant.ruppes)\(originalPrice.removeZerosFromEnd())"
            if #available(iOS 15, *) {
                originalPriceLbl.attributedText = "\(offerText) \(originalText)".setAttributedText(offer_price: offerText, originalPrice: originalText)
            } else {
                // Fallback on earlier versions
            }
            offerPriceLbl.text = "Save \(Constant.ruppes)\(savedAmount.removeZerosFromEnd())"
            offerPriceLbl.isHidden = false
        }else{
            originalPriceLbl.text = "\(Constant.ruppes)"+prod.price.removeZerosFromEnd()
            offerPriceLbl.isHidden = true
            offerPriceLbl.text = ""
        }
    }
}
