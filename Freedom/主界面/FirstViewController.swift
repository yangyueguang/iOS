//
//  FirstViewController.swift
//  Freedom
//
//  Created by Super on 6/15/18.
//  Copyright © 2018 Super. All rights reserved.
import UIKit
//import XExtension
class CollectionViewCell1:BaseCollectionViewCell<Any> {
    var view: UIView = UIView()
    override func initUI() {
        view.frame = CGRect(x: 0, y: (self.height - 80) * 0.5, width: 80, height: 80)
        view.backgroundColor = UIColor.clear
        icon = UIImageView(frame: view.frame)
        icon.layer.borderWidth = 2
        icon.layer.cornerRadius = 40
        view.addSubview(icon)
        contentView.addSubview(view)
        title = UILabel(frame: CGRect(x: icon.right, y: (self.height - 20) * 0.5, width: 200, height: 20))
        contentView.addSubview(title)
        icon.clipsToBounds = true
    }
}
class CollectionViewCell2: BaseCollectionViewCell<Any> {
    override func initUI() {
        title = UILabel(frame: CGRect(x: 80, y: 0, width: 200, height: 40))
        title.font = FFont(28)
        contentView.addSubview(title)
    }
}
class XCollectionViewDialLayout: UICollectionViewLayout {
    var cellCount: Int = 0
    var wheelType: Int = 0
    var center = CGPoint.zero
    var offset: CGFloat = 0.0
    var itemHeight: CGFloat = 0.0
    var xOffset: CGFloat = 0.0
    var cellSize = CGSize.zero
    var angularSpacing: CGFloat = 0.0
    var dialRadius: CGFloat = 0.0
    private(set) var currentIndexPath: IndexPath?
    init(radius: CGFloat, andAngularSpacing spacing: CGFloat, andCellSize cell: CGSize, andAlignment alignment: Int, andItemHeight height: CGFloat, andXOffset xOff: CGFloat) {
        super.init()
        dialRadius = radius
        cellSize = cell
        itemHeight = height
        angularSpacing = spacing
        xOffset = xOff
        wheelType = alignment
        offset = 0.0
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepare() {
        super.prepare()
        cellCount = (collectionView?.numberOfItems(inSection: 0))!
        offset = -(collectionView?.contentOffset.y ?? 0.0) / itemHeight
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var theLayoutAttributes = [AnyHashable]()
        let minY: CGFloat = rect.minY
        let maxY: CGFloat = rect.maxY
        let firstIndex: Int = Int(floorf(Float(minY / itemHeight)))
        let lastIndex: Int = Int(floorf(Float(maxY / itemHeight)))
        let activeIndex: Int = (firstIndex + lastIndex) / 2
        let maxVisibleOnScreen: Int = Int(180 / angularSpacing + 2)
        var firstItem = activeIndex - Int(maxVisibleOnScreen / 2)
        if firstItem < 0{
            firstItem = 0
        }
        var lastItem = activeIndex + Int(maxVisibleOnScreen / 2)
        if lastItem > cellCount - 1 && cellCount > 1{
            lastItem = cellCount - 1
        }
        if firstItem > lastItem{
            firstItem = lastItem
        }
        for i in firstItem...lastItem {
            let indexPath = IndexPath(item: i, section: 0)
            let theAttributes: UICollectionViewLayoutAttributes? = layoutAttributesForItem(at: indexPath)
            if let anAttributes = theAttributes {
                theLayoutAttributes.append(anAttributes)
            }
        }
        return theLayoutAttributes as? [UICollectionViewLayoutAttributes]
    }
    override var collectionViewContentSize: CGSize {
        var theSize = CGSize()
        theSize.width = (collectionView?.bounds.size.width)!
        theSize.height = CGFloat(cellCount - 1) * itemHeight + (collectionView?.bounds.size.height ?? 0.0)
        return theSize
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let newIndex = (CGFloat(indexPath.item) + offset)
        let theAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        theAttributes.size = cellSize
        var scaleFactor: CGFloat
        var deltaX: CGFloat
        var translationT: CGAffineTransform?
        let rotationT = CGAffineTransform(rotationAngle: angularSpacing * CGFloat(newIndex) * .pi / 180)
        if indexPath.item == 3 {
        }
        if wheelType == 0 {
            scaleFactor = CGFloat(fmax(0.6, 1 - fabs(Float(newIndex * 0.25))))
            deltaX = cellSize.width / 2
            theAttributes.center = CGPoint(x: -dialRadius + xOffset, y: (collectionView?.bounds.size.height ?? 0.0) / 2 + (collectionView?.contentOffset.y ?? 0.0))
            translationT = CGAffineTransform(translationX: dialRadius + deltaX * scaleFactor, y: 0)
        } else {
            scaleFactor = CGFloat(fmax(0.4, 1 - fabs(newIndex * 0.50)))
            deltaX = CGFloat((collectionView?.bounds.size.width ?? 0.0) / 2)
            theAttributes.center = CGPoint(x: -dialRadius + xOffset, y: (collectionView?.bounds.size.height ?? 0.0) / 2 + (collectionView?.contentOffset.y ?? 0.0))
            translationT = CGAffineTransform(translationX: dialRadius + CGFloat((1 - scaleFactor) * -30), y: 0)
        }
        let scaleT = CGAffineTransform(scaleX: CGFloat(scaleFactor), y: scaleFactor)
        theAttributes.alpha = scaleFactor
        theAttributes.transform = scaleT.concatenating((translationT?.concatenating(rotationT))!)
        theAttributes.zIndex = indexPath.item
        return theAttributes
    }
}
class FirstViewController: BaseViewController,UICollectionViewDataSource, UICollectionViewDelegate,UISearchBarDelegate {
    static let sharedVC = FirstViewController()
    @IBOutlet weak var homecollectionView: UICollectionView!
    var items:[[String:String]] = (UIApplication.shared.delegate as! AppDelegate).items
    var transition: ElasticTransition = ElasticTransition()
    var LibraryGR: UIScreenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer()
    var SettingsGR: UIScreenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer()
    var searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 50, y: 0, width: APPW - 110, height: 44))
    var showingSettings = false
    var settingsView: UIView = UIView()
    var radiusLabel: UILabel = UILabel()
    var radiusSlider: UISlider = UISlider()
    var angularSpacingLabel: UILabel = UILabel()
    var angularSpacingSlider: UISlider = UISlider()
    var xOffsetLabel: UILabel = UILabel()
    var xOffsetSlider: UISlider = UISlider()
    var exampleSwitch: UISwitch = UISwitch(frame: CGRect(x: 30, y: 30, width: 200, height: 20))
    var dialLayout: XCollectionViewDialLayout?
    var count: Int = 0
    var timer: Timer?
    @IBOutlet weak var firstNavigationBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isStatusBarHidden = true
        searchBar.delegate = self
        searchBar.placeholder = "搜索"
        searchBar.barTintColor = UIColor.gray
        let leftNav = UIBarButtonItem(title: "设置", action: {
            self.gotoSettingsView(nil)
        })
        let rightNav = UIBarButtonItem(image: Image.setting.image) {
            self.showSettingsView(nil)
        }
        let navigationItem = UINavigationItem(title: "自由主义")
        navigationItem.leftBarButtonItem = leftNav
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = rightNav
        firstNavigationBar?.items = [navigationItem]
        // 键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        transition.sticky = true
        transition.showShadow = true
        transition.panThreshold = 0.55
        transition.radiusFactor = 0.3
        //    transition.transformType    = ROTATE;
        transition.overlayColor = UIColor(white: 0, alpha: 0.5)
        transition.shadowColor = UIColor(white: 0, alpha: 0.5)
        SettingsGR.addTarget(self, action: #selector(self.gotoSettings(_:)))
        SettingsGR.edges = .left
        view.addGestureRecognizer(SettingsGR)
        LibraryGR.addTarget(self, action: #selector(self.gotoLibrary(_:)))
        LibraryGR.edges = .right
        view.addGestureRecognizer(LibraryGR)
        showingSettings = false
        buildSettings()
        homecollectionView.register(CollectionViewCell1.self, forCellWithReuseIdentifier: CollectionViewCell1.identifier)
        homecollectionView.register(CollectionViewCell2.self, forCellWithReuseIdentifier: CollectionViewCell2.identifier)
        homecollectionView.delegate = self
        homecollectionView.dataSource = self
        homecollectionView.backgroundColor = UIColor(230, 230, 230, 1)
        //下雪 每隔1秒下一次
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.snowAnimat(_:)), userInfo: nil, repeats: true)
        timer?.fireDate = Date(timeIntervalSinceNow: 1000)
        switchExample()
    }
    // MARK: 设置与收藏的跳转
    func gotoSettingsView(_ sender: UIButton?) {
        timer?.fireDate = Date.distantFuture
        transition.edge = .left;
        transition.startingPoint = CGPoint(x: 230, y: 170)
        performSegue(withIdentifier: "settings", sender: transition)
    }
    func gotoSettings(_ pan: UIPanGestureRecognizer?) {
        if pan?.state != .began {
            _ = transition.updateInteractiveTransition(gestureRecognizer: pan!)
        } else {
            transition.edge = Edge.left
            transition.startInteractiveTransition(self, segueIdentifier: "settings", gestureRecognizer: pan!)
        }
    }
    func gotoLibrary(_ pan: UIPanGestureRecognizer?) {
        if pan?.state == .began {
            transition.edge = Edge.right
            transition.startInteractiveTransition(self, segueIdentifier: "library", gestureRecognizer: pan!)
        } else {
            _ = transition.updateInteractiveTransition(gestureRecognizer: pan!)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc: UIViewController? = segue.destination
        vc?.transitioningDelegate = transition
        vc?.modalPresentationStyle = .custom
    }
    func buildSettings() {
        settingsView.frame = CGRect(x: 0, y: view.frame.size.height + 100, width: view.frame.size.width, height: view.frame.size.height - 44)
        settingsView.backgroundColor = UIColor(white: 1.0, alpha: 0.6)
        exampleSwitch.addTarget(self, action: #selector(self.switchExample), for: .valueChanged)
        exampleSwitch.isOn = true
        radiusLabel.frame = CGRect(x: 30, y: exampleSwitch.bottom + 20, width: APPW - 60, height: 20)
        radiusSlider.frame = CGRect(x: 30, y: radiusLabel.bottom + 10, width: settingsView.width - 60, height: 20)
        radiusSlider.addTarget(self, action: #selector(self.updateDialSettings), for: .valueChanged)
        angularSpacingLabel.frame = CGRect(x: 30, y: radiusSlider.bottom + 20, width: 100, height: 20)
        angularSpacingSlider.frame = CGRect(x: 30, y: angularSpacingLabel.bottom + 10, width: settingsView.width - 60, height: 20)
        angularSpacingSlider.addTarget(self, action: #selector(self.updateDialSettings), for: .valueChanged)
        xOffsetLabel.frame = CGRect(x: 30, y: angularSpacingSlider.bottom + 20, width: 100, height: 20)
        xOffsetSlider.frame = CGRect(x: 30, y: xOffsetLabel.bottom + 10, width: settingsView.width - 60, height: 20)
        xOffsetSlider.addTarget(self, action: #selector(self.updateDialSettings), for: .valueChanged)
        settingsView.addSubviews([exampleSwitch, radiusLabel, radiusSlider, angularSpacingLabel, angularSpacingSlider, xOffsetLabel, xOffsetSlider])
        view.addSubview(settingsView)
        dialLayout = XCollectionViewDialLayout(radius: CGFloat(radiusSlider.value * 1000), andAngularSpacing: CGFloat(angularSpacingSlider.value * 90), andCellSize: CGSize(width: 240, height: 100), andAlignment: 1, andItemHeight: 100, andXOffset: CGFloat(xOffsetSlider.value * 320))
        homecollectionView.collectionViewLayout = dialLayout!
    }
    func switchExample() {
        radiusSlider.value = 0.3
        angularSpacingSlider.value = 0.2
        xOffsetSlider.value = 0.6
        if exampleSwitch.isOn {
            dialLayout?.cellSize = CGSize(width: 240, height: 100)
            dialLayout?.wheelType = 0
        } else {
            dialLayout?.cellSize = CGSize(width: 260, height: 50)
            dialLayout?.wheelType = 1
        }
        updateDialSettings()
        homecollectionView.reloadData()
    }
    func updateDialSettings() {
        let radius: CGFloat = CGFloat(radiusSlider.value * 1000)
        let angularSpacing: CGFloat = CGFloat(angularSpacingSlider.value * 90)
        let xOffset: CGFloat = CGFloat(xOffsetSlider.value * 320)
        radiusLabel.text = "弧度: \(Int(radius))"
        dialLayout?.dialRadius = radius
        angularSpacingLabel.text = "间距: \(Int(angularSpacing))"
        dialLayout?.angularSpacing = angularSpacing
        xOffsetLabel.text = "偏移量: \(Int(xOffset))"
        dialLayout?.xOffset = xOffset
        dialLayout?.invalidateLayout()
    }
    func showSettingsView(_ sender: UIButton?) {
        transition.edge = .bottom
        var frame: CGRect = settingsView.frame
        if showingSettings {
            frame.origin.y = view.frame.size.height + 100
        } else {
            frame.origin.y = 44
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.transition.startingPoint = CGPoint(x: self.settingsView.frame.origin.x + self.settingsView.frame.size.width / 2.0, y: self.settingsView.frame.origin.y)
            self.settingsView.frame = frame
        }) { finished in
        }
        showingSettings = !showingSettings
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mode = PopoutModel()
        mode.name = items[indexPath.row]["control"]!
        AppDelegate.radialView.didSelectBlock!(AppDelegate.radialView, false,false,mode)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dic = items[indexPath.item]
        let color = UIColor.random
        if exampleSwitch.isOn {
            let cell = cv.dequeueCell(CollectionViewCell1.self, for: indexPath)
            cell.icon.layer.borderColor = color.cgColor
            cell.title.text = dic["title"]
            cell.icon.image = UIImage(named:dic["icon"]!)
            return cell
        } else {
            let cell = cv.dequeueCell(CollectionViewCell2.self, for: indexPath)
            cell.title.text = dic["title"]
            cell.title.textColor = color
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // DLog(@"didEndDisplayingCell:%i", (int)indexPath.item);
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    // MARK: others
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            return
        }
        let pre = NSPredicate(format: "title CONTAINS %@ OR icon CONTAINS[c] %@ OR icon MATCHES %@", searchText, searchText, "[F-j]+")
        let temp = self.items.filter { (freeItem) -> Bool in
            return pre.evaluate(with: freeItem)
        }
        self.items = temp
        homecollectionView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBa: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    // MARK: - 键盘显示/隐藏
    //  键盘显示
    func keyBoardWillShow(_ note: Notification?) {
        if let timeIntervar:TimeInterval = note?.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval{
            UIView.animate(withDuration: timeIntervar) {
                //        _tableView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height);
            }
        }
    }
    // 键盘隐藏
    func keyBoardWillHide(_ note: Notification?) {
        if let timeIntervar:TimeInterval = note?.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval{
            UIView.animate(withDuration: timeIntervar) {
                //        _tableView.frame = CGRectMake(0, 20, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-20);
            }
        }
    }
    // MARK: 下雪相关内容
    func tingzhixiaxue() {
        timer?.fireDate = Date.distantFuture
    }
    func kaishixiaxue() {
        timer?.fireDate = Date.distantPast
    }
    //下雪
    func snowAnimat(_ timer: Timer?) {
        count += 1
        //1.创建雪花
        let snow = UIImageView(image: Image.snow.image)
        snow.tag = count
        let width: CGFloat = view.frame.size.width
        let x: CGFloat = CGFloat(arc4random() % UInt32(width))
        let size: CGFloat = CGFloat(arc4random() % 10 + 10)
        snow.frame = CGRect(x: CGFloat(x), y: -20, width: CGFloat(size), height: CGFloat(size))
        view.addSubview(snow)
        UIView.beginAnimations("\(count)", context: nil)
        UIView.setAnimationDuration(TimeInterval(arc4random() % 10 + 2))
        UIView.setAnimationCurve(.easeIn)
        let offset: CGFloat = (CGFloat(arc4random())/0xFFFFFFFF) * 100 - 50
        snow.center = CGPoint(x: snow.center.x + CGFloat(offset), y: view.bounds.size.height - 10)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStop(#selector(self.snowDisappear(_:)))
        UIView.commitAnimations()
    }
    //区分不同的雪花动画
    func snowDisappear(_ animatedID: String?) {
        //创建雪花消失动画
        UIView.beginAnimations(animatedID, context: nil)
        UIView.setAnimationDuration(TimeInterval(arc4random() % 2 + 2))
        UIView.setAnimationCurve(.easeIn)
        let view: UIView? = self.view.viewWithTag(Int(animatedID ?? "") ?? 0)
        let imageView = view as? UIImageView
        imageView?.alpha = 0.0
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStop(#selector(self.snowRemove(_:)))
        UIView.commitAnimations()
    }
    //动画结束后 删除视图
    func snowRemove(_ animatedID: String?) {
        let snow: UIView? = view.viewWithTag(Int(animatedID ?? "") ?? 0)
        snow?.removeFromSuperview()
    }
    // MARK: View生存周期
    override func viewWillDisappear(_ animated: Bool) {
        timer?.fireDate = Date.distantFuture
        timer?.invalidate()
        timer = nil
    }
}
