//
//  TaobaoCommunityViewController.swift
//  Freedom
import UIKit
import BaseFile
import XExtension
import XCategory
class TaobaoCommunityViewCell1:BaseCollectionViewCell{
    override func initUI() {
        title = UILabel(frame: CGRect(x: 10, y: 0, width: APPW - 20, height: 40))
        title.numberOfLines = 0
        title.font = fontTitle
        icon = UIImageView(frame: CGRect(x: 10, y: YH(title), width: W(self) - 20, height: 100))
        icon.layer.cornerRadius = 10
        icon.clipsToBounds = true
        script = UILabel(frame: CGRect(x: 10, y: YH(icon), width: APPW - 20, height: 60))
        script.numberOfLines = 0
        script.font = fontnomal
        script.textColor = gradtextcolor
        line = UIView(frame: CGRect(x: 0, y: 198, width: APPW, height: 2))
        line.backgroundColor = whitecolor
        addSubviews([title, icon, script, line])
        title.text = "我想买一个6000到8000左右的游戏本，求各位大神给个推荐"
        icon.image = UIImage(named: "image4.jpg")
        script.text = "这款笔记本电脑，用料考究，做工精细，运行速度快，携带方便，是您居家旅行的不二之选，它极致的性能堪比外挂，性价比特别高，建议选联想拯救者或惠普精灵系列的电脑，买电脑千万别图便宜，一分价格一分货。"
    }
}
class TaobaoCommunityViewCell2:BaseCollectionViewCell {
    override func initUI() {
        icon = UIImageView(frame: CGRect(x: 0, y: 0, width: APPW / 2 - 20, height: 100))
        title = UILabel(frame: CGRect(x: 0, y: YH(icon), width: W(icon), height: 70))
        title.font = fontnomal
        title.textColor = gradtextcolor
        title.numberOfLines = 0
        addSubviews([icon, title])
        title.text = "做工很精细，大品牌，值得信赖！用了几天才评价，真实堪称完美！质量上乘，使用方便，是您居家旅行，过节送礼，朋友关系维护的绝佳产品，可以送老人，送孩子，送长辈，价格合理，你值得拥有！"
        icon.image = UIImage(named: "a")
    }
}
class TaobaoCommunityHeadView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initUI() {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 5, width: APPW, height: 20))
        titleLabel.textColor = redcolor
        titleLabel.textAlignment = .center
        titleLabel.text = "每日必看"
        backgroundColor = whitecolor
        addSubview(titleLabel)
    }
}
class TaobaoCommunityViewController: TaobaoBaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    let banner = BaseScrollView(banner: CGRect(x: 0, y: 30, width: APPW, height: 130), icons:["",""])
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchBar = UISearchBar()
        searchBar.placeholder = "你想要的购物经验，这里都能找到"
        navigationItem.titleView = searchBar
        navigationController?.navigationBar.tintColor = UIColor.gray
        let image = UIImage(named: "Taobaomessage")?.withRenderingMode(.alwaysOriginal)
        let leftI = UIBarButtonItem(image: UIImage(named: "TaobaoScanner"), style: .done, actionBlick: {() -> Void in
        })
        let rightI = UIBarButtonItem(image: image, style: .done, actionBlick: {() -> Void in
        })
        navigationItem.leftBarButtonItem = leftI
        navigationItem.rightBarButtonItem = rightI
        _ = [
            "type" : "1"
        ]
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (APPW - 50) / 4, height: 90)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView = BaseCollectionView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH - 110), collectionViewLayout: layout)
        collectionView.dataArray = [["name": "流量充值", "pic": "userLogo"]]
        collectionView.register(TaobaoCommunityViewCell2.self, forCellWithReuseIdentifier:TaobaoCommunityViewCell2.identifier())
        collectionView.register(TaobaoCommunityViewCell1.self, forCellWithReuseIdentifier: TaobaoCommunityViewCell1.identifier())
        collectionView.register(TaobaoCommunityHeadView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headview")
        collectionView.register(TaobaoCommunityHeadView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footview")
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return 5
        }
        if section == 2 {
            return 10
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: BaseCollectionViewCell? = nil
        if indexPath.section == 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier:TaobaoCommunityViewCell1.identifier(), for: indexPath) as? TaobaoCommunityViewCell1
            cell?.frame = CGRect(x: 0, y: 0, width: APPW, height: 100)
            cell?.addSubview(banner)
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaobaoCommunityViewCell2.identifier(), for: indexPath) as? BaseCollectionViewCell
        }
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: APPW, height: 120)
        } else if indexPath.section == 1 {
            return CGSize(width: APPW, height: 200)
        } else {
            return CGSize(width: APPW / 2 - 20, height: APPW / 2 - 20)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: APPW, height: 30)
        }
        return CGSize(width: APPW, height: 30)
    }
    
    //分区尾的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headview", for: indexPath)
        }else{
            return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footview", for: indexPath)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let log = "你选择的是\(indexPath.section)，\(indexPath.row)"
        Dlog(log)
    }
    
}
