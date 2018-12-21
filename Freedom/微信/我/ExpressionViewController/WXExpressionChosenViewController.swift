//
//  WXExpressionChosenViewController.swift
//  Freedom

import Foundation

protocol WXExpressionCellDelegate: NSObjectProtocol {
    func expressionCellDownloadButtonDown(_ group: TLEmojiGroup)
}

class WXExpressionCell: WXTableViewCell {
    weak var delegate: WXExpressionCellDelegate
    var group: TLEmojiGroup
    private var iconImageView: UIImageView
    private var titleLabel: UILabel
    private var detailLabel: UILabel
    private var tagView: UIImageView
    private var downloadButton: UIButton

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        if let aView = iconImageView {
            contentView.addSubview(aView)
        }
        if let aLabel = titleLabel {
            contentView.addSubview(aLabel)
        }
        if let aLabel = detailLabel {
            contentView.addSubview(aLabel)
        }
        if let aView = tagView {
            contentView.addSubview(aView)
        }
        if let aButton = downloadButton {
            contentView.addSubview(aButton)
        }

        p_addMasonry()

    }
    func setGroup(_ group: TLEmojiGroup) {
        self.group = group
        let image = UIImage(named: group.groupIconPath)
        if image != nil {
            iconImageView.image = image
        } else {
            iconImageView.sd_setImage(with: URL(string: group.groupIconURL))
        }
        titleLabel.text = group.groupName
        detailLabel.text = group.groupDetailInfo

        if group.status == TLEmojiGroupStatusDownloaded {
            downloadButton.setTitle("已下载", for: .normal)
            downloadButton.layer.borderColor = UIColor.gray.cgColor
            downloadButton.setTitleColor(UIColor.gray, for: .normal)
        } else if group.status == TLEmojiGroupStatusDownloading {
            downloadButton.setTitle("下载中", for: .normal)
            downloadButton.layer.borderColor = UIColor.green.cgColor
            downloadButton.setTitleColor(UIColor.green, for: .normal)
        } else {
            downloadButton.setTitle("下载", for: .normal)
            downloadButton.layer.borderColor = UIColor.green.cgColor
            downloadButton.setTitleColor(UIColor.green, for: .normal)
        }
    }
    func p_addMasonry() {
        iconImageView.mas_makeConstraints({ make in
            make.left.mas_equalTo(self.contentView).mas_offset(15)
            make.top.mas_equalTo(self.contentView).mas_offset(10)
            make.bottom.mas_equalTo(self.contentView).mas_offset(-10)
            make.width.mas_equalTo(self.iconImageView.mas_height)
        })
        titleLabel.mas_makeConstraints({ make in
            make.bottom.mas_equalTo(self.iconImageView.mas_centerY).mas_offset(-2.0)
            make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(13.0)
            make.right.mas_lessThanOrEqualTo(self.downloadButton.mas_left).mas_offset(-15)
        })
        detailLabel.mas_makeConstraints({ make in
            make.top.mas_equalTo(self.iconImageView.mas_centerY).mas_offset(5.0)
            make.left.mas_equalTo(self.titleLabel)
            make.right.mas_lessThanOrEqualTo(self.downloadButton.mas_left).mas_offset(-15)
        })
        tagView.mas_makeConstraints({ make in
            make.left.and().top().mas_equalTo(self.contentView)
        })
        downloadButton.mas_makeConstraints({ make in
            make.right.mas_equalTo(self.contentView).mas_offset(-15)
            make.centerY.mas_equalTo(self.contentView)
            make.size.mas_equalTo(CGSize(width: 60, height: 26))
        })
    }
    func downloadButtonDown(_ sender: UIButton) {
        if group.status == TLEmojiGroupStatusUnDownload {
            group.status = TLEmojiGroupStatusDownloading
            self.group = group
            if delegate && delegate.responds(to: #selector(self.expressionCellDownloadButtonDown(_:))) {
                delegate.expressionCellDownloadButtonDown(group)
            }
        }
    }

    func iconImageView() -> UIImageView {
        if iconImageView == nil {
            iconImageView = UIImageView()
            iconImageView.backgroundColor = UIColor.clear
            iconImageView.layer.masksToBounds = true
            iconImageView.layer.cornerRadius = 5.0
        }
        return iconImageView
    }

    var titleLabel: UILabel {
        if titleLabel == nil {
            titleLabel = UILabel()
            titleLabel.font = UIFont.systemFont(ofSize: 16.0)
        }
        return titleLabel
    }

    func detailLabel() -> UILabel {
        if detailLabel == nil {
            detailLabel = UILabel()
            detailLabel.font = UIFont.systemFont(ofSize: 13.0)
            detailLabel.textColor = UIColor.gray
        }
        return detailLabel
    }
    func tagView() -> UIImageView {
        if tagView == nil {
            tagView = UIImageView()
            tagView.image = UIImage(named: "icon_corner_new")
            tagView.hidden = true
        }
        return tagView
    }

    func downloadButton() -> UIButton {
        if downloadButton == nil {
            downloadButton = UIButton()
            downloadButton.setTitle("下载", for: .normal)
            downloadButton.titleLabel.font = UIFont.systemFont(ofSize: 14.0)
            downloadButton.setTitleColor(UIColor.green, for: .normal)
            downloadButton.layer.masksToBounds = true
            downloadButton.layer.cornerRadius = 3.0
            downloadButton.layer.borderWidth = 1.0
            downloadButton.layer.borderColor = UIColor.green.cgColor
            downloadButton.addTarget(self, action: #selector(self.downloadButtonDown(_:)), for: .touchUpInside)
        }
        return downloadButton
    }



}

