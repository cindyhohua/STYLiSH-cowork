//
//  ProductsOfOrderTableViewCell.swift
//  STYLiSH
//
//  Created by 莊羚羊 on 2023/11/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit
//
//struct CheckButton{
//    var review: "前往評價"
//    var seeReview: "前往查看"
//}

protocol ProductsOfOrderTableViewCellDelegate{
    func reviewActive(cell: ProductsOfOrderTableViewCell)
    func seeReviewActive(cell: ProductsOfOrderTableViewCell)
}

class ProductsOfOrderTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setCellView()
        setButtonActive()
        
    }
    override func didMoveToWindow() {
        super.didMoveToWindow()
        setCellView()
        setButtonActive()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        

    }
    
    var delegate: ProductsOfOrderTableViewCellDelegate?
    
    var productOfColors: [UIColor] = []
    var productOfSize: [String] = []
    var sizeLabelText = UILabel()
//    var checkButtonText: String = ""
    var colorView: [UIView] = []
    var sizeLabel: [UIView] = []
    var productID: Int?
    var checkButtonType: CheckButtonText = .edit
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
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .B1
        return button
    }()
    
    func setButtonActive(){
        checkButton.setTitle(checkButtonType.title, for: .normal)
        checkButton.addTarget(self, action: #selector(reviewAction), for: .touchUpInside)
    }
    
    @objc func reviewAction(){
//        if CheckButtonText == CheckButtonText.init().edit{
//            delegate?.reviewActive(cell: self)
//        }else{
//            delegate?.seeReviewActive(cell: self)
//        }
        switch checkButtonType {

        case .edit:
            delegate?.reviewActive(cell: self)
        case .see:
            delegate?.seeReviewActive(cell: self)
        }
        
    }
    
    func setColorAndSize(){
        colorView.removeAll()
        sizeLabel.removeAll()
        if productOfColors != nil {
            for ind in 0..<productOfColors.count{
                let cView: UIView = {
                    let view = UIView()
                    view.backgroundColor = productOfColors[ind]
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
        addSubToSuperView(superview: contentView, subview: checkButton)
        addSubToSuperView(superview: contentView, subview: productImage)
        addSubToSuperView(superview: contentView, subview: titleLabel)
        addSubToSuperView(superview: contentView, subview: sizeLabelText)

        setColorAndSize()
        productImage.setContentCompressionResistancePriority(.required, for: .vertical)
        productImage.setContentHuggingPriority(.required, for: .vertical)
        
        NSLayoutConstraint.activate([
            checkButton.widthAnchor.constraint(equalToConstant: 90),
            checkButton.heightAnchor.constraint(equalToConstant: 30),
            checkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            checkButton.bottomAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 0),
            
            productImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            productImage.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            productImage.widthAnchor.constraint(equalToConstant: 82),
            productImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            productImage.heightAnchor.constraint(equalToConstant: 110),
            
            titleLabel.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            
            
            
            
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
        
        sizeLabelText.text = "qqq"
        sizeLabelText.translatesAutoresizingMaskIntoConstraints = false
        sizeLabelText.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        sizeLabelText.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 8).isActive = true
            
    }
    
    func addTO(sub: UIView){
        addSubview(sub)
        sub.translatesAutoresizingMaskIntoConstraints = false
    }
}
