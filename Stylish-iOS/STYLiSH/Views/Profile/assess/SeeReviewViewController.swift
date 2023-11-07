//
//  SeeReviewViewController.swift
//  STYLiSH
//
//  Created by 莊羚羊 on 2023/11/5.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class SeeReviewViewController: ReviewModelViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setReviewView()
        checkButton.isHidden = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
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
    let startView = UIView()
    var starImageViews: [UIImageView] = []
    var numberOfStar = 0
    let reviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 // 设置为0表示支持多行
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .left // 设置文本对齐方式，根据需要更改
        label.lineBreakMode = .byWordWrapping // 设置换行方式，根据需要更改
        
        return label
    }()

    let reviewView: UIView = {
        let rview = UIView()
        rview.backgroundColor = .B5
        return rview
    }()
    
    var productID: Int = 0
    var orderID: String = ""
    private var datas: [UserFeedback] = []  {
        didSet {
            productImage.kf.setImage(with: URL(string: datas[0].list[0].mainImage!))
            titleLabel.text = datas[0].list[0].name
            reviewLabel.text = datas[0].feedback
            numberOfStar = datas[0].score
            setstarImageViewiew()
        }
    }
    private let marketProvider = MarketProvider(httpClient: HTTPClient())
    
    var token = KeyChainManager.shared.token
//    let testToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjM3LCJpYXQiOjE2OTkyNTg5ODMsImV4cCI6MTY5OTI2MjU4M30.1ZOurs2eGwA7bXrvCcnwNjlVOMeSlMX4tIR9VpqHGeI"
    func fetchData() {
        if let testToken = testToken {
            marketProvider.fetchUserFeedBack(token: testToken, productID: productID, orderID: orderID, completion:{ [weak self] result in
                switch result {
                case .success(let feedback):
                    self?.datas = [feedback]
                    return
                case .failure:
                    LKProgressHUD.showFailure(text: "讀取資料失敗！")
                }
            })
        }
   }
    
    
    func setstarImageViewiew(){
        starImageViews.removeAll()
        for index in 0..<5{
            
            var starImageView: UIImageView = {
                let imageView = UIImageView(image: UIImage(named: "star-3"))
                return imageView
            }()
            if index < numberOfStar{
                starImageView.image = UIImage(named: "star-2")
            }else{
                starImageView.image = UIImage(named: "star-3")
            }
            starImageViews.append(starImageView)
            addSubToSuperView(superview: startView, subview: starImageView)
            let width: CGFloat = 50
            let leagerGap: CGFloat = 40
            let totalGap = view.frame.width - (width * 5) - (leagerGap * 2)
            let gap = totalGap / 4
            let ind = CGFloat(index)
            print("\(gap)")
            var leadin = leagerGap + width * ind + gap * ind
            
            NSLayoutConstraint.activate([
                starImageView.widthAnchor.constraint(equalToConstant: width),
                starImageView.heightAnchor.constraint(equalToConstant: width),
                starImageView.centerYAnchor.constraint(equalTo: startView.centerYAnchor),
                starImageView.leadingAnchor.constraint(equalTo: startView.leadingAnchor, constant: leadin)
            ])
        }
    }
    
    func setReviewView(){
        addSubToSuperView(superview: view, subview: reviewLabel)
        addSubToSuperView(superview: view, subview: startView)
        setstarImageViewiew()
        NSLayoutConstraint.activate([
            startView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            startView.heightAnchor.constraint(equalTo: startView.widthAnchor, multiplier: 1 / 5),
            startView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startView.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 16),
            
            reviewLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            reviewLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            reviewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reviewLabel.topAnchor.constraint(equalTo: startView.bottomAnchor, constant: 16),
            
        ])
        
        
    }
    
    
    
}
