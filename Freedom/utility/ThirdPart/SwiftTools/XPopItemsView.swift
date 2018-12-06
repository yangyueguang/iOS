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
    var isSingleSelect = false //是单选还是多选
    var isLimited = false //是否删除不限
    //可选的  typesBlock和netCompletBlock二选一
    var typesBlock: ((_ key: String?) -> [BaseType])?//如果是本地数据可以直接赋值
    var netCompletblock: ((_ block: NetCompletBlock) -> Void)? //网络传输语句写到这里
    var selectedItems: [BaseType] = [] //被选择对象
    var tempSItems: [BaseType] = [] //操作时临时缓冲对象
    //所有对象
    var types: [BaseType] = [BaseType()]
    init(name: String, key: String?, typesBlock: @escaping (String?) -> [BaseType]) {
        super.init()
        columns = 4
        self.name = name
        if let key = key {
            self.key = key
        }else {
            self.key = name
        }
        self.typesBlock = typesBlock
    }
    init(name: String, key: String?, netCompletBlock netBlock: @escaping (NetCompletBlock) -> Void) {
        super.init()
        columns = 4
        self.name = name
        if let key = key {
            self.key = key
        }else {
            self.key = name
        }
        netCompletblock = netBlock
    }
}

class SelectCCell: UICollectionViewCell {
    lazy var title: UILabel = {
        let title = UILabel()
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 13)
        title.layer.cornerRadius = 3.5
        title.layer.masksToBounds = true
        title.layer.borderWidth = 0.5
        title.layer.borderColor = UIColor(white: 0.8, alpha: 1).cgColor
        return title
    }()
    var script = UILabel()
    var ty: BaseType? {
        didSet {
            title.text = ty?.value
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
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

class XPopItemsView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var sureBlock: ((_ types: [BaseType], _ key: String?) -> Void)?
    private lazy var alertLabel: UILabel = {
        let alertLabel = UILabel(frame: CGRect(x: frame.size.width / 2 - 50, y: frame.size.height / 3 - 80, width: 100, height: 80))
        alertLabel.backgroundColor = UIColor(red: 192 / 255.0, green: 8 / 255.0, blue: 34 / 255.0, alpha: 0.8)
        alertLabel.font = UIFont.systemFont(ofSize: 26)
        alertLabel.textColor = UIColor.white
        alertLabel.layer.cornerRadius = 10
        alertLabel.layer.masksToBounds = true
        alertLabel.textAlignment = .center
        alertLabel.isHidden = true
        return alertLabel
    }()
    private var currentItem: SBItem!
    private var currentEditButton: UIButton!
    private var fromNvc: UIViewController!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleScrollView: UIScrollView!

    var items: [SBItem] = [] {
        didSet {
            DispatchQueue.main.async(execute: {
                self.titleScrollView.subviews.forEach({$0.removeFromSuperview()})
                for i in 0..<self.items.count {
                    let item: SBItem = self.items[i]
                    let a = UIButton(frame: CGRect(
                        x: CGFloat(i) * self.titleScrollView.frame.size.width / CGFloat(self.items.count),
                        y: 0,
                        width: self.titleScrollView.frame.size.width / CGFloat(self.items.count),
                        height: self.titleScrollView.bounds.size.height))
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
                        self.titleScrollView.addSubview(a)
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(SelectCCell.self, forCellWithReuseIdentifier: SelectCCell.nameOfClass)
    }
    convenience init(navibarMenu frame: CGRect, item: SBItem, inVC nvc: UIViewController?) {
        let frame =  CGRect(x: 0, y: frame.origin.y, width: APPW, height: APPH - frame.origin.y)
        self.init(frame: frame)
        item.isLimited = true
        item.isSingleSelect = true
        item.selectedItems = [BaseType]()
        fromNvc = nvc
        contentView.snp.makeConstraints { (make) in
            make.left.equalTo(self.frame.origin.x)
            make.width.equalTo(self.frame.size.width)
            make.top.equalToSuperview()
            make.height.equalToSuperview()
        }
        if let aBar = nvc?.navigationController?.navigationBar {
            fromNvc.view.insertSubview(self, belowSubview: aBar)
        }
        items = [item]
    }
    @IBAction func submitAction(_ sender: UIButton) {
        sureAction(sender)
    }
    @IBAction func cancelAction(_ sender: UIButton) {
        hide()
    }
    convenience init(sortView frame: CGRect, item: SBItem, inVC nvc: UIViewController) {
        self.init(frame: nvc.view.bounds)
        item.isSingleSelect = true
        item.key = "noSort"
        fromNvc = nvc
        let tempV = UIView(frame: CGRect(x: frame.origin.x, y: frame.origin.y + CGFloat(SortButtonH), width: frame.size.width, height: UIScreen.main.bounds.size.height))
        tempV.clipsToBounds = true
        tempV.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.lessThanOrEqualToSuperview()
        }
        addSubview(titleScrollView)
        if let aBar = nvc.navigationController?.navigationBar {
            fromNvc.view.insertSubview(self, belowSubview: aBar)
        }
        items = [item]
    }
    convenience init(frame: CGRect, items: [SBItem]) {
        self.init(frame: frame)
        titleScrollView.backgroundColor = UIColor.white

        addSubview(alertLabel)
        self.items = items
    }
    ///FIXME:内部方法
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self {
            return nil
        }
        return view
    }
    @objc func buttonSelect(_ sender: UIButton?) {
        sender?.isSelected = !(sender?.isSelected ?? false)
        if !(sender?.isSelected ?? false) {
            hide()
            return
        }
        currentItem = items[(sender?.tag ?? 0) - 10]
        currentItem.tempSItems = currentItem.selectedItems
        if currentEditButton != sender {
            currentEditButton.isSelected = false
        }
        currentEditButton = sender

        if ((currentItem?.typesBlock) != nil) || ((currentItem?.types) != nil) {
            refreshView()
        } else if ((currentItem?.netCompletblock) != nil) {
            contentView.alpha = 0
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
                    self.currentItem.tempSItems = self.currentItem.selectedItems
                    self.contentView.alpha = 1
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
        if currentItem.selectedItems.count > 0 {
            currentEditButton.setTitle(currentItem.selectedItems.first?.value, for: .normal)
            currentEditButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(currentEditButton.imageView?.bounds.size.width ?? 0.0) - 2, bottom: 0, right: (currentEditButton.imageView?.bounds.size.width ?? 0.0) + 2)
            currentEditButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (currentEditButton.titleLabel?.bounds.size.width ?? 0.0) + 2, bottom: 0, right: -(currentEditButton.titleLabel?.bounds.size.width ?? 0.0) - 2)
        }
        sureBlock?(currentItem.selectedItems, currentItem.key)
    }
    func show() {
        DispatchQueue.main.async(execute: {
            if self.currentItem == nil {
                if let btn = self.titleScrollView.viewWithTag(10) as? UIButton {
                    self.buttonSelect(btn)
                }
                return
            }
            self.contentView.frameY = -self.contentView.height
            UIView.animate(withDuration: 0.25, animations: {
                self.contentView.frameY = 0
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
                self.contentView.frameY =  -self.contentView.height
            }) { finished in
            }
        })
    }

    func showOrHid() {
        if contentView.frameY < 0  {
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
        return CGSize(width: a / CGFloat(currentItem.columns), height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectCCell.nameOfClass, for: indexPath) as! SelectCCell
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