protocol WXExpressionBannerCellDelegate: NSObjectProtocol {
    func expressionBannerCellDidSelectBanner(_ item: Any)
}

class WXExpressionBannerCell: WXTableViewCell,WXPictureCarouselDelegate {
    weak var delegate: WXExpressionBannerCellDelegate
    var data: [Any] = []

    private var picCarouselView: WXPictureCarouselView

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setBottomLineStyle(TLCellLineStyleNone)
        selectionStyle = .none
        if let aView = picCarouselView {
            contentView.addSubview(aView)
        }

        p_addMasonry()

    }

    func setData(_ data: [Any]) {
        _data = data
        picCarouselView.data = data
    }
    func pictureCarouselView(_ pictureCarouselView: WXPictureCarouselView, didSelectItem model: WXPictureCarouselProtocol) {
        if delegate && delegate.responds(to: #selector(self.expressionBannerCellDidSelectBanner(_:))) {
            delegate.expressionBannerCellDidSelectBanner(model)
        }
    }

    // MARK: -
    func p_addMasonry() {
        picCarouselView().mas_makeConstraints({ make in
            make.edges.mas_equalTo(self.contentView)
        })
    }

    // MARK: -
    func picCarouselView() -> WXPictureCarouselView {
        if picCarouselView == nil {
            picCarouselView = WXPictureCarouselView()
            picCarouselView.delegate = self
        }
        return picCarouselView
    }

}

class WXExpressionChosenViewController: WXTableViewController, WXExpressionCellDelegate, WXExpressionBannerCellDelegate,UISearchBarDelegate {
    var kPageIndex: Int = 0

    var data: [AnyHashable] = []
    var bannerData: [Any] = []
    var proxy: WXExpressionHelper


