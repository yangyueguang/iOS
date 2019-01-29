//
//  WXMineInfoViewController.swift
//  Freedom
import SnapKit
import Foundation
import XExtension
class WXMineInfoAvatarCell: BaseTableViewCell<WXSettingItem> {
    var titleLabel = UILabel()
    var avatarImageView = UIImageView()
    var item: WXSettingItem = WXSettingItem() {
        didSet {
            titleLabel.text = item.title
            if !item.rightImagePath.isEmpty {
                avatarImageView.image = UIImage(named: item.rightImagePath)
            } else if !item.rightImageURL.isEmpty {
                avatarImageView.sd_setImage(with: URL(string: item.rightImageURL), placeholderImage: Image.logo.image)
            } else {
                avatarImageView.image = nil
            }
        }
    }

    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 4.0
        contentView.addSubview(titleLabel)
        contentView.addSubview(avatarImageView)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.left.lessThanOrEqualTo(self.avatarImageView.snp.left).offset(-15)
        }
        avatarImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView)
            make.top.equalTo(self.contentView).offset(9)
            make.bottom.equalTo(self.contentView).offset(-9)
            make.width.equalTo(self.avatarImageView.snp.height)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
class WXMineInfoViewController: WXSettingViewController {
    var helper = WXMineInfoHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "个人信息"
        tableView.register(WXMineInfoAvatarCell.self, forCellReuseIdentifier: WXMineInfoAvatarCell.identifier)
        data = helper.mineInfoData(byUserInfo: WXUserHelper.shared.user)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = data[indexPath.section].items[indexPath.row]
        if (item.title == "头像") {
            let cell = tableView.dequeueCell(WXMineInfoAvatarCell.self)
            cell.item = item
            return cell
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.section].items[indexPath.row]
        if (item.title == "我的二维码") {
            let myQRCodeVC = WXMyQRCodeViewController()
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(myQRCodeVC, animated: true)
        }
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = data[indexPath.section].items[indexPath.row]
        if (item.title == "头像") {
            return 85.0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
}
