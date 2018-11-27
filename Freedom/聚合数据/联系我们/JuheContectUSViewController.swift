//
//  JuheContectUSViewController.swift
//  Freedom
//
import UIKit
import BaseFile
import XExtension
import XCarryOn
class JuheContectUSViewCell:BaseCollectionViewCell{
    override func initUI() {
        self.icon = UIImageView(frame: CGRect(x:0, y:0, width:APPW*2/3, height:120))
        self.title = UILabel(frame: CGRect(x:0, y:YH( self.icon), width:self.icon.width(), height: 20))
        self.title.textAlignment = .center
        self.addSubviews([self.title,self.icon])
        self.title.text = "name"
        self.icon.image = UIImage(named:"taobaomini2")
    }
}
class JuheContectUSViewController: JuheBaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
    self.title = "联系我们";
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: (APPW*2)/3, height:140);
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    layout.minimumInteritemSpacing = 50;
    layout.minimumLineSpacing = 10;
        self.collectionView = BaseCollectionView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH-TopHeight), collectionViewLayout: layout)
        
    self.collectionView.dataArray = NSMutableArray(array: ["进入公众号","查看历史消息","关于我们","聊天"])
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
        self.collectionView.register(JuheContectUSViewCell.self, forCellWithReuseIdentifier: JuheContectUSViewCell.identifier())
    view.addSubview(collectionView)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionView.dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JuheContectUSViewCell.identifier(), for: indexPath) as? JuheContectUSViewCell
        
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row==0{
            _ = self.push(JuhePublicViewController(), withInfo: "", withTitle: "")
        }else if indexPath.row==1{
            _ = self.push(JuheMessageViewController(), withInfo: "", withTitle: "")
        }else if indexPath.row==2{
            _ = self.push(JuheAboutUSViewController(), withInfo: "", withTitle: "")
        }else{
            _ = self.push(JuheChartViewController(), withInfo: "", withTitle: "")
        }
    }
}
