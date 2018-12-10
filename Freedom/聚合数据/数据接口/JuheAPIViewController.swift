//
//  JuheAPIViewController.swift
//  Freedom
//
//  Created by Super on 2018/5/16.
//  Copyright © 2018年 Super. All rights reserved.
//
import UIKit
import XExtension
import XCarryOn
class JuheAPICollectionViewCell:BaseCollectionViewCell{
    override func initUI() {
        self.icon = UIImageView(frame: CGRect(x: 10, y: 0, width:self.bounds.size.width-20, height: self.bounds.size.width-20))
        self.icon.layer.cornerRadius = 10
        self.icon.clipsToBounds = true
        self.title = UILabel(frame: CGRect(x:0, y: self.icon.bottom, width:self.icon.bounds.size.width, height: 20))
        self.title.textAlignment = .center
        self.addSubviews([self.title,self.icon])
        self.title.text = "name"
        self.icon.image = UIImage(named:"taobaomini2")
    }
}
class JuheAPIViewController: JuheBaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"juheadd"), style: .plain, target: nil, action: nil)
    let searchBar = UISearchBar()
    searchBar.placeholder = "请输入想要查找的接口";
    self.navigationItem.titleView = searchBar;
    
    let banner = BaseScrollView(banner: CGRect(x: 0, y: 0, width: APPW, height: 120), icons: ["",""])
        let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: (APPW-50)/4, height:90);
        layout.sectionInset = UIEdgeInsets(top:  banner.bottom+10, left: 10, bottom: 0, right:10)
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    
    self.collectionView = BaseCollectionView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH-100), collectionViewLayout: layout)
        self.collectionView.dataArray = NSMutableArray(array: ["IP地址","手机号码归属地","身份证查询","常用快递","餐饮美食","菜谱大全","彩票开奖结果","邮编查询","律师查询","笑话大全","小说大全","恋爱物语","商品比价","新闻","微信精选","经典日至","天气查询","手机话费","个人缴费","移动出行","足球赛事","新闻资讯","视频播放","流量充值"])
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
        self.collectionView.register(JuheAPICollectionViewCell.self, forCellWithReuseIdentifier: JuheAPICollectionViewCell.identifier())
        collectionView.addSubview(banner)
        view.addSubview(collectionView)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionView.dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JuheAPICollectionViewCell.identifier(), for: indexPath) as? JuheAPICollectionViewCell
        
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let name =  self.collectionView.dataArray[indexPath.row] as! String
        _ = self.push(JuheAPIDetailViewController(), withInfo: "", withTitle:name)
    }
}
