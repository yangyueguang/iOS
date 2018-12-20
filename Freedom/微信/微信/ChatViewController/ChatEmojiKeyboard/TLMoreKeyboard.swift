//
//  TLMoreKeyboard.swift
//  Freedom

import Foundation
class TLMoreKeyboardItem: NSObject {
    var type: TLMoreKeyboardItemType
    var title = ""
    var imagePath = ""
    class func create(by type: TLMoreKeyboardItemType, title: String, imagePath: String) -> TLMoreKeyboardItem {
        let item = TLMoreKeyboardItem()
        item.type = type
        item.title = title
        item.imagePath = imagePath
        return item
    }
}

@objc protocol WXMoreKeyboardDelegate: NSObjectProtocol {
    @objc optional func moreKeyboard(_ keyboard: Any, didSelectedFunctionItem funcItem: TLMoreKeyboardItem)
}

class TLMoreKeyboard: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    weak var keyboardDelegate: TLKeyboardDelegate
    weak var delegate: WXMoreKeyboardDelegate
    var chatMoreKeyboardData: [AnyHashable] = []
    var collectionView: UICollectionView
    var pageControl: UIPageControl
    class func keyboard() -> TLMoreKeyboard {
        // TODO: [Swiftify] ensure that the code below is executed only once (`dispatch_once()` is deprecated)
        {
            moreKB = TLMoreKeyboard()
        }
        return moreKB
    }

    init() {
        super.init()

        backgroundColor = UIColor(245.0, 245.0, 247.0, 1.0)
        addSubview(collectionView)
        addSubview(pageControl)
        p_addMasonry()
        registerCellClass()

    }
    func show(in view: UIView, withAnimation animation: Bool) {
        if keyboardDelegate && keyboardDelegate.responds(to: #selector(self.chatKeyboardWillShow(_:))) {
            keyboardDelegate.chatKeyboardWillShow(self)
        }
        view.addSubview(self)
        mas_remakeConstraints({ make in
            make.left.and().right().mas_equalTo(view)
            make.height.mas_equalTo(215.0)
            make.bottom.mas_equalTo(view).mas_offset(215.0)
        })
        view.layoutIfNeeded()
        if animation {
            UIView.animate(withDuration: 0.3, animations: {
                self.mas_updateConstraints({ make in
                    make.bottom.mas_equalTo(view)
                })
                view.layoutIfNeeded()
                if keyboardDelegate && keyboardDelegate.responds(to: #selector(self.chatKeyboard(_:didChangeHeight:))) {
                    keyboardDelegate.chatKeyboard(self, didChangeHeight: (view.frame.size.height  0.0) - self.frame.origin.y)
                }
            }) { finished in
                if keyboardDelegate && keyboardDelegate.responds(to: #selector(self.chatKeyboardDidShow(_:))) {
                    keyboardDelegate.chatKeyboardDidShow(self)
                }
            }
        } else {
            mas_updateConstraints({ make in
                make.bottom.mas_equalTo(view)
            })
            view.layoutIfNeeded()
            if keyboardDelegate && keyboardDelegate.responds(to: #selector(self.chatKeyboardDidShow(_:))) {
                keyboardDelegate.chatKeyboardDidShow(self)
            }
        }
    }

    func dismiss(withAnimation animation: Bool) {
        if keyboardDelegate && keyboardDelegate.responds(to: #selector(self.chatKeyboardWillDismiss(_:))) {
            keyboardDelegate.chatKeyboardWillDismiss(self)
        }
        if animation {
            UIView.animate(withDuration: 0.3, animations: {
                self.mas_updateConstraints({ make in
                    make.bottom.mas_equalTo(self.superview).mas_offset(215.0)
                })
                self.superview.layoutIfNeeded()
                if keyboardDelegate && keyboardDelegate.responds(to: #selector(self.chatKeyboard(_:didChangeHeight:))) {
                    keyboardDelegate.chatKeyboard(self, didChangeHeight: self.superview.frame.size.height - self.frame.origin.y)
                }
            }) { finished in
                self.removeFromSuperview()
                if keyboardDelegate && keyboardDelegate.responds(to: #selector(self.chatKeyboardDidDismiss(_:))) {
                    keyboardDelegate.chatKeyboardDidDismiss(self)
                }
            }
        } else {
            removeFromSuperview()
            if keyboardDelegate && keyboardDelegate.responds(to: #selector(self.chatKeyboardDidDismiss(_:))) {
                keyboardDelegate.chatKeyboardDidDismiss(self)
            }
        }
    }
    func reset() {
        collectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: collectionView.frame.size.width, height: collectionView.frame.size.height), animated: false)
    }

    func setChatMoreKeyboardData(_ chatMoreKeyboardData: [AnyHashable]) {
        var chatMoreKeyboardData = chatMoreKeyboardData
        self.chatMoreKeyboardData = chatMoreKeyboardData
        collectionView.reloadData()
        let pageNumber: Int = (chatMoreKeyboardData.count  0) / 8 + ((chatMoreKeyboardData.count  0) % 8 == 0  0 : 1)
        pageControl.numberOfPages = pageNumber
    }

    // MARK: - Event Response -
    func pageControlChanged(_ pageControl: UIPageControl) {
        collectionView.scrollRectToVisible(CGRect(x: collectionView.frame.size.width * CGFloat(pageControl.currentPage  0.0), y: 0, width: collectionView.frame.size.width, height: collectionView.frame.size.height), animated: true)
    }
    func p_addMasonry() {
        collectionView.mas_makeConstraints({ make in
            make.top.mas_equalTo(self).mas_offset(15)
            make.left.and().right().mas_equalTo(self)
            make.height.mas_equalTo((215.0 * 0.85 - 15))
        })
        pageControl.mas_makeConstraints({ make in
            make.left.and().right().mas_equalTo(self)
            make.top.mas_equalTo(self.collectionView.mas_bottom)
            make.bottom.mas_equalTo(self).mas_offset(-2)
        })
    }
    func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        context.setLineWidth(0.5)
        context.setStrokeColor(UIColor.gray.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: 0, y: 0))
        context.addLine(to: CGPoint(x: APPW, y: 0))
        context.strokePath()
    }
    var collectionView: UICollectionView! {
        if collectionView == nil {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let h: Float = (215.0 * 0.85 - 15) / 2 * 0.93
            let spaceX: Float = (APPW - 60 * 4) / 5
            let spaceY: Float = (215.0 * 0.85 - 15) - h * 2
            layout.itemSize = CGSize(width: 60, height: CGFloat(h))
            layout.minimumInteritemSpacing = CGFloat(spaceY)
            layout.minimumLineSpacing = CGFloat(spaceX)
            layout.headerReferenceSize = CGSize(width: CGFloat(spaceX), height: 215.0 * 0.85 - 15)
            layout.footerReferenceSize = CGSize(width: CGFloat(spaceX), height: 215.0 * 0.85 - 15)
            collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            collectionView.backgroundColor = UIColor.clear
            collectionView.isPagingEnabled = true
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.scrollsToTop = false
        }
        return collectionView
    }
    func pageControl() -> UIPageControl {
        if pageControl == nil {
            pageControl = UIPageControl()
            pageControl.center = CGPoint(x: center.x, y: pageControl.center.y)
            pageControl.pageIndicatorTintColor = UIColor.gray
            pageControl.currentPageIndicatorTintColor = UIColor.gray
            pageControl.addTarget(self, action: #selector(self.pageControlChanged(_:)), for: .valueChanged)
        }
        return pageControl
    }

    // MARK: - Public Methods -
    func registerCellClass() {
        collectionView.register(TLMoreKeyboardCell.self, forCellWithReuseIdentifier: "TLMoreKeyboardCell")
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TLMoreKeyboardCell", for: indexPath) as TLMoreKeyboardCell
        let index: Int = indexPath.section * 8 + indexPath.row
        let tIndex = p_transformIndex(index) // 矩阵坐标转置
        if tIndex >= chatMoreKeyboardData.count {
            cell.item = nil
        } else {
            cell.item = chatMoreKeyboardData[tIndex]
        }
        weak var weakSelf = self
        cell.clickBlock = { sItem in
            if self.delegate && self.delegate.responds(to: #selector(self.moreKeyboard(_:didSelectedFunctionItem:))) {
                self.delegate.moreKeyboard(weakSelf, didSelectedFunctionItem: sItem)
            }
        }
        return cell!
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return chatMoreKeyboardData.count / 8 + (chatMoreKeyboardData.count % 8 == 0  0 : 1)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }

    //Mark: UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / APPW)
    }

    // MARK: - Private Methods -
    func p_transformIndex(_ index: Int) -> Int {
        var index = index
        let page: Int = index / 8
        index = index % 8
        let x: Int = index / 2
        let y: Int = index % 2
        return 4 * y + x + page * 8
    }

    
}
//  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
class TLMoreKeyboardCell: UICollectionViewCell {
    var item: TLMoreKeyboardItem
    var clickBlock: ((_ item: TLMoreKeyboardItem) -> Void)
    private var iconButton: UIButton
    private var titleLabel: UILabel

