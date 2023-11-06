//
//  ReviewViewController.swift
//  STYLiSH
//
//  Created by 莊羚羊 on 2023/11/5.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class ReviewViewController: ReviewModelViewController, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setReviewView()
        reviewTextView.delegate = self
        
        reviewTextView.toolbarPlaceholder = "請輸入評論（字數上限：\(maxText)）"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    let maxText = 100
    func textViewDidChange(_ textView: UITextView) {
            // 检查文本长度是否超过上限
            if let text = textView.text, text.count > maxText {
                // 如果超过上限，截取前maxCharacterCount个字符
                let truncatedText = String(text.prefix(maxText))
                textView.text = truncatedText
            }
        }
    let startView = UIView()
    var startButton: [UIButton] = []
    let reviewTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.backgroundColor = .B5
        // 设置属性，使其支持多行输入
        textView.isEditable = true
        textView.isScrollEnabled = true
        // 调整文本容器的边距，使文本不贴近边缘
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.font = UIFont.systemFont(ofSize: 18)
        
        // 将完成按钮添加到工具栏
        textView.returnKeyType = .route
        return textView
    }()
    struct ReqBody{
        var productID: String
    }
    func setButton(){
        for index in 0..<5{
            let startB: UIButton = {
                let button = UIButton()
                button.setImage(UIImage(named: "star-3"), for: .normal)
                return button
            }()
            startB.addTarget(self, action: #selector(starButtonActive(_:)), for: .touchUpInside)
            startB.tag = index
            startButton.append(startB)
            addSubToSuperView(superview: startView, subview: startB)
            let width: CGFloat = 50
            let leagerGap: CGFloat = 40
            let totalGap = view.frame.width - (width * 5) - (leagerGap * 2)
            let gap = totalGap / 4
            let ind = CGFloat(index)
            print("\(gap)")
            var leadin = leagerGap + width * ind + gap * ind
            
            NSLayoutConstraint.activate([
                startB.widthAnchor.constraint(equalToConstant: width),
                startB.heightAnchor.constraint(equalToConstant: width),
                startB.centerYAnchor.constraint(equalTo: startView.centerYAnchor),
                startB.leadingAnchor.constraint(equalTo: startView.leadingAnchor, constant: leadin)
            ])
        }
    }
    
    @objc func starButtonActive(_ sender: UIButton){
        print("\(sender.tag)")
        for index in 0...4{
            if index <= sender.tag{
                startButton[index].setImage(UIImage(named: "star-2"), for: .normal)
            }else{
                startButton[index].setImage(UIImage(named: "star-3"), for: .normal)
            }
        }
        checkButton.isEnabled = true
        checkButton.backgroundColor = .B1
    }
                             
    func setReviewView(){
        addSubToSuperView(superview: view, subview: reviewTextView)
        addSubToSuperView(superview: view, subview: startView)
        setButton()
        
        NSLayoutConstraint.activate([
            startView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            startView.heightAnchor.constraint(equalTo: startView.widthAnchor, multiplier: 1 / 5),
            startView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startView.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 16),
            
            reviewTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            reviewTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            reviewTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reviewTextView.topAnchor.constraint(equalTo: startView.bottomAnchor, constant: 16),
            
        ])
        
        
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
     
        reviewTextView.resignFirstResponder()
            return true
    
    }
}
