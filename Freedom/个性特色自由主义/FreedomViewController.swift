//
//  FreedomViewController.swift
//  Freedom
//
//  Created by Super on 2018/5/15.
//  Copyright © 2018年 Super. All rights reserved.
//
import UIKit
import XExtension
import XCarryOn
class FreedomViewCell:BaseCollectionViewCell{
    override func initUI() {
        self.icon = UIImageView(frame: CGRect(x: 10, y: 0, width: APPW/5-20, height: 40))
        self.title = UILabel(frame: CGRect(x: 0, y: YH( self.icon), width: APPW/5-12, height: 20))
        self.title.font = UIFont.systemFont(ofSize: 14)
        self.title.textAlignment = .center
        self.addSubviews([self.title,self.icon])
    }
}
class FreedomViewController: FreedomBaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个性特色自由主义";
        let left = UIBarButtonItem(title: "设置", style: .plain, target: nil, action: nil)
        let right = UIBarButtonItem(image: UIImage(named: "Padd"), style: .done, target: nil, action: nil)
        navigationItem.leftBarButtonItem = left
        navigationItem.rightBarButtonItem = right
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (APPW-50)/4, height: 60)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.headerReferenceSize = CGSize(width: APPW, height: 30)
        layout.footerReferenceSize = CGSize.zero
        self.collectionView = BaseCollectionView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH-110), collectionViewLayout: layout)
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = .white;
        self.collectionView.frame = self.view.bounds;
        self.collectionView.register(FreedomViewCell.self, forCellWithReuseIdentifier: FreedomViewCell.identifier())
        view.addSubview(self.collectionView)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.edgesForExtendedLayout = .all
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:FreedomViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: FreedomViewCell.identifier(), for: indexPath) as! FreedomViewCell
        cell.title.text = "name"
        cell.icon.image = UIImage(named: "userLogo")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let log = "你选择的是\(indexPath.section)，\(indexPath.row)"
        noticeInfo(log)
        _ = self.push(FreedomBooksViewController(), withInfo: indexPath.row, withTitle: "书籍详情")
    }
}
