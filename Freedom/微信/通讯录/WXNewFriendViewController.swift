//
//  WXNewFriendViewController.swift
//  Freedom

import Foundation
protocol WXAddThirdPartFriendCellDelegate: NSObjectProtocol {
    func addThirdPartFriendCellDidSelectedType(_ type: TLThirdPartType)
}
class WXAddThirdPartFriendCell: WXTableViewCell {
    weak var delegate: WXAddThirdPartFriendCellDelegate?
    var lastItem: WXAddThirdPartFriendItem?
    var thridPartItems: [WXAddThirdPartFriendItem] = [] {
        didSet {
            for v: UIView in contentView.subviews {
                v.removeFromSuperview()
            }
            for i in 0..<thridPartItems.count {
                let keyStr = thridPartItems[i].itemType
                let item = itemsDic[keyStr.rawValue]
                if let anItem = item {
                    contentView.addSubview(anItem)
                }
                item?.snp.remakeConstraints({ (make) in
                    make.top.bottom.equalTo(self.contentView)
                })
                if i==0{
                    item?.snp.updateConstraints({ (make) in
                        make.left.equalTo(self.contentView)
                    })
                }else{
                    item?.snp.updateConstraints({ (make) in
                        make.left.equalTo(lastItem?.snp.right ?? 0)
                        make.width.equalTo(lastItem ?? 0)
                    })
                }
                if i == self.thridPartItems.count - 1 {
                    item?.snp.updateConstraints({ (make) in
                        make.right.equalTo(self.contentView)
                    })
                }
                lastItem = item
            }
            setNeedsDisplay()
        }
    }
    private var itemsDic: [String : WXAddThirdPartFriendItem] = [:]
    private lazy var contacts: WXAddThirdPartFriendItem = {
        let contacts = WXAddThirdPartFriendItem(imagePath: "newFriend_contacts", andTitle: "添加手机联系人")
        contacts.itemType = .contacts
        contacts.addTarget(self, action: #selector(self.itemButtonDown(_:)), for: .touchUpInside)
        return contacts
    }()
    private lazy var qq: WXAddThirdPartFriendItem = {
        let qq = WXAddThirdPartFriendItem(imagePath: "newFriend_qq", andTitle: "添加QQ好友")
        qq.itemType = .QQ
        qq.addTarget(self, action: #selector(self.itemButtonDown(_:)), for: .touchUpInside)
        return qq
    }()
    private lazy var google: WXAddThirdPartFriendItem = {
        let google = WXAddThirdPartFriendItem(imagePath: "newFriend_google", andTitle: "添加Google好友")
        google.itemType = .google
        google.addTarget(self, action: #selector(self.itemButtonDown(_:)), for: .touchUpInside)
        return google
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        bottomLineStyle = .fill
        itemsDic = [TLThirdPartType.contacts.rawValue: contacts, TLThirdPartType.QQ.rawValue: qq, TLThirdPartType.google.rawValue: google]
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(0.5)
        context.setStrokeColor(UIColor.gray.cgColor)
        context.beginPath()
        if thridPartItems.count == 2 {
            context.move(to: CGPoint(x: frame.size.width / 2.0, y: 0))
            context.addLine(to: CGPoint(x: frame.size.width / 2.0, y: frame.size.height))
        } else if thridPartItems.count == 3 {
            context.move(to: CGPoint(x: frame.size.width / 3.0, y: 0))
            context.addLine(to: CGPoint(x: frame.size.width / 3.0, y: frame.size.height))
            context.move(to: CGPoint(x: frame.size.width / 3.0 * 2, y: 0))
            context.addLine(to: CGPoint(x: frame.size.width / 3.0 * 2, y: frame.size.height))
        }
        context.strokePath()
    }
    @objc func itemButtonDown(_ item: WXAddThirdPartFriendItem) {
        delegate?.addThirdPartFriendCellDidSelectedType(item.itemType)
    }
}
class WXNewFriendSearchViewController: WXTableViewController, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    }
}
class WXAddThirdPartFriendItem: UIButton {
    var itemType = TLThirdPartType.contacts
    private var iconImageView = UIImageView()
    private var textLabel = UILabel()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init(imagePath: String, andTitle title: String) {
        super.init(frame: CGRect.zero)
        textLabel.font = UIFont.systemFont(ofSize: 12.0)
        iconImageView.image = UIImage(named: imagePath)
        textLabel.text = title
        addSubview(iconImageView)
        addSubview(textLabel)
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        textLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.iconImageView.snp.bottom).offset(5)
            make.centerX.equalTo(self.iconImageView)
        }
    }
}
class WXNewFriendViewController: WXTableViewController, UISearchBarDelegate, WXAddThirdPartFriendCellDelegate {
    private var searchVC = WXNewFriendSearchViewController()
    private lazy var searchController: WXSearchController = {
        let searchController = WXSearchController(searchResultsController: searchVC)
        searchController.searchResultsUpdater = searchVC
        searchController.searchBar.placeholder = "微信号/手机号"
        searchController.searchBar.delegate = self
        return searchController
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "新的朋友"
        view.backgroundColor = UIColor.white
        tableView.tableHeaderView = searchController.searchBar
        let rightBarButton = UIBarButtonItem(title: "添加朋友", style: .plain, target: self, action: #selector(WXNewFriendViewController.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
        tableView.register(WXAddThirdPartFriendCell.self, forCellReuseIdentifier: "TLAddThirdPartFriendCell")
    }
    @objc func rightBarButtonDown(_ sender: UIBarButtonItem) {
        let addFriendVC = WXAddFriendViewController()
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(addFriendVC, animated: true)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TLAddThirdPartFriendCell") as! WXAddThirdPartFriendCell
            let item = WXAddThirdPartFriendItem(imagePath: "", andTitle: "")
            item.itemType = TLThirdPartType.contacts
            cell.thridPartItems = [item]
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 80 : 60.0
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 20 : 0.0
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    func addThirdPartFriendCellDidSelectedType(_ type: TLThirdPartType) {
        switch type {
        case .contacts:
            let contactsVC = WXContactsViewController()
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(contactsVC, animated: true)
        case .QQ:break
        case .google:break
        }
    }
}
