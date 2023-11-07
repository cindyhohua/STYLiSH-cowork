//
//  ProductsOfOrderViewController.swift
//  STYLiSH
//
//  Created by 莊羚羊 on 2023/11/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit
import Kingfisher

class ProductsOfOrderViewController: UIViewController {
   
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setTable()
        setOrderInfoView()
        setProductListLayout()
        setNavigationAndTab()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        setOrderInfoView()
        productListTable.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    let orderInfoView = UIView()
    let orderIDLabel = UILabel()
    let orderTimeLabel = UILabel()
    var orderID: String = ""
    var productID: Int = 0
    let productListTable =  UITableView()
    let numberOfProducts = 3
   
    var didReview = false
    
    private let marketProvider = MarketProvider(httpClient: HTTPClient())
    var token = KeyChainManager.shared.token
    var processedDataColor: [Int: [String]] = [:]
    var processedDataSize: [Int: [String]] = [:]
    var groupedItems: [Int: [List]] = [:]
    private var datas: OrderDetail? = nil  {
        didSet {
            if let data = datas?.order{
                let dateString = data.createTime
                // 创建日期格式化器
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

                // 设置时区（如果字符串中有 Z 表示 Zulu 时间，即 UTC）
                dateFormatter.timeZone = TimeZone(identifier: "UTC")
        //            dateFormatter.timeZone = TimeZone.current
                // 将字符串转换为日期
                if let date = dateFormatter.date(from: dateString) {
                    orderTimeLabel.text = "購賣日期：" + "\(date)"
                    print(date)
                } else {
                    orderTimeLabel.text = "購賣日期：" + String(dateString.prefix(10))
                }
                orderIDLabel.text = "訂單編號：\(data.orderID)"
            }
            
            
            productListTable.reloadData()
        }
    }
    
//    var datasList: [UserOrderDetail] = []{
//        didSet {
//            productListTable.reloadData()
//
//        }
//    }
    func fetchData() {
//        guard let token = testToken else {return print("no token") }
        print("------------------\(orderID)")
       marketProvider.fetchOrderDetail(token: testToken, productID: "\(orderID)", completion:{ [weak self] result in
           switch result {
           case .success(let ordersDetail):
               self?.datas = ordersDetail
               print("\(self?.datas)")
               
               if let list = self?.datas?.order.list{
                   for item in list{
                       
                       if self?.groupedItems[item.id] == nil {
                           self?.groupedItems[item.id] = []
                           }

                       self?.groupedItems[item.id]?.append(item)
                       
                       // Process color data
                       if self?.processedDataColor[item.id] == nil {
                           self?.processedDataColor[item.id] = []
                       }

                       self?.processedDataColor[item.id]!.append(item.color.code)

                       // Process size data
                       if self?.processedDataSize[item.id] == nil {
                           self?.processedDataSize[item.id] = []
                       }
                       if !(self?.processedDataSize[item.id]!.contains(item.size) ?? true) {
                           self?.processedDataSize[item.id]?.append(item.size)
                       }
                   }
               }
               print("\(self?.processedDataColor)")
               print("\(self?.processedDataSize)")
               
               DispatchQueue.main.async {
                   self?.productListTable.reloadData()
               }
           case .failure:
               LKProgressHUD.showFailure(text: "讀取資料失敗！")
           }
       })
        
//        orderTimeLabel.text = "購買日期：\(datas?.order.createTime)"
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
    
    func setOrderInfoView(){
        
        orderIDLabel.text = "訂單編號：\(datas?.order.orderID)"
        orderTimeLabel.text = "購買日期：\(datas?.order.createTime)"
        
        
        addSubToSuperView(superview: view, subview: orderInfoView)
        addSubToSuperView(superview: orderInfoView, subview: orderIDLabel)
        addSubToSuperView(superview: orderInfoView, subview: orderTimeLabel)
        
        NSLayoutConstraint.activate([
            
            
            orderInfoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            orderInfoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            orderInfoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            orderInfoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            
            orderIDLabel.topAnchor.constraint(equalTo: orderInfoView.topAnchor, constant: 16),
            orderIDLabel.leadingAnchor.constraint(equalTo: orderInfoView.leadingAnchor, constant: 16),
            
            orderTimeLabel.leadingAnchor.constraint(equalTo: orderInfoView.leadingAnchor, constant: 16),
            orderTimeLabel.topAnchor.constraint(equalTo: orderIDLabel.bottomAnchor, constant: 16)
        ])
    }
    
    func setProductListLayout(){
        addSubToSuperView(superview: view, subview: productListTable)
        
        NSLayoutConstraint.activate([
            
            
            productListTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productListTable.topAnchor.constraint(equalTo: orderInfoView.bottomAnchor, constant: 0),
            productListTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            productListTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    func setTable(){
        productListTable.delegate = self
        productListTable.dataSource = self
        productListTable.register(ProductsOfOrderTableViewCell.self, forCellReuseIdentifier: "productCell")
    }
    
   
}

extension ProductsOfOrderViewController: UITableViewDelegate, UITableViewDataSource, ProductsOfOrderTableViewCellDelegate{
    func seeReviewActive(cell: ProductsOfOrderTableViewCell) {
        let seeVC = SeeReviewViewController()
        seeVC.productOfColors = cell.productOfColors
        seeVC.productOfSize = cell.productOfSize
        navigationController?.pushViewController(seeVC, animated: true)
       
    }
    
  
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = datas{
            return (groupedItems.keys.count)
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = productListTable.dequeueReusableCell(withIdentifier: "productCell") as? ProductsOfOrderTableViewCell {
            cell.delegate = self
            if groupedItems.keys.count > 0{
                let keyArray = Array(groupedItems.keys)
                let id = keyArray[indexPath.row]
                if let value = groupedItems[id]{
                    if value[0].isFeedback{
                        cell.checkButtonText = CheckButtonText.init().see
                    }else{
                        cell.checkButtonText = CheckButtonText.init().edit
                    }
                    cell.productImage.kf.setImage(with: URL(string: value[0].mainImage!))
                    cell.titleLabel.text = value[0].name
                }
                cell.productOfColors.removeAll()
                cell.productOfSize.removeAll()
                cell.productOfSize = processedDataSize[id]!
                for colorCode in processedDataColor[id]!{
                    cell.productOfColors.append(UIColor.hexStringToUIColor(hex: colorCode))
                }
                
            }
            
            return cell
        } else {
            // 如果轉型失敗，這裡可以處理錯誤情況或者返回一個默認的儲存格
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        126
    }
    
    func reviewActive(cell: ProductsOfOrderTableViewCell) {
        let reviewVC = ReviewViewController()
        if let indexPath = productListTable.indexPath(for: cell){
            let data = datas?.order.list![indexPath.row]
            reviewVC.productImage.kf.setImage(with: URL(string: (data?.mainImage)!))
            reviewVC.titleLabel.text = data?.name
            reviewVC.productOfSize.removeAll()
            reviewVC.productOfSize.append(data!.size)
            reviewVC.productOfColors.removeAll()
            reviewVC.productOfColors.append(UIColor.hexStringToUIColor(hex: (data?.color.code)!))
            reviewVC.productId = data!.id
            reviewVC.orderId = (datas?.order.orderID)!
        }
        
        
        navigationController?.pushViewController(reviewVC, animated: true)
    }
    
}
