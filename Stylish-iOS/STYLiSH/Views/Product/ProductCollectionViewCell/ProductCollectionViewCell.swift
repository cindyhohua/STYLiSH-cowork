//
//  ProductCollectionViewCell.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/15.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImg: UIImageView!

    @IBOutlet weak var productTitleLbl: UILabel!

    @IBOutlet weak var productPriceLbl: UILabel!
    
    let starLabelAmount = UILabel()
    
    let starLabelScore = UILabel()
    
    var starImageViews: [UIImageView] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func layoutCell(image: String, title: String, price: Int, starNumber: Float, commentAmount: Int) {
        productImg.loadImage(image, placeHolder: .asset(.Image_Placeholder))
        productTitleLbl.text = title
        productPriceLbl.text = "NT$ \(price)"
        
        for _ in 0..<5 {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageViews.append(starImageView)
            contentView.addSubview(starImageView)
        }
        
        var previousStarImageView: UIImageView?
        for (_, starImageView) in starImageViews.enumerated() {
            NSLayoutConstraint.activate([
                starImageView.widthAnchor.constraint(equalToConstant: 15),
                starImageView.heightAnchor.constraint(equalToConstant: 15)
            ])
            if let previousStarImageView = previousStarImageView {
                NSLayoutConstraint.activate([
                    starImageView.leadingAnchor.constraint(equalTo: previousStarImageView.trailingAnchor, constant: 5)
                ])
            } else {
                NSLayoutConstraint.activate([
                    starImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1)
                ])
            }
            
            NSLayoutConstraint.activate([
                starImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
            ])
            
            previousStarImageView = starImageView
        }
        configure(withRating: starNumber)
        
        contentView.addSubview(starLabelScore)
        starLabelScore.textColor = .B4
        starLabelScore.translatesAutoresizingMaskIntoConstraints = false
        starLabelScore.leadingAnchor.constraint(equalTo: starImageViews[4].trailingAnchor, constant: 5).isActive = true
        starLabelScore.centerYAnchor.constraint(equalTo: starImageViews[4].centerYAnchor).isActive = true
        starLabelScore.font = UIFont(name: "Helvetica", size: 16)
        starLabelScore.text = "\(starNumber) (\(commentAmount))"
        
//        contentView.addSubview(starLabelAmount)
//        starLabelAmount.text = "(\(starNumber))"
//        starLabelAmount.translatesAutoresizingMaskIntoConstraints = false
//        starLabelAmount.topAnchor.constraint(equalTo: productPriceLbl.bottomAnchor, constant: 2).isActive = true
//        starLabelAmount.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2).isActive = true
    }
    
    func configure(withRating rating: Float) {
        for (index, starImageView) in starImageViews.enumerated() {
            let wholeStarRating = Int(rating)
            let remainderRating = rating - Float(wholeStarRating)

            if index < wholeStarRating {
                starImageView.image = UIImage(named: "fullStar")
            } else if index == wholeStarRating && remainderRating >= 0.3 && remainderRating < 0.8 {
                starImageView.image = UIImage(named: "halfStar 2")
            } else if index == wholeStarRating && remainderRating > 0.8 {
                starImageView.image = UIImage(named: "fullStar")
            } else if index <= 4 {
                starImageView.image = UIImage(named: "emptyStar 2")
            } else {
                starImageView.image = nil
            }
        }
    }
}
