//
//  TaobaoHomeViewController.swift
//  Freedom
import UIKit
import XExtension
import SVProgressHUD
class TitlesImageViewFull: UIView {
    var title: UILabel!
    var subtitle: UILabel!
    var iconview: UIImageView!
    var imageview: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        title = UILabel(frame: CGRect(x: 8, y: 8, width: frame.size.width - 20, height: 14))
        subtitle = UILabel(frame: CGRect(x: 8, y: 25, width: frame.size.width - 10, height: 12))
        iconview = UIImageView(frame: CGRect(x: 100, y: 0, width: 15, height: 14))
        imageview = UIImageView(frame: CGRect(x: 8, y: 25, width: frame.size.width, height: 20))
        imageview.contentMode = .scaleAspectFit
        iconview.contentMode = .scaleAspectFit
        title.font = UIFont.systemFont(ofSize: 14)
        subtitle.font = UIFont.systemFont(ofSize: 12)
        title.textColor = UIColor.red
        subtitle.textColor = UIColor.green
        addSubview(title)
        addSubview(subtitle)
        addSubview(iconview)
        addSubview(imageview)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class DaRenTaoCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let daren = UIButton(frame: CGRect(x: APPW / 2 - 50, y: 0, width: 100, height: 20))
        daren.setImage(UIImage(named: "hot"), for: .normal)
        daren.setTitle("达人淘", for: .normal)
        daren.setTitleColor(UIColor.red, for: .normal)
        let more = UILabel(frame: CGRect(x: APPW - 80, y: 0, width: 60, height: 20))
        more.text = "更多 >"
        let mainView = UIView(frame: CGRect(x: 0, y: YH(daren), width: APPW, height: H(self) - YH(daren) - 30))
        mainView.backgroundColor = UIColor.white
        let height: CGFloat = (APPW - 32) / 3 + 14 + 3 + 12 + 3
        let view1 = TitlesImageViewFull(frame: CGRect(x: 8, y: 6, width: (APPW - 32) / 3, height: height))
        let view2 = TitlesImageViewFull(frame: CGRect(x: 8 + (APPW - 32) / 3 + 8, y: 6, width: (APPW - 32) / 3, height: height))
        let view3 = TitlesImageViewFull(frame: CGRect(x: 8 + (APPW - 32) / 3 + 8 + (APPW - 32) / 3 + 8, y: 6, width: (APPW - 32) / 3, height: height))
        mainView.addSubview(view1)
        mainView.addSubview(view2)
        mainView.addSubview(view3)
        view1.title.text = "红人圈"
        view1.subtitle.text = "别怕，红人圈来了"
        view1.imageview.image = UIImage(named: "a")
        view1.iconview.image = UIImage(named: "hot")
        view2.title.text = "视频直播"
        view2.subtitle.text = "别怕，学会保护自己!"
        view3.title.text = "搭配控"
        view3.subtitle.text = "我有我的fan"
        view2.imageview.image = UIImage(named: "a")
        view3.imageview.image = UIImage(named: "a")
        let subscrib = UILabel(frame: CGRect(x: 10, y: YH(mainView) - 20, width: APPW - 100, height: 20))
        subscrib.text = "小秘书为你精选推荐的N个达人"
        let icon = UIImageView(frame: CGRect(x: APPW - 40, y: Y(subscrib), width: 30, height: 30))
        icon.image = UIImage(named: "a")
        addSubviews([daren, more, mainView, subscrib, icon])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class Cell1: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let image1 = UIImageView(frame: CGRect(x: 0, y: 0, width: W(self) * 2 / 5.0, height: H(self)))
        let image2 = UIImageView(frame: CGRect(x: XW(image1) + 1, y: 0, width: W(self) - XW(image1) - 1, height: H(self) / 2.0))
        let view = UIView(frame: CGRect(x: X(image2), y: YH(image2) + 1, width: W(image2), height: H(image2) - 1))
        let image3 = UIImageView(frame: CGRect(x: 0, y: 0, width: (W(view) - 1) / 2.0, height: H(view)))
        let image4 = UIImageView(frame: CGRect(x: XW(image3) + 1, y: 0, width: W(image3), height: H(image3)))
        view.addSubviews([image3, image4])
        addSubviews([image1, image2, view])
        image1.image = UIImage(named: "taobao01.jpg")
        image2.image = UIImage(named: "taobao02.jpg")
        image3.image = UIImage(named: "taobao03.jpg")
        image4.image = UIImage(named: "taobao04.jpg")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class GridCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: W(self), height: H(self) - 60))
        iv.clipsToBounds = true
        let bgview = UIView(frame: bounds)
        bgview.layer.shadowColor = UIColor.black.cgColor
        bgview.layer.shadowOffset = CGSize(width: 0, height: 1)
        bgview.layer.shadowOpacity = 0.2
        bgview.layer.shadowRadius = 10
        let titleLab = UILabel(frame: CGRect(x: 0, y: YH(iv), width: W(self), height: 40))
        titleLab.highlightedTextColor = UIColor(200, 200, 200)
        let priceLabel = UILabel(frame: CGRect(x: 10, y: YH(titleLab), width: 100, height: 20))
        let flagLab = UILabel(frame: CGRect(x: W(self) - 60, y: Y(priceLabel), width: 40, height: 20))
        flagLab.backgroundColor = UIColor.red
        addSubviews([bgview, iv, titleLab, priceLabel, flagLab])
        iv.image = UIImage(named: "image1.jpg")
        titleLab.text = "户外腰包男女士跑步运动音乐手机包轻薄贴身防水"
        flagLab.text = "热销"
        priceLabel.text = "￥19800.0"
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class GridCell2: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let image1 = UIImageView(frame: CGRect(x: 0, y: 0, width: W(self) * 2 / 3.0, height: H(self) - 40))
        let image2 = UIImageView(frame: CGRect(x: XW(image1), y: 0, width: W(self) - XW(image1), height: H(image1) / 2))
        let image3 = UIImageView(frame: CGRect(x: X(image2), y: YH(image2), width: W(image2), height: H(image2)))
        let label1 = UILabel(frame: CGRect(x: 10, y: YH(image1), width: W(self) - 20, height: 20))
        let label2 = UILabel(frame: CGRect(x: X(label1), y: YH(label1), width: W(label1), height: H(label1)))
        label2.font = Font(13)
        addSubviews([image1, image2, image3, label1, label2])
        image1.image = UIImage(named: "image1.jpg")
        image2.image = UIImage(named: "image2.jpg")
        image3.image = UIImage(named: "image3.jpg")
        label1.text = "【生活家--爱的杂货店"
        label2.text = "115.5万人正在逛店"
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class GridCell3: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let iv = UIImageView(frame: CGRect(x: 10, y: 10, width: W(self) - 20, height: W(self) - 20))
        iv.layer.cornerRadius = (APPW / 5 - 8 / 5 - 20) / 2
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        let name = UILabel(frame: CGRect(x: 0, y: YH(iv), width: W(self), height: 20))
        name.textAlignment = .center
        name.text = "天猫来了"
        addSubviews([iv, name])
        iv.image = UIImage(named: "a")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class HotShiChangCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let dataArr = [["title": "内衣", "subtitle": "性感装备", "image": "taobao06.jpg", "icon": ""], ["title": "数码", "subtitle": "潮流新机", "image": "taobao06.jpg", "icon": ""], ["title": "运动", "subtitle": "潮流新品", "image": "taobao07.jpg", "icon": ""], ["title": "家电", "subtitle": "爆款现货抢", "image": "taobao06.jpg", "icon": ""], ["title": "美女", "subtitle": "暖被窝女神", "image": "taobao07.jpg", "icon": ""], ["title": "质+", "subtitle": "休息裙", "image": "taobao06.jpg", "icon": ""], ["title": "中老年", "subtitle": "巧策", "image": "taobao07.jpg", "icon": ""], ["title": "篮球公园", "subtitle": "虎扑识货", "image": "taobao06.jpg", "icon": ""]]
        let titleButton = UIButton(frame: CGRect(x: W(self) / 2 - 50, y: 0, width: 100, height: 20))
        titleButton.setTitle("热门市场", for: .normal)
        titleButton.setImage(UIImage(named: "hot"), for: .normal)
        let more = UILabel(frame: CGRect(x: W(self) - 80, y: 0, width: 60, height: 20))
        more.text = "更多 >"
        let mainView = UIView(frame: CGRect(x: 0, y: YH(titleButton), width: W(self), height: H(self) - YH(titleButton) - 80))
        mainView.backgroundColor = UIColor.clear
        let view1 = TitlesImageViewFull(frame: CGRect(x: 0, y: 0, width: (APPW - 1) / 2, height: 120))
        let view2 = TitlesImageViewFull(frame: CGRect(x: (APPW - 1) / 2 + 1, y: 0, width: (APPW - 1) / 2, height: 120))
        view2.backgroundColor = UIColor.white
        view1.backgroundColor = view2.backgroundColor
        mainView.addSubview(view1)
        mainView.addSubview(view2)
        view1.title.text = "家具"
        view1.subtitle.text = "尖货推荐"
        view2.title.text = "女装"
        view2.subtitle.text = "新品推荐"
        view1.imageview.image = UIImage(named: "taobao05.jpg")
        view2.imageview.image = UIImage(named: "taobao05.jpg")
        let footimage = UIImageView(frame: CGRect(x: 0, y: YH(mainView), width: W(self), height: 80))
        footimage.image = UIImage(named: "image2.jpg")
        addSubviews([titleButton, more, mainView, footimage])
        var view: TitlesImageViewFull?
        //当前i的数据
        var x: CGFloat = 0
        var y: CGFloat = 0
        var row: Int = 0
        var col: Int = 0
        let width: CGFloat = CGFloat((APPW - 3) / 4)
        //间隔为1，4列，总间隔3
        let height: CGFloat = 100
        for i in 0..<dataArr.count {
            let dic = dataArr[i]
            view = TitlesImageViewFull(frame: CGRect.zero)
            view?.isUserInteractionEnabled = true
            if i % 4 == 0 {
                row = i / 4
                print("行 (i / 4)")
            }
            col = i % 4
            print(" 列  (i % 4)")
            x = CGFloat((APPW - 3.0) / 4.0 * CGFloat(i) + CGFloat(col) - CGFloat(row) * (APPW - 3.0))
            y = CGFloat(120.0 + CGFloat(row) * 1 + 1) + CGFloat(row) * height
            view?.frame = CGRect(x: x, y: y, width: width, height: height)
            view?.title.text = dic["title"]
            view?.subtitle.text = dic["subtitle"]
            view?.imageview.image = UIImage(named: dic["image"]!)
            view?.backgroundColor = UIColor.white
            mainView.addSubview(view!)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class Headview1: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let scroll = UIScrollView(frame: bounds)
        scroll.contentSize = CGSize(width: APPW * 2, height: APPW / 4)
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        let image1 = UIImageView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPW / 4))
        let image2 = UIImageView(frame: CGRect(x: APPW, y: 0, width: APPW, height: APPW / 4))
        image1.image = UIImage(named: "image2.jpg")
        image2.image = UIImage(named: "image4.jpg")
        scroll.addSubview(image1)
        scroll.addSubview(image2)
        addSubview(scroll)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class Headview2: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let icon = UIImageView(frame: CGRect(x: 0, y: 10, width: 40, height: 40))
        let title = UILabel(frame: CGRect(x: XW(icon), y: 0, width: 200, height: 20))
        let subscrib = UILabel(frame: CGRect(x: X(title), y: YH(title), width: W(title), height: 20))
        contentMode = .center
        addSubviews([icon, title, subscrib])
        icon.image = UIImage(named: "xin")
        title.text = "猜你喜欢的"
        subscrib.text = "今日11：00更新"
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class Headview3: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let line = UIView(frame: CGRect(x: 0, y: 20, width: APPW, height: 1))
        line.backgroundColor = UIColor(224, 225, 226, 1)
        let lable = UILabel(frame: CGRect(x: 100, y: 10, width: 300, height: 20))
        lable.textAlignment = .center
        lable.text = "实时推荐最适合你的宝贝"
        lable.backgroundColor = UIColor(245, 245, 245, 1)
        contentMode = .center
        addSubviews([line, lable])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class Footview0: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let icon = UIImageView(frame: CGRect(x: 0, y: 0, width: H(self), height: H(self)))
        icon.image = UIImage(named: "toutiao.jpg")
        let mainview = UIView(frame: CGRect(x: XW(icon) + 1, y: 0, width: W(self) - XW(icon) - 1, height: H(self)))
        let scroll = UIScrollView()
        scroll.frame = CGRect(x: 0, y: 0, width: APPW - 50 * 3 / 2, height: 50)
        scroll.isPagingEnabled = true
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.isScrollEnabled = false
        mainview.addSubview(scroll)
        let ttv1 = UIView(frame: CGRect(x: 0, y: 50 * 0, width: APPW - 50 * 3 / 2, height: 50))
        let ttv2 = UIView(frame: CGRect(x: 0, y: 50 * 1, width: APPW - 50 * 3 / 2, height: 50))
        ttv1.backgroundColor = UIColor.yellow
        ttv2.backgroundColor = UIColor.green
        scroll.addSubview(ttv1)
        scroll.addSubview(ttv2)
        scroll.contentSize = CGSize(width: APPW - 50 * 3 / 2, height: 50 * 2)
        scroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        addSubviews([icon, mainview])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class Footview1: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let name = UILabel(frame: CGRect(x: 10, y: 10, width: APPW - 20, height: 20))
        name.textAlignment = .center
        name.text = "宝贝已经看完了，18：00后更新"
        let image = UIImageView(frame: CGRect(x: 10, y: YH(name), width: W(name), height: 70))
        image.image = UIImage(named: "image2.jpg")
        addSubviews([name, image])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//FIXME: 以下是正式的VC
