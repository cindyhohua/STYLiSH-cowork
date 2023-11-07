//
//  UserManager.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/7.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import FBSDKLoginKit

typealias FacebookResponse = (Result<String, Error>) -> Void

enum FacebookError: String, Error {
    case noToken = "讀取 Facebook 資料發生錯誤！"
    case userCancel
    case denineEmailPermission = "請允許存取 Facebook email！"
}

enum STYLiSHSignInError: Error {
    case noToken
}

class UserProvider {
    
    let httpClient: HTTPClientProtocol
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }

    func signInToSTYLiSH(fbToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
        httpClient.request(STUserRequest.signin(fbToken), completion: { result in
            switch result {
            case .success(let data):
                do {
                    let userObject = try JSONDecoder().decode(STSuccessParser<UserObject>.self, from: data)
                    KeyChainManager.shared.token = userObject.data.accessToken
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func signInNativeToSTYLiSH(email: String,password: String,completion: @escaping (Result<Void, Error>) -> Void) {
        httpClient.request(STUserRequest.nativeSignin(email: email, password: password), completion: { result in
            switch result {
            case .success(let data):
                do {
                    let userObject = try JSONDecoder().decode(STSuccessParser<UserObject>.self, from: data)
                    KeyChainManager.shared.token = userObject.data.accessToken
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func updatePoint(point: Int, token: String ,completion: @escaping (Result<Void, Error>) -> Void) {
        httpClient.request(STUserRequest.dailyevent(point: point, token: token) , completion: { result in
            switch result {
            case .success(let data):
                do {
                    let userObject = try JSONDecoder().decode(DailyEvent.self, from: data)
                    completion(.success(()))
                    print(userObject)
                    print("niceee")
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    func loginWithFaceBook(from: UIViewController, completion: @escaping FacebookResponse) {
        LoginManager().logIn(permissions: ["email"], from: from, handler: { (result, error) in
            if let error = error { return completion(.failure(error)) }
            guard let result = result else {
                let fbError = FacebookError.noToken
                LKProgressHUD.showFailure(text: fbError.rawValue)
                return completion(.failure(fbError))
            }
            
            switch result.isCancelled {
            case true: break
            case false:
                guard result.declinedPermissions.contains("email") == false else {
                    let fbError = FacebookError.denineEmailPermission
                    LKProgressHUD.showFailure(text: fbError.rawValue)
                    return completion(.failure(fbError))
                }
                guard let token = result.token?.tokenString else {
                    let fbError = FacebookError.noToken
                    LKProgressHUD.showFailure(text: fbError.rawValue)
                    return completion(.failure(fbError))
                }
                completion(.success(token))
            }
        })
    }

    func checkout(order: Order, prime: String, completion: @escaping (Result<Reciept, Error>) -> Void) {
        guard let token = KeyChainManager.shared.token else {
            return completion(.failure(STYLiSHSignInError.noToken))
        }
        let body = CheckoutAPIBody(order: order, prime: prime)
        let request = STUserRequest.checkout(
            token: token,
            body: try? JSONEncoder().encode(body)
        )
        httpClient.request(request, completion: { result in
            switch result {
            case .success(let data):
                do {
                    let reciept = try JSONDecoder().decode(STSuccessParser<Reciept>.self, from: data)
                    DispatchQueue.main.async {
                        print("qq")
                        completion(.success(reciept.data))
                    }
                } catch {
                    completion(.failure(error))
                    print("error1")
                }
            case .failure(let error):
                completion(.failure(error))
                print("error2")
            }
        })
    }
    
    func getUserProfile(completion: @escaping (Result<User, Error>) -> Void) {
        guard let token = KeyChainManager.shared.token else {
            return completion(.failure(STYLiSHSignInError.noToken))
        }
        let request = STUserRequest.profile(token: token)
        httpClient.request(request, completion: { result in
            switch result {
            case .success(let data):
                do {
                    print("yeas")
                    print(data)
                    print(token)
                    let user = try JSONDecoder().decode(STSuccessParser<User>.self, from: data)
                    print(user.data)
                    DispatchQueue.main.async {
                        completion(.success(user.data))
                    }
                } catch {
                    completion(.failure(error))
                    print("error1")
                }
            case .failure(let error):
                print("error2")
                completion(.failure(error))
            }
        })
    }
    
    func getProductComment(id: Int,completion: @escaping (Result<ProductComment, Error>) -> Void) {
        let request = STUserRequest.productComment(id: id)
        httpClient.request(request, completion: { result in
            switch result {
            case .success(let data):
                do {
                    print("yeas")
                    print(data)
                    let user = try JSONDecoder().decode(ProductComment.self, from: data)
                    print(user.averageScore)
                    DispatchQueue.main.async {
                        completion(.success(user))
                    }
                } catch {
                    completion(.failure(error))
                    print("error1")
                }
            case .failure(let error):
                print("error2")
                completion(.failure(error))
            }
        })
    }
}
