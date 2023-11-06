//
//  ProductDetailCommentTableHeader.swift
//  STYLiSH
//
//  Created by 賀華 on 2023/11/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class CommentHeader: UITableViewHeaderFooterView {
    var starImageViews: [UIImageView] = []
    var title = UILabel()
    var starsLabel = UILabel()
    var commentsCounts = UILabel()
    var seeMoreComments = UIButton()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
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
                starImageView.widthAnchor.constraint(equalToConstant: 20),
                starImageView.heightAnchor.constraint(equalToConstant: 20)
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
            
            NSLayoutConstraint.activate([
                starImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
            ])
            
            previousStarImageView = starImageView
        }
        
        contentView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "商品評價"
        title.font = UIFont.systemFont(ofSize: 20)
        title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        title.bottomAnchor.constraint(equalTo: starImageViews[0].topAnchor, constant: -6).isActive = true
        
        contentView.addSubview(starsLabel)
        starsLabel.translatesAutoresizingMaskIntoConstraints = false
        starsLabel.text = ""
        starsLabel.leadingAnchor.constraint(equalTo: starImageViews.last?.trailingAnchor ?? contentView.centerXAnchor, constant: 16).isActive = true
        starsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
        
        contentView.addSubview(commentsCounts)
        commentsCounts.translatesAutoresizingMaskIntoConstraints = false
        commentsCounts.text = "目前尚無評價"
        commentsCounts.textColor = .lightGray
        commentsCounts.leadingAnchor.constraint(equalTo: starsLabel.trailingAnchor, constant: 5).isActive = true
        commentsCounts.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
        
        contentView.addSubview(seeMoreComments)
        seeMoreComments.translatesAutoresizingMaskIntoConstraints = false
        seeMoreComments.setTitle("", for: .normal)
        seeMoreComments.setTitleColor(.B4, for: .normal)
        seeMoreComments.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        seeMoreComments.bottomAnchor.constraint(equalTo: starImageViews[0].topAnchor, constant: -3).isActive = true
        
    }
    
    func configure(withRating rating: Float) {
        for (index, starImageView) in starImageViews.enumerated() {
            let wholeStarRating = Int(rating)
            let remainderRating = rating - Float(wholeStarRating)
            
            
//            let wholeStarRating = Int(rating)
//            let remainderRating = rating - Float(wholeStarRating)

            if index < wholeStarRating {
                starImageView.image = UIImage(named: "fullStar")
            } else if index == wholeStarRating && remainderRating >= 0.3 && remainderRating < 0.8 {
                starImageView.image = UIImage(named: "halfStar")
            } else if index == wholeStarRating && remainderRating > 0.8 {
                starImageView.image = UIImage(named: "fullStar")
            } else {
                starImageView.image = nil
            }
        }
    }
}

class SeeAllCommentHeader: CommentHeader {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func setupUI() {
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
                starImageView.widthAnchor.constraint(equalToConstant: 30),
                starImageView.heightAnchor.constraint(equalToConstant: 30)
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
            
            NSLayoutConstraint.activate([
                starImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10)
            ])
            
            previousStarImageView = starImageView
        }
        
        contentView.addSubview(starsLabel)
        starsLabel.translatesAutoresizingMaskIntoConstraints = false
        starsLabel.text = "4.5/5"
        starsLabel.leadingAnchor.constraint(equalTo: starImageViews.last?.trailingAnchor ?? contentView.centerXAnchor, constant: 16).isActive = true
        starsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10).isActive = true
        
        contentView.addSubview(commentsCounts)
        commentsCounts.translatesAutoresizingMaskIntoConstraints = false
        commentsCounts.text = "(58則評論)"
        commentsCounts.textColor = .lightGray
        commentsCounts.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        commentsCounts.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10).isActive = true

    }
}
