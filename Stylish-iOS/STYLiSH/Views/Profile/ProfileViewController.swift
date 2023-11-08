//
//  ProfileViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/14.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, CouponToCheckoutPage, UIScrollViewDelegate {
    func couponToCheckoutPage(coupon: Int) {
        fetchData()
    }
    
    
    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelInfo: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    private var memberCoupon: Int = 0
    
    private var couponLabel = UILabel()
    
    private let manager = ProfileManager()
    
    private let userProvider = UserProvider(httpClient: HTTPClient())
    
//    var scrollView: UIScrollView!
//    var imageViews: [UIImageView] = []
//    var currentIndex = 0
//    var timer: Timer?
//    func setScrollView() {
//        let images = [UIImage(named: "star-1"), UIImage(named: "star-2"), UIImage(named: "star-3")]
//
//        // 创建 UIScrollView
//        scrollView = UIScrollView()
//        scrollView.isPagingEnabled = true
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.delegate = self
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
//        view.addSubview(scrollView)
//
//        // 配置 UIScrollView
//        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        scrollView.heightAnchor.constraint(equalToConstant: 80)
//        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//
//        for (index, image) in images.enumerated() {
//            let imageView = UIImageView(image: image)
//            imageView.translatesAutoresizingMaskIntoConstraints = false
//            scrollView.addSubview(imageView)
//            imageViews.append(imageView)
//
//            // 设置约束以水平排列图片
//            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CGFloat(index) * view.frame.width).isActive = true
//            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//            imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//            imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
//        }
//
//        // 设置 UIScrollView 的 contentSize
//        scrollView.contentSize = CGSize(width: CGFloat(images.count) * view.frame.width, height: view.frame.height)
//
//        // 启动定时器，每3秒滚动到下一张广告
//        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextAd), userInfo: nil, repeats: true)
//    }
//
//    @objc func scrollToNextAd() {
//        let nextPage = (currentIndex + 1) % imageViews.count
//        scrollView.setContentOffset(CGPoint(x: CGFloat(nextPage) * view.frame.width, y: 0), animated: true)
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let contentOffsetX = scrollView.contentOffset.x
//        currentIndex = Int(contentOffsetX / view.frame.width)
//    }
    
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("登出", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .B1
        return button
    }()
    
    private var user: User? {
        didSet {
            if let user = user {
                updateUser(user)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLongout()
//        setScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        fetchData()
    }
    // MARK: - 登出按鈕
    private func setupLongout(){
        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.layer.cornerRadius = 10
        NSLayoutConstraint.activate([
            logoutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            logoutButton.heightAnchor.constraint(equalToConstant: 48),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
        
        logoutButton.addTarget(self, action: #selector(logoutActive), for: .touchUpInside)
    }
    
    @objc func logoutActive(){
        print("我要登出！！！")
        
        if let tabBarController = self.tabBarController {
            // 选择第一个标签
            tabBarController.selectedIndex = 0
        }
        KeyChainManager.shared.token = nil
        
    }
    
    // MARK: - Action
    private func fetchData() {
        userProvider.getUserProfile(completion: { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
                if user.isDailyEvent { // == false
                    self?.couponGame()
                }
            case .failure:
                LKProgressHUD.showFailure(text: "讀取資料失敗！")
            }
        })
    }
    
    private func couponGame(){
        let couponViewController = CouponGameViewController()
        couponViewController.delegate = self
        couponViewController.modalPresentationStyle = .overFullScreen
        present(couponViewController, animated: true)
    }
    
    private func updateUser(_ user: User) {
        imageProfile.loadImage(user.picture, placeHolder: .asset(.Icons_36px_Profile_Normal))
        labelName.text = user.name
        labelInfo.text = user.getUserInfo()
        labelInfo.isHidden = false
        view.addSubview(couponLabel)
        couponLabel.translatesAutoresizingMaskIntoConstraints = false
        couponLabel.font = UIFont(name: "Helvetica", size: 15)
        couponLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        couponLabel.centerYAnchor.constraint(equalTo: imageProfile.centerYAnchor, constant: -10).isActive = true
        couponLabel.text = "會員點數：\(user.points)點"
        couponLabel.textColor = .white
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manager.groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.groups[section].items.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ProfileCollectionViewCell.self),
            for: indexPath
        )
        guard let profileCell = cell as? ProfileCollectionViewCell else { return cell }
        let item = manager.groups[indexPath.section].items[indexPath.row]
        profileCell.layoutCell(image: item.image, text: item.title)
        return profileCell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: String(describing: ProfileCollectionReusableView.self),
                for: indexPath
            )
            guard let profileView = header as? ProfileCollectionReusableView else { return header }
            let group = manager.groups[indexPath.section]
            profileView.layoutView(title: group.title, actionText: group.action?.title)
            return profileView
        }
        return UICollectionReusableView()
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 3{
            navigationController?.pushViewController(MyOrderListViewController(), animated: true)
        }
        if indexPath.section == 1 && indexPath.row == 6{
            let lineURL = URL(string: "https://liff.line.me/1645278921-kWRPP32q/?accountId=480zjqff") // Line 群组或朋友 ID
            
            if UIApplication.shared.canOpenURL(lineURL!) {
                UIApplication.shared.open(lineURL!, options: [:], completionHandler: nil)
            } else {
                // 如果没有安装 Line，则打开 Safari 并自动打开网址
                //                let safariURL = URL(string: "https://liff.line.me/1645278921-kWRPP32q/?accountId=480zjqff")!
                //                UIApplication.shared.open(safariURL, options: [:], completionHandler: nil)
                // 若沒安裝 Line 則導到 App Store(id443904275 為 Line App 的 ID)
                let lineURL = URL(string: "https://liff.line.me/1645278921-kWRPP32q/?accountId=480zjqff")!
                UIApplication.shared.open(lineURL, options: [:], completionHandler: nil)
            }
        }
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: UIScreen.width / 5.0, height: 60.0)
        } else if indexPath.section == 1 {
            return CGSize(width: UIScreen.width / 4.0, height: 60.0)
        }
        return CGSize.zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24.0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 24.0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: UIScreen.width, height: 48.0)
    }
}
