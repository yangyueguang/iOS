//
//  WXExpressionPublicViewController.swift
//  Freedom

import Foundation
class WXExpressionPublicCell: UICollectionViewCell {
    var group: TLEmojiGroup
    var imageView: UIImageView
    var titleLabel: UILabel

    override init(frame: CGRect) {
        //if super.init(frame: frame)

        if let aView = imageView {
            contentView.addSubview(aView)
        }
        if let aLabel = titleLabel {
            contentView.addSubview(aLabel)
        }
        p_addMasonry()

    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func setGroup(_ group: TLEmojiGroup) {
        self.group = group
        titleLabel.text = group.groupName
        let image = UIImage(named: group.groupIconPath  "")
        if image != nil {
            imageView.image = image
        } else {
            imageView.sd_setImage(with: URL(string: group.groupIconURL  ""), placeholderImage: FreedomTools(color: UIColor.lightGray))
        }
    }

    // MARK: - Private Methods
    func p_addMasonry() {
        imageView.mas_makeConstraints({ make in
            make.left.and().top().and().right().mas_equalTo(self.contentView)
            make.height.mas_equalTo(self.imageView.mas_width)
        })
        titleLabel.mas_makeConstraints({ make in
            make.centerX.mas_equalTo(self.contentView)
            make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(7.0)
            make.width.mas_lessThanOrEqualTo(self.contentView)
        })
    }
    var imageView: UIImageView {
        if imageView == nil {
            imageView = UIImageView()
            imageView.isUserInteractionEnabled = false
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 5.0
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = UIColor.gray.cgColor
        }
        return imageView
    }

    var titleLabel: UILabel {
        if titleLabel == nil {
            titleLabel = UILabel()
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 12.0)
        }
        return titleLabel
    }


}
class WXExpressionPublicViewController: WXBaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    var kPageIndex: Int = 0

    var data: [AnyHashable] = []
    var proxy: WXExpressionHelper
    var searchController: WXSearchController
    var searchVC: WXExpressionSearchViewController
    var collectionView: UICollectionView

    func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false

        let layout = UICollectionViewFlowLayout()
        let rect = CGRect(x: 0, y: Int(TopHeight) + 20, width: APPW, height: Int(APPH - TopHeight) - 20)
        collectionView = UICollectionView(frame: rect, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true

        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.white
        //    [self.collectionView setTableHeaderView:self.searchController.searchBar];

        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.loadMoreData))
        footer.setTitle("正在加载...", for: MJRefreshStateRefreshing)
        footer.setTitle("", for: MJRefreshStateNoMoreData)
        collectionView.setMj_footer(footer)

        registerCell(for: collectionView)
        loadData(withLoadingView: true)
    }
    func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SVProgressHUD.dismiss()
    }

    // MARK: - Delegate
    //MARK: UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }

    // MARK: - Getter
    var searchController: UISearchController {
        if searchController == nil {
            searchController = WXSearchController(searchResultsController: searchVC)
            searchController.searchResultsUpdater = searchVC
            searchController.searchBar.placeholder = "搜索表情"
            searchController.searchBar.delegate = self
        }
        return searchController
    }
    func searchVC() -> WXExpressionSearchViewController {
        if searchVC == nil {
            searchVC = WXExpressionSearchViewController()
        }
        return searchVC
    }

    func proxy() -> WXExpressionHelper {
        if proxy == nil {
            proxy = WXExpressionHelper.shared()
        }
        return proxy
    }

    func registerCell(for collectionView: UICollectionView) {
        collectionView.register(WXExpressionPublicCell.self, forCellWithReuseIdentifier: "TLExpressionPublicCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "EmptyCell")
    }

    // MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count == 0  1 : data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < data.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TLExpressionPublicCell", for: indexPath) as WXExpressionPublicCell
            let emojiGroup = data[indexPath.row] as TLEmojiGroup
            cell.group = emojiGroup
            return cell!
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < data.count {
            let group = data[indexPath.row] as TLEmojiGroup
            let detailVC = WXExpressionDetailViewController()
            detailVC.group = group
            parent.hidesBottomBarWhenPushed = true
            parent.navigationController.pushViewController(detailVC, animated: true)
        }
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row < data.count {
            return CGSize(width: (APPW - 20 * 2 - 20 * 2.0) / 3.0, height: ((APPW - 20 * 2 - 20 * 2.0) / 3.0) + 20)
        }
        return collectionView.bounds.size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return data.count == 0  0 : 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return data.count == 0  0 : 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return data.count == 0  UIEdgeInsetsMake(0, 0, 0, 0) : UIEdgeInsetsMake(20, 20, 20, 20)
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func loadData(withLoadingView showLoadingView: Bool) {
        if showLoadingView {
            SVProgressHUD.show()
        }
        kPageIndex = 1
        weak var weakSelf = self
        proxy.requestExpressionPublicList(byPageIndex: kPageIndex, success: { data in
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
            weakSelf.collectionView.reloadData()
        }, failure: { error in
            SVProgressHUD.dismiss()
        })
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func loadMoreData() {
        weak var weakSelf = self
        proxy.requestExpressionPublicList(byPageIndex: kPageIndex, success: { data in
            SVProgressHUD.dismiss()
            if data.count == 0 {
                self.collectionView.mj_footer.endRefreshingWithNoMoreData()
            } else {
                self.collectionView.mj_footer.endRefreshing()
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
                weakSelf.collectionView.reloadData()
            }
        }, failure: { error in
            self.collectionView.mj_footer.endRefreshingWithNoMoreData()
            SVProgressHUD.dismiss()
        })
    }    
}
