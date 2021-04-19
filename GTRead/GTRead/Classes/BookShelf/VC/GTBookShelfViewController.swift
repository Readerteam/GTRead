//
//  GTBookShelfViewController.swift
//  GTRead
//
//  Created by YangJie on 2021/2/20.
//

import UIKit
import SnapKit

class GTBookShelfViewController: GTBaseViewController {
    
    private let cellName = "bookCollectioncell"
    
    lazy var bookCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.white
        collectionView.register(GTBookCollectionCell.self, forCellWithReuseIdentifier: cellName)
        return collectionView
    }()
    
    var viewModel: GTBookShelfViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        
        GTNet.shared.loginTest()
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.white
        
        // 导航条设置
        self.title = "书架"
        
        let navHeight = self.navigationController?.navigationBar.frame.height ?? 0
        self.view.addSubview(bookCollectionView)
        bookCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(navHeight)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalToSuperview()
        }
        
        self.viewModel = GTBookShelfViewModel(viewController: self,collectionView: self.bookCollectionView)
    }
}
