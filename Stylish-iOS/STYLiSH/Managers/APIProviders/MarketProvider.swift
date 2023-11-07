//
//  MarketProvider.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/13.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import Foundation

typealias PromotionHanlder = (Result<[PromotedProducts], Error>) -> Void
typealias ProductsResponseWithPaging = (Result<STSuccessParser<[Product]>, Error>) -> Void
typealias UserOrderResponse = (Result<UserOrder, Error>) -> Void
typealias UserOrderDetailResponse = (Result<OrderDetail, Error>) -> Void
typealias PostReviewResponse = (Result<String, Error>) -> Void
typealias FeedbackBtUserResponse = (Result<UserFeedback, Error>) -> Void
class MarketProvider {

    let decoder = JSONDecoder()
    let httpClient: HTTPClientProtocol

    private enum ProductType {
        case men(Int)
        case women(Int)
        case accessories(Int)
    }
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }

    
    func fetchUserFeedBack(token: String, productID: Int, orderID: String, completion: @escaping FeedbackBtUserResponse){
       
        httpClient.request(STMarketRequest.feedbackByUser(token: token, productID: productID, orderID: orderID), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let order = try self.decoder.decode(
                        UserFeedback.self,
                        from: data
                    )
                    
                    DispatchQueue.main.async {
                        print("qqq")
//                        print("\(order.order)")
                        completion(.success(order))
                        
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
    // MARK: - UserOrder method
    func fetchUserOrder(token: String, completion: @escaping UserOrderResponse){
        httpClient.request(STMarketRequest.userOrder(token: token), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let order = try self.decoder.decode(
                        UserOrder.self,
                        from: data
                    )
                    
                    DispatchQueue.main.async {
                        print("qqq")
//                        print("\(order.order)")
                        completion(.success(order))
                        
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
    
    func fetchOrderDetail(token: String, productID: String, completion: @escaping UserOrderDetailResponse){
        print("\(token)\n\(productID)")
        httpClient.request(STMarketRequest.orderDetail(token: token, productID: productID), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let order = try self.decoder.decode(
                        OrderDetail.self,
                        from: data
                    )
                    DispatchQueue.main.async {
                        print("qq---------")
                        print(order.order.orderID)
                        completion(.success(order))
                    }
                } catch {
                    print("error1")
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func postReview(token: String, productID: Int, orderID: String, score: Int, comment: String, completion: @escaping PostReviewResponse){
        print("token:\n\(token)\n productID \n \(productID)\n orderID \n \(orderID)\n\(score)\n\(comment)")
        httpClient.request(STMarketRequest.feedbackForProduct(token: token, productID: productID, orderID: orderID, score: score, comment: comment), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                return print("發送成功")
            case .failure(let error):
                print("\(STMarketRequest.feedbackForProduct(token: token, productID: productID, orderID: orderID, score: score, comment: comment))")
                completion(.failure(error))
            }
        })
    }
    
   
    // MARK: - Public method
    func fetchHots(completion: @escaping PromotionHanlder) {
        httpClient.requestHots(STMarketRequest.hots, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let products = try self.decoder.decode(
                        STSuccessParser<[PromotedProducts]>.self,
                        from: data
                    )
                    DispatchQueue.main.async {
                        completion(.success(products.data))
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    func fetchProductForMen(paging: Int, completion: @escaping ProductsResponseWithPaging) {
        fetchProducts(request: STMarketRequest.men(paging: paging), completion: completion)
    }

    func fetchProductForWomen(paging: Int, completion: @escaping ProductsResponseWithPaging) {
        fetchProducts(request: STMarketRequest.women(paging: paging), completion: completion)
    }

    func fetchProductForAccessories(paging: Int, completion: @escaping ProductsResponseWithPaging) {
        fetchProducts(request: STMarketRequest.accessories(paging: paging), completion: completion)
    }

    // MARK: - Private method
    private func fetchProducts(request: STMarketRequest, completion: @escaping ProductsResponseWithPaging) {
        httpClient.request(request, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let response = try self.decoder.decode(STSuccessParser<[Product]>.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(response))
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
