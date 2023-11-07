//
//  FindWithPicListViewController.swift
//  STYLiSH
//
//  Created by 賀華 on 2023/11/7.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit
class FindWithPicListViewController: STCompondViewController {
    var products: ProductData?
    var pdata: [Product] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print("QQqQQ", products)
        setupTableView()
        setupCollectionView()
        pdata = products!.data
        datas = [pdata]
    }
    
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.lk_registerCellWithNib(
            identifier: String(describing: ProductTableViewCell.self),
            bundle: nil
        )
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.lk_registerCellWithNib(
            identifier: String(describing: ProductCollectionViewCell.self),
            bundle: nil
        )
        setupCollectionViewLayout()
    }
    private func setupCollectionViewLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(
            width: Int(164.0 / 375.0 * UIScreen.width),
            height: Int(164.0 / 375.0 * UIScreen.width * 308.0 / 164.0)
        )
        flowLayout.sectionInset = UIEdgeInsets(top: 24.0, left: 16.0, bottom: 24.0, right: 16.0)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 24.0
        collectionView.collectionViewLayout = flowLayout
    }
    
    private func showProductDetailViewController(product: Product) {
        let productDetailVC = UIStoryboard.product.instantiateViewController(withIdentifier:
            String(describing: ProductDetailViewController.self)
        )
        guard let detailVC = productDetailVC as? ProductDetailViewController else { return }
        detailVC.product = product
        show(detailVC, sender: nil)
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ProductCollectionViewCell.self),
            for: indexPath
        )
        guard
            let productCell = cell as? ProductCollectionViewCell,
            let product = products?.data[indexPath.row] as? Product
        else {
            return cell
        }
        productCell.layoutCell(
            image: product.mainImage,
            title: product.title,
            price: product.price,
            starNumber: Float(round(10*(product.averageScore ?? 0))/10),
            commentAmount: product.feedbackAmounts ?? 0
        )
        return productCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let product = products?.data[indexPath.row] as? Product else { return }
        showProductDetailViewController(product: product)
    }
}
