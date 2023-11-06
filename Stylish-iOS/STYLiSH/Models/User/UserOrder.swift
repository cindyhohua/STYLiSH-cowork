//
//  UserOrder.swift
//  STYLiSH
//
//  Created by 莊羚羊 on 2023/11/6.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import Foundation

// MARK: - UserOrderElement
struct UserOrder: Codable {
    let order: UserOrderInfo
}

// MARK: - Order
struct UserOrderInfo: Codable {
    let orderID: String
    let shipping, payment: String
    let subtotal, usePoint, freight, total: Int
    let createTime: String
    let recipient: Recipient
}

// MARK: - Recipient
struct Recipient: Codable {
    let name, phone, email, address: String
    let time: String
}

// MARK: - OrderDetail
struct OrderDetail: Codable {
    let prime: String
    let order: UserOrderDetail
}

// MARK: - Order
struct UserOrderDetail: Codable {
    let orderID: Int
    let shipping, payment: String
    let subtotal, usePoint, freight, total: Int
    let createTime: String
    let recipent: Recipient
    let list: [List]
}

// MARK: - List
struct List: Codable {
    let id: Int
    let name: String
    let price: Int
    let color: Color
    let size: String
    let qty: Int
    let isFeedback: Bool
}

