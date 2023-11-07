//
//  MyOrderListViewController.swift
//  STYLiSH
//
//  Created by 莊羚羊 on 2023/11/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit
let testToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjM4LCJpYXQiOjE2OTkzMjQ4MzYsImV4cCI6MTY5OTMyODQzNn0.cSe3V0maIOclqEmdd3uzMQ3giuQApp2ghCRBP3yiaDw"
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
   
    
    private var datas: [UserOrder] = []  {
        didSet {
            orderListTable.reloadData()
        }
    }
    func fetchData() {
//        guard let token = token else {return print("no token") }
       marketProvider.fetchUserOrder(token: testToken, completion: { [weak self] result in
           switch result {
           case .success(let orders):
               self?.datas = [orders]
               return
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
        if datas.count > 0{
            return datas[0].orders.count
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = orderListTable.dequeueReusableCell(withIdentifier: "orderCell") as? OrderListTableViewCell {
            print("in cell")
            let dateString = datas[0].orders[indexPath.row].order.createTime
            // 创建日期格式化器
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

            // 设置时区（如果字符串中有 Z 表示 Zulu 时间，即 UTC）
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
//            dateFormatter.timeZone = TimeZone.current
            // 将字符串转换为日期
            if let date = dateFormatter.date(from: dateString) {
                cell.orderTimeLabel.text = "購賣日期：" + "\(date)"
                print(date)
            } else {
                cell.orderTimeLabel.text = "購賣日期：" + String(dateString.prefix(10))
            }
                cell.orderIDLabel.text = "訂單編號：" + "\(datas[0].orders[indexPath.row].order.orderID)"
                
            
            
            return cell
        } else {
            // 如果轉型失敗，這裡可以處理錯誤情況或者返回一個默認的儲存格
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productsVC = ProductsOfOrderViewController()
        productsVC.orderID = datas[0].orders[indexPath.row].order.orderID
        navigationController?.pushViewController(productsVC, animated: true)
    }
}
