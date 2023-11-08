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
        self.view.addSubview(selectPhotoButton)
        selectPhotoButton.tintColor = .B1
        selectPhotoButton.backgroundColor = .B1
        selectPhotoButton.setTitle("點 此 選 擇 照 片", for: .normal)
        selectPhotoButton.setTitleColor(.white, for: .normal)
        selectPhotoButton.titleLabel?.font = UIFont(name: "Helvetica", size: 18.0)
        selectPhotoButton.layer.cornerRadius = 5
        selectPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        selectPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        selectPhotoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        selectPhotoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        selectPhotoButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        selectPhotoButton.addTarget(self, action: #selector(selectPhotoButtonTapped), for: .touchUpInside)
        
        view.addSubview(selectedImageView)
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        selectedImageView.topAnchor.constraint(equalTo: selectPhotoButton.bottomAnchor, constant: 70).isActive = true
        selectedImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        selectedImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        selectedImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
//        selectedImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }

//    @objc func selectPhotoButtonTapped() {
//        imagePicker.delegate = self
//        imagePicker.sourceType = .photoLibrary
//        present(imagePicker, animated: true, completion: nil)
//    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            selectPhotoButton.setTitle("重 新 選 擇 照 片", for: .normal)
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
        searchButton.setTitle("開 始 以 圖 搜 圖", for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.titleLabel?.font = UIFont(name: "Helvetica", size: 18.0)
        searchButton.layer.cornerRadius = 5
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchButton.topAnchor.constraint(equalTo: selectPhotoButton.bottomAnchor, constant: 10).isActive = true
        searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
    }
    
    @objc func search() {
        if let selectedImage = selectedImage {
            var imageData: Data = selectedImage.jpegData(compressionQuality: 1.0)!
            var xVar = 0.0
            while Double(imageData.count) / (1024.0 * 1024.0) > 5 {
                imageData = selectedImage.jpegData(compressionQuality: (1.0 - xVar))!
                xVar += 0.1
            }
            uploadImageToAPI(imageData: imageData)
        }
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
    
    func uploadImageToAPI(imageData: Data) {
        LKProgressHUD.show()
        let url = URL(string: "https://7jiun.shop/api/products/imageSearch")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"uploaded_image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body as Data
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else if let data = data {
                do {
                    let products = try JSONDecoder().decode(ProductData.self, from: data)
                    print("Data: \(products)")
                    DispatchQueue.main.async {
                        LKProgressHUD.dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                if products.data.isEmpty {
                                    LKProgressHUD.showFailure(text: "沒有相似的產品")
                                } else {
                                    self.handleParsedData(products)
                                }
                            }
                        
                    }
                } catch {
                    LKProgressHUD.dismiss()
                    print("解析 JSON 數據時出錯: \(error)")
                }
                let responseString = String(data: data, encoding: .utf8)
                print("Data: \(responseString ?? "無法解析數據QQ")")
                }
        }
        task.resume()
    }

    func handleParsedData(_ parsedData: ProductData) {
        let nextVC = FindWithPicListViewController()
        nextVC.products = parsedData
        navigationController?.pushViewController(nextVC, animated: true)
    }

}
