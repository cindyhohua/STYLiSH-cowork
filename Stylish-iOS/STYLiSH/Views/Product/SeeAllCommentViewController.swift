//
//  SeeAllCommentViewController.swift
//  STYLiSH
//
//  Created by 賀華 on 2023/11/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class SeeAllCommentViewController: UIViewController {
    var tableView: UITableView!
    var id: Int?
    private let marketProvider = MarketProvider(httpClient: HTTPClient())
    var comments: ProductComment?
    var feedbacks: [Feedback] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        self.navigationItem.title = "評價"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< 返回", style: .done , target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .B4
        if let id = id {
            fetchData(id: id, paging: 0)
        }
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SeeAllCommentCell.self, forCellReuseIdentifier: "SeeAllCommentCell")
        tableView.separatorStyle = .none
        tableView.addRefreshFooter(refreshingBlock: { [weak self] in
            self?.footerLoader()
        })
    }
    
    private func fetchData(id: Int, paging: Int) {
        marketProvider.fetchProductComment(id: id, paging: paging, completion: { [weak self] result in
            switch result {
            case .success(let products):
                print(products.averageScore)
                self?.comments = products
                self?.feedbacks = products.feedbacks
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure:
                print("no comment")
//                LKProgressHUD.showFailure(text: "讀取資料失敗！")
            }
        })
    }
    
    @objc func back(sender: AnyObject) {
        guard let viewControllers = self.navigationController?.viewControllers else { return }
        for controller in viewControllers {
            if controller is ProductDetailViewController {
            self.navigationController?.popToViewController(controller, animated: true)
            }
        }
    }
}

extension SeeAllCommentViewController: UITableViewDataSource, UITableViewDelegate {
    func maskString(_ input: String) -> String {
        let length = input.count
        if length == 2 {
            let startIndex = input.index(input.startIndex, offsetBy: 1)
            return String(input[..<startIndex]) + "*"
        } else if length < 2 {
            return "*"
        }
        
        let startIndex = input.index(input.startIndex, offsetBy: 1)
        let endIndex = input.index(input.endIndex, offsetBy: -1)
        
        let head = String(input[..<startIndex])
        let tail = String(input[endIndex...])
        
        let middle = String(repeating: "*", count: length - 2)
        
        let maskedString = head + middle + tail
        
        return maskedString
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let comments = comments {
            return feedbacks.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeeAllCommentCell", for: indexPath) as? SeeAllCommentCell
        cell?.isUserInteractionEnabled = false
        if let comments = comments {
            cell?.nameLabel.text = maskString(feedbacks[indexPath.row].name)
            cell?.configure(withRating: Double(feedbacks[indexPath.row].score))
            cell?.commentLabel.text = feedbacks[indexPath.row].comment
            cell?.timeLabel.text = String(feedbacks[indexPath.row].feedbackCreateTime.prefix(10))
            var variant: String = ""
            for index in 0..<feedbacks[indexPath.row].variants.count {
                variant += feedbacks[indexPath.row].variants[index].color.name + feedbacks[indexPath.row].variants[index].size + " "
            }
            cell?.contextLabel.text = "規格：" + variant
        }
        return cell ?? SeeAllCommentCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SeeAllCommentHeader(reuseIdentifier: "seeAllCommentHeader")
        if let comments = comments {
            headerView.configure(withRating: Float(round(10*comments.averageScore)/10))
            headerView.starsLabel.text = "\(Float(round(10*comments.averageScore)/10))/5.0"
            headerView.commentsCounts.text = "（\(comments.feedbackAmounts)則評論）"
        }
        headerView.isUserInteractionEnabled = false
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func footerLoader() {
        guard let paging = comments?.nextPaging else {
            tableView.endWithNoMoreData()
            return
        }
        print("qq",paging)
        marketProvider.fetchProductComment(id: id ?? 0, paging: paging, completion: { [weak self] result in
            switch result {
            case .success(let response):
                self?.comments = response
                self?.feedbacks += response.feedbacks
                self?.tableView.reloadData()
                self?.tableView.endFooterRefreshing()
            case .failure(let error):
                self?.tableView.endWithNoMoreData()
                LKProgressHUD.showSuccess(text: "已加載完所有評論")
            }
        })
    }
}
