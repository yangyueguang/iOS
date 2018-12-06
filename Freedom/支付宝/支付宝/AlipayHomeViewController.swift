//
//  SDHomeViewController.swift
//  Freedom
import UIKit
import XExtension
class AlipayHomeGridItemModel: NSObject {
    var imageResString = ""
    var title = ""
    var destinationClass: AnyClass?
}
class AlipayHomeGridViewListItemView: UIView {
    var itemModel: AlipayHomeGridItemModel?
    var hidenIcon = false
    var iconImage: UIImage?
    var itemLongPressedOperationBlock: ((_ longPressed: UILongPressGestureRecognizer?) -> Void)?
    var buttonClickedOperationBlock: ((_ item: AlipayHomeGridViewListItemView?) -> Void)?
    var iconViewClickedOperationBlock: ((_ view: AlipayHomeGridViewListItemView?) -> Void)?
    private var button = UIButton()
    private var iconView: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initialization() {
        backgroundColor = UIColor.white
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        addSubview(button)
        let icon = UIButton()
        icon.setImage(UIImage(named:"delete"), for: .normal)
        icon.addTarget(self, action: #selector(self.iconViewClicked), for: .touchUpInside)
        icon.isHidden = true
        addSubview(icon)
        iconView = icon
        let longPressed = UILongPressGestureRecognizer(target: self, action:#selector(itemLongPressed(_:)))
        addGestureRecognizer(longPressed)
    }
    @objc func itemLongPressed(_ longPressed: UILongPressGestureRecognizer?) {
        if (itemLongPressedOperationBlock != nil) {
            itemLongPressedOperationBlock!(longPressed)
        }
    }
    
    @objc func buttonClicked() {
        if (buttonClickedOperationBlock != nil) {
            buttonClickedOperationBlock!(self)
        }
    }
    
    @objc func iconViewClicked() {
        if (iconViewClickedOperationBlock != nil) {
            iconViewClickedOperationBlock!(self)
        }
    }
    func setItemModel(_ itemModel: AlipayHomeGridItemModel?) {
        self.itemModel = itemModel
        if itemModel?.title != nil {
            button.setTitle(itemModel?.title, for: .normal)
        }
        if itemModel?.imageResString != nil {
            if itemModel?.imageResString.hasPrefix("http:") ?? false {
                button.sd_setImage(with: URL(string: itemModel?.imageResString ?? ""), for: .normal, placeholderImage: nil)
            } else {
                button.setImage(UIImage(named: itemModel?.imageResString ?? ""), for: .normal)
            }
        }
    }
    func setHidenIcon(_ hidenIcon: Bool) {
        self.hidenIcon = hidenIcon
        iconView?.isHidden = hidenIcon
    }
    
    func setIconImage(_ iconImage: UIImage?) {
        self.iconImage = iconImage
        iconView?.setImage(iconImage, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin: CGFloat = 10
        button.frame = bounds
        let h: CGFloat = H(button)
        let w: CGFloat = W(button)
        button.imageEdgeInsets = UIEdgeInsets(top: h * 0.2, left: w * 0.32, bottom: h * 0.3, right: w * 0.32)
        button.titleEdgeInsets = UIEdgeInsets(top: h * 0.6, left: -w * 0.4, bottom: 0, right: 0)
        iconView?.frame = CGRect(x: frame.size.width - (iconView?.frame.size.width)! - margin, y: margin, width: 20, height: 20)
    }
}
protocol SDHomeGridViewDeleate: NSObjectProtocol {
    func homeGrideView(_ gridView: AlipayHomeGridView?, selectItemAt index: Int)
    func homeGrideViewmoreItemButtonClicked(_ gridView: AlipayHomeGridView?)
    func homeGrideViewDidChangeItems(_ gridView: AlipayHomeGridView?)
}
class AlipayHomeGridView: UIScrollView, UIScrollViewDelegate {
    weak var gridViewDelegate: SDHomeGridViewDeleate?
    var gridModelsArray = [Any]()
    private var itemsArray = [AnyHashable]()
    private var rowSeparatorsArray = [AnyHashable]()
    private var columnSeparatorsArray = [AnyHashable]()
    private var shouldAdjustedSeparators = false
    private var lastPoint = CGPoint.zero
    private var placeholderButton: UIButton?
    private var currentPressedView: AlipayHomeGridViewListItemView?
    private var cycleScrollADView: BaseScrollView?
    private var cycleScrollADViewBackgroundView: UIView?
    private var moreItemButton: UIButton?
    private var currentPresssViewFrame = CGRect.zero
    @objc func scanButtonClicked() {
        let desVc = AlipayScanViewController()
        getCurrentViewController()?.navigationController?.pushViewController(desVc, animated: true)
    }
    
    func getCurrentViewController() -> UIViewController? {
        var next: UIResponder? = self.next
        repeat {
            if (next is UIViewController) {
                return next as? UIViewController
            }
            next = next?.next
        } while next != nil
        return nil
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        itemsArray = [AnyHashable]()
        rowSeparatorsArray = [AnyHashable]()
        columnSeparatorsArray = [AnyHashable]()
        shouldAdjustedSeparators = false
        placeholderButton = UIButton()
        // MARK: 在这里设置最上面的那个扫描二维码
        let header = UIView()
        header.frame = CGRect(x: 0, y: 0, width: APPW, height: 100)
        header.backgroundColor = UIColor(red: 38 / 255.0, green: 42 / 255.0, blue: 59 / 255.0, alpha: 1)
        let scan = UIButton(frame: CGRect(x: 0, y: 0, width: header.frame.size.width * 0.5, height: header.frameHeight))
        scan.setImage(UIImage(named: "scan_y"), for: .normal)
        scan.addTarget(self, action: #selector(self.scanButtonClicked), for: .touchUpInside)
        header.addSubview(scan)
        let pay = UIButton(frame: CGRect(x: scan.frame.size.width, y: 0, width: header.frame.size.width * 0.5, height: header.frameHeight))
        pay.setImage(UIImage(named: "home_pay"), for: .normal)
        header.addSubview(pay)
        let line = UIView(frame: CGRect(x: APPW / 2, y: 0, width: 0.5, height: 100))
        line.backgroundColor = .white
        header.addSubview(line)
        addSubview(header)
        let cycleScrollADViewBackgroundView = UIView()
        cycleScrollADViewBackgroundView.backgroundColor = UIColor(red: 235 / 255.0, green: 235 / 255.0, blue: 235 / 255.0, alpha: 1)
        addSubview(cycleScrollADViewBackgroundView)
        self.cycleScrollADViewBackgroundView = cycleScrollADViewBackgroundView
        self.cycleScrollADViewBackgroundView?.backgroundColor = UIColor.red
        let temp = ["http://ww3.sinaimg.cn/bmiddle/9d857daagw1er7lgd1bg1j20ci08cdg3.jpg", "http://ww4.sinaimg.cn/bmiddle/763cc1a7jw1esr747i13xj20dw09g0tj.jpg", "http://ww4.sinaimg.cn/bmiddle/67307b53jw1esr4z8pimxj20c809675d.jpg"]
        cycleScrollADView = BaseScrollView(banner: CGRect(x: 0, y: 0, width: APPW, height: 100), icons: temp)
        addSubview(cycleScrollADView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setGridModelsArray(_ gridModelsArray: [Any]?) {
        self.gridModelsArray = gridModelsArray!
        itemsArray.removeAll()
        rowSeparatorsArray.removeAll()
        columnSeparatorsArray.removeAll()
        for model in gridModelsArray!{
            let item = AlipayHomeGridViewListItemView()
            item.itemModel = model as? AlipayHomeGridItemModel
            item.itemLongPressedOperationBlock = {(_ longPressed: UILongPressGestureRecognizer?) -> Void in
                self.buttonLongPressed(longPressed)
            }
            item.iconViewClickedOperationBlock = {(_ view: AlipayHomeGridViewListItemView?) -> Void in
                self.delete(view)
            }
            item.buttonClickedOperationBlock = {(_ view: AlipayHomeGridViewListItemView?) -> Void in
                if !self.currentPressedView!.hidenIcon && (self.currentPressedView != nil) {
                    self.currentPressedView?.hidenIcon = true
                    return
                }
                if let aView = view {
                    self.gridViewDelegate?.homeGrideView(self, selectItemAt: self.itemsArray.index(of: aView)!)
                }
            }
            self.addSubview(item)
        }
        let more = UIButton()
        more.setImage(UIImage(named: "u_navi_3p_b"), for: .normal)
        more.addTarget(self, action: #selector(self.moreItemButtonClicked), for: .touchUpInside)
        addSubview(more)
        itemsArray.append(more)
        moreItemButton = more
        // MARK: 设置中间分割线的位置
        let rowCount: Int = self.rowCount(withItemsCount: (gridModelsArray?.count)!)
        let lineColor: UIColor? = UIColor.lightGray.withAlphaComponent(0.8)
        for _ in 0..<(rowCount + 1) {
            let rowSeparator = UIView()
            rowSeparator.backgroundColor = lineColor
            addSubview(rowSeparator)
            rowSeparatorsArray.append(rowSeparator)
        }
        for _ in 0..<(4 + 1) {
            let columnSeparator = UIView()
            columnSeparator.backgroundColor = lineColor
            addSubview(columnSeparator)
            columnSeparatorsArray.append(columnSeparator)
        }
        shouldAdjustedSeparators = true
        bringSubviewToFront(cycleScrollADViewBackgroundView!)
        bringSubviewToFront(cycleScrollADView!)
    }
    @objc func moreItemButtonClicked() {
        gridViewDelegate?.homeGrideViewmoreItemButtonClicked(self)
    }
    func rowCount(withItemsCount count: Int) -> Int {
        var rowCount: Int = (count + 4 - 1) / 4
        rowCount += 1
        rowCount = (rowCount < 4) ? 4 : rowCount
        return rowCount
    }
    func buttonLongPressed(_ longPressed: UILongPressGestureRecognizer?) {
        let pressedView = longPressed?.view as? AlipayHomeGridViewListItemView
        let point: CGPoint? = longPressed?.location(in: self)
        if longPressed?.state == .began {
            currentPressedView?.hidenIcon = true
            currentPressedView = pressedView
            currentPresssViewFrame = (pressedView?.frame)!
            longPressed?.view?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            pressedView?.hidenIcon = false
            var index: Int? = nil
            if let aView = longPressed?.view {
                index = itemsArray.index(of: aView)
            }
            if let aView = longPressed?.view {
                while let elementIndex = itemsArray.index(of: aView) { itemsArray.remove(at: elementIndex) }
            }
            itemsArray.insert(placeholderButton!, at: index ?? 0)
            lastPoint = point!
            var temp: CGRect? = longPressed?.view?.frame
            temp?.origin.x += (point?.x)! - lastPoint.x
            temp?.origin.y += (point?.y)! - lastPoint.y
            longPressed?.view?.frame = temp ?? CGRect.zero
            lastPoint = point!
        }
        if longPressed?.state == .ended {
            let index: Int = itemsArray.index(of: placeholderButton!)!
            while let elementIndex = itemsArray.index(of: placeholderButton!) { itemsArray.remove(at: elementIndex) }
            if let aView = longPressed?.view {
            itemsArray.insert(aView, at: index)
        }
        if let aView = longPressed?.view {
            sendSubviewToBack(aView)
        }
        // 保存数据
//        self.saveItemsSettingCache()
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            longPressed?.view?.transform = .identity
        }, completion: {(_ finished: Bool) -> Void in
            if !self.currentPresssViewFrame.equalTo((self.currentPressedView?.frame)!) {
                self.currentPressedView?.hidenIcon = true
            }
        })
        }
    }
    func delete(_ view: AlipayHomeGridViewListItemView?) {
        if let aView = view {
            while let elementIndex = itemsArray.index(of: aView) {
                itemsArray.remove(at: elementIndex)
            }
        }
        view?.removeFromSuperview()
        saveItemsSettingCache()
    }
    func saveItemsSettingCache() {
        for button in itemsArray{
            if (button is AlipayHomeGridViewListItemView) {
            }
        }
        gridViewDelegate?.homeGrideViewDidChangeItems(self)
    }
    func setupSubViewsFrame() {
        let itemW: CGFloat = frame.size.width / 4
        let itemH: CGFloat = itemW * 1.1
        for idx in 0..<itemsArray.count{
            let rowIndex: Int = idx / 4
            let columnIndex: Int = idx % 4
            let x = itemW * CGFloat(columnIndex)
            var y: CGFloat = 0
            if idx < 4 * 3 {
                y = itemH * CGFloat(rowIndex) + 100
            } else {
                y = itemH * CGFloat((rowIndex + 1))
            }
            let item = self.itemsArray[idx] as? UIView
            item?.frame = CGRect(x: x, y: y, width: itemW, height: itemH)
            if idx == (itemsArray.count - 1) {
                self.contentSize = CGSize(width: 0, height: (item?.frame.size.height)! + (item?.frame.origin.y)!)
            }
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let itemW: CGFloat = frame.size.width / 4
        let itemH: CGFloat = itemW * 1.1
        setupSubViewsFrame()
        if shouldAdjustedSeparators {
            for idx in 0 ..< self.rowSeparatorsArray.count{
                let view = self.rowSeparatorsArray[idx] as? UIView
                view?.frame = CGRect(x:0, y: CGFloat(idx) * itemH + 100, width:self.frame.size.width, height: 0.4)
            }
        }
        shouldAdjustedSeparators = false
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        currentPressedView?.hidenIcon = true
    }
}
class AlipayHomeViewController: AlipayBaseViewController,SDHomeGridViewDeleate {
    var dataArray :[Any]!
    let mainView = AlipayHomeGridView()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "支付宝"
        mainView.gridViewDelegate = self
        mainView.showsVerticalScrollIndicator = false
        let itemsArray = AlipayTools.itemsArray()
        var temp = [AnyHashable]()
        for _ in itemsArray {
            let model = AlipayHomeGridItemModel()
            model.destinationClass = AlipayHomeViewController.self
            temp.append(model)
        }
        dataArray = temp
        mainView.gridModelsArray = dataArray
        view.addSubview(mainView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tabbarHeight: CGFloat? = tabBarController?.tabBar.frame.size.height
        mainView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: APPH - (tabbarHeight ?? 0.0))
    }
    func homeGrideView(_ gridView: AlipayHomeGridView?, selectItemAt index: Int) {
        let model: AlipayHomeGridItemModel? = dataArray[index] as? AlipayHomeGridItemModel
        let vc = UIViewController()
        vc.title = model?.title
        navigationController?.pushViewController(vc, animated: true)
    }
    func homeGrideViewmoreItemButtonClicked(_ gridView: AlipayHomeGridView?) {
        let addVc = AlipayAddItemViewController()
        addVc.title = "添加更多"
        navigationController?.pushViewController(addVc, animated: true)
    }
    
    func homeGrideViewDidChangeItems(_ gridView: AlipayHomeGridView?) {
    }
}
