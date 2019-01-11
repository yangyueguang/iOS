//
//  WXMenuViewController.swift
//  Freedom
//
import SnapKit
import Foundation
class WXMenuCell: UITableViewCell {
    private var iconImageView = UIImageView()
    private var titleLabel = UILabel()
    private var midLabel = UILabel()
    private var rightImageView = UIImageView()
    private var redPointView = UIView()
    var menuItem: WXMenuItem = WXMenuItem() {
        didSet {
            iconImageView.image = UIImage(named: menuItem.iconPath)
            titleLabel.text = menuItem.title
            midLabel.text = menuItem.subTitle
            if menuItem.rightIconURL?.isEmpty ?? true {
                rightImageView.snp.updateConstraints { (make) in
                    make.width.equalTo(0)
                }
            } else {
                rightImageView.snp.updateConstraints { (make) in
                    make.height.equalTo(self.rightImageView.snp.height)
                }
                rightImageView.sd_setImage(with: URL(string: menuItem.rightIconURL!), placeholderImage: UIImage(named: PuserLogo))
            }
            redPointView.isHidden = !menuItem.showRightRedPoint
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(midLabel)
        contentView.addSubview(rightImageView)
        contentView.addSubview(redPointView)
        midLabel.textColor = UIColor.gray
        midLabel.font = UIFont.systemFont(ofSize: 14.0)
        redPointView.backgroundColor = UIColor.red
        redPointView.layer.masksToBounds = true
        redPointView.layer.cornerRadius = 8 / 2.0
        redPointView.isHidden = true
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconImageView.snp.right).offset(15)
            make.right.lessThanOrEqualTo(self.contentView).offset(15)
        }
        rightImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalTo(self.iconImageView)
            make.width.height.equalTo(31)
        }
        midLabel.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualTo(self.titleLabel.snp.right).offset(15)
            make.right.equalTo(self.rightImageView.snp.left).offset(-5)
            make.centerY.equalTo(self.iconImageView)
        }
        redPointView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.rightImageView.snp.right).offset(1)
            make.centerY.equalTo(self.rightImageView.snp.top).offset(1)
            make.width.height.equalTo(8)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WXMenuViewController: UITableViewController {
    var data: [[WXMenuItem]] = []
    override func loadView() {
        view = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH))
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.backgroundColor = UIColor.lightGray
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        tableView.separatorColor = UIColor.gray
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 20))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(WXMenuCell.self, forCellReuseIdentifier: "TLMenuCell")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let temp = data[section]
        return temp.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TLMenuCell") as! WXMenuCell
        let item = data[indexPath.section][indexPath.row] as WXMenuItem
        cell.menuItem = item
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.section][indexPath.row] as WXMenuItem
        if !(item.rightIconURL?.isEmpty ?? true && item.subTitle.isEmpty) {
            item.rightIconURL = ""
            item.subTitle = ""
            item.showRightRedPoint = false
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15.0
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
}
