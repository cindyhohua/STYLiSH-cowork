//
//  addSubviewToSuper.swift
//  STYLiSH
//
//  Created by 莊羚羊 on 2023/11/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import Foundation

func addSubToSuperView(superview: UIView, subview: UIView){
    superview.addSubview(subview)
    subview.translatesAutoresizingMaskIntoConstraints = false
}


struct OrderInfo{
    var orderID: String
    var orderTime: String
}

struct CheckButtonText{
    var edit = "前往評價"
    var see = "查看評價"
}
