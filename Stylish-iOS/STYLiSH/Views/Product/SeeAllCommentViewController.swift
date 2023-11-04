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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        self.navigationItem.title = "評價"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< 返回", style: .done , target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .B4

        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        tableView.register(SeeAllCommentCell.self, forCellReuseIdentifier: "commentCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
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
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SeeAllCommentCell()
        cell.isUserInteractionEnabled = false
        cell.nameLabel.text = maskString("陸瑋恩")
        cell.configure(withRating: 4.5)
        cell.commentLabel.text = "QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ"

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SeeAllCommentHeader(reuseIdentifier: "seeAllCommentHeader")
        headerView.configure(withRating: 4.5)
        headerView.isUserInteractionEnabled = false
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func footerLoader() {
        tableView.endFooterRefreshing()
//        guard let paging = paging else {
//            endWithNoMoreData()
//            return
//        }
//        provider?.fetchData(paging: paging, completion: { [weak self] result in
//            self?.endFooterRefreshing()
//            guard let self = self else { return }
//            switch result {
//            case .success(let response):
//                guard let originalData = self.datas.first else { return }
//                let newDatas = response.data
//                self.datas = [originalData + newDatas]
//                self.paging = response.paging
//            case .failure(let error):
//                LKProgressHUD.showFailure(text: error.localizedDescription)
//            }
//        })
    }
}
