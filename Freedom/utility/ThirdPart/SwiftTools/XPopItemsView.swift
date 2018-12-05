/*
 //使用范例
 var item = SBItem(name: "接触方式", key: "接触方式", isCollectionType: true, netCompletBlock: { block in
 APIManager.instance().getTypeWithTypeName("接触方式", htf: false, block: { types, status in
 block([])
 })
 })
 WS(self)
 var sb = SelectButtons(frame: CGRect(x: 0, y: CGFloat(TopHeight), width: APPW, height: APPH), items: [item])
 sb.sureBlock = { types, key in
 }
*/
import UIKit
import Masonry
import SnapKit
import UIKit.UIGestureRecognizerSubclass
typealias NetCompletBlock = ([BaseType]) -> Void
let SortButtonH = 34.0
class UIScreenTouchRecognizer: UIGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        state = .recognized
    }
}
class BaseType: NSObject {
    var key: String = ""
    var value: String = "不限"
    var code: String = "101010101010"
}
class SBItem: NSObject {
    var name = "" //按钮显示的名字
    var key = "" //记录该对象存储的唯一标识||如果key=“noSort”则不使用自带的排序功能
    var columns: Int = 0 //如果是集合视图，列数
    var sectionH: CGFloat = 0.0 //如果是列表视图，分区高度
    var isCollectionType = false //是集合视图还是列表
    var isSingleSelect = false //是单选还是多选
    var isLimited = false //是否删除不限
    //可选的  typesBlock和netCompletBlock二选一
    var typesBlock: ((_ key: String?) -> [BaseType])?//如果是本地数据可以直接赋值
    var netCompletblock: ((_ block: NetCompletBlock) -> Void)? //网络传输语句写到这里
    var selectedItems: [BaseType] = [] //被选择对象
    var tempSItems: [BaseType] = [] //操作时临时缓冲对象
    //所有对象
    var types: [BaseType] = [BaseType()]
    //分区头部标题列表
    lazy var setionTitleArray: [String] = {
        var nameItems: [String] = []
        for i in 1..<types.count {
            let ty: BaseType? = types[i]
            if let aValue = ty?.value {
                nameItems.append(aValue)
            }
        }
        //        _setionTitleArray = [ChineseToPinyin IndexArray:nameItems];
        if (key == "noSort") {
            nameItems.removeAll()
        }
        return nameItems
    }()
    //列表分区内容集合
    lazy var resultArr: [[String]] = {
        var resultArr: [[String]] = []
        var nameItems: [String] = []
        let index: Int = isLimited ? 0 : 1
        for i in index..<types.count {
            let ty = types[i]
            nameItems.append(ty.value)
        }
        //        _resultArr = [ChineseToPinyin LetterSortArray:nameItems];
        if (key == "noSort") {
            resultArr = [nameItems]
        }
        var temp: [String] = []
        if let anObject = resultArr.first {
            temp = anObject
        }
        if !isLimited {
            temp.insert("不限", at: 0)
        }
        resultArr[0] = temp
        return resultArr
    }()
    init(name: String, key: String?, isCollectionType ctype: Bool = true, typesBlock: @escaping (String?) -> [BaseType]) {
        super.init()
        sectionH = 0
        columns = 4
        self.name = name
        if let key = key {
            self.key = key
        }else {
            self.key = name
        }
        isCollectionType = ctype
        self.typesBlock = typesBlock
    }
    init(name: String, key: String?, isCollectionType ctype: Bool = true, netCompletBlock netBlock: @escaping (NetCompletBlock) -> Void) {
        super.init()
        sectionH = 0
        columns = 4
        self.name = name
        if let key = key {
            self.key = key
        }else {
            self.key = name
        }
        isCollectionType = ctype
        netCompletblock = netBlock
    }
}

