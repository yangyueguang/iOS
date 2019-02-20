//
//  WXExpressionPublicViewController.swift
//  Freedom
import SnapKit
import MJRefresh
import XCarryOn
import XExtension
import Foundation
class WXExpressionPublicCell: UICollectionViewCell {
    var group: TLEmojiGroup = TLEmojiGroup() {
        didSet {
            titleLabel.text = group.groupName
            let image = group.groupIconPath.image
            if image != nil {
                imageView.image = image
            } else {
                imageView.sd_setImage(with: URL(string: group.groupIconURL), placeholderImage: UIImage.imageWithColor(UIColor.light))
            }
        }
    }
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5.0
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.grayx.cgColor
        return imageView
    }()
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.small
        return titleLabel
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        imageView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self.contentView)
            make.height.equalTo(self.imageView.snp.width)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(self.imageView.snp.bottom).offset(7)
            make.width.lessThanOrEqualTo(self.contentView)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
class WXExpressionPublicViewController: WXBaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    var collectionView: BaseCollectionView!
    var kPageIndex: Int = 0
    var data: [TLEmojiGroup] = []
    var proxy = WXExpressionHelper.shared
    lazy var searchController: WXSearchController = {
        let searchController = WXSearchController(searchResultsController: searchVC)
        searchController.searchResultsUpdater = searchVC
        searchController.searchBar.placeholder = "搜索表情"
        searchController.searchBar.delegate = self
        return searchController
    }()
    var searchVC = WXExpressionSearchViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        let layout = UICollectionViewFlowLayout()
        let rect = CGRect(x: 0, y: TopHeight + 20, width: APPW, height: APPH - TopHeight - 20)
        collectionView = BaseCollectionView(frame: rect, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.whitex
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.whitex
        //    [self.collectionView setTableHeaderView:self.searchController.searchBar];
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.loadMoreData))
        footer?.setTitle("正在加载...", for: .refreshing)
        footer?.setTitle("", for: .noMoreData)
        collectionView.mj_footer = (footer)
        collectionView.register(WXExpressionPublicCell.self, forCellWithReuseIdentifier: WXExpressionPublicCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.identifier)
        loadData(withLoadingView: true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        XHud.hide()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count == 0 ? 1 : data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < data.count {
            let cell = collectionView.dequeueCell(WXExpressionPublicCell.self, for: indexPath)
            let emojiGroup = data[indexPath.row] as TLEmojiGroup
            cell.group = emojiGroup
            return cell
        }
        return collectionView.dequeueCell(UICollectionViewCell.self, for: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < data.count {
            let group = data[indexPath.row] as TLEmojiGroup
            let detailVC = WXExpressionDetailViewController()
            detailVC.group = group
            parent?.navigationController?.pushViewController(detailVC, animated: true)
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
        return data.count == 0 ? 0 : 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return data.count == 0 ? 0 : 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return data.count == 0 ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) : UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }

    func loadData(withLoadingView showLoadingView: Bool) {
        if showLoadingView {
            XHud.show()
        }
        kPageIndex = 1
        XNetKit.kit.requestExpressionPublicList(byPageIndex: kPageIndex, success: { data in
            XHud.hide()
            self.kPageIndex += 1
            for group: TLEmojiGroup in data {
                // 优先使用本地表情
                let localEmojiGroup = WXExpressionHelper.shared.emojiGroup(byID: group.groupID)
                if let localEmojiGroup = localEmojiGroup {
                    self.data.append(localEmojiGroup)
                } else {
                    self.data.append(group)
                }
            }
            self.collectionView.reloadData()
        }, failure: { error in
            XHud.hide()
        })
    }

    func loadMoreData() {
        XNetKit.kit.requestExpressionPublicList(byPageIndex: kPageIndex, success: { data in
            XHud.hide()
            if data.count == 0 {
                self.collectionView.mj_footer.endRefreshingWithNoMoreData()
            } else {
                self.collectionView.mj_footer.endRefreshing()
                self.kPageIndex += 1
                for group: TLEmojiGroup in data {
                    // 优先使用本地表情
                    let localEmojiGroup = WXExpressionHelper.shared.emojiGroup(byID: group.groupID)
                    if let localEmojiGroup = localEmojiGroup {
                        self.data.append(localEmojiGroup)
                    } else {
                        self.data.append(group)
                    }
                }
                self.collectionView.reloadData()
            }
        }, failure: { error in
            self.collectionView.mj_footer.endRefreshingWithNoMoreData()
            XHud.hide()
        })
    }
}
