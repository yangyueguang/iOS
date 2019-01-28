//
//  LibraryCollectionViewController.swift
//  Freedom
//
//  Created by Super on 6/15/18.
//  Copyright © 2018 Super. All rights reserved.
//
import UIKit
import XExtension
class LibraryCollectionViewCell: BaseCollectionViewCell {
    override func initUI() {
        super.initUI()
        icon.frame = CGRect(x: 0, y: 0, width: APPW / 5, height: 80)
        icon.layer.cornerRadius = 40
        icon.clipsToBounds = true
        title.frame = CGRect(x: 0, y: icon.bottom, width: icon.width, height: 20)
        title.textAlignment = .center
        backgroundColor = UIColor.clear
        addSubviews([icon, title])
    }
}
class LibraryCollectionViewController: BaseViewController,ElasticMenuTransitionDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    var collectionView: BaseCollectionView!
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
        let tm = transitioningDelegate as! ElasticTransition
        print( "transition.edge = .\(tm.edge)\n" +
            "transition.transformType = .\(tm.transformType)\n" +
            "transition.sticky = \(tm.sticky)\n" +
            "transition.showShadow = \(tm.showShadow)")
        collectionView.register(LibraryCollectionViewCell.self, forCellWithReuseIdentifier: LibraryCollectionViewCell.identifier)
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
        var cell = collectionView.dequeueCell(LibraryCollectionViewCell.self, for: indexPath)
        let dict = items[indexPath.row]
        cell.title.text = dict["title"]
        cell.icon.image = UIImage(named: dict["icon"]!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mode = PopoutModel()
        mode.name = items[indexPath.row]["control"]!
        AppDelegate.radialView.didSelectBlock!(AppDelegate.radialView, false,false,mode)
    }
}
