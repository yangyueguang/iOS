//
//  DZHomeController.swift
//  Freedom
import UIKit
//import XExtension
class DZHomeViewCell1:BaseCollectionViewCell<Any> {
    override func initUI() {//120
        icon = UIImageView(frame: CGRect(x: 10, y: 60, width: self.width / 2 - 10, height: 60))
        let view = getViewWithFrame(CGRect(x: 0, y: 0, width: APPW / 2 - 10, height: 55))
        let view2 = getViewWithFrame(CGRect(x: APPW / 2, y: 0, width: APPW / 2 - 10, height: 55))
        let view3 = getViewWithFrame(CGRect(x: view2.x, y: view2.bottom + 10, width: view2.width, height: view2.height))
        let image1 = UIImageView(frame: CGRect(x: view2.width - 40, y: 0, width: 40, height: view2.height))
        image1.image = Image.logo.image
        let image2 = UIImageView(frame: CGRect(x: view2.width - 40, y: 0, width: 40, height: view2.height))
        image2.image = Image.logo.image
        view2.addSubview(image1)
        view3.addSubview(image2)
        addSubviews([view, view2, icon, view3])
    }
    func getViewWithFrame(_ rect: CGRect) -> UIView {
        let view = UIView(frame: rect)
        let a = UILabel(frame: CGRect(x: 10, y: 0, width: APPW / 2 - 20, height: 18), font: .small, color: .red, text: "外卖贺新春")
        let b = UILabel(frame: CGRect(x: a.x, y: a.bottom, width: a.width, height: a.height), font: .small, color: .dark, text: "省事省力又省心")
        let c = UILabel(frame: CGRect(x: a.x, y: b.bottom, width: 100, height: 15), font: .small, color: .yellow, text: "用外卖订年夜饭")
        c.layer.cornerRadius = 7
        c.layer.borderWidth = 1
        c.layer.borderColor = UIColor.redx.cgColor
        view.addSubviews([a, b, c])
        return view
    }
    func setCollectionDataWithDic(_ dict: [AnyHashable: Any]?) {
        icon.image = TBImage.im4.image
    }
}
class DZHomeViewCell2:BaseCollectionViewCell<Any> {
    override func initUI() {//100
        icon = UIImageView(frame: CGRect(x: 0, y: 0, width: APPW / 4, height: 60))
        title = UILabel(frame: CGRect(x: 20, y: icon.bottom, width: icon.width, height: 20))
        script = UILabel(frame: CGRect(x: title.x, y: title.bottom, width: title.width, height: title.height))
        script.font = .small
        title.font = .middle
        script.textColor = .cd
        addSubviews([icon, title, script])
    }
    func setCollectionDataWithDic(_ dict: [AnyHashable: Any]?) {
        title.text = "全球贺新年"
        script.text = "春节专享"
        icon.image = Image.logo.image
    }
}
class DZHomeViewCell3:BaseCollectionViewCell<Any> {
    override func initUI() {//80
        icon = UIImageView(frame: CGRect(x: 0, y: 0, width: APPW / 4 - 11, height: 50))
        icon.clipsToBounds = true
        icon.layer.cornerRadius = 10
        title = UILabel(frame: CGRect(x: 0, y: icon.bottom, width: icon.width, height: 18))
        script = UILabel(frame: CGRect(x: title.x, y: title.bottom, width: title.width, height: 15))
        script.font = Font(12)
        title.font = .small
        script.textColor = .cd
        title.textAlignment = .center
        script.textAlignment = .center
        addSubviews([icon, title, script])
    }
    func setCollectionDataWithDic(_ dict: [AnyHashable: Any]?) {
        title.text = "爱车"
        script.text = "9.9元洗车"
        icon.image = Image.logo.image
    }
}
class DZHomeViewCell4:BaseCollectionViewCell<Any> {
    override func initUI() {//100
        icon = UIImageView(frame: CGRect(x: 10, y: 0, width: APPW / 4, height: 80))
        title = UILabel(frame: CGRect(x: icon.right + 10, y: icon.y, width: APPW - icon.right - 20, height: 20))
        script = UILabel(frame: CGRect(x: title.x, y: title.bottom, width: title.width, height: 40))
        let a = UILabel(frame: CGRect(x: APPW - 80, y: title.y, width: 70, height: title.height))
        a.textAlignment = .right
        let b = UILabel(frame: CGRect(x: title.x, y: script.bottom, width: title.width, height: title.height))
        let d = UILabel(frame: CGRect(x: a.x, y: b.y, width: a.width, height: a.height))
        d.textAlignment = .right
        d.font = .small
        a.font = d.font
        script.font = a.font
        script.numberOfLines = 0
        d.textColor = .gray
        a.textColor = d.textColor
        script.textColor = a.textColor
        b.textColor = .red
        a.text = "575m"
        b.text = "￥69"
        d.text = "已售50000"
        let ling = UIView(frame: CGRect(x: 10, y: 99, width: APPW - 20, height: 1))
        ling.backgroundColor = .white
        addSubviews([icon, title, a, script, b, d, ling])
    }
    func setCollectionDataWithDic(_ dict: [AnyHashable: Any]?) {
        title.text = "上海海洋水族馆(4A)"
        script.text = "[陆家嘴]4.2分|门票、套餐、线路游 等优惠，欢迎上门体验"
        icon.image = Image.logo.image
    }
}
class DZHomeHeadView1: UICollectionReusableView {
    var DZtoutiaoV: BaseScrollView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initUI() {
        DZtoutiaoV = BaseScrollView(viewBanner: CGRect(x: 20, y: 0, width: APPW - 40, height: 60), viewsNumber: 5, viewOfIndex: {(_ index: Int) -> UIView in
            let view = UIView(frame: CGRect(x: 0, y: 0, width: APPW - 50, height: 60))
            let icon = UIImageView(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
            icon.clipsToBounds = true
            icon.layer.cornerRadius = 20
            icon.image = Image.logo.image
            let label1 = UILabel(frame: CGRect(x: icon.right + 10, y: 10, width: APPW / 2, height: 40), font: .small, color: .c3, text: "好友蜂蜜绿茶，吃完这家，还有下一家。地点中环广场店")
            label1.numberOfLines = 0
            view.addSubviews([icon, label1])
            view.backgroundColor = .red
            if index % 2 != 0 {
                view.backgroundColor = .yellow
            }
            return view
        }, vertically: true, setFire: true)
        addSubview(DZtoutiaoV!)
    }
}
class DZHomeHeadView2: UICollectionReusableView {
    var titleLabel: UILabel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initUI() {
        titleLabel = UILabel(frame: CGRect(x: 0, y: 5, width: APPW, height: 20))
        titleLabel?.textColor = .red
        titleLabel?.textAlignment = .center
        titleLabel?.text = "为你优选BEST"
        backgroundColor = .white
        if let aLabel = titleLabel {
            addSubview(aLabel)
        }
    }
}
final class DZHomeController: DZBaseViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    var collectionView: BaseCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whitex
        let more = UIBarButtonItem(image: Image.u_Add.image, style: .done, target: nil, action: nil)
        navigationItem.rightBarButtonItem = more
        let map = UIBarButtonItem(title: "北京") {
            
        }
        navigationItem.leftBarButtonItem = map
        let searchBar = UISearchBar()
        searchBar.placeholder = "输入商户名、地点"
        navigationItem.titleView = searchBar
        let titles = ["美食", "电影", "酒店", "休闲娱乐", "外卖", "机票/火车票", "丽人", "周边游", "亲子", "KTV", "高端酒店", "足疗按摩", "结婚", "家族", "学习培训", "景点", "游乐园", "生活服务", "洗浴", "全部分类"]
        let icons = ["taobaomini1", "taobaomini2", "taobaomini3", "taobaomini4", "taobaomini5", "taobaomini1", "taobaomini2", "taobaomini3", "taobaomini4", "taobaomini5", "taobaomini1", "taobaomini2", "taobaomini3", "taobaomini4", "taobaomini5", "taobaomini1", "taobaomini2", "taobaomini3", "taobaomini4", "taobaomini5"]
        let itemScrollView = BaseScrollView(scrollItem: CGRect(x: 0, y: 60, width: APPW, height: 200), icons: icons, titles: titles, size: CGSize(width: APPW / 5.0, height: 70), hang: 2, round: true)
        itemScrollView.backgroundColor = .white
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (APPW - 50) / 4, height: 90)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView = BaseCollectionView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH - 110), collectionViewLayout: layout)
        collectionView?.register(DZHomeViewCell1.self, forCellWithReuseIdentifier: DZHomeViewCell1.identifier)
        collectionView?.register(DZHomeViewCell2.self, forCellWithReuseIdentifier: DZHomeViewCell2.identifier)
        collectionView?.register(DZHomeViewCell3.self, forCellWithReuseIdentifier: DZHomeViewCell3.identifier)
        collectionView?.register(DZHomeViewCell4.self, forCellWithReuseIdentifier: DZHomeViewCell4.identifier)
        collectionView?.register(DZHomeHeadView1.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DZHomeHeadView1.identifier)
        collectionView?.register(DZHomeHeadView2.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DZHomeHeadView2.identifier)
        collectionView?.addSubview(itemScrollView)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        if let aView = collectionView {
            view.addSubview(aView)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return 6
        }
        if section == 2 {
            return 8
        }
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: BaseCollectionViewCell<Any>? = nil
        if indexPath.section == 0 {
            cell = collectionView.dequeueCell(DZHomeViewCell1.self, for: indexPath)
        } else if indexPath.section == 1 {
            cell = collectionView.dequeueCell(DZHomeViewCell2.self, for: indexPath)
        } else if indexPath.section == 2 {
            cell = collectionView.dequeueCell(DZHomeViewCell3.self, for: indexPath)
        } else {
            cell = collectionView.dequeueCell(DZHomeViewCell4.self, for: indexPath)
        }
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: APPW, height: 130)
        } else if indexPath.section == 1 {
            return CGSize(width: APPW / 3 - 15, height: 100)
        } else if indexPath.section == 2 {
            return CGSize(width: APPW / 4 - 15, height: 90)
        } else {
            return CGSize(width: APPW, height: 100)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: APPW, height: 60)
        } else if section == 1 {
            return CGSize(width: APPW, height: 30)
        } else if section == 2 {
            return CGSize(width: APPW, height: 60)
        } else if section == 3 {
            return CGSize(width: APPW, height: 30)
        }
        return CGSize(width: APPW, height: 30)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 160, left: 10, bottom: 0, right: 10)
        } else {
            return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if indexPath.section == 0 {
                return collectionView.dequeueHeadFoot(Headview1.self, kind: kind, for: indexPath)
            } else if indexPath.section == 1 {
                return collectionView.dequeueHeadFoot(Headview2.self, kind: kind, for: indexPath)
            } else if indexPath.section == 2 {
                return collectionView.dequeueHeadFoot(Headview1.self, kind: kind, for: indexPath)
            } else {
                return collectionView.dequeueHeadFoot(Headview2.self, kind: kind, for: indexPath)
            }
        }else{
            return collectionView.dequeueHeadFoot(Headview1.self, kind: kind, for: indexPath)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let log = "你选择的是\(indexPath.section)，\(indexPath.row)"
        Dlog(log)
    }
}
