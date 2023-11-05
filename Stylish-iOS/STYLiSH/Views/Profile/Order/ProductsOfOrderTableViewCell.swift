//
//  ProductsOfOrderTableViewCell.swift
//  STYLiSH
//
//  Created by 莊羚羊 on 2023/11/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class ProductsOfOrderTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setCellView()
        
    }
    override func didMoveToWindow() {
        super.didMoveToWindow()
        setCellView()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        

    }
    
    var productOfColors: [UIColor] = [.B2!]
    var productOfSize: [String] = ["m", "l"]
    var colorView: [UIView] = []
    var sizeLabel: [UIView] = []
    var productImage: UIImageView = {
        let image = UIImage(named: "Image_Placeholder")
        let imageView = UIImageView(image: image)
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "我是假的商品"
        label.textColor = .B1
        return label
    }()
    
    
    let checkButton: UIButton = {
        let button = UIButton()
        button.setTitle(CheckButtonText.init().edit, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .B4
        return button
    }()
    
    
    
    func setColor(){
        if productOfColors != nil {
            for _ in 0..<productOfColors.count{
                let cView: UIView = {
                    let view = UIView()
                    view.backgroundColor = .B2
                    return view
                }()
                addSubToSuperView(superview: contentView, subview: cView)
                colorView.append(cView)
            }
        }
        
        if productOfSize != nil {
            for index in 0..<productOfSize.count{
                let sLabel: UILabel = {
                    let label = UILabel()
                    label.text = productOfSize[index]
                    label.textColor = .B1
                    return label
                }()
                addSubToSuperView(superview: contentView, subview: sLabel)
                sizeLabel.append(sLabel)
            }
        }
        
        
        
    }
    
    func setCellView(){
        addSubToSuperView(superview: contentView, subview: productImage)
        addSubToSuperView(superview: contentView, subview: titleLabel)
        addSubToSuperView(superview: contentView, subview: checkButton)

        setColor()
        productImage.setContentCompressionResistancePriority(.required, for: .vertical)
        productImage.setContentHuggingPriority(.required, for: .vertical)
        
        NSLayoutConstraint.activate([
            
            
            productImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            productImage.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            productImage.heightAnchor.constraint(equalToConstant: 110),
            productImage.widthAnchor.constraint(equalToConstant: 82),
            productImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            titleLabel.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            
            checkButton.widthAnchor.constraint(equalToConstant: 80),
            checkButton.heightAnchor.constraint(equalToConstant: 30),
            checkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            checkButton.bottomAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 0),
            
            
        ])
        
        for indexPath in 0..<colorView.count{
            let base = 20
            var leadin: Int = 0
            if indexPath > 0{
                let spacingValue = (indexPath + 1 * 22)
                let offsetValue = ((indexPath) * 8)
                leadin = base + spacingValue + offsetValue
            }else{
                leadin = base
            }
            NSLayoutConstraint.activate([
                colorView[indexPath].widthAnchor.constraint(equalToConstant: 22),
                colorView[indexPath].heightAnchor.constraint(equalToConstant: 22),
                colorView[indexPath].leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: CGFloat(leadin)),
                colorView[indexPath].topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8)
            ])
        }
        
        for indexPath in 0..<sizeLabel.count{
            let base = 20
            var leadin: Int = 0
            if indexPath > 0{
                let spacingValue = (indexPath + 1 * 22)
                let offsetValue = ((indexPath) * 8)
                leadin = base + spacingValue + offsetValue
            }else{
                leadin = base
            }
            NSLayoutConstraint.activate([
                sizeLabel[indexPath].leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: CGFloat(leadin)),
                sizeLabel[indexPath].topAnchor.constraint(equalTo: colorView[0].bottomAnchor, constant: 8)
            ])
        }
            
    }
    
    func addTO(sub: UIView){
        addSubview(sub)
        sub.translatesAutoresizingMaskIntoConstraints = false
    }
}
