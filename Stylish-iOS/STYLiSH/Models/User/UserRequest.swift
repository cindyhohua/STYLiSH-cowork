//
//  UserRequest.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/7.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import Foundation

enum STUserRequest: STRequest {
    case signin(String)
    case checkout(token: String, body: Data?)
    case profile(token: String)
    case nativeSignin(email: String, password: String)
    case dailyevent(point: Int, token: String)
    case productComment(id: Int)

    var headers: [String: String] {
        switch self {
        case .signin:
            return [STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue]
        case .checkout(let token, _):
            return [
                STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue,
                STHTTPHeaderField.auth.rawValue: "Bearer \(token)"
            ]
        case .profile(let token):
            return [ STHTTPHeaderField.auth.rawValue: "Bearer \(token)"]
        case .nativeSignin:
            return [STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue]
        case .dailyevent(_, let token):
            return [STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue,
                    STHTTPHeaderField.auth.rawValue: "Bearer \(token)"]
        case .productComment(_):
            return [STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue]
        }
    }

    var body: Data? {
        switch self {
        case .signin(let token):
            let dict = [
                "provider": "facebook",
                "access_token": token
            ]
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        case .checkout(_, let body):
            return body
        case .profile: return nil
        case .nativeSignin(let email, let password):
            let dict = [
                  "provider": "native",
                  "email": email,
                  "password": password
            ]
            print(dict)
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        case .dailyevent(let point, _):
            let dict = [
                  "points": point
            ]
            print(dict)
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        case .productComment(_):
            return try? JSONSerialization.data(withJSONObject: [:], options: .prettyPrinted)
        }
    }

    var method: String {
        switch self {
        case .signin, .checkout, .nativeSignin, .dailyevent: return STHTTPMethod.POST.rawValue
        case .profile, .productComment: return STHTTPMethod.GET.rawValue
        }
    }

    var endPoint: String {
        switch self {
        case .signin, .nativeSignin: return "/user/signin"
        case .checkout: return "/order/checkout"
        case .profile: return "/user/profile"
        case .dailyevent: return "/user/dailyevent"
        case .productComment(let id) : return "product?productID=\(id)"
        }
    }
}
