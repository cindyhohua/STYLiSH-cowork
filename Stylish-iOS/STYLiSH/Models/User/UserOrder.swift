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
    let orders: [OrderData]
}
// MARK: - OrderDetail
struct OrderDetail: Codable {
//    let prime: String
    let order: UserOrderInfo
}

struct OrderData: Codable {
    let order: UserOrderInfo
}
//struct OrderData2: Codable {
//    let order: UserOrderInfo
//}

// MARK: - Order
struct UserOrderInfo: Codable {
    let orderID: String
    let shipping, payment: String
    let subtotal, usePoint, freight, total: Int
    let createTime: String
    let recipient: Recipient
    let list: [List]?
}

// MARK: - Recipient
struct Recipient: Codable {
    let name, phone, email, address: String
    let time: String
}



// MARK: - Order


// MARK: - List
struct List: Codable {
    let id: Int
    let mainImage: String
    let name: String
    let color: Color
    let size: String
    let qty: Int
    let isFeedback: Bool
    enum CodingKeys: String, CodingKey {
            case id
            case mainImage = "main_image"
            case name, color, size, qty, isFeedback
        }
}