    private var searchController: WXSearchController
    private var searchVC: WXExpressionSearchViewController
    func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        tableView.frame = CGRect(x: 0, y: Int(TopHeight) + 20, width: APPW, height: APPH - 20 - Int(TopHeight))
        tableView.backgroundColor = UIColor.white
        tableView.tableHeaderView = searchController.searchBar

        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.loadMoreData))
        footer.setTitle("正在加载...", for: MJRefreshStateRefreshing)
        footer.setTitle("", for: MJRefreshStateNoMoreData)
        tableView.setMj_footer(footer)

        registerCells(for: tableView)
        loadData(withLoadingView: true)
    }

    func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SVProgressHUD.dismiss()
    }
    func proxy() -> WXExpressionHelper {
        if proxy == nil {
            proxy = WXExpressionHelper.shared()
        }
        return proxy
    }

    var searchController: UISearchController {
        if searchController == nil {
            searchController = WXSearchController(searchResultsController: searchVC())
            searchController.searchResultsUpdater = searchVC()
            searchController.searchBar.placeholder = "搜索表情"
            searchController.searchBar.delegate = searchVC()
        }
        return searchController
    }

    func searchVC() -> WXExpressionSearchViewController {
        if searchVC == nil {
            searchVC = WXExpressionSearchViewController()
        }
        return searchVC
    }
    func loadData(withLoadingView showLoadingView: Bool) {
        if showLoadingView {
            SVProgressHUD.show()
        }
        kPageIndex = 1
        weak var weakSelf = self
        proxy.requestExpressionChosenList(byPageIndex: kPageIndex, success: { data in
            SVProgressHUD.dismiss()
            kPageIndex += 1
            weakSelf.data = [AnyHashable]()
            for group: TLEmojiGroup in data as! [TLEmojiGroup] {
                // 优先使用本地表情
                let localEmojiGroup: TLEmojiGroup = WXExpressionHelper.shared().emojiGroup(byID: group.groupID)
                if localEmojiGroup != nil {
                    if let aGroup = localEmojiGroup {
                        self.data.append(aGroup)
                    }
                } else {
                    if let aGroup = group {
                        self.data.append(aGroup)
                    }
                }
            }
            weakSelf.tableView.reloadData()

        }, failure: { error in
            SVProgressHUD.dismiss()
        })

        proxy.requestExpressionChosenBannerSuccess({ data in
            self.bannerData = data
            self.tableView.reloadData()
        }, failure: { error in

        })
    }
    
    func loadMoreData() {
        weak var weakSelf = self
        proxy.requestExpressionChosenList(byPageIndex: kPageIndex, success: { data in
            SVProgressHUD.dismiss()
            if data.count == 0 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            } else {
                self.tableView.mj_footer.endRefreshing()
                kPageIndex += 1
                for group: TLEmojiGroup in data as [TLEmojiGroup]  [] {
                    // 优先使用本地表情
                    let localEmojiGroup: TLEmojiGroup = WXExpressionHelper.shared().emojiGroup(byID: group.groupID)
                    if localEmojiGroup != nil {
                        if let aGroup = localEmojiGroup {
                            self.data.append(aGroup)
                        }
                    } else {
                        if let aGroup = group {
                            self.data.append(aGroup)
                        }
                    }
                }
                weakSelf.tableView.reloadData()
            }
        }, failure: { error in
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
            SVProgressHUD.dismiss()
        })
    }
    func registerCells(for tableView: UITableView) {
        tableView.register(WXExpressionBannerCell.self, forCellReuseIdentifier: "TLExpressionBannerCell")
        tableView.register(WXExpressionCell.self, forCellReuseIdentifier: "TLExpressionCell")
    }

    // MARK: -
    func numberOfSections(in tableView: UITableView) -> Int {
        return bannerData.count > 0  2 : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return bannerData.count > 0  1 : data.count
        } else if section == 1 {
            return data.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && bannerData.count > 0 {
            let bannerCell = tableView.dequeueReusableCell(withIdentifier: "TLExpressionBannerCell") as WXExpressionBannerCell
            bannerCell.data = bannerData
            bannerCell.delegate = self
            return bannerCell!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "TLExpressionCell") as WXExpressionCell
        let group: TLEmojiGroup = data[indexPath.row]
        cell.group = group
        cell.delegate = self
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0 && bannerData.count == 0) || indexPath.section == 1 {
            let group = data[indexPath.row] as TLEmojiGroup
            let detailVC = WXExpressionDetailViewController()
            detailVC.group = group
            parent.hidesBottomBarWhenPushed = true
            parent.navigationController.pushViewController(detailVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return bannerData.count > 0  140 : 80
        } else if indexPath.section == 1 {
            return 80
        }
        return 0
    }

    //MARK: TLExpressionBannerCellDelegate
    func expressionBannerCellDidSelectBanner(_ item: Any) {
        let detailVC = WXExpressionDetailViewController()
        detailVC.group = item
        parent.hidesBottomBarWhenPushed = true
        parent.navigationController.pushViewController(detailVC, animated: true)
    }
    func expressionCellDownloadButtonDown(_ group: TLEmojiGroup) {
        group.status = TLEmojiGroupStatusDownloading
        proxy.requestExpressionGroupDetail(byGroupID: group.groupID, pageIndex: 1, success: { data in
            group.data = data
            WXExpressionHelper.shared().downloadExpressions(withGroupInfo: group, progress: { progress in

            }, success: { group in
                group.status = TLEmojiGroupStatusDownloaded
                var index: Int = nil
                if let aGroup = group {
                    index = self.data.index(of: aGroup)
                }
                if (index) < self.data.count {
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 1)], with: .none)
                }
                let ok = WXExpressionHelper.shared().addExpressionGroup(group)
                if !ok {
                    if let aName = group.groupName {
                        SVProgressHUD.showError(withStatus: "表情 \(aName) 存储失败！")
                    }
                }
            }, failure: { group, error in

            })
        }, failure: { error in
            if let aName = group.groupName {
                SVProgressHUD.showError(withStatus: "\"\(aName)\" 下载失败: \(error)")
            }
        })
    }


}
