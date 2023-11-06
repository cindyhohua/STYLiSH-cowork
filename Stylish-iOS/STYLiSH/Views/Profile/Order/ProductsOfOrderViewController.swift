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
    
    var productID: String = ""
    let productListTable =  UITableView()
    let numberOfProducts = 3
   
    var didReview = false
    
    private let marketProvider = MarketProvider(httpClient: HTTPClient())
    var token = KeyChainManager.shared.token
    let testToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjM3LCJpYXQiOjE2OTkyNTg5ODMsImV4cCI6MTY5OTI2MjU4M30.1ZOurs2eGwA7bXrvCcnwNjlVOMeSlMX4tIR9VpqHGeI"
    
    private var datas: OrderDetail? = nil  {
        didSet {
            orderIDLabel.text = "訂單編號：\(datas!.order.orderID)"
            orderTimeLabel.text = "購買日期：\(datas!.order.orderID)"
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
        print("------------------\(productID)")
       marketProvider.fetchOrderDetail(token: testToken, productID: productID, completion:{ [weak self] result in
           switch result {
           case .success(let ordersDetail):
               self?.datas = ordersDetail
               print("\(self?.datas)")
              
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
    
    func setOrderInfoView(){
        
        orderIDLabel.text = "訂單編號：\(datas?.order.orderID)"
        orderTimeLabel.text = "購買日期：\(datas?.order.orderID)"
        
        
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
            return (datas?.order.list!.count)!
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = productListTable.dequeueReusableCell(withIdentifier: "productCell") as? ProductsOfOrderTableViewCell {
            cell.delegate = self
            if let data = datas?.order.list![indexPath.row]{
                if data.isFeedback{
                    cell.checkButtonText = CheckButtonText.init().see
                }else{
                    cell.checkButtonText = CheckButtonText.init().edit
                }
                cell.productImage.kf.setImage(with: URL(string: data.mainImage))
                cell.titleLabel.text = data.name
                cell.productOfColors.removeAll()
                cell.productOfSize.removeAll()
                cell.productOfSize.append(data.size)
                cell.productOfColors.append(UIColor.hexStringToUIColor(hex: data.color.code))
                
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
//        reviewVC.productOfColors = cell.productOfColors
//        reviewVC.productOfSize = cell.productOfSize
        
        navigationController?.pushViewController(reviewVC, animated: true)
    }
    
}
