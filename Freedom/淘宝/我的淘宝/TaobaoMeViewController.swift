//
//  TaobaoMeViewController.swift
//  Freedom
import UIKit
import XExtension
import XCarryOn
class TaobaoMeViewCell1:BaseCollectionViewCell{
    override func initUI() {
        icon = UIImageView(frame: CGRect(x: 10, y: 0, width: APPW / 5 - 20, height: 40))
        title = UILabel(frame: CGRect(x: 0, y: icon.bottom, width: APPW / 5 - 10, height: 20))
        title.font = fontSmall
        title.textAlignment = .center
        addSubviews([title, icon])
        title.text = "待收货"
        icon.image = UIImage(named: "taobaomini2")
    }
}
class TaobaoMeViewCell2:BaseCollectionViewCell{
    override func initUI() {
        icon = UIImageView(frame: CGRect(x: 10, y: 0, width: APPW / 5 - 20, height: 40))
        title = UILabel(frame: CGRect(x: 0, y: icon.bottom, width: APPW / 5 - 12, height: 20))
        title.font = fontSmall
        title.textAlignment = .center
        addSubviews([title, icon])
        title.text = "蚂蚁花呗"
        icon.image = UIImage(named: "taobaomini1")
    }
}
class TaobaoMeHeadView: UICollectionReusableView {
    var titleLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initUI() {
        titleLabel = UILabel(frame: CGRect(x: 10, y: 5, width: APPW / 2, height: 20))
        titleLabel.textColor = .red
        titleLabel.text = "必备工具"
        let more = UILabel(frame: CGRect(x: titleLabel.right, y: titleLabel!.y, width: APPW - titleLabel.right - 10, height: 20))
        more.textColor = .gray
        more.textAlignment = .right
        more.font = fontSmall
        more.text = "查看更多 >"
        backgroundColor = .white
        if let aLabel = titleLabel {
            addSubview(aLabel)
        }
        addSubview(more)
    }
}
class TaobaoMeViewController: TaobaoBaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的淘宝"
        navigationController?.navigationBar.tintColor = .red
        let image = UIImage(named: "Taobaomessage")?.withRenderingMode(.alwaysOriginal)
        let `left` = UIBarButtonItem(title: "设置", style: .plain, actionBlick: {() -> Void in
        })
        let right1 = UIBarButtonItem(image: UIImage(named: "TaobaoScanner"), style: .done, actionBlick: {() -> Void in
        })
        let right2 = UIBarButtonItem(image: image, style: .done, actionBlick: {() -> Void in
        })
        navigationItem.leftBarButtonItem = `left`
        navigationItem.rightBarButtonItems = [right1, right2] as? [UIBarButtonItem]
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 100))
        headView.backgroundColor = UIColor(252, 50, 50, 1)
        let icon = UIImageView(frame: CGRect(x: APPW / 2 - 30, y: 0, width: 60, height: 60))
        icon.layer.cornerRadius = 30
        icon.image = UIImage(named: "userLogo")
        icon.clipsToBounds = true
        let name = UILabel(frame: CGRect(x: 10, y: icon.bottom, width: APPW - 20, height: 20), font: fontMiddle, color: .white, text: "杨越光", alignment: .center)
        let taoqi = UILabel(frame: CGRect(x: APPW / 2 - 40, y: name.bottom, width: 80, height: 15), font: fontSmall, color: .red, text: "淘气值：710", alignment: .center)
        taoqi.clipsToBounds = true
        taoqi.layer.cornerRadius = 7
        taoqi.backgroundColor = .yellow
        headView.addSubviews([icon, name, taoqi])
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (APPW - 50) / 4, height: 90)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.headerReferenceSize = CGSize(width: APPW, height: 30)
        layout.footerReferenceSize = CGSize.zero
        collectionView = BaseCollectionView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH - 110), collectionViewLayout: layout)
        collectionView.dataArray = [["name": "流量充值", "pic": "userLogo"]]
        collectionView?.register(TaobaoMeViewCell1.self, forCellWithReuseIdentifier: TaobaoMeViewCell1.identifier())
        collectionView?.register(TaobaoMeViewCell2.self, forCellWithReuseIdentifier: TaobaoMeViewCell2.identifier())
        collectionView?.register(TaobaoMeHeadView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headview")
        collectionView?.register(TaobaoMeHeadView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footview")
        collectionView?.addSubview(headView)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        if let aView = collectionView {
            view.addSubview(aView)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }
        if section == 1 {
            return 12
        }
        if section == 2 {
            return 4
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: BaseCollectionViewCell? = nil
        if indexPath.section == 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaobaoMeViewCell1.identifier(), for: indexPath) as? TaobaoMeViewCell1
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaobaoMeViewCell2.identifier(), for: indexPath) as? TaobaoMeViewCell2
        }
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: APPW / 5 - 12, height: 60)
        } else if indexPath.section == 1 {
            return CGSize(width: APPW / 5 - 5, height: 60)
        } else {
            return CGSize(width: APPW / 5 - 5, height: 60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headview", for: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let log = "你选择的是\(indexPath.section)，\(indexPath.row)"
        Dlog(log)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 80, left: 10, bottom: 0, right: 10)
        } else {
            return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        }
    }
    
}
