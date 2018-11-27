//
//  LibraryCollectionViewController.swift
//  Freedom
//
//  Created by Super on 6/15/18.
//  Copyright © 2018 Super. All rights reserved.
//
import UIKit
import ElasticTransitionObjC
import BaseFile
import XExtension
import SVProgressHUD
class LibraryCollectionViewCell: BaseCollectionViewCell {
    override func initUI() {
        super.initUI()
        icon.frame = CGRect(x: 0, y: 0, width: APPW / 5, height: 80)
        icon.layer.cornerRadius = 40
        icon.clipsToBounds = true
        title.frame = CGRect(x: 0, y: YH(icon), width: W(icon), height: 20)
        title.textAlignment = .center
        backgroundColor = UIColor.clear
        addSubviews([icon, title])
    }
}
class LibraryCollectionViewController: XBaseViewController,ElasticMenuTransitionDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    var contentLength:CGFloat = APPW
    var items:[[String:String]] = (UIApplication.shared.delegate as! AppDelegate).items
    var dismissByBackgroundTouch = true
    var dismissByBackgroundDrag = true
    var dismissByForegroundDrag = true
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: APPW / 5, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 30, left: 10, bottom: 0, right: 10)
        collectionView = BaseCollectionView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH - 110), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        let backView = UIImageView(frame: CGRect(x: 0, y: 100, width: APPW, height: APPH - 100))
        backView.image = UIImage(named: "")
        collectionView?.backgroundView = backView
        let ET = transitioningDelegate as? ElasticTransition
        print("\ntransition.edge = \(HelperFunctions.type(toStringOf: (ET?.edge)!))\ntransition.transformType = \(String(describing: ET?.transformTypeToString()))\ntransition.sticky = \(String(describing:  ET?.sticky))\ntransition.showShadow = \(String(describing: ET?.showShadow))")
        collectionView.register(LibraryCollectionViewCell.self, forCellWithReuseIdentifier: LibraryCollectionViewCell.identifier())
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: LibraryCollectionViewCell.identifier(), for: indexPath) as? LibraryCollectionViewCell
        if cell == nil {
            cell = LibraryCollectionViewCell(frame: CGRect(x: 0, y: 0, width: APPW / 5, height: 100))
        }
        let dict = items[indexPath.row]
        cell?.title.text = dict["title"]
        cell?.icon.image = UIImage(named: dict["icon"]!)
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mode = PopoutModel()
        mode.name = items[indexPath.row]["control"]!
        AppDelegate.radialView.didSelectBlock!(AppDelegate.radialView, false,false,mode)
    }
}
