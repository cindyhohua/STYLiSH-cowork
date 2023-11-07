//
//  CouponGameViewController.swift
//  STYLiSH
//
//  Created by 賀華 on 2023/11/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

protocol CouponPageToProfile {
    func couponPageToProfile()
}

class CouponGameViewController: UIViewController {
    private let blue = UIColor(red: CGFloat(99)/250, green: CGFloat(123)/250, blue: CGFloat(127)/250, alpha: 1)
    private let orange = UIColor(red: CGFloat(235)/250, green: CGFloat(181)/250, blue: CGFloat(90)/250, alpha: 1)
    private let lightOrange = UIColor(red: CGFloat(253)/250, green: CGFloat(248)/250, blue: CGFloat(239)/250, alpha: 1)
    private let userProvider = UserProvider(httpClient: HTTPClient())
    var delegate: CouponToCheckoutPage?
    let dismissButton = UIButton()
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let stackView = UIStackView()
    let lotteryView = UIView()
    var memberCoupon: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLotteryGrid()
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
        lotteryView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.2).isActive = true
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
        titleLabel.text = "  幸運抽抽樂！"
        titleLabel.textColor = blue
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 33)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: lotteryView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: lotteryView.topAnchor, constant: 38).isActive = true
        
        lotteryView.addSubview(contentLabel)
        contentLabel.text = "點選方框可隨機獲得會員點數\n{點數將可用於下次消費}"
        contentLabel.textColor = .B4
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.centerXAnchor.constraint(equalTo: lotteryView.centerXAnchor).isActive = true
        contentLabel.bottomAnchor.constraint(equalTo: lotteryView.bottomAnchor, constant: -40).isActive = true
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10 // 間隔
        
        for _ in 0..<3 {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.alignment = .fill
            rowStack.distribution = .fillEqually
            rowStack.spacing = 15 // 間隔
            
            for _ in 0..<3 {
                let button = UIButton(type: .custom)
                if let image = UIImage(named: "hanger") {
                    let resizedImage = image.resizableImage(withCapInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), resizingMode: .stretch)
                    button.setImage(resizedImage, for: .normal)
                }
                button.setImage(UIImage(named: "hanger"), for: .normal)
                button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 40)
                button.layer.cornerRadius = 10
                button.addTarget(self, action: #selector(lotteryButtonTapped(_:)), for: .touchUpInside)
                button.backgroundColor = orange
                rowStack.addArrangedSubview(button)
            }
            
            stackView.addArrangedSubview(rowStack)
        }
        
        lotteryView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: lotteryView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: lotteryView.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: lotteryView.leadingAnchor, constant: 60).isActive = true
        stackView.trailingAnchor.constraint(equalTo: lotteryView.trailingAnchor, constant: -60).isActive = true
        stackView.heightAnchor.constraint(equalTo: lotteryView.heightAnchor, multiplier: 0.5).isActive = true
        
    }
    @objc func lotteryButtonTapped(_ sender: UIButton) {
        UIView.transition(with: sender, duration: 0.8, options: .transitionFlipFromRight, animations: {
            sender.backgroundColor = self.blue
            sender.setImage(.none, for: .normal)
            sender.setTitle("!", for: .normal)
            sender.setTitleColor(self.orange, for: .normal)
        }, completion: nil)
        showLotteryResult()
    }
    
    @objc func dismissButtonTapped() {
        if memberCoupon != 0 {
            updateCoupon(coupon: memberCoupon)
        }
        self.dismiss(animated: true)
    }
    
    func showLotteryResult() {
        UIView.animate(withDuration: 1 ,delay: 0.8) {
            self.titleLabel.alpha = 0
            self.stackView.alpha = 0
            self.contentLabel.alpha = 0
        }
        let resultImageView = UIImageView(image: UIImage(named: "couponResult"))
        resultImageView.contentMode = .scaleAspectFit
        resultImageView.translatesAutoresizingMaskIntoConstraints = false
        lotteryView.addSubview(resultImageView)
        resultImageView.alpha = 0
        resultImageView.centerXAnchor.constraint(equalTo: self.lotteryView.centerXAnchor).isActive = true
        resultImageView.centerYAnchor.constraint(equalTo: self.lotteryView.centerYAnchor).isActive = true
        resultImageView.leadingAnchor.constraint(equalTo: self.lotteryView.leadingAnchor, constant: 16).isActive = true
        resultImageView.trailingAnchor.constraint(equalTo: self.lotteryView.trailingAnchor, constant: -10).isActive = true
        self.titleLabel.text = "！恭喜中獎！"
        self.contentLabel.text = "點數將可用於下次消費"
        
        let randomNumber = Int.random(in: 1...10)
        self.memberCoupon = 5*randomNumber
        uploadDailyevent(point: memberCoupon, token: KeyChainManager.shared.token ?? "")
        var lotteryContent = UILabel()
        lotteryView.addSubview(lotteryContent)
        let text = "會員點數 \n\(self.memberCoupon)點"
        let attributedText = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        lotteryContent.attributedText = attributedText
        lotteryContent.alpha = 0
        lotteryContent.textAlignment = .center
        lotteryContent.numberOfLines = 0
        lotteryContent.textColor = blue
        lotteryContent.font = UIFont(name: "Helvetica-Bold", size: 40)
        lotteryContent.translatesAutoresizingMaskIntoConstraints = false
        lotteryContent.centerXAnchor.constraint(equalTo: resultImageView.centerXAnchor, constant: -12).isActive = true
        lotteryContent.centerYAnchor.constraint(equalTo: resultImageView.centerYAnchor, constant: 6).isActive = true
        UIView.animate(withDuration: 1,delay: 1){
            resultImageView.alpha = 1
            self.titleLabel.alpha = 1
            self.contentLabel.alpha = 1
            lotteryContent.alpha = 1
        }
    }
    
    private func uploadDailyevent(point: Int, token: String) {
        userProvider.updatePoint(point: point, token: token, completion: { [weak self] result in
            switch result {
            case .success:
                print("Update success")
            case .failure:
                print("failed to update")
            }
        })
    }
    
    func updateCoupon(coupon: Int) {
        delegate?.couponToCheckoutPage(coupon: memberCoupon)
    }
}
