//
//  JuheDynamicViewController.swift
//  Freedom
import UIKit
import XExtension
import XCarryOn
class JuheDynamicCollectionViewCell:BaseCollectionViewCell{
    override func initUI() {
        backgroundColor = .white
        self.icon = UIImageView(frame: CGRect(x: 10, y:0, width:self.bounds.size.width-20, height:self.bounds.size.height-20))
        self.title = UILabel(frame: CGRect(x:10, y: self.icon.bottom, width:self.bounds.size.width-20, height: 20))
        self.title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 14)
        title.backgroundColor = .red
        title.textColor = .white
        title.layer.cornerRadius = 5
        title.layer.masksToBounds = true
        self.addSubviews([self.title,self.icon])
        self.title.text = "name"
        self.icon.image = UIImage(named:"taobaomini2")
    }
}
class JuheDynamicViewController: JuheBaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
    self.title = "聚合动态";
    let backimagev = UIImageView(frame:view.bounds)
        backimagev.image = UIImage(named:"backgroundImage.jpg")
    backimagev.contentMode = .scaleAspectFill
    view.addSubview(backimagev)
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: (APPW-50)/4, height:110);
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
self.collectionView = BaseCollectionView(frame: CGRect(x: 0, y: APPH-360, width: APPW, height: 300), collectionViewLayout: layout)
self.collectionView.register(JuheDynamicCollectionViewCell.self, forCellWithReuseIdentifier: JuheDynamicCollectionViewCell.identifier())
        
        self.collectionView.dataArray = NSMutableArray(array: ["身份证认证","手机归属地","身份证查询","常用快递","餐饮美食","菜谱大全","彩票开奖","邮编查询"])
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    self.collectionView.backgroundColor = .clear
    self.collectionView.isScrollEnabled = false
    view.addSubview(collectionView)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionView.dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JuheDynamicCollectionViewCell.identifier(), for: indexPath) as? JuheDynamicCollectionViewCell
        
        return cell!
    }
}