class TaobaoHomeViewController: TaobaoBaseViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    var grid: UICollectionView!
    var dataArr = [Any]()
    var sectionArr = [Any]()
    var msgLab: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        dataArr = [Any]()
        sectionArr = [Any]()
        navigationController?.isNavigationBarHidden = false
        let searchBar = UISearchBar()
        searchBar.placeholder = "输入搜索关键字"
        navigationItem.titleView = searchBar
        navigationController?.navigationBar.tintColor = UIColor.gray
        let image = UIImage(named: "Taobaomessage")?.withRenderingMode(.alwaysOriginal)
        let leftI = UIBarButtonItem(image: UIImage(named: "TaobaoScanner"), style: .done, actionBlick: {
        })
        let rightI = UIBarButtonItem(image: image, style: .done, actionBlick: {
        })
        navigationItem.leftBarButtonItem = leftI
        navigationItem.rightBarButtonItem = rightI
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.headerReferenceSize = CGSize(width: 320, height: 40)
        grid = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        view.addSubview(grid)
        grid.backgroundColor = UIColor(245, 245, 245, 1)
        grid.delegate = self
        grid.dataSource = self
        grid.register(GridCell.self, forCellWithReuseIdentifier: "GridCell")
        grid.register(GridCell2.self, forCellWithReuseIdentifier: "GridCell2")
        grid.register(GridCell3.self, forCellWithReuseIdentifier: "GridCell3")
        grid.register(Cell1.self, forCellWithReuseIdentifier: "Cell1")
        grid.register(HotShiChangCell.self, forCellWithReuseIdentifier: "HotShiChangCell")
        grid.register(DaRenTaoCell.self, forCellWithReuseIdentifier: "DaRenTaoCell")
        grid.register(Headview1.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headview1")
        grid.register(Headview2.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headview2")
        grid.register(Headview3.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headview3")
        grid.register(Footview0.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footview0")
        grid.register(Footview1.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footview1")
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 10
        }
        if section == 1 {
            return 6
        }
        if section == 2 {
            return 4
        }
        if section == 3 {
            return 10
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var gridcell: UICollectionViewCell? = nil
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell3", for: indexPath) as? GridCell3
            gridcell = cell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell1", for: indexPath) as? Cell1
                gridcell = cell
            } else if indexPath.row == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell1", for: indexPath) as? Cell1
                gridcell = cell
            } else if indexPath.row == 2 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell1", for: indexPath) as? Cell1
                gridcell = cell
            } else if indexPath.row == 3 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell1", for: indexPath) as? Cell1
                gridcell = cell
            } else if indexPath.row == 4 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotShiChangCell", for: indexPath) as? HotShiChangCell
                gridcell = cell
            } else if indexPath.row == 5 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DaRenTaoCell", for: indexPath) as? DaRenTaoCell
                gridcell = cell
            } else {
            }
        } else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell2", for: indexPath) as? GridCell2
            gridcell = cell
        } else {
            //可以加载更多的那个cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as? GridCell
            gridcell = cell
        }
        if let aGridcell = gridcell {
            return aGridcell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview: UICollectionReusableView? = nil
        if indexPath.section == 0 {
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headview1", for: indexPath) as? Headview1
                reusableview = headerView
            }
            if kind == UICollectionView.elementKindSectionFooter {
                let footview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footview0", for: indexPath) as? Footview0
                reusableview = footview
            }
        } else if indexPath.section == 2 {
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headview2", for: indexPath) as? Headview2
                reusableview = headerView
            }
        } else if indexPath.section == 3 {
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headview3", for: indexPath) as? Headview3
                reusableview = headerView
            }
            if kind == UICollectionView.elementKindSectionFooter {
                let footview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footview1", for: indexPath) as? Footview1
                reusableview = footview
            }
        }
        if let aReusableview = reusableview {
            return aReusableview
        }
        return UICollectionReusableView()
    }
    //item 宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            //9宫格组//减1去除误差
            //DLog(@"########%f", (SCREEN_W-4-4-1)/5;
            return CGSize(width: (APPW - 4 - 4 - 1) / 5, height: APPW / 5 + 20)
        }
        if indexPath.section == 1 {
            //乱七八糟组
            if indexPath.row == 0 {
                return CGSize(width: APPW, height: APPW * ((190) / 375.0) + 8)
            }
            if indexPath.row == 4 {
                return CGSize(width: APPW, height: 8 + 30 + 1 + 120 + 1 + 70 + 2 * 101)
            }
            if indexPath.row == 5 {
                return CGSize(width: APPW, height: (APPW - 32) / 3 + 8 + 30 + 8 + 42 + 40)
            }
            return CGSize(width: APPW, height: APPW * ((190) / 375.0) + 8)
        }
        if indexPath.section == 2 {
            //喜欢组
            return CGSize(width: APPW / 2 - 4 / 2, height: (APPW / 2 - 4 / 2) * 2 / 3 + 48)
        }
        if indexPath.section == 3 {
            //推荐组
            return CGSize(width: APPW / 2 - 4 / 2, height: APPW / 2 - 4 / 2 + 80)
        }
        return CGSize(width: 0, height: 0)
    }
    //head 宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: APPW, height: APPW / 4)
        }
        //图片滚动的宽高
        if section == 2 {
            return CGSize(width: APPW, height: 50)
        }
        //猜你喜欢的宽高
        if section == 3 {
            return CGSize(width: APPW, height: 35)
        }
        //推荐适合的宽高
        return CGSize(width: 0, height: 0)
    }
    //foot 宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: APPW, height: 50)
        }
        //淘宝头条的宽高
        if section == 3 {
            return CGSize(width: APPW, height: 110)
        }
        //最底部view的宽高
        return CGSize.zero
    }
    //边缘间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
        }
        return .zero
    }
    //x 间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //y 间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return 0
        }
        if section == 2 {
            return 4
        }
        return 2
    }
    //:FIXME collectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            return
        }
        SVProgressHUD.showSuccess(withStatus: "你选择的是\(indexPath.section)，\(indexPath.row)")
        print("你选择的是\(indexPath.section)，\(indexPath.row)")
    }
}