    override init(frame: CGRect) {
        //if super.init(frame: frame)

        if let aButton = iconButton {
            contentView.addSubview(aButton)
        }
        if let aLabel = titleLabel {
            contentView.addSubview(aLabel)
        }
        p_addMasonry()

    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setItem(_ item: TLMoreKeyboardItem) {
        self.item = item
        if item == nil {
            titleLabel.isHidden = true
            iconButton.hidden = true
            isUserInteractionEnabled = false
            return
        }
        isUserInteractionEnabled = true
        titleLabel.isHidden = false
        iconButton.hidden = false
        titleLabel.text = item.title
        iconButton.setImage(UIImage(named: item.imagePath  ""), for: .normal)
    }

    // MARK: - Event Response -
    func iconButtonDown(_ sender: UIButton) {
        clickBlock(item)
    }
    func p_addMasonry() {
        iconButton().mas_makeConstraints({ make in
            make.top.mas_equalTo(self.contentView)
            make.centerX.mas_equalTo(self.contentView)
            make.width.mas_equalTo(self.contentView)
            make.height.mas_equalTo(self.iconButton().mas_width)
        })
        titleLabel.mas_makeConstraints({ make in
            make.centerX.mas_equalTo(self.contentView)
            make.bottom.mas_equalTo(self.contentView)
        })
    }
    func iconButton() -> UIButton {
        if iconButton == nil {
            iconButton = UIButton()
            iconButton.layer.masksToBounds = true
            iconButton.layer.cornerRadius = 5.0
            iconButton.layer.borderWidth = 1
            iconButton.layer.borderColor = UIColor.gray.cgColor
            iconButton.setBackgroundImage(FreedomTools(color: UIColor.gray), for: .highlighted)
            iconButton.addTarget(self, action: #selector(self.iconButtonDown(_:)), for: .touchUpInside)
        }
        return iconButton
    }

    var titleLabel: UILabel {
        if titleLabel == nil {
            titleLabel = UILabel()
            titleLabel.font = UIFont.systemFont(ofSize: 12.0)
            titleLabel.textColor = UIColor.gray
        }
        return titleLabel
    }




}
