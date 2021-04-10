//
//  ChangeSkinViewController.swift
//  GTRead
//
//  Created by Dev on 2021/4/10.
//

import UIKit

class ChangeSkinViewController: GTBaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var skinData: [String] = ["活力红", "经典蓝", "炫酷黑"]
    var skinColor: [UIColor] = [UIColor.systemRed, UIColor.systemBlue, UIColor.black]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "皮肤"
        self.view.backgroundColor = UIColor.white
        
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        let collectionView = ChangeSkinCollectionView(frame: CGRect(x: 30, y: 50, width:self.view.bounds.size.width - 60, height: self.view.bounds.height))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    func blur() {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blur.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 300)
        view.addSubview(blur)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) ->Int {
        return skinData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for:indexPath) as! ChangeSkinViewControllerViewCell
        
        cell.title.text = skinData[indexPath.row]
        cell.btnView.backgroundColor = skinColor[indexPath.row]
        
        return cell
    }
    
    //实现某个cell被选择的事件处理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}
