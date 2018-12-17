//
//  XRefreshControl.swift
import UIKit
let XRefreshTotalLenght: CGFloat = 60
typealias refreshAction = () -> Void
typealias PullDownRefreshing = () -> Void //< 下拉刷新开始
enum RefreshType : Int {
    case normal
    case loading
    case notMore
    case fail
    case loosen
    case notFullowup
}

enum XRefreshState : Int {
    case pulling = 0
    case normal = 1
    case loading = 2
    case stopped = 3
}

enum CLLLoadMoreState : Int {
    case normal = 10
    case loading = 11
    case stopped = 12
    case pulling
}

enum XRefreshViewLayerType : Int {
    case onScrollViews = 0
    case onSuperView = 1
}

protocol XRefreshHeadControllerDelegate: NSObjectProtocol {
    func beginPullDownRefreshing()
    func beginPullUpLoading()
    func refreshViewLayerType() -> XRefreshViewLayerType
    //UIScrollView的控制器是否保留iOS7新的特性，意思是：tablView的内容是否可以显示导航条后面
    func keepiOS7NewApiCharacter() -> Bool
    func hasRefreshHeaderView() -> Bool
    func hasRefreshFooterView() -> Bool
}
class XRefreshHeadView: UIView /*刷新操作提示 */ {
    lazy var statusLabel: UILabel = {
        let _statusLabel = UILabel(frame: CGRect(x: 140, y: 15, width: 160, height: 14))
        _statusLabel.backgroundColor = UIColor.clear
        _statusLabel.font = UIFont.systemFont(ofSize: 14.0)
        _statusLabel.textColor = UIColor.black
        return _statusLabel
    }()
    lazy var timeLabel: UILabel = {
        var timeLabelFrame = self.statusLabel.frame
        timeLabelFrame.origin.y += timeLabelFrame.height + 6
        let timeLabel = UILabel(frame: timeLabelFrame)
        timeLabel.backgroundColor = UIColor.clear
        timeLabel.font = UIFont.systemFont(ofSize: 11.0)
        timeLabel.textColor = UIColor(white: 0.659, alpha: 1.000)
        return timeLabel
    }()
    private lazy var pullDownAnimations: [UIImage] = {
        var pullDownAnimations = [UIImage]()
        var fileNames = [String]()
        for i in 0..<27 {
            let strImageName = "\("pull_down_animeted_")\(i)"
            fileNames.append(strImageName)
        }
        let pullDownImages = fileNames
        for obj in pullDownImages {
            let image = UIImage(named: obj)
            if let anImage = image {
                pullDownAnimations.append(anImage)
            }
        }
        return pullDownAnimations
    }()
    private lazy var refreshAnimations: [UIImage] = {
        var refreshAnimations = [UIImage]()
        var fileNames = [String]()
        for i in 0..<15 {
            let strImageName = "\("refresh_animation_")\(i)"
            fileNames.append(strImageName)
        }
        var i = 15 - 1
        while i >= 0 {
            let strImageName = "\("refresh_animation_")\(i)"
            fileNames.append(strImageName)
            i -= 1
        }
        let refreshImages = fileNames
        for obj in refreshImages  {
            if let image = UIImage(named: obj) {
            refreshAnimations.append(image)
            }
        }
        return refreshAnimations
    }()

