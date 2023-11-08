////
////  ScrollUIView.swift
////  STYLiSH
////
////  Created by 賀華 on 2023/11/8.
////  Copyright © 2023 AppWorks School. All rights reserved.
////
//
//import UIKit
//
//class ScrollUIView: UIView , UIScrollViewDelegate {
//    var scrollView: UIScrollView!
//    var imageViews: [UIImageView] = []
//    var currentIndex = 0
//    var timer: Timer?
//    
//    func setScroll() {
////        super.viewDidLoad()
//
//        // 设置广告图片数组
//        let images = [UIImage(named: "ad1"), UIImage(named: "ad2"), UIImage(named: "ad3")]
//
//        // 创建 UIScrollView
//        scrollView = UIScrollView()
//        scrollView.isPagingEnabled = true
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.delegate = self
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
////        view.addSubview(scrollView)
//
//        // 配置 UIScrollView
////        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
////        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
////        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
////        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//
//        for (index, image) in images.enumerated() {
//            let imageView = UIImageView(image: image)
//            imageView.translatesAutoresizingMaskIntoConstraints = false
//            scrollView.addSubview(imageView)
//            imageViews.append(imageView)
//
////            // 设置约束以水平排列图片
////            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CGFloat(index) * view.frame.width).isActive = true
////            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
////            imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
////            imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
////        }
////
////        // 设置 UIScrollView 的 contentSize
////        scrollView.contentSize = CGSize(width: CGFloat(images.count) * view.frame.width, height: view.frame.height)
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
//}
