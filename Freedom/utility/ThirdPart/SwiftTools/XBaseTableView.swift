//
//  XBaseTableView.swift
import UIKit
protocol XBaseTableViewDelegate: UITableViewDelegate, UITableViewDataSource {
    ///网络请求结束more代表是否还有更多completion要在reloadData之前做
    func refresh(_ refresh: Bool, loadMorePage page: Int, completion: @escaping (_ more: Bool) -> Bool)
}

class XBaseTableView: UITableView, XRefreshHeadControllerDelegate {
    var page: Int = 0
    var emptyView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    var isRefreshOnTop = false
    weak var baseDelegate: XBaseTableViewDelegate? {
        didSet {
            delegate = baseDelegate
            dataSource = baseDelegate
        }
    }
    lazy var refreshController: XRefreshControl = {
        return XRefreshControl(scrollView: self, viewDelegate: self)
    }()

    private var secondReload = false

    convenience init(frame: CGRect) {
        self.init(frame: frame, style: .plain)
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0.01))
        tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0.5))
        page = 0
        emptyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(XBaseTableView.startRefresh)))
        emptyView.isHidden = true
        addSubview(emptyView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func startRefresh() {
        refreshController.startPullDownRefreshing()
    }

    override func reloadData() {
        let num: Int? = dataSource?.tableView(self, numberOfRowsInSection: 0)
        if (num ?? 0) > 14 {

        }
        if dataSource != nil && (num ?? 0) > 0 {
            emptyView.isHidden = true
        } else if false {
            //![UNUtilHelper isNetWorkReachable]
            emptyView.isHidden = false
            bringSubviewToFront(emptyView)
        } else if page > 0 && secondReload {
            //        self.emptyView.titilLabel.text = @"暂无数据哦~";
            emptyView.isHidden = false
            bringSubviewToFront(emptyView)
            if let aView = tableHeaderView {
                bringSubviewToFront(aView)
            }
        }
        secondReload = true
        super.reloadData()
    }

    func beginPullDownRefreshing() {
        page = 0
        loadMore(withRefresh: true)
    }

    func beginPullUpLoading() {
        loadMore(withRefresh: false)
    }
    func loadMore(withRefresh refresh: Bool) {
        if false {
            //![UNUtilHelper isNetWorkReachable]
            print("网络异常!")
            DispatchQueue.main.async(execute: {
                self.refreshController.endPullDownRefreshing()
                self.refreshController.endPullUpLoading()
            })
        } else if baseDelegate != nil {
            page += 1
            baseDelegate?.refresh(refresh, loadMorePage: page) { more in
                self.refreshController.endPullDownRefreshing()
                self.refreshController.endPullUpLoading()
                let num: Int? = self.dataSource?.tableView(self, numberOfRowsInSection: 0)
                if !more && (num ?? 0) > 0 && self.hasRefreshFooterView() {
                    //&& !refresh
                    self.refreshController.notMoreHaveContent()
                }
                return true //停止成功
            }
        } else {
            DispatchQueue.main.async(execute: {
                self.refreshController.endPullDownRefreshing()
                self.refreshController.endPullUpLoading()
            })
        }
    }

    func refreshViewLayerType() -> XRefreshViewLayerType {
        if isRefreshOnTop {
            return .onScrollViews
        } else {
            return .onSuperView
        }
    }

    func keepiOS7NewApiCharacter() -> Bool {
        return true
    }

    func hasRefreshHeaderView() -> Bool {
        return true
    }
    func hasRefreshFooterView() -> Bool{
        return true
    }

    override func removeFromSuperview() {
        super.removeFromSuperview()
        if Float(UIDevice.current.systemVersion) ?? 0.0 < 11.0 {
            refreshController.removeAllObserver()
        }
    }
    deinit {
    }
}
