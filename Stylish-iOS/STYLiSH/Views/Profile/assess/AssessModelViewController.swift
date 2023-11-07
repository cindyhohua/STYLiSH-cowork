//
//  ReviewModelViewController.swift
//  STYLiSH
//
//  Created by 莊羚羊 on 2023/11/5.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class ReviewModelViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setView()
        view.backgroundColor = .white
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    var productOfColors: [UIColor] = []
    var productOfSize: [String] = []
    var colorView: [UIView] = []
    var sizeLabel: [UIView] = []
    
    var productImage: UIImageView = {
        let image = UIImage(named: "Image_Placeholder")
        let imageView = UIImageView(image: image)
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "我是假的商品"
        label.textColor = .B1
        return label
    }()
    
    let checkButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .B5
        button.isEnabled = false
        button.setTitle("確     認", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    func setColorAndSize(){
        if productOfColors != nil {
            for _ in 0..<productOfColors.count{
                let cView: UIView = {
                    let view = UIView()
                    view.backgroundColor = .B2
                    return view
                }()
                addSubToSuperView(superview: view, subview: cView)
                colorView.append(cView)
            }
        }
        
        if productOfSize != nil {
            for index in 0..<productOfSize.count{
                let sLabel: UILabel = {
                    let label = UILabel()
                    label.text = productOfSize[index]
                    label.textColor = .B1
                    return label
                }()
                addSubToSuperView(superview: view, subview: sLabel)
                sizeLabel.append(sLabel)
            }
        }
    }
    
    func setView(){
        addSubToSuperView(superview: view, subview: productImage)
        addSubToSuperView(superview: view, subview: titleLabel)
        addSubToSuperView(superview: view, subview: checkButton)

        setColorAndSize()
        productImage.setContentCompressionResistancePriority(.required, for: .vertical)
        productImage.setContentHuggingPriority(.required, for: .vertical)
        
        NSLayoutConstraint.activate([
            
            
            productImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            productImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            productImage.heightAnchor.constraint(equalToConstant: 110),
            productImage.widthAnchor.constraint(equalToConstant: 82),
            
            titleLabel.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
        
            checkButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            checkButton.heightAnchor.constraint(equalToConstant: 48),
            checkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
            
        ])
        
        for indexPath in 0..<colorView.count{
            let base = 20
            var leadin: Int = 0
            if indexPath > 0{
                let spacingValue = (indexPath + 1 * 22)
                let offsetValue = ((indexPath) * 8)
                leadin = base + spacingValue + offsetValue
            }else{
                leadin = base
            }
            NSLayoutConstraint.activate([
                colorView[indexPath].widthAnchor.constraint(equalToConstant: 22),
                colorView[indexPath].heightAnchor.constraint(equalToConstant: 22),
                colorView[indexPath].leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: CGFloat(leadin)),
                colorView[indexPath].topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8)
            ])
        }
        
        for indexPath in 0..<sizeLabel.count{
            let base = 20
            var leadin: Int = 0
            if indexPath > 0{
                let spacingValue = (indexPath + 1 * 22)
                let offsetValue = ((indexPath) * 8)
                leadin = base + spacingValue + offsetValue
            }else{
                leadin = base
            }
            NSLayoutConstraint.activate([
                sizeLabel[indexPath].leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: CGFloat(leadin)),
                sizeLabel[indexPath].topAnchor.constraint(equalTo: colorView[0].bottomAnchor, constant: 8)
            ])
        }
            
    }
    
    func addTO(sub: UIView){
        view.addSubview(sub)
        sub.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
}
