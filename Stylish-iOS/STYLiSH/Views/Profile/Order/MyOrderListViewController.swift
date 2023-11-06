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
        setNavigationAndTab()
    
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private let marketProvider = MarketProvider(httpClient: HTTPClient())
    let orderListTable =  UITableView()
    var token = KeyChainManager.shared.token
    let testToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjI3LCJpYXQiOjE2OTkyMzQ5NjAsImV4cCI6MTY5OTIzODU2MH0.e1fdvNJ46LEEsi9RaMLaebfgqqrrl8PIhYoqQH8q334"
    var orderIDs: [String] = ["111"]
    var orderTimes: [String] = ["2023.01.02"]
    private var datas: [OrderElement] = []  {
        didSet {
            orderListTable.reloadData()
        }
    }
    func fetchData() {
        guard let token = token else {return print("no token") }
       marketProvider.fetchUserOrder(token: token, completion: { [weak self] result in
           switch result {
           case .success(let orders):
               self?.datas = orders.orders
           case .failure:
               LKProgressHUD.showFailure(text: "讀取資料失敗！")
           }
       })
   }
    
    func setNavigationAndTab(){
        self.tabBarController?.tabBar.isHidden = true
        self.title = "購買記錄"
        // 設定導航條背景顏色
        self.navigationController?.navigationBar.barTintColor = .white
        
        // 設定導航條文字顏色
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        view.backgroundColor = .white
        
    }
    func setOutlay(){
        addSubToSuperView(superview: view, subview: orderListTable)
        
        NSLayoutConstraint.activate([
            orderListTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            orderListTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            orderListTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            orderListTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    func setTable(){
        orderListTable.register(OrderListTableViewCell.self, forCellReuseIdentifier: "orderCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfOrder = datas.count
        return numberOfOrder
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = orderListTable.dequeueReusableCell(withIdentifier: "orderCell") as? OrderListTableViewCell {
            print("in cell")
            if orderTimes.isEmpty == false{
                cell.orderIDLabel.text = "訂單編號：" + "\(datas[indexPath.row].order.orderID)"
                cell.orderTimeLabel.text = "購賣日期：" + "\(datas[indexPath.row].order.createTime)"
            }else{
                cell.orderIDLabel.text = "訂單編號："
                cell.orderTimeLabel.text = "購賣日期："
            }
            
            return cell
        } else {
            // 如果轉型失敗，這裡可以處理錯誤情況或者返回一個默認的儲存格
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productsVC = ProductsOfOrderViewController()
        productsVC.orderInfo = OrderInfo(orderID: orderIDs[indexPath.row], orderTime: orderTimes[indexPath.row])
        navigationController?.pushViewController(productsVC, animated: true)
    }
}
