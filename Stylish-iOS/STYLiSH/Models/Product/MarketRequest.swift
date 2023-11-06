//
//  STRequest.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/13.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import Foundation

struct FeedbackBody: Encodable {
    var productID: Int
    var orderID: Int
    var score: Int
    var comment: String?
}

enum STMarketRequest: STRequest {
    case hots
    case women(paging: Int)
    case men(paging: Int)
    case accessories(paging: Int)
    case userOrder(token: String)
    case orderDetail(token: String)
    case feedbackForProduct(token: String, body: Data)
    case feedbackByUser(token: String)
    var headers: [String: String] {
        switch self {
        case .hots, .women, .men, .accessories: return [:]
        case .userOrder(let token): return ["Authorization": token]
        case .orderDetail(let token):
            return ["Authorization": token]
        case .feedbackForProduct(let token, let body):
            return ["Authorization": token]
        case .feedbackByUser(let token):
            return ["Authorization": token]
        }
    
    }

    var body: Data? {
        switch self {
        case .hots, .women, .men, .accessories, .userOrder, .orderDetail, .feedbackByUser: return nil
        case .feedbackForProduct(_, let body): return body
        }
    }

    var method: String {
        switch self {
        case .hots, .women, .men, .accessories, .userOrder, .orderDetail, .feedbackByUser: return STHTTPMethod.GET.rawValue
        case .feedbackForProduct: return STHTTPMethod.POST.rawValue
        }
    }

    var endPoint: String {
        switch self {
        case .hots: return "/marketing/hots"
        case .women(let paging): return "/products/women?paging=\(paging)"
        case .men(let paging): return "/products/men?paging=\(paging)"
        case .accessories(let paging): return "/products/accessories?paging=\(paging)"
        case .userOrder: return "/user/order"
        case .orderDetail: return "/order:id"
        case .feedbackForProduct: return "/feedback"
        case .feedbackByUser: return "/feedback/user"
        }
    }
}
