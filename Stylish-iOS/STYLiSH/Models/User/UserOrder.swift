//
//  UserOrder.swift
//  STYLiSH
//
//  Created by 莊羚羊 on 2023/11/6.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import Foundation

// MARK: - UserOrder
struct UserOrder: Codable {
    let orders: [OrderElement]
}

// MARK: - OrderElement
struct OrderElement: Codable {
    let prime: String
    let order: OrderOrder
}

// MARK: - OrderOrder
struct OrderOrder: Codable {
    let orderID: Int
    let shipping, payment: String
    let subtotal, usePoint, freight, total: Int
    let createTime: String
    let recipent: Recipent
}

// MARK: - Recipent
struct Recipent: Codable {
    let name, phone, email, address: String
    let time: String
}
