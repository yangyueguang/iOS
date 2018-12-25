//
//  WXMomentsViewController.swift
//  Freedom
import MJExtension
import SnapKit
import MWPhotoBrowser
import XExtension
import Foundation
class WXMomentsProxy: NSObject {
    func testData() -> [WXMoment] {
        let path = Bundle.main.path(forResource: "Moments", ofType: "json")
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path ?? ""))
        let jsonArray = try! JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments)
        let arr = WXMoment.mj_objectArray(withKeyValuesArray: jsonArray)
        return arr as! [WXMoment]
    }
}
class WXMomentBaseCell: WXTableViewCell {
    weak var delegate: WXMomentViewDelegate?
    var moment: WXMoment = WXMoment()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bottomLineStyle = .fill
        selectionStyle = .none
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class WXMomentImagesCell: WXMomentBaseCell {
    var momentView = WXMomentImageView()
    override var moment: WXMoment {
        didSet {
            momentView.moment = moment
        }
    }
    override var delegate: WXMomentViewDelegate? {
        didSet {
            momentView.delegate = delegate
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(momentView)
        momentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class WXMomentHeaderCell: WXTableViewCell {
    var user: WXUser = WXUser() {
        didSet {
            backgroundWall.sd_setImage(with: URL(string: user.detailInfo.momentsWallURL), for: UIControl.State.normal)
            backgroundWall.sd_setImage(with: URL(string: user.detailInfo.momentsWallURL), for: UIControl.State.highlighted)
            avatarView.sd_setImage(with: URL(string: user.avatarURL), for: UIControl.State.normal, placeholderImage: UIImage(named: PuserLogo))
            usernameLabel.text = user.nikeName
            mottoLabel.text = user.detailInfo.motto
        }
    }
    var backgroundWall = UIButton()
    var usernameLabel = UILabel()
    lazy var avatarView: UIButton = {
        let avatarView = UIButton()
        avatarView.layer.masksToBounds = true
        avatarView.layer.borderWidth = 2.0
        avatarView.layer.borderColor = UIColor.white.cgColor
        return avatarView
    }()
    lazy var mottoLabel: UILabel =  {
        let mottoLabel = UILabel()
        mottoLabel.font = UIFont.systemFont(ofSize: 14.0)
        mottoLabel.textColor = UIColor.gray
        mottoLabel.textAlignment = .right
        return mottoLabel
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bottomLineStyle = .none
        selectionStyle = .none
        contentView.addSubview(backgroundWall)
        contentView.addSubview(avatarView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(mottoLabel)
        backgroundWall.backgroundColor = UIColor.gray
        usernameLabel.textColor = UIColor.white
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    func p_addMasonry() {
//        backgroundWall.mas_makeConstraints({ make in
//            make.left.and().right().mas_equalTo(self.contentView)
//            make.bottom.mas_equalTo(self.mottoLabel.mas_top).mas_offset(-65 / 3.0 - 8.0)
//            make.top.mas_lessThanOrEqualTo(self.contentView.mas_top)
//        })
//        avatarView.mas_makeConstraints({ make in
//            make.right.mas_equalTo(self.contentView).mas_offset(-20.0)
//            make.centerY.mas_equalTo(self.backgroundWall.mas_bottom).mas_offset(-65 / 6.0)
//            make.size.mas_equalTo(CGSize(width: 65, height: 65))
//        })
//        usernameLabel.mas_makeConstraints({ make in
//            make.bottom.mas_equalTo(self.backgroundWall).mas_offset(-8.0)
//            make.right.mas_equalTo(self.avatarView.mas_left).mas_offset(-15.0)
//        })
//        mottoLabel.mas_makeConstraints({ make in
//            make.bottom.mas_equalTo(self.contentView).mas_offset(-8.0)
//            make.right.mas_equalTo(self.avatarView)
//            make.width.mas_lessThanOrEqualTo(APPW * 0.4)
//        })
//    }
}
class WXMomentsViewController: WXTableViewController, WXMomentViewDelegate {
    var data: [WXMoment] = []
    var proxy = WXMomentsProxy()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "朋友圈"
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60.0))
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "nav_camera"), style: .done, target: nil, action: nil)
        navigationItem.rightBarButtonItem = rightBarButton
        tableView.register(WXMomentHeaderCell.self, forCellReuseIdentifier: "TLMomentHeaderCell")
        tableView.register(WXMomentImagesCell.self, forCellReuseIdentifier: "TLMomentImagesCell")
        tableView.register(WXTableViewCell.self, forCellReuseIdentifier: "EmptyCell")
        data = proxy.testData()
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TLMomentHeaderCell") as! WXMomentHeaderCell
            cell.user = WXUserHelper.shared.user
            return cell
        }
        let moment = data[indexPath.row - 1]
        let cell: WXMomentImagesCell = tableView.dequeueReusableCell(withIdentifier: "TLMomentImagesCell") as! WXMomentImagesCell
        cell.moment = moment
        cell.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count + 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 260.0
        }
        let moment = data[indexPath.row - 1]
        return moment.momentFrame.height
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            let moment = data[indexPath.row - 1]
            let detailVC = WXMomentDetailViewController()
            detailVC.moment = moment
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(detailVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    func momentViewClickImage(_ images: [String], at index: Int) {
        var data = [AnyHashable](repeating: 0, count: images.count)
        for imageUrl: String in images {
            let photo = MWPhoto(url: URL(string: imageUrl))
            data.append(photo)
        }
        let browser = MWPhotoBrowser(photos: data)
        browser?.displayNavArrows = true
        browser?.setCurrentPhotoIndex(UInt(index))
        let broserNavC = WXNavigationController(rootViewController: browser!)
        present(broserNavC, animated: false)
    }
}
