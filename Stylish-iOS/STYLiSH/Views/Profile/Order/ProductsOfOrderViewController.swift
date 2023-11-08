//
//  ProductsOfOrderViewController.swift
//  STYLiSH
//
//  Created by 莊羚羊 on 2023/11/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit
import Kingfisher

class ProductsOfOrderViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
        setOrderInfoView()
        setProductListLayout()
        setNavigationAndTab()
        setOrderInfoView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        product = []
        datas = nil
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
    let orderInfoView = UIView()
    let orderIDLabel = UILabel()
    let orderTimeLabel = UILabel()
    var orderID: String = ""
    var productID: Int = 0
    let productListTable =  UITableView()
    let numberOfProducts = 3
   
    var didReview = false
    
    struct ProductCell{
        let id: Int
        let mainImage: String?
        let name: String
        let price: Int?
        var context: String
        let isFeedback: Bool
    }
    
    
    private let marketProvider = MarketProvider(httpClient: HTTPClient())
    var token = KeyChainManager.shared.token
    var processedDataColor: [Int: [String]] = [:]
    var processedDataSize: [Int: [String]] = [:]
    var groupedItems: [Int: [List]] = [:]
    var product: [ProductCell] = []
    private var datas: OrderDetail? = nil  {
        didSet {
            if let data = datas?.order{
                let dateString = data.createTime
                orderTimeLabel.text = "購賣日期：" + String(dateString.prefix(10))

                var test: [Int] = []
                for index in 0..<(data.list?.count ?? 0) {
                    if !test.contains(data.list?[index].id ?? 0) {
                        test.append(data.list?[index].id ?? 0)
                        product.append(ProductCell(id: (data.list?[index].id)!,
                                                   mainImage: data.list?[index].mainImage,
                                                   name: (data.list?[index].name)!,
                                                   price: data.list?[index].price,
                                                   context: "",
                                                   isFeedback: (data.list?[index].isFeedback)!))
                    }
                }
                print(test)
                var test2: [String] = []
                for index in 0..<test.count {
                    for data in data.list! {
                        if data.id == test[index] {
                            test2.append(data.color.name + data.size)
                            product[index].context += data.color.name + data.size + " "
                        }
                    }
                    print(test2)
                    
                    print("qqqqqqq",product[index].context)
                    test2 = []
                }
                
                
                orderIDLabel.text = "訂單編號：\(data.orderID)"
                productListTable.reloadData()
            }
            
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
        if let testToken = testToken{
        marketProvider.fetchOrderDetail(token: testToken, productID: "\(orderID)", completion:{ [weak self] result in
            switch result {
            case .success(let ordersDetail):
                self?.datas = ordersDetail
                print("\(self?.datas)")
                
            
                
//                self?.groupedItems = [:]
//                self?.processedDataSize = [:]
//                self?.processedDataColor = [:]
//                if let list = self?.datas?.order.list{
//                    for item in list{
//
//                        if self?.groupedItems[item.id] == nil {
//                            self?.groupedItems[item.id] = []
//                        }
//
//                        self?.groupedItems[item.id]?.append(item)
//
//                        // Process color data
//                        if self?.processedDataColor[item.id] == nil {
//                            self?.processedDataColor[item.id] = []
//                        }
//
//                        self?.processedDataColor[item.id]!.append(item.color.code)
//
//                        // Process size data
//                        if self?.processedDataSize[item.id] == nil {
//                            self?.processedDataSize[item.id] = []
//                        }
//                        if !(self?.processedDataSize[item.id]!.contains(item.size) ?? true) {
//                            self?.processedDataSize[item.id]?.append(item.size)
//                        }
//                    }
//                }
//                print("\(self?.processedDataColor)")
//                print("\(self?.processedDataSize)")
                
//                DispatchQueue.main.async {
//                    self?.productListTable.reloadData()
//                }
            case .failure:
                LKProgressHUD.showFailure(text: "讀取資料失敗！")
            }
        })
    }
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
        if let indexPath = productListTable.indexPath(for: cell){
            seeVC.productOfSize.removeAll()
            seeVC.productOfSize.removeAll()
//            seeVC.productOfColors.append(contentsOf: cell.productOfColors)
//            seeVC.productOfSize.append(contentsOf: cell.productOfSize)
//            seeVC.orderID = (datas?.order.orderID)!
//            let keyArray = Array(groupedItems.keys)
//            let id = keyArray[indexPath.row]
//            seeVC.productID = (groupedItems[id]![0].id)
            if let data = datas{
                seeVC.orderID = data.order.orderID
                seeVC.productID = product[indexPath.row].id
            }
            
            navigationController?.pushViewController(seeVC, animated: true)
           
        }
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = datas{
            return product.count
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = productListTable.dequeueReusableCell(withIdentifier: "productCell") as? ProductsOfOrderTableViewCell {
            cell.delegate = self
            cell.titleLabel.text = product[indexPath.row].name
            cell.productImage.kf.setImage(with: URL(string: product[indexPath.row].mainImage!))
            cell.sizeLabelText.text = "規格：\(product[indexPath.row].context)"
            
            print("qqqqqqq",product[indexPath.row].name,product[indexPath.row].context)
            cell.checkButtonType = nil
            cell.checkButton.setTitle("", for: .normal)
            if product[indexPath.row].isFeedback {
                cell.checkButtonType = .see
            } else {
                cell.checkButtonType = .edit
            }
            cell.checkButton.setTitle(cell.checkButtonType?.title, for: .normal)
//            cell.checkButton.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
//            if groupedItems.keys.count > 0{
//                let keyArray = Array(groupedItems.keys)
//                let id = keyArray[indexPath.row]
//                cell.productID = id
//                if let value = groupedItems[id]{
//                    if value[0].isFeedback{
//                        cell.checkButtonType = .edit
//                    }else{
//                        cell.checkButtonType = .see
//                    }
//                    cell.productImage.kf.setImage(with: URL(string: value[0].mainImage!))
//                    cell.titleLabel.text = value[0].name
//                }
//                cell.productOfColors.removeAll()
//                cell.productOfSize.removeAll()
//                cell.productOfSize = processedDataSize[id]!
//                for colorCode in processedDataColor[id]!{
//                    cell.productOfColors.append(UIColor.hexStringToUIColor(hex: colorCode))
//                }
//
//            }
            
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
//        reviewVC.delegate = self
        if let indexPath = productListTable.indexPath(for: cell){
//            let keyArray = Array(groupedItems.keys)
//            let id = keyArray[indexPath.row]
            if let data = datas{
                reviewVC.orderId = data.order.orderID
                reviewVC.productId = (product[indexPath.row].id)
                reviewVC.productImage.kf.setImage(with: URL(string: product[indexPath.row].mainImage!))
                reviewVC.titleLabel.text = product[indexPath.row].name
            }
            
//            let data = datas?.order.list![indexPath.row]
//            reviewVC.productImage.kf.setImage(with: URL(string: (data?.mainImage)!))
//            reviewVC.titleLabel.text = data?.name
//            reviewVC.productOfSize.removeAll()
//            reviewVC.productOfSize.append(data!.size)
//            reviewVC.productOfColors.removeAll()
//            reviewVC.productOfColors.append(UIColor.hexStringToUIColor(hex: (data?.color.code)!))
//            reviewVC.productId = data!.id
//            reviewVC.orderId = (datas?.order.orderID)!
           
//            reviewVC.productOfColors.append(contentsOf: cell.productOfColors)
//            reviewVC.productOfSize.append(contentsOf: cell.productOfSize)
//            seeVC.orderID = (datas?.order.orderID)!
          
        }
        
        
        navigationController?.pushViewController(reviewVC, animated: true)
    }
    
}
