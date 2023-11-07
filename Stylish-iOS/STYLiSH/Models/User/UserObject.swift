//
//  UserObject.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/7.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import Foundation

struct ProductComment: Codable {
    let averageScore: Double
    let feedbackAmounts: Int
    let feedbacks: [Feedback]
    let nextPaging: Int

    enum CodingKeys: String, CodingKey {
        case averageScore, feedbackAmounts, feedbacks
        case nextPaging = "next_paging"
    }
}

// MARK: - Feedback
struct Feedback: Codable {
    let name: String
    let color: Color
    let size: String
    let score: Int
    let comment, feedbackCreateTime: String
}

struct DailyEvent: Codable {
    let userId: Int
    let points: Int
}

struct UserObject: Codable {
    let accessToken: String
    let user: User
    enum CodingKeys: String, CodingKey {
        case user
        case accessToken = "access_token"
    }
}

struct User: Codable {
    let id: Int?
    let name: String
    let email: String
    let picture: String
    let points: Int
    let isDailyEvent: Bool
}

struct Reciept: Codable {
    let number: String
}
