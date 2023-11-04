//
//  MyOrderListViewController.swift
//  STYLiSH
//
//  Created by 莊羚羊 on 2023/11/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class MyOrderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        orderListTable.delegate = self
        orderListTable.dataSource = self
        setOutlay()
        setTable()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    let orderListTable =  UITableView()
    let numberOfOrder = 3
    var orderIDs: [String] = []
    var orderTimes: [String] = []
    func setOutlay(){
        view.addSubview(orderListTable)
        orderListTable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            orderListTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            orderListTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            orderListTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            orderListTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
    func setTable(){
        orderListTable.register(OrderListTableViewCell.self, forCellReuseIdentifier: "orderCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfOrder
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = orderListTable.dequeueReusableCell(withIdentifier: "orderCell") as? OrderListTableViewCell {
            print("in cell")
//            if orderTimes.count >= indexPath.row{
//                cell.orderIDLabel.text = "訂單編號：" + orderIDs[indexPath.row]
//                cell.orderTimeLabel.text = "購賣日期：" + orderTimes[indexPath.row]
//            }
            cell.orderIDLabel.text = "訂單編號："
            cell.orderTimeLabel.text = "購賣日期："
            return cell
        } else {
            // 如果轉型失敗，這裡可以處理錯誤情況或者返回一個默認的儲存格
            return UITableViewCell()
        }
    }
}
