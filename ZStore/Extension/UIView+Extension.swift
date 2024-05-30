//
//  UIView+Extension.swift
//  ZStore
//
//  Created by Apple on 27/05/24.
//

import UIKit
import Cosmos

class TriangleView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.close()
        
        UIColor.systemPink.setFill()
        path.fill()
    }
}
class CircleButton: UIButton{
    @IBInspectable var bgColor: UIColor = .systemOrange {
        didSet { backgroundColor = bgColor }
    }
    @IBInspectable var TextColor: UIColor = .label {
        didSet { setTitleColor(TextColor, for: .normal) }
    }
    @IBInspectable var Text: String = "" {
        didSet { setTitle(Text, for: .normal) }
    }
    @IBInspectable var image: UIImage = UIImage(named: "dataicon") ?? UIImage(systemName: "globe")! {
        didSet { setImage(image, for: .normal) }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    func setupView(){
        setTitle(Text, for: .normal)
        setTitleColor(TextColor, for: .normal)
        backgroundColor = bgColor
        layer.cornerRadius = bounds.height / 2
        titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        tintColor = TextColor
        setImage(image, for: .normal)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}

public typealias CosMos = CosmosView
