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
            if menuItem.rightIconURL.isEmpty {
                rightImageView.snp.updateConstraints { (make) in
                    make.width.equalTo(0)
                }
            } else {
                rightImageView.snp.updateConstraints { (make) in
                    make.height.equalTo(self.rightImageView.snp.height)
                }
                rightImageView.sd_setImage(with: URL(string: menuItem.rightIconURL), placeholderImage: UIImage(named: PuserLogo))
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
//        iconImageView.mas_makeConstraints({ make in
//            make.left.mas_equalTo(self.contentView).mas_offset(15.0)
//            make.centerY.mas_equalTo(self.contentView)
//            make.width.and().height().mas_equalTo(25.0)
//        })
//        titleLabel.mas_makeConstraints({ make in
//            make.centerY.mas_equalTo(self.iconImageView)
//            make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(15.0)
//            make.right.mas_lessThanOrEqualTo(self.contentView).mas_offset(15.0)
//        })
//        rightImageView.mas_makeConstraints({ make in
//            make.right.mas_equalTo(self.contentView)
//            make.centerY.mas_equalTo(self.iconImageView)
//            make.width.and().height().mas_equalTo(31)
//        })
//        midLabel.mas_makeConstraints({ make in
//            make.left.mas_greaterThanOrEqualTo(self.titleLabel.mas_right).mas_offset(15)
//            make.right.mas_equalTo(self.rightImageView.mas_left).mas_offset(-5)
//            make.centerY.mas_equalTo(self.iconImageView)
//        })
//        redPointView.mas_makeConstraints({ make in
//            make.centerX.mas_equalTo(self.rightImageView.mas_right).mas_offset(1)
//            make.centerY.mas_equalTo(self.rightImageView.mas_top).mas_offset(1)
//            make.width.and().height().mas_equalTo(8)
//        })
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
        if !(item.rightIconURL.isEmpty && item.subTitle.isEmpty) {
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
