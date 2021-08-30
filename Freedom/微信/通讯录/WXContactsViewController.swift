//
//  WXContactsViewController.swift
//  Freedom
import SnapKit
//import XCarryOn
import Foundation
class WechatContactCell: BaseTableViewCell<WechatContact> {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    override func initUI() {
        viewModel.subscribe(onNext: { [weak self](contact) in
            guard let `self` = self else { return }
            if !contact.avatarPath.isEmpty {
                let path = FileManager.pathContactsAvatar(contact.avatarPath)
                self.iconImageView.image = path.image
            } else {
                self.iconImageView.kf.setImage(with: URL(string: contact.avatarURL))
            }
            self.titleLabel.text = contact.name
            self.subTitleLabel.text = contact.tel
            if contact.status == .stranger {
                self.rightButton.backgroundColor = UIColor.greenx
                self.rightButton.setTitle("添加", for: .normal)
                self.rightButton.setTitleColor(UIColor.whitex, for: .normal)
                self.rightButton.layer.borderColor = UIColor(white: 0.7, alpha: 1.0).cgColor
            } else {
                self.rightButton.backgroundColor = UIColor.clear
                self.rightButton.setTitleColor(UIColor.grayx, for: .normal)
                self.rightButton.layer.borderColor = UIColor.clear.cgColor
                if contact.status == .friend {
                    self.rightButton.setTitle("已添加", for: .normal)
                } else if contact.status == .wait {
                    self.rightButton.setTitle("等待验证 ", for: .normal)
                }
            }
        }).disposed(by: disposeBag)
    }
}

final class WXContactsSearchViewController: BaseTableViewController, UISearchResultsUpdating {
    var contactsData: [WechatContact] = []
    private var data: [WechatContact] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(WechatContactCell.self, forCellReuseIdentifier: WechatContactCell.identifier)
        automaticallyAdjustsScrollViewInsets = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: TopHeight + 20.0, width: tableView.frame.size.width, height: APPH - tableView.frame.origin.y)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(WechatContactCell.self)
        let contact = data[indexPath.row]
        cell.viewModel.onNext(contact)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text?.lowercased() ?? ""
        data.removeAll()
        for contact: WechatContact in contactsData {
            if contact.name.contains(searchText) || contact.name.pinyin().contains(searchText) || contact.name.firstLetter().contains(searchText) {
                data.append(contact)
            }
        }
        tableView.reloadData()
    }
}

final class WXContactsViewController: BaseTableViewController, UISearchBarDelegate {
    var contactsData: [WechatContact] = []// 通讯录好友（初始数据）
    var data: [WXUserGroup] = []// 通讯录好友（格式化的列表数据）
    var headers: [String] = []// 通讯录好友索引
    var searchVC = WXContactsSearchViewController()
    private lazy var searchController: WXSearchController = {
        let searchController = WXSearchController(searchResultsController: searchVC)
        searchController.searchResultsUpdater = searchVC
        searchController.searchBar.placeholder = "搜索"
        searchController.searchBar.delegate = self
        return searchController
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "通讯录朋友"
        view.backgroundColor = UIColor.whitex
        tableView.sectionIndexBackgroundColor = UIColor.clear
        tableView.sectionIndexColor = UIColor.back
        tableView.tableHeaderView = searchController.searchBar
        tableView.register(WXFriendHeaderView.self, forHeaderFooterViewReuseIdentifier: WXFriendHeaderView.identifier)
        tableView.register(WechatContactCell.self, forCellReuseIdentifier: WechatContactCell.identifier)
        XHud.show(.withDetail(message: "加载中"))
        WXFriendHelper.trytoGetAllContacts(success: { data, formatData, headers in
            XHud.hide()
            self.data = formatData
            self.contactsData = data
            self.headers = headers
            self.tableView.reloadData()
            MobClick.event("e_get_contacts")
        }, failed: {
            XHud.hide()
            self.noticeError("未成功获取到通讯录信息")
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        XHud.hide()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = data[section]
        return Int(group.users.count)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(WechatContactCell.self)
        return cell
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        let group = data[section] as WXUserGroup
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TLFriendHeaderView") as! WXFriendHeaderView
        view.title = group.groupName
        return view
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String] {
        return headers
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22.0
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchVC.contactsData = contactsData
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
}
