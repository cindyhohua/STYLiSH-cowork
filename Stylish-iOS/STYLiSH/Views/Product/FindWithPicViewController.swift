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
    let selectPhotoButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setLayout()
//        addSearchButton()
    }
    
    func setLayout() {
        selectPhotoButton.setTitle("點此選擇照片", for: .normal)
        selectPhotoButton.setTitleColor(.B1, for: .normal)
        selectPhotoButton.addTarget(self, action: #selector(selectPhotoButtonTapped), for: .touchUpInside)
        selectPhotoButton.translatesAutoresizingMaskIntoConstraints = false

        // 添加其他 UI 元素，例如顯示已選擇照片的UIImageView和上傳按鈕

        view.addSubview(selectPhotoButton)
        selectPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectPhotoButton.topAnchor.constraint(equalTo: view.topAnchor,constant: 160).isActive = true
        
        view.addSubview(selectedImageView)
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        selectedImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectedImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        selectedImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-60).isActive = true
        selectedImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-60).isActive = true
//        selectedImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }

//    @objc func selectPhotoButtonTapped() {
//        imagePicker.delegate = self
//        imagePicker.sourceType = .photoLibrary
//        present(imagePicker, animated: true, completion: nil)
//    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            selectPhotoButton.setTitle("重新選擇照片", for: .normal)
            self.selectedImage = selectedImage
            selectedImageView.image = selectedImage
            selectedImageView.clipsToBounds = true
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
        searchButton.topAnchor.constraint(equalTo: selectedImageView.bottomAnchor, constant: 10).isActive = true
        searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
    }
    
    @objc func search() {
        if let selectedImage = selectedImage {
            if let imageData = selectedImage.jpegData(compressionQuality: 1.0) {
                let fileSize = Double(imageData.count) / (1024.0 * 1024.0)
                print("图像文件大小：\(fileSize) MB")
            }
        }
//                let fileSize = Double(imageData.count) / (1024.0 * 1024.0)
//                if fileSize > 5 {
//                    if let imageData = selectedImage.jpegData(compressionQuality: 0.9) {
//                        let fileSize = Double(imageData.count) / (1024.0 * 1024.0)
//                        print("图像文件大小：\(fileSize) MB")
//                        uploadImage(imageData: imageData)
//                    }
//                } else {
//                    print("图像文件大小：\(fileSize) MB")
//                    uploadImage(imageData: imageData)
//                }
//            } else {
//                print("??")
//            }
//        } else {
//            print("???")
//        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func selectPhotoButtonTapped() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "從相簿中選擇", style: .default) { _ in
            self.showImagePicker(sourceType: .photoLibrary)
        })

        alertController.addAction(UIAlertAction(title: "拍照", style: .default) { _ in
            self.showImagePicker(sourceType: .camera)
        })

        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))

        present(alertController, animated: true)
    }
        
    func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        if sourceType == .photoLibrary {
            imagePicker.sourceType = sourceType
            present(imagePicker, animated: true, completion: nil)
        } else if sourceType == .camera {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = sourceType
                present(imagePicker, animated: true, completion: nil)
            } else {
                print("設備不支援相機")
            }
        } else {
            print("相機不可用或其他情况")
        }
    }
    
    func uploadImage(imageData: Data) {
    }

}
