//
//  GTBookShelfViewController.swift
//  GTRead
//
//  Created by YangJie on 2021/2/20.
//

import UIKit
import MJRefresh
import SnapKit

let cellName = "bookCollectioncell"

class GTBookShelfViewController: GTBaseViewController {
    
    lazy var bookCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.white
        collectionView.register(GTBookCollectionCell.self, forCellWithReuseIdentifier: cellName)
        return collectionView
    }()
    var leftButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isHidden = true
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    var rightButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("编辑", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    var deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isHidden = true
        button.setTitle("删除", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        return button
    }()
    var viewModel: GTBookShelfViewModel?
    
    var isEdit: Bool = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.white
        self.setupNavigation()
        let header = MJRefreshNormalHeader()
        header.setTitle("下拉刷新", for: .idle)
        header.setTitle("释放更新", for: .pulling)
        header.setTitle("正在刷新...", for: .refreshing)
        header.setRefreshingTarget(self, refreshingAction: #selector(refresh(refreshControl:)))
        bookCollectionView.mj_header = header
        self.view.addSubview(bookCollectionView)
        bookCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(88)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalToSuperview()
        }
        self.viewModel = GTBookShelfViewModel(viewController: self,collectionView: self.bookCollectionView)
        self.viewModel?.seletedEvent = { [weak self] count in
            if count > 0 {
                self?.deleteButton.isHidden = false
            }else{
                self?.deleteButton.isHidden = true
            }
        }
    }
    
    // 导航条
    func setupNavigation() {
        self.title = "我的书籍"
        leftButton.addTarget(self, action: #selector(cancelEditEvent), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        deleteButton.addTarget(self, action: #selector(deleteEvent), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(StartEditEvent), for: .touchUpInside)
        let rightItems = [UIBarButtonItem(customView: rightButton),UIBarButtonItem(customView: deleteButton)]
        self.navigationItem.rightBarButtonItems = rightItems
    }
    
    @objc func refresh(refreshControl: UIRefreshControl) {
        // 模拟请求
        self.viewModel?.reloadBookDate()
        refreshControl.endRefreshing()
    }
    
    @objc func StartEditEvent() {
        if isEdit {
            // 全选事件
            self.viewModel?.seletedAll()
        }else{
            isEdit = true
            leftButton.isHidden = false
            rightButton.setTitle("全选", for: .normal)
            // 进入编辑模式
            self.viewModel?.startEditing(isEditIng: true)
        }
    }
    
    @objc func cancelEditEvent() {
        isEdit = false
        leftButton.isHidden = true
        deleteButton.isHidden = true
        rightButton.setTitle("编辑", for: .normal)
        self.viewModel?.cancelEditing()
    }
    
    @objc func deleteEvent() {
        isEdit = false
        leftButton.isHidden = true
        deleteButton.isHidden = true
        rightButton.setTitle("编辑", for: .normal)
        self.viewModel?.deleteImages()
    }
}
