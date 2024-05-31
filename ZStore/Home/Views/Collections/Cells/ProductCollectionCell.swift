//
//  ProductCollectionCell.swift
//  ZStore
//
//  Created by Apple on 27/05/24.
//

import UIKit
import SDWebImage

class ProductCollectionCell: BaseCollectionCell {
    
    let productIcon = UIImageView(cornerRadius: 8, mode: .scaleAspectFill)
    let bgView = UIView()
    
    let ratingLbl = UILabel(text: "4.3", textColor: .orange, font: .setFont(size: 15, weight: .regular))
    let reviewLbl = UILabel(text: "(3748)", textColor: .darkColor, font: .setFont(size: 15, weight: .regular))
    
    lazy var starRatingView: CosMos = {
        let view = CosMos()
        view.filledImage = UIImage(named: "star.fill")
        view.emptyImage = UIImage(named: "star")
        view.filledColor = UIColor.orange
        view.emptyColor = UIColor.gray
        view.updateOnTouch = false
        return view
    }()
    
    let originalPriceLbl = UILabel(text: "\(Constant.ruppes)62,999", textColor: .BlackColor, font: .setFont(size: 21, weight: .bold))
    let offerPriceLbl = CustomLabel(text: "Save \(Constant.ruppes)2,000", textColor: .White, font: .setFont(size: 11.5, weight: .regular),alignment: .center)
    
    let deliveryInstrLbl = UILabel(text: "Free Delivery | Get by Sunday, 5 November", textColor: .darkColor, font: .setFont(size: 14, weight: .regular),line: 2)
    
    let titleLbl = UILabel(text: "Samsung Galazy M14 5G (Berry Blue, 6GB, 12 GB) | 50 MO Triple Cam | Segment's ONLY 6000 mAh...", textColor: .BlackColor, font: .setFont(size: 19, weight: .bold), line: 3)
    
    lazy var proptyCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(cell: ProductColorCollectionCell.self)
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    let collectionBgView = UIView()
    
    var colorNames: [String] = []
    
    override func initalSetup() {
        super.initalSetup()
        addSubview(bgView)
        bgView.makeEdgeConstraints(toView: self)
        bgView.addSubview(productIcon)
        productIcon.makeEdgeConstraints(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil,edge: .init(top: 10, left: 10, bottom: 0, right: 0))
        
        let reviewStacks = HorizontalStack(arrangedSubViews: [ratingLbl,starRatingView,reviewLbl], spacing: 6, alignment: .top, distribution: .fill)
        let priceStacks = HorizontalStack(arrangedSubViews: [originalPriceLbl,offerPriceLbl], spacing: 6, alignment: .center, distribution: .fill)
        collectionBgView.addSubview(proptyCollection)
        proptyCollection.makeEdgeConstraints(toView: collectionBgView)
        let descStack = VerticalStack(arrangedSubViews: [titleLbl,reviewStacks,priceStacks,deliveryInstrLbl], spacing: 8, alignment: .leading, distribution: .fill)
        bgView.addSubview(descStack)
        descStack.makeEdgeConstraints(top: productIcon.topAnchor, leading: productIcon.trailingAnchor, trailing: bgView.trailingAnchor, bottom: nil,edge: .init(top: 0, left: 10, bottom: 12, right: 8))
        bgView.addSubview(collectionBgView)
        collectionBgView.makeEdgeConstraints(top: descStack.bottomAnchor, leading: productIcon.trailingAnchor, trailing: bgView.trailingAnchor, bottom: nil,edge: .init(top: 10, left: 10, bottom: 10, right: 10))
        collectionBgView.bottomAnchor.constraint(lessThanOrEqualTo: bgView.bottomAnchor, constant: -1).isActive = true
        
        productIcon.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45).isActive = true
        productIcon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.48).isActive = true
        
        proptyCollection.heightConstraints(30)
        productIcon.image = UIImage(named: "health")
        offerPriceLbl.backgroundColor = .Green
//        offerPriceLbl.minimumScaleFactor = 0.5
//        offerPriceLbl.adjustsFontSizeToFitWidth = true
    }
    func configureUI(_ prod:ProductsDataModel,sel_card_id: CardOfferModel?){
        ratingLbl.text = prod.rating.description
        reviewLbl.text = "(\(prod.review_count.description))"
        setupPrice(prod, sel_card_id: sel_card_id)
        deliveryInstrLbl.text = prod.description
        titleLbl.text = prod.name
        starRatingView.rating = prod.rating
        setupData(prod.colors ?? [])
        
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
        setupData(prod.colors?.components(separatedBy: ",") ?? [])
        
        guard let url = URL(string: prod.image_url ?? "") else{return}
        let place = UIImage(named: "health")
        productIcon.sd_setImage(with: url, placeholderImage: place)
    }
    private func setupPrice(_ prod:ProductsDataModel,sel_card_id: CardOfferModel?){
        if let sel_card_id,prod.card_offer_ids.contains(sel_card_id.id){
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
            offerPriceLbl.text = "Save \(Constant.ruppes) \(savedAmount.removeZerosFromEnd())"
            offerPriceLbl.isHidden = false
        }else{
            originalPriceLbl.text = "\(Constant.ruppes)"+prod.price.removeZerosFromEnd()
            offerPriceLbl.isHidden = true
            offerPriceLbl.text = ""
        }
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
    func setupData(_ arr: [String] = []){
        colorNames = arr
        proptyCollection.reloadData()
    }
}
extension ProductCollectionCell:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorNames.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cell: ProductColorCollectionCell.self, indexPath: indexPath)
        cell.colorView.backgroundColor = ProductColorCollectionCell.colorNames[colorNames[indexPath.item]]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 22, height: 22)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        4
    }
}
