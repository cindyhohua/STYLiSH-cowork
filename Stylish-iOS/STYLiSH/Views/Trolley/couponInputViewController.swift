//
//  couponInputViewController.swift
//  STYLiSH
//
//  Created by 賀華 on 2023/11/5.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit
class CouponInputViewController: UIViewController {
    let lotteryView = UIView()
    let dismissButton = UIButton()
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let pointTextField = UITextField()
    let commitButton = UIButton()
    var delegate: CouponToCheckoutPage?
    private let userProvider = UserProvider(httpClient: HTTPClient())
    private let blue = UIColor(red: CGFloat(99)/250, green: CGFloat(123)/250, blue: CGFloat(127)/250, alpha: 1)
    private let orange = UIColor(red: CGFloat(235)/250, green: CGFloat(181)/250, blue: CGFloat(90)/250, alpha: 1)
    private let lightOrange = UIColor(red: CGFloat(253)/250, green: CGFloat(248)/250, blue: CGFloat(239)/250, alpha: 1)
    var totalPoint: Int = 3
    var currentValue: Int = 0 {
        didSet {
            if currentValue == totalPoint && currentValue == 0{
                currentValue = totalPoint
                pointTextField.text = "\(currentValue)"

            }else if currentValue >= totalPoint {
                currentValue = totalPoint
                pointTextField.text = "\(totalPoint)"
                
            } else if currentValue <= 0 {
                currentValue = 0
                pointTextField.text = "\(currentValue)"
            }else{
                pointTextField.text = "\(currentValue)"
            }
            print(currentValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
    }
    
    func setupLotteryGrid() {
        
        let dimView = UIView(frame: UIScreen.main.bounds)
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.view.addSubview(dimView)
        
        
        self.view.addSubview(lotteryView)
        lotteryView.translatesAutoresizingMaskIntoConstraints = false
        lotteryView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        lotteryView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lotteryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        lotteryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        lotteryView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        lotteryView.backgroundColor = lightOrange
        lotteryView.layer.cornerRadius = 20
        
        lotteryView.addSubview(dismissButton)
        dismissButton.setTitle("X", for: .normal)
        dismissButton.setTitleColor(.B4, for: .normal)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        dismissButton.trailingAnchor.constraint(equalTo: lotteryView.trailingAnchor, constant: -8).isActive = true
        dismissButton.topAnchor.constraint(equalTo: lotteryView.topAnchor, constant: 8).isActive = true
        
        lotteryView.addSubview(titleLabel)
        titleLabel.text = "會員點數：\(totalPoint)點"
        titleLabel.textColor = blue
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 32)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: lotteryView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: lotteryView.topAnchor, constant: 20).isActive = true
        
        lotteryView.addSubview(contentLabel)
        contentLabel.text = "請輸入欲折抵之會員點數"
        contentLabel.textColor = .B4
        contentLabel.font = UIFont(name: "Helvetica", size: 16)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.centerXAnchor.constraint(equalTo: lotteryView.centerXAnchor).isActive = true
        contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        
        lotteryView.addSubview(pointTextField)
        pointTextField.textAlignment = .center
        pointTextField.backgroundColor = .white
        pointTextField.layer.cornerRadius = 10
        pointTextField.layer.borderWidth = 1
        pointTextField.layer.borderColor = orange.cgColor
        pointTextField.translatesAutoresizingMaskIntoConstraints = false
        pointTextField.centerXAnchor.constraint(equalTo: lotteryView.centerXAnchor).isActive = true
        pointTextField.widthAnchor.constraint(equalToConstant: 120).isActive = true
        pointTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        pointTextField.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8).isActive = true
        
        lotteryView.addSubview(commitButton)
        commitButton.setTitle("確認", for: .normal)
        commitButton.setTitleColor(.white, for: .normal)
        commitButton.backgroundColor = orange
        commitButton.isEnabled = true
        commitButton.layer.cornerRadius = 5
        commitButton.addTarget(self, action: #selector(commitButtonTapped), for: .touchUpInside)
        commitButton.translatesAutoresizingMaskIntoConstraints = false
        commitButton.centerXAnchor.constraint(equalTo: lotteryView.centerXAnchor).isActive = true
        commitButton.topAnchor.constraint(equalTo: pointTextField.bottomAnchor, constant: 30).isActive = true
        commitButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        commitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        pointTextField.delegate = self
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [flexibleSpace, doneButton]
        pointTextField.inputAccessoryView = toolbar
    }
    
    @objc func commitButtonTapped() {
        delegate?.couponToCheckoutPage(coupon: currentValue)
        self.dismiss(animated: true)
    }
    
    @objc func doneButtonTapped() {
        if let text = pointTextField.text, let number = Int(text) {
                    currentValue = number
                }
        pointTextField.resignFirstResponder()
//        stepperToTableDelegate?.stepperToTable(cell: self, stepperToTable: currentValue)
    }
    
    @objc func dismissButtonTapped() {
        self.dismiss(animated: true)
    }
    
    private func fetchData() {
        userProvider.getUserProfile(completion: { [weak self] result in
            switch result {
            case .success(let user):
                self?.totalPoint = user.points
                self?.setupLotteryGrid()
            case .failure:
                LKProgressHUD.showFailure(text: "讀取資料失敗！")
            }
        })
    }
}
