//
//  ProductDetailPageUITableCell.swift
//  STYLiSH
//
//  Created by 賀華 on 2023/11/3.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit
class CommentCell: UITableViewCell {
    var nameLabel = UILabel()
    var starImageViews: [UIImageView] = []
    var commentLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        nameLabel.text = "name"
        
        for _ in 0..<5 {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageViews.append(starImageView)
            contentView.addSubview(starImageView)
        }
        
        var previousStarImageView: UIImageView?
        for starImageView in starImageViews {
            NSLayoutConstraint.activate([
                starImageView.widthAnchor.constraint(equalToConstant: 16),
                starImageView.heightAnchor.constraint(equalToConstant: 16)
            ])
            if let previousStarImageView = previousStarImageView {
                NSLayoutConstraint.activate([
                    starImageView.leadingAnchor.constraint(equalTo: previousStarImageView.trailingAnchor, constant: 5)
                ])
            } else {
                NSLayoutConstraint.activate([
                    starImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
                ])
            }
            previousStarImageView = starImageView
        }
        
        NSLayoutConstraint.activate(
            starImageViews.map { $0.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 1) }
        )
        
        contentView.addSubview(commentLabel)
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        commentLabel.topAnchor.constraint(equalTo: starImageViews[0].bottomAnchor, constant: 3).isActive = true
        commentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        commentLabel.numberOfLines = 0
        commentLabel.text = "comment"
        
    }
    
    func configure(withRating rating: Double) {
        for (index, starImageView) in starImageViews.enumerated() {
            let wholeStarRating = Int(rating)
            let remainderRating = rating - Double(wholeStarRating)
            
            if index < wholeStarRating {
                starImageView.image = UIImage(named: "fullStar")
            } else if index == wholeStarRating && remainderRating >= 0.3 && remainderRating < 0.8 {
                starImageView.image = UIImage(named: "halfStar")
            } else {
                starImageView.image = nil
            }
        }
    }
}

