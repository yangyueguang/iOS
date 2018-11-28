//
//  SDAddItemViewController.swift
//  Freedom
import UIKit
import XExtension
class AlipayAddItemGridView: UIScrollView, UIScrollViewDelegate {
    var gridModelsArray = [Any]()
    var itemClickedOperationBlock: ((_ gridView: AlipayAddItemGridView?, _ index: Int) -> Void)?
    
    private var itemsArray = [AnyHashable]()
    private var rowSeparatorsArray = [AnyHashable]()
    private var columnSeparatorsArray = [AnyHashable]()
    private var hasAdjustedSeparators = false
    private var lastPoint = CGPoint.zero
    private var placeholderButton: UIButton?
    private var currentPressedView: AlipayHomeGridViewListItemView?
    private var currentPresssViewFrame = CGRect.zero
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        itemsArray = [AnyHashable]()
        rowSeparatorsArray = [AnyHashable]()
        columnSeparatorsArray = [AnyHashable]()
        hasAdjustedSeparators = false
        placeholderButton = UIButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let itemW: CGFloat = frame.size.width / 4
        let itemH: CGFloat = itemW * 1.1
        print(itemH)
        hasAdjustedSeparators = true
    }
    
    func setGridModelsArray(_ gridModelsArray: [Any]?) {
        self.gridModelsArray = gridModelsArray!
        let rowCount: Int = self.rowCount(withItemsCount: (gridModelsArray?.count)!)
        for _ in 0..<(rowCount + 1) {
            let rowSeparator = UIView()
            rowSeparator.backgroundColor = UIColor.lightGray
            addSubview(rowSeparator)
            rowSeparatorsArray.append(rowSeparator)
        }
        for _ in 0..<(4 + 1) {
            let columnSeparator = UIView()
            columnSeparator.backgroundColor = UIColor.lightGray
            addSubview(columnSeparator)
            columnSeparatorsArray.append(columnSeparator)
        }
    }
    func rowCount(withItemsCount count: Int) -> Int {
        let rowCount: Int = (count + 4 - 1) / 4
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
        }
    }
    func setupSubViewsFrame() {
        let itemW: CGFloat = frame.size.width / 4
        let itemH: CGFloat = itemW * 1.1
        print(itemH)
    }
    func delete(_ view: AlipayHomeGridViewListItemView?) {
        if let aView = view {
            while let elementIndex = itemsArray.index(of: aView) { itemsArray.remove(at: elementIndex) }
        }
        view?.removeFromSuperview()
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.setupSubViewsFrame()
        })
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        currentPressedView?.hidenIcon = true
    }
}
class AlipayAddItemViewController: AlipayBaseViewController {
    weak var mainView: AlipayAddItemGridView?
    var dataArray = [AnyHashable]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainView = AlipayAddItemGridView(frame: view.bounds)
        mainView.showsVerticalScrollIndicator = false
        let titleArray = ["淘宝", "生活缴费", "教育缴费", "红包", "物流", "信用卡", "转账", "爱心捐款", "彩票", "当面付", "余额宝", "AA付款", "国际汇款", "淘点点", "淘宝电影", "亲密付", "股市行情", "汇率换算"]
        var temp = [AnyHashable]()
        for i in 0..<18 {
            let model = AlipayHomeGridItemModel()
//            model.destinationClass = SDBasicViewContoller.self
            model.imageResString = String(format: "i%02d", i)
            model.title = titleArray[i]
            temp.append(model)
        }
        dataArray = temp
        mainView.gridModelsArray = temp
        view.addSubview(mainView)
        self.mainView = mainView
    }
}
