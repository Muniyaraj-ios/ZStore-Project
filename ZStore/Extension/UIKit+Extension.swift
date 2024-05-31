//
//  UIKit+Extension.swift
//  ZStore
//
//  Created by Apple on 26/05/24.
//

import UIKit

extension UIView{
    func addSubViews(views: UIView...){
        views.forEach { addSubview($0) }
    }
    func makeEdgeConstraints(toView view: UIView,edge const: UIEdgeInsets = .zero,isSafeArea: Bool = false){
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: isSafeArea ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor, constant: const.top).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: const.left).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -const.right).isActive = true
        bottomAnchor.constraint(equalTo: isSafeArea ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor, constant: -const.bottom).isActive = true
    }
    @discardableResult
    func makeEdgeConstraints(top: NSLayoutYAxisAnchor?,leading: NSLayoutXAxisAnchor?,trailing: NSLayoutXAxisAnchor?,bottom: NSLayoutYAxisAnchor?,edge const: UIEdgeInsets = .zero,width: CGFloat? = nil,height: CGFloat? = nil)-> UIView.AnchoredConstraints{
        translatesAutoresizingMaskIntoConstraints = false
        var anchor = UIView.AnchoredConstraints()
        if let top{
            anchor.top = topAnchor.constraint(equalTo: top, constant: const.top)
        }
        if let leading{
            anchor.leading = leadingAnchor.constraint(equalTo: leading, constant: const.left)
        }
        if let trailing{
            anchor.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -const.right)
        }
        if let bottom{
            anchor.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -const.bottom)
        }
        if let width{
            anchor.width = widthAnchor.constraint(equalToConstant: width)
        }
        if let height{
            anchor.height = heightAnchor.constraint(equalToConstant: height)
        }
        [anchor.top,anchor.leading,anchor.trailing,anchor.bottom,anchor.width,anchor.height].forEach { $0?.isActive = true }
        return anchor
    }
    func makeCenterConstraints(toView view: UIView){
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    func makeCenterXandYConstraints(toView view: UIView,centerX: Bool,centerY: Bool){
        if centerX || centerY{
            translatesAutoresizingMaskIntoConstraints = false
        }
        if centerX{
            centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
        if centerY{
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    }
    func equalSizeConstrinats(_ const: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: const).isActive = true
        heightAnchor.constraint(equalToConstant: const).isActive = true
    }
    func heightConstraints(_ const: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: const).isActive = true
    }
    func widthConstraints(_ const: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: const).isActive = true
    }
    func sizeConstraints(width: CGFloat,height: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    func fillSuperViewConstranits(_ edge: UIEdgeInsets = .zero){
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewTop = superview?.topAnchor{
            topAnchor.constraint(equalTo: superviewTop, constant: edge.top).isActive = true
        }
        if let superviewLeading = superview?.leadingAnchor{
            leadingAnchor.constraint(equalTo: superviewLeading, constant: edge.left).isActive = true
        }
        if let superviewTrailing = superview?.trailingAnchor{
            trailingAnchor.constraint(equalTo: superviewTrailing, constant: -edge.right).isActive = true
        }
        if let superviewBottom = superview?.bottomAnchor{
            bottomAnchor.constraint(equalTo: superviewBottom, constant: -edge.bottom).isActive = true
        }
    }
    struct AnchoredConstraints{
        var top,leading,trailing,bottom,width,height: NSLayoutConstraint?
    }
}

extension UICollectionView{
    func register<T: UICollectionViewCell>(cell name: T.Type){
        register(T.self, forCellWithReuseIdentifier: String(describing: name))
    }
    func register<T: UICollectionReusableView>(ofKind kind: String,cell name: T.Type){
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: name))
    }
    func dequeueReusableCell<T: UICollectionViewCell>(cell name: T.Type,indexPath: IndexPath)->T{
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as? T else{
            fatalError("make sure the \(String(describing: name)) cell is registered with collectionview")
        }
        return cell
    }
    func dequeueReusableCell<T: UICollectionReusableView>(ofKind kind: String,cell name: T.Type,indexPath: IndexPath)->T{
        guard let cell = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: name), for: indexPath) as? T else{
            fatalError("Make sure the \(String(describing: name)) the reusable view is register with collectionview")
        }
        return cell
    }
}

class HorizontalStack: UIStackView{
    
    init(arrangedSubViews: [UIView],spacing: CGFloat = 0,alignment: UIStackView.Alignment = .center,distribution: UIStackView.Distribution = .fill){
        super.init(frame: .zero)
        arrangedSubViews.forEach{ addArrangedSubview($0) }
        self.spacing = spacing
        self.distribution = distribution
        self.alignment = alignment
        self.axis = .horizontal
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VerticalStack: UIStackView{
    init(arrangedSubViews: [UIView],spacing: CGFloat = 0,alignment: UIStackView.Alignment = .center,distribution: UIStackView.Distribution = .fill) {
        super.init(frame: .zero)
        arrangedSubViews.forEach{ addArrangedSubview($0) }
        self.spacing = spacing
        self.distribution = distribution
        self.alignment = alignment
        self.axis = .vertical
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension UIStackView{
    func addBackgroundColor(_ color: UIColor){
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
extension UIFont{
    static func setFont(size: CGFloat,weight: UIFont.Weight)->UIFont{
        UIFont.systemFont(ofSize: size, weight: weight)
    }
}
extension UILabel{
    convenience init(text: String,textColor: UIColor,font: UIFont,alignment: NSTextAlignment = .left,line: Int = 1) {
        self.init(frame: .zero)
        self.text = text
        self.textColor = textColor
        self.font = font
        self.textAlignment = alignment
        self.numberOfLines = line
    }
}
extension UIImageView{
    convenience init(cornerRadius: CGFloat,mode: UIView.ContentMode = .scaleAspectFit) {
        self.init(image: nil)
        self.layer.cornerRadius = cornerRadius
        self.contentMode = mode
        self.clipsToBounds = true
    }
}

extension UIView{
    func addTap(count : Int = 1,action : @escaping() -> Void){
        let tap = MyGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.action = action
        tap.numberOfTapsRequired = count
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    @objc func handleTap(_ sender: MyGestureRecognizer){
        sender.action?()
    }
    
    class MyGestureRecognizer : UITapGestureRecognizer{
        var action : (()->(Void))? = nil
    }
}