class SelectCCell: UICollectionViewCell {
    var title = UILabel()
    var script: UILabel!
    var ty: BaseType? {
        didSet {
            title.text = ty?.value
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 13)
        title.layer.cornerRadius = 3.5
        title.layer.masksToBounds = true
        title.layer.borderWidth = 0.5
        title.layer.borderColor = UIColor(white: 0.8, alpha: 1).cgColor
            addSubview(title)
        title.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        title.backgroundColor = UIColor.clear
        title.textColor = UIColor(white: 0.2, alpha: 1)
    }
}
//buttonView+alertLabel+backGroundView-->
//         showView-->
//               sureB+cancelB
//               collectionView-->SelectCCell
class XPopItemsView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var sureBlock: ((_ types: [BaseType]?, _ key: String?) -> Void)?
    var buttonView: UIView!
    private var cancelB: UIButton!
    private var sureB: UIButton!
    private var alertLabel: UILabel!
    private var Cheight: CGFloat = 0.0
    private var currentItem: SBItem!
    private var currentEditButton: UIButton!
    private var fromNvc: UIViewController!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var titleScrollView: UIScrollView!
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 10, height: 30)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(white: 0.94, alpha: 1)
        collectionView.register(SelectCCell.self, forCellWithReuseIdentifier: "SelectCCell")
        collectionView.isHidden = true
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    private lazy var showView: UIView = {
        let showView = UIView()
        showView.addSubview(collectionView)
        cancelB = UIButton()
        sureB = UIButton()
        cancelB.backgroundColor = UIColor(white: 0.93, alpha: 1)
        sureB.backgroundColor = UIColor(red: 192 / 255.0, green: 8 / 255.0, blue: 34 / 255.0, alpha: 1)
        cancelB.setTitle("取消", for: .normal)
        sureB.setTitle("确定", for: .normal)
        sureB.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        cancelB.titleLabel?.font = sureB.titleLabel?.font
        cancelB.setTitleColor(UIColor(white: 0.2, alpha: 1), for: .normal)
        sureB.setTitleColor(UIColor.white, for: .normal)
        cancelB.addTarget(self, action: #selector(self.hide), for: .touchUpInside)
        sureB.addTarget(self, action: #selector(self.sureAction(_:)), for: .touchUpInside)
        showView.addSubview(cancelB)
        showView.addSubview(sureB)
        return showView
    }()
    private lazy var backGroundView: UIView = {
        let backGroundView = UIView(frame: bounds)
        backGroundView.alpha = 0.0
        backGroundView.clipsToBounds = true
        backGroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.03)
        return backGroundView
    }()
    var items: [SBItem] = [] {
        didSet {
            DispatchQueue.main.async(execute: {
                self.buttonView.subviews.forEach({$0.removeFromSuperview()})
                for i in 0..<self.items.count {
                    let item: SBItem = self.items[i]
                    let a = UIButton(frame: CGRect(
                        x: CGFloat(i) * self.buttonView.frame.size.width / CGFloat(self.items.count),
                        y: 0,
                        width: self.buttonView.frame.size.width / CGFloat(self.items.count),
                        height: self.buttonView.bounds.size.height))
                    a.setTitle(item.name, for: .normal)
                    if item.selectedItems.count > 0 && item.selectedItems.first?.value != "不限" {
                        a.setTitle(item.selectedItems.first?.value, for: .normal)
                    }
                    a.setImage(UIImage(named: "下灰"), for: .normal)
                    a.setImage(UIImage(named: "上灰"), for: .selected)
                    for i in 0..<self.items.count {
                        a.contentHorizontalAlignment = .center
                        a.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                        a.tag = 10 + i
                        a.setTitleColor(UIColor(white: 0.2, alpha: 1), for: .normal)
                        a.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(a.imageView?.bounds.size.width ?? 0.0) - 2, bottom: 0, right: (a.imageView?.bounds.size.width ?? 0.0) + 2)
                        a.imageEdgeInsets = UIEdgeInsets(top: 0, left: (a.titleLabel?.bounds.size.width ?? 0.0) + 2, bottom: 0, right: -(a.titleLabel?.bounds.size.width ?? 0.0) - 2)
                        a.addTarget(self, action: #selector(self.buttonSelect(_:)), for: .touchUpInside)
                        self.buttonView.addSubview(a)
                        if self.items.count == 1 && self.fromNvc == nil {
                            a.contentHorizontalAlignment = .right
                            a.frame = CGRect(x: a.frame.origin.x, y: a.frame.origin.y, width: a.frame.size.width - 20, height: a.frame.size.height)
                        }
                    }
                }
            });
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func hitTest(_ point: CGPoint, with event: UIEvent) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
            return nil
        }
        return hitView
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(navibarMenu frame: CGRect, item: SBItem, inVC nvc: UIViewController?) {
        let frame =  CGRect(x: 0, y: frame.origin.y, width: APPW, height: APPH - frame.origin.y)
        self.init(frame: frame)
        item.isLimited = true
        item.isSingleSelect = true
        item.isCollectionType = true
        item.selectedItems = [BaseType]()
        layout.itemSize = CGSize(width: 10, height: 40)
        let rows = (item.types.count / item.columns + ((item.types.count % item.columns != 0) ? 1: 0))
        Cheight = CGFloat(rows) * layout.itemSize.height
        fromNvc = nvc
        buttonView = UIView()
        showView = UIView()
        showView.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.white
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        collectionView.isHidden = false
        backGroundView.addSubview(showView)
        showView.snp.makeConstraints { (make) in
            make.left.equalTo(self.frame.origin.x)
            make.width.equalTo(self.frame.size.width)
            make.top.equalToSuperview()
            make.height.equalToSuperview()
        }
        addSubview(backGroundView)
        if let aBar = nvc?.navigationController?.navigationBar {
            fromNvc.view.insertSubview(self, belowSubview: aBar)
        }
        items = [item]
    }
    @IBAction func submitAction(_ sender: Any) {
    }
    @IBAction func cancelAction(_ sender: Any) {
    }
    convenience init(sortView frame: CGRect, item: SBItem, inVC nvc: UIViewController) {
        self.init(frame: nvc.view.bounds)
        item.isSingleSelect = true
        item.isCollectionType = false
        item.sectionH = 0
        item.key = "noSort"
        fromNvc = nvc
        buttonView = UIView(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: CGFloat(SortButtonH)))
        buttonView.layer.cornerRadius = 3
        buttonView.layer.borderWidth = 1
        buttonView.layer.borderColor = UIColor(white: 0.3, alpha: 1).cgColor
        buttonView.backgroundColor = UIColor.white
        showView = UIView(frame: CGRect(x: frame.origin.x,
                                        y: CGFloat(SortButtonH) + frame.origin.y,
                                        width: frame.size.width,
                                        height: min(frame.size.height, CGFloat(item.types.count) * 40.0)))
        addSubview(backGroundView)
        let tempV = UIView(frame: CGRect(x: frame.origin.x, y: frame.origin.y + CGFloat(SortButtonH), width: frame.size.width, height: UIScreen.main.bounds.size.height))
        tempV.clipsToBounds = true
        tempV.addSubview(showView)
        backGroundView.addSubview(tempV)
        showView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.lessThanOrEqualToSuperview()
        }
        addSubview(buttonView)
        if let aBar = nvc.navigationController?.navigationBar {
            fromNvc.view.insertSubview(self, belowSubview: aBar)
        }
        items = [item]
    }
    convenience init(frame: CGRect, items: [SBItem]) {
        self.init(frame: frame)
        Cheight = UIScreen.main.bounds.size.height * 0.3
        buttonView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: CGFloat(SortButtonH)))
        buttonView.backgroundColor = UIColor.white
        backGroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        backGroundView.frame = CGRect(x: 0, y: buttonView.bounds.size.height, width: frame.size.width, height: frame.size.height - buttonView.bounds.size.height)
        alertLabel = UILabel(frame: CGRect(x: frame.size.width / 2 - 50, y: frame.size.height / 3 - 80, width: 100, height: 80))
        alertLabel.backgroundColor = UIColor(red: 192 / 255.0, green: 8 / 255.0, blue: 34 / 255.0, alpha: 0.8)
        alertLabel.font = UIFont.systemFont(ofSize: 26)
        alertLabel.textColor = UIColor.white
        alertLabel.layer.cornerRadius = 10
        alertLabel.layer.masksToBounds = true
        alertLabel.textAlignment = .center
        alertLabel.isHidden = true
        backGroundView.addSubview(showView)
        addSubview(buttonView)
        addSubview(backGroundView)
        addSubview(alertLabel)
        self.items = items
        configurationConstraints()
    }
    ///FIXME:布局约束
    func configurationConstraints() {
//        showView.mas_makeConstraints({ make in
//            make?.left.right().and().top().mas_offset(0)
//            _ = make?.height.equalTo()(Float(Theight))
//        })
//        cancelB.mas_makeConstraints({ make in
//            make?.left.bottom().mas_offset(0)
//            _ = make?.right.equalTo()(sureB.mas_left)
//            _ = make?.height.equalTo()(50)
//        })
//        sureB.mas_makeConstraints({ make in
//            make?.right.bottom().mas_offset(0)
//            _ = make?.left.equalTo()(cancelB.mas_right)
//            _ = make?.height.equalTo()(cancelB)
//            _ = make?.width.equalTo()(cancelB)
//        })
//        collectionView.mas_makeConstraints({ make in
//            make?.left.right().and().top().mas_offset(0)
//            make?.bottom.mas_equalTo(cancelB.mas_top)
//        })
//        tableView.mas_makeConstraints({ make in
//            make?.left.right().and().top().mas_offset(0)
//            make?.bottom.mas_equalTo(cancelB.mas_top)
//        })
    }

    ///FIXME:内部方法
    @objc func buttonSelect(_ sender: UIButton?) {
        sender?.isSelected = !(sender?.isSelected ?? false)
        if !(sender?.isSelected ?? false) {
            hide()
            return
        }
        currentItem = items[(sender?.tag ?? 0) - 10]
        if currentItem.columns <= 1 {
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            layout.minimumLineSpacing = 0
        }
        currentItem.tempSItems = currentItem.selectedItems
        if currentEditButton != sender {
            currentEditButton.isSelected = false
        }
        currentEditButton = sender
        showView.mas_updateConstraints({ make in
            if self.currentItem.isCollectionType {
                _ = make?.height.equalTo()(Double(Cheight))
            }
        })
        if ((currentItem?.typesBlock) != nil) || ((currentItem?.types) != nil) {
            refreshView()
        } else if ((currentItem?.netCompletblock) != nil) {
            showView.alpha = 0
            backGroundView.alpha = 1
            currentItem.types = []
            currentItem.selectedItems = []
            currentItem.netCompletblock?({ result in
                if result.count == 0 {
                    self.currentItem.typesBlock = nil
                    self.currentItem.selectedItems = []
                    self.hide()
                } else {
                    self.currentItem.typesBlock = { key in
                        return result
                    }
                    if (fromNvc != nil) {
                        let a = result.count / self.currentItem.columns
                        let yu: Bool = result.count % self.currentItem.columns != 0
                        let rows = a + (yu ? 1 : 0)
                        Cheight = CGFloat(rows) * self.layout.itemSize.height
                    }
                    self.currentItem.tempSItems = self.currentItem.selectedItems
                    self.showView.alpha = 1
                    self.refreshView()
                }
            })
        } else {
            print("请完善数据源")
        }
    }
    func refreshView() {
        DispatchQueue.main.async(execute: {
            self.show()
            self.collectionView.reloadData()
        })
    }
    @objc func sureAction(_ sender: UIButton?) {
        hide()
        currentItem.selectedItems = currentItem.tempSItems
        if ((fromNvc != nil) || currentItem.isCollectionType) && currentItem.selectedItems.count > 0 {
            currentEditButton.setTitle(currentItem.selectedItems.first?.value, for: .normal)
            currentEditButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(currentEditButton.imageView?.bounds.size.width ?? 0.0) - 2, bottom: 0, right: (currentEditButton.imageView?.bounds.size.width ?? 0.0) + 2)
            currentEditButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (currentEditButton.titleLabel?.bounds.size.width ?? 0.0) + 2, bottom: 0, right: -(currentEditButton.titleLabel?.bounds.size.width ?? 0.0) - 2)
        }
        sureBlock?(currentItem.selectedItems, currentItem.key)
    }
    func show() {
        DispatchQueue.main.async(execute: {
            if self.currentItem == nil {
                if let btn = self.buttonView.viewWithTag(10) as? UIButton {
                    self.buttonSelect(btn)
                }
                return
            }
            self.showView.frameY = -self.Cheight
            self.backGroundView.alpha = 1
            UIView.animate(withDuration: 0.25, animations: {
                self.showView.frameY = 0
            }) { finished in
            }
        })
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        hide()
    }
    @objc func hide() {
        DispatchQueue.main.async(execute: {
            self.currentEditButton.isSelected = false
            UIView.animate(withDuration: 0.25, animations: {
                self.showView.frameY =  -self.Cheight
            }) { finished in
                self.backGroundView.alpha = 0
            }
        })
    }

    func showOrHid() {
        if showView.frameY < 0 || backGroundView.alpha == 0 {
            show()
        } else {
            hide()
        }
    }
    ///FIXME:集合视图代理
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentItem.types.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let a:CGFloat = APPW - CGFloat(15.0) * CGFloat(currentItem.columns - 1)
        return CGSize(width: a / CGFloat(currentItem.columns), height: layout.itemSize.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return layout.minimumLineSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return layout.minimumInteritemSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return layout.sectionInset
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectCCell", for: indexPath) as! SelectCCell
        if indexPath.item < currentItem.types.count {
            cell.ty = currentItem.types[indexPath.item]
        }
        if let aTy = cell.ty {
            if currentItem.tempSItems.contains(aTy) {
                cell.title.backgroundColor = UIColor.green
                cell.title.textColor = UIColor.white
            }
        }
        let a:CGFloat = APPW - CGFloat(15.0) * CGFloat(currentItem.columns - 1)
        let frameWidth: CGFloat = a / CGFloat(currentItem.columns)
        cell.title.frame = CGRect(x: cell.title.frame.origin.x, y: cell.title.frame.origin.y, width: frameWidth, height: cell.title.bounds.size.height)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentItem.tempSItems.count > 0 {
            currentItem.tempSItems[0] = currentItem.types[indexPath.item]
        } else {
            currentItem.tempSItems.append(currentItem.types[indexPath.item])
        }
        collectionView.reloadData()
        if fromNvc != nil {
            sureAction(nil)
        }
    }
}
