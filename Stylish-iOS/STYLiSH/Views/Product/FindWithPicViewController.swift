//
//  FindWithPicViewController.swift
//  STYLiSH
//
//  Created by 賀華 on 2023/11/6.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit
class FindWithPicViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    let selectedImageView = UIImageView()
    let searchButton = UIButton()
    var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setLayout()
//        addSearchButton()
    }
    
    func setLayout() {
        let selectPhotoButton = UIButton(type: .system)
        selectPhotoButton.setTitle("選擇照片", for: .normal)
        selectPhotoButton.addTarget(self, action: #selector(selectPhotoButtonTapped), for: .touchUpInside)
        selectPhotoButton.translatesAutoresizingMaskIntoConstraints = false

        // 添加其他 UI 元素，例如顯示已選擇照片的UIImageView和上傳按鈕

        view.addSubview(selectPhotoButton)
        selectPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectPhotoButton.topAnchor.constraint(equalTo: view.topAnchor,constant: 100).isActive = true
        
        view.addSubview(selectedImageView)
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        selectedImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectedImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        selectedImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-60).isActive = true
        selectedImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-60).isActive = true
//        selectedImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }

    @objc func selectPhotoButtonTapped() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            print("qqq")
            self.selectedImage = selectedImage
            selectedImageView.image = selectedImage
            selectedImageView.contentMode = .scaleAspectFit
            selectedImageView.layer.cornerRadius = 5
            addSearchButton()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func addSearchButton() {
        self.view.addSubview(searchButton)
        searchButton.tintColor = .B1
        searchButton.backgroundColor = .B1
        searchButton.setTitle("開始以圖搜圖", for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.layer.cornerRadius = 5
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchButton.topAnchor.constraint(equalTo: selectedImageView.bottomAnchor).isActive = true
        searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
    }
    
    @objc func search() {
        if let selectedImage = selectedImage {
            print(selectedImage.size)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // 實現上傳照片的邏輯，可以使用 URLSession 或其他方式
    // 記得實現 API POST 請求
}