    lazy var animtionImageView: UIImageView = {
        let image = UIImage(named: "pull_down_animeted_0")
        let animtionImageView = UIImageView(image: image)
        animtionImageView.sizeToFit()
        let ri: CGFloat = statusLabel.frame.origin.x - 10
        let bottom: CGFloat = XRefreshTotalLenght + 5.0
        let frame = CGRect(x: ri - animtionImageView.bounds.size.width, y: bottom - animtionImageView.bounds.size.height, width: animtionImageView.bounds.size.width, height: animtionImageView.bounds.size.height)
        animtionImageView.frame = frame
        return animtionImageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(statusLabel)
        addSubview(timeLabel)
        addSubview(animtionImageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func moveAnimationPercent(_ percent: CGFloat) {
        let drawingIndex = Int(percent) * (pullDownAnimations.count - 1)
        animtionImageView.image = pullDownAnimations[drawingIndex]
    }
    func startRefreshAnimation() {
        animtionImageView.stopAnimating()
        animtionImageView.animationImages = refreshAnimations
        animtionImageView.animationDuration = 1.0
        animtionImageView.animationRepeatCount = 0
        animtionImageView.startAnimating()
    }
    func resetAnimation() {
        var stopImages = [UIImage]()
        let count = pullDownAnimations.count - 1
        var i = Int(count)
        while i >= 0 {
            stopImages.append(pullDownAnimations[i])
            i -= 1
        }
        animtionImageView.stopAnimating()
        animtionImageView.animationImages = stopImages
        animtionImageView.animationDuration = 0.7
        animtionImageView.animationRepeatCount = 1
    }
}

class XRefreshFooterView: UIView {
    var mrefreshAction: refreshAction?
    //刷新操作提示
    lazy var statusLabel: UILabel = {
        let _statusLabel = UILabel(frame: CGRect(x: 135, y: (bounds.size.height - 14) * 0.5, width: 160, height: 14))
        _statusLabel.backgroundColor = UIColor.clear
        _statusLabel.font = UIFont.systemFont(ofSize: 14.0)
        _statusLabel.textColor = UIColor.gray
        return _statusLabel
    }()
    var refreshType: RefreshType = .normal
    var footerTop: CGFloat = 0.0 {
        didSet {
            var frame: CGRect = refreshButton.frame
            frame.origin.y = footerTop
            refreshButton.frame = frame
        }
    }
    private lazy var refreshButton: UIButton = {
        let refreshButton = UIButton(type: .custom)
        refreshButton.backgroundColor = UIColor.lightGray
        refreshButton.frame = CGRect(x: 0, y: 10, width: frame.size.width, height: 35)
        let border = CALayer()
        border.backgroundColor = UIColor.gray.cgColor
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 0.5)
        refreshButton.layer.addSublayer(border)
        refreshButton.addTarget(self, action: #selector(self.clickRefreshAction), for: .touchUpInside)
        refreshButton.layer.addSublayer(circleLayer)
        return refreshButton
    }()
    private lazy var circleLayer: CAShapeLayer = {
        let circleLayer = CAShapeLayer()
        circleLayer.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let center = CGPoint(x: circleLayer.frame.midX, y: circleLayer.frame.midY)
        let bezierPath = UIBezierPath(arcCenter: center, radius: 7, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI_2 * 2.7), clockwise: true)
        circleLayer.lineWidth = 1.0
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.red.cgColor
        circleLayer.path = bezierPath.cgPath
        return circleLayer
    }()


    @objc func clickRefreshAction() {
        self.mrefreshAction?()
    }
    func animation() {
        let animation1 = CABasicAnimation(keyPath: "strokeStart")
        animation1.duration = 1
        animation1.fromValue = 0.8
        animation1.toValue = 0.1
        animation1.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation1.fillMode = .forwards
        animation1.isRemovedOnCompletion = false
        let animation2 = CABasicAnimation(keyPath: "strokeStart")
        animation2.duration = 1
        animation2.fromValue = 0.1
        animation2.toValue = 0.8
        animation2.beginTime = animation1.duration
        animation2.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation2.fillMode = .forwards
        animation2.isRemovedOnCompletion = false
        let rotateAni = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAni.duration = 0.2
        rotateAni.isCumulative = true
        rotateAni.isRemovedOnCompletion = false
        rotateAni.fillMode = .forwards
        rotateAni.timingFunction = CAMediaTimingFunction(name: .linear)
//        rotateAni.toValue = .pi / 2
        rotateAni.repeatCount = MAXFLOAT
        circleLayer.add(rotateAni, forKey: "rotate")
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 2
        animationGroup.animations = [animation1, animation2]
        animationGroup.repeatCount = MAXFLOAT
        circleLayer.add(animationGroup, forKey: "groupAnimation")
    }
    func setRefreshType(_ refreshType: RefreshType) {
        self.refreshType = refreshType
        if self.refreshType == .loading {
            statusLabel.text = "正在加载数据..."
            statusLabel.sizeToFit()
            let kMaxWidth: CGFloat = circleLayer.frame.size.width + statusLabel.frame.size.width + 5
            var _frame: CGRect = circleLayer.frame
            _frame.origin.x = (refreshButton.frame.size.width - kMaxWidth) / 2
            _frame.origin.y = (refreshButton.frame.size.height - _frame.size.height) / 2
            circleLayer.frame = _frame
            let top: CGFloat = (refreshButton.frame.size.height - statusLabel.frame.size.height) / 2
            let `left`: CGFloat = _frame.origin.x + _frame.size.width + 5
            statusLabel.frame = CGRect(x: `left`, y: top, width: statusLabel.frame.size.width, height: statusLabel.frame.size.height)
            animation()
            refreshButton.isUserInteractionEnabled = false
        } else {
            circleLayer.removeAllAnimations()
            circleLayer.removeFromSuperlayer()
            switch refreshType {
            case .normal:
                statusLabel.text = "上拉显示更多数据"
                refreshButton.isUserInteractionEnabled = true
            case .notMore:
                statusLabel.text = "已经没有更多了"
                refreshButton.isUserInteractionEnabled = false
            case .fail:
                refreshButton.isUserInteractionEnabled = true
                statusLabel.text = "加载失败，点击重新加载"
            case .loosen:
                refreshButton.isUserInteractionEnabled = false
                statusLabel.text = "松开加载更多"
            case .notFullowup:
                refreshButton.isUserInteractionEnabled = false
                statusLabel.text = "暂无跟帖"
            default:
                statusLabel.text = "上拉显示更多数据"
            }
            statusLabel.sizeToFit()
            let top: CGFloat = (refreshButton.frame.size.height - statusLabel.frame.size.height) / 2
            let lef: CGFloat = (refreshButton.frame.size.width - statusLabel.frame.size.width) / 2
            statusLabel.frame = CGRect(x: lef, y: top, width: statusLabel.frame.size.width, height: statusLabel.frame.size.height)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(refreshButton)
        refreshButton.addSubview(statusLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class XRefreshControl: NSObject {
    lazy var refreshHeadView: XRefreshHeadView = {
        let refreshHeadView = XRefreshHeadView(frame: CGRect(x: 0, y: CGFloat((refreshViewLayerType == .onScrollViews ? -XRefreshTotalLenght : originalTopInset)), width: UIScreen.main.bounds.width, height: CGFloat(XRefreshTotalLenght)))
        refreshHeadView.backgroundColor = UIColor.clear
        return refreshHeadView
    }()
    lazy var refreshFooterView: XRefreshFooterView = {
        let refreshFooterView = XRefreshFooterView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 55))
        if footerHeight != 0 {
            refreshFooterView.footerTop = footerTop
            var frame: CGRect = refreshFooterView.frame
            frame.size.height = footerHeight
            refreshFooterView.frame = frame
        }
        if (scrollView is UITableView) {
            let tableView = scrollView as? UITableView
            if tableView?.style == .grouped {
                refreshFooterView.footerTop = 0
                var frame: CGRect = refreshFooterView.frame
                frame.size.height = 45
                refreshFooterView.frame = frame
            }
        }
        refreshFooterView.backgroundColor = UIColor.clear
        scrollView?.addSubview(refreshFooterView)
        refreshFooterView.mrefreshAction = {
            self.pullDownMoreLoading = true
            self.loadMoreState = .loading
        }
        return refreshFooterView
    }()
    var footerHeight: CGFloat = 0.0
    var footerTop: CGFloat = 0.0
    //*新加 上啦刷新页面类型控制
    var refreshFooterType: RefreshType = .normal {
        didSet {
            refreshFooterView.refreshType = refreshFooterType
//            setupFooterView()
        }
    }
    var refreshHeadPullDownRefreshing: PullDownRefreshing?
    weak var scrollView: UIScrollView!
    weak var delegate: XRefreshHeadControllerDelegate?
    var originalTopInset: CGFloat = 0.0
    var refreshState: XRefreshState = .normal
    var loadMoreState: CLLLoadMoreState = .normal
    lazy var refreshViewLayerType: XRefreshViewLayerType = {
        return self.delegate?.refreshViewLayerType() ?? .onSuperView
    }()
    var isPullDownRefreshed: Bool {
        set {
            isPullDownRefreshed = newValue
        }
        get {
            let hasHeaderView = delegate?.hasRefreshHeaderView()
            if hasHeaderView ?? false {
                if refreshHeadView == nil {
//                    setup()
                }
            } else {
                removeHeader()
            }
            return hasHeaderView ?? false
        }
    }


    var isPullUpLoadMore: Bool {
        set {
            isPullUpLoadMore = newValue
        }
        get {
            let hasFooterView = delegate?.hasRefreshFooterView()
            if hasFooterView ?? false {
//                    setupFooterView()
            } else {
                if refreshFooterView != nil && refreshFooterView.refreshType != .notMore && refreshFooterView.refreshType != .notFullowup {
                    var contentInset = scrollView.contentInset
                    contentInset.bottom = refreshFooterView.frame.size.height
                    scrollView.contentInset = contentInset
                    removeFooter()
                }
            }
            return hasFooterView ?? false
        }
    }
    var pullDownRefreshing = false
    var pullDownMoreLoading = false
    var isPauseMoreLoading = false
    var didAddObserveForRefresh = false
    func removeHeader() {
        refreshHeadView.removeFromSuperview()
//        refreshHeadView = nil
    }
    func removeFooter() {
        refreshFooterView.removeFromSuperview()
//        refreshFooterView = nil
    }
    //下拉刷新开始 <调用下拉刷新协议>
    func callBeginPullDownRefreshing() {
            delegate?.beginPullDownRefreshing()
            refreshHeadPullDownRefreshing?()
    }
    //上拉加载更多开始 <调用上拉加载更多协议>
    func callBeginPullUpLoading() {
            delegate?.beginPullUpLoading()
    }
    //手动停止下拉刷新
    func endPullDownRefreshing() {
        if isPullDownRefreshed {
            pullDownRefreshing = false
            refreshState = .stopped
//            resetScrollViewContentInset()
        }
    }
    //手动停止上拉
    func endPullUpLoading() {
        if !isPullUpLoadMore {
            refreshFooterView.removeFromSuperview()
        } else {
            refreshFooterType = .normal
        }
        pullDownMoreLoading = false
//        resetScrollViewContentInsetWithDoneLoadMore()
    }
    func notFullowup() {
        refreshFooterView.refreshType = .notFullowup
//        setupFooterView()
    }
    func notMoreHaveContent() {
        refreshFooterView.refreshType = .notMore
//        setupFooterView()
    }
    func footerRefreshFail() {
        refreshFooterView.refreshType = .fail
    }
    func resetFooterRefreshStatus() {
        refreshFooterView.refreshType = .normal
    }
    //手动开始上拉刷新
    func startPullUpRefreshing() {
        if isPullUpLoadMore && refreshFooterView != nil && !pullDownMoreLoading {
            pullDownMoreLoading = true
            loadMoreState = .loading
        }
    }
    //手动开始刷新
    func startPullDownRefreshing() {
        if isPullDownRefreshed {
            pullDownRefreshing = true
            refreshState = .pulling
            refreshState = .loading
            scrollView.contentOffset = CGPoint(x: 0, y: -XRefreshTotalLenght)
        }
    }
    //刷新动画
    func animationWithRefresh() {

        refreshHeadView.startRefreshAnimation()
        callBeginPullDownRefreshing()
    }
    // MARK: - Getter Method
    init(scrollView: UIScrollView, viewDelegate delegate: XRefreshHeadControllerDelegate) {
        super.init()
        setScrollView(scrollView, andDelegate: delegate)
    }
    func setScrollView(_ scrollView: UIScrollView, andDelegate delegate: XRefreshHeadControllerDelegate) {
        if scrollView == self.scrollView {
            return
        }
        self.delegate = delegate

        self.scrollView = scrollView

        isPauseMoreLoading = false
        setup()
    }
    func setupFooterView() {
        var tmpFrame: CGRect = refreshFooterView.frame
        tmpFrame.origin.y = scrollView.contentSize.height
        refreshFooterView.frame = tmpFrame
        var contentInset: UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = refreshFooterView.frame.size.height
        scrollView.contentInset = contentInset
        if refreshFooterView.refreshType != .notMore && refreshFooterView.refreshType != .notFullowup {
            loadMoreState = .normal
        }
    }
    func addPullDownRefreshBlock(_ refreshing: @escaping PullDownRefreshing) {
        refreshHeadPullDownRefreshing = refreshing
    }
    func setup() {
        originalTopInset = scrollView.contentInset.top
//        configuraObserver(with: scrollView)
        refreshHeadView.timeLabel.text = ""
        refreshHeadView.statusLabel.text = "下拉刷新"
        refreshState = .normal
        if refreshViewLayerType == .onSuperView {
            scrollView.backgroundColor = UIColor.clear
            if isPullDownRefreshed {
                scrollView.superview?.insertSubview(refreshHeadView, belowSubview: scrollView)
            }
        } else if refreshViewLayerType == .onScrollViews {
            if isPullDownRefreshed {
                scrollView.addSubview(refreshHeadView)
            }
        }
    }
    func resetScrollViewContentInset() {
        var contentInset: UIEdgeInsets = scrollView.contentInset
        contentInset.top = originalTopInset
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.contentInset = contentInset
        }) { finished in
            self.refreshState = .normal

            self.refreshHeadView.resetAnimation()
        }
    }
    // MARK: - SrollerView 上拉加载更多后的 重置
    func resetScrollViewContentInsetWithDoneLoadMore() {
        if refreshFooterView != nil {
            if refreshFooterView.refreshType != .notMore && refreshFooterView.refreshType != .fail && refreshFooterView.refreshType != .notFullowup {
                loadMoreState = .normal
            }
            perform(#selector(self.resetLock), with: nil, afterDelay: 0.5)
        }
    }
    @objc func resetLock() {
        isPauseMoreLoading = false
    }
    func setScrollViewContentInset(_ contentInset: UIEdgeInsets) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.scrollView?.contentInset = contentInset
        }) { finished in
            if self.refreshState == .stopped {
                self.refreshState = .normal
            }
        }
    }
    func setScrollViewContentInsetForLoading() {
        var currentInsets: UIEdgeInsets = scrollView.contentInset
        currentInsets.top = XRefreshTotalLenght
        setScrollViewContentInset(currentInsets)
    }
    func configuraObserver(with scrollView: UIScrollView?) {
        if didAddObserveForRefresh {
            return
        }
        didAddObserveForRefresh = true
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        scrollView?.addObserver(self, forKeyPath: "contentInset", options: .new, context: nil)
        scrollView?.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    func removeObserver(with scrollView: UIScrollView?) {
        if didAddObserveForRefresh {
            didAddObserveForRefresh = false
            scrollView?.removeObserver(self, forKeyPath: "contentOffset", context: nil)
            scrollView?.removeObserver(self, forKeyPath: "contentInset", context: nil)
            scrollView?.removeObserver(self, forKeyPath: "contentSize", context: nil)
        }
    }
    // MARK: -上拉
    func setLoadMoreState(_ loadMoreState: CLLLoadMoreState) {
        switch loadMoreState {
        case .stopped, .normal:
            //上拉加载更多
            if refreshFooterView.refreshType != .fail {
                refreshFooterView.refreshType = .normal
            }
        case .pulling:
            refreshFooterView.refreshType = .loosen
        case .loading:
            //加载中
            refreshFooterView.refreshType = .loading

            if pullDownMoreLoading {
                callBeginPullUpLoading()
                //                [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.frame.size.height) animated:YES];
            }
        default:
            break
        }
        self.loadMoreState = loadMoreState
        //如果是加载中，加载完重置为normal
        if loadMoreState == .loading {
            self.loadMoreState = .normal
        }
    }
    // MARK: -下拉
    func setRefreshState(_ refreshState: XRefreshState) {
        if refreshHeadView != nil {
            switch refreshState {
            case .stopped, .normal:
                refreshHeadView.statusLabel.text = "下拉刷新"
            case .loading:
                if pullDownRefreshing {
                    refreshHeadView.statusLabel.text = "正在加载"
                    setScrollViewContentInsetForLoading()
                    if self.refreshState == .pulling {
                        animationWithRefresh()
                    }
                }
            case .pulling:
                refreshHeadView.statusLabel.text = "释放立即刷新"
            default:
                break
            }
            self.refreshState = refreshState
        }
    }

    //是否支持 ios7 这里暂时不支持
    func getAdaptorHeight() -> CGFloat {
        return delegate?.keepiOS7NewApiCharacter() ?? false ? 64 : 0
    }

    // MARK: - KVO
    func observeValue(forKeyPath keyPath: String, of object: Any, change: [NSKeyValueChangeKey : Any], context: UnsafeMutableRawPointer) {
        if (keyPath == "contentOffset") {
            var contentOffset = (change[NSKeyValueChangeKey.newKey] as! CGPoint)
            if isPullDownRefreshed {
                // 下拉刷新的逻辑方法
                if refreshState != .loading {
                    //动画效果
                    var offset: CGFloat = -(scrollView.contentOffset.y)
                    if offset >= -5 && offset <= XRefreshTotalLenght + 5.0 {
                        var percent: CGFloat = 0
                        if offset < 0 {
                            offset = 0
                        }
                        if offset > CGFloat(XRefreshTotalLenght) {
                            offset = CGFloat(XRefreshTotalLenght)
                        }
                        percent = offset / CGFloat(XRefreshTotalLenght)
                        if refreshHeadView != nil {
                            refreshHeadView.moveAnimationPercent(percent)
                        }
                    }
                    var scrollOffsetThreshold: CGFloat
                    scrollOffsetThreshold = CGFloat(-(XRefreshTotalLenght + originalTopInset))
                    if !scrollView.isDragging && refreshState == .pulling {
                        pullDownRefreshing = true
                        refreshState = .loading
                    } else if contentOffset.y < scrollOffsetThreshold && scrollView.isDragging && refreshState == .stopped {
                        refreshState = .pulling
                    } else if contentOffset.y >= scrollOffsetThreshold && refreshState != .stopped {
                        refreshState = .stopped
                    }
                } else {
                    var offset: CGFloat
                    var contentInset: UIEdgeInsets!
                    offset = max(scrollView.contentOffset.y * -1, 0.0)
                    offset = min(offset, XRefreshTotalLenght)
                    contentInset = scrollView.contentInset
                    scrollView.contentInset = UIEdgeInsets(top: offset, left: contentInset.left, bottom: contentInset.bottom, right: contentInset.right)
                }
            }
            if isPullUpLoadMore && contentOffset.y > 0 && refreshFooterView.refreshType != .notMore && refreshFooterView.refreshType != .notFullowup {
                if loadMoreState != .loading && !isPauseMoreLoading && contentOffset.y != 0 && !pullDownMoreLoading {
                    let he = scrollView.bounds.size.height
                    contentOffset.y += he
                    let scrollOContentSizeHeight = scrollView.contentSize.height + 80.0
                    if !scrollView.isDragging && contentOffset.y > scrollOContentSizeHeight {
                        pullDownMoreLoading = true
                        loadMoreState = .loading
                        //下拉刷新上锁
                        isPauseMoreLoading = true
                    } else if scrollView.isDragging && contentOffset.y > scrollOContentSizeHeight && loadMoreState != .pulling && loadMoreState != .loading {
                        loadMoreState = .pulling
                    } else if scrollView.isDragging && contentOffset.y <= scrollOContentSizeHeight && refreshFooterView.refreshType != .fail && loadMoreState != .normal {
                        loadMoreState = .normal
                    }
                } else {
                    if pullDownMoreLoading && !isPullUpLoadMore {
                        var offset: CGFloat
                        var contentInset: UIEdgeInsets!
                        offset = 0
                        offset = max(offset, refreshFooterView.frame.size.height)
                        contentInset = scrollView.contentInset
                        scrollView.contentInset = UIEdgeInsets(top: contentInset.top, left: contentInset.left, bottom: offset, right: contentInset.right)
                    }
                }
            }
        } else if (keyPath == "contentInset") {
        } else if (keyPath == "contentSize") {
            let hasFooterView = isPullUpLoadMore
            if hasFooterView {
                var tmpFrame: CGRect = refreshFooterView.frame
                tmpFrame.origin.y = scrollView.contentSize.height
                refreshFooterView.frame = tmpFrame
            }
        }
    }
    deinit {
        delegate = nil
        removeObserver(with: scrollView)
        if refreshHeadView != nil{
            refreshHeadView.removeFromSuperview()
            refreshFooterView.removeFromSuperview()
        }
        if let anArchiver = classForKeyedArchiver {
            print("dealloc::\(anArchiver)")
        }
    }
    func removeAllObserver() {
        delegate = nil
        removeObserver(with: scrollView)
        refreshHeadView.removeFromSuperview()
        refreshFooterView.removeFromSuperview()
        if let anArchiver = classForKeyedArchiver {
            print("dealloc::\(anArchiver)")
        }
    }
}
