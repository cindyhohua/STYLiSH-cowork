//
//  OrderListTableViewCell.swift
//  STYLiSH
//
//  Created by 莊羚羊 on 2023/11/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class OrderListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        setLayout()
    }
    
    let orderIDLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let orderTimeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    func setLayout(){
        addSubview(orderIDLabel)
        addSubview(orderTimeLabel)
        
        orderIDLabel.translatesAutoresizingMaskIntoConstraints = false
        orderTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            orderIDLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            orderIDLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            
            orderTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            orderTimeLabel.topAnchor.constraint(equalTo: orderIDLabel.bottomAnchor, constant: 16),
            orderTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

}
