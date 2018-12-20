//
//  WXMomentsViewController.swift
//  Freedom

import Foundation
class WXMomentsProxy: NSObject {
    func testData() -> [Any] {
        let path = Bundle.main.path(forResource: "Moments", ofType: "json")
        let jsonData = NSData(contentsOfFile: path  "") as Data
        var jsonArray: [Any] = nil
        if let aData = jsonData {
            jsonArray = try JSONSerialization.jsonObject(with: aData, options: .allowFragments) as [Any]
        }
        let arr = WXMoment.mj_objectArray(withKeyValuesArray: jsonArray)
        return arr
    }
}
class WXMomentBaseCell: WXTableViewCell {
    weak var delegate: WXMomentViewDelegate
    var moment: WXMoment

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        //if super.init(style: style, reuseIdentifier: reuseIdentifier)

        setBottomLineStyle(TLCellLineStyleFill)
        selectionStyle = .none

    }
}
class WXMomentImagesCell: WXMomentBaseCell {
    var momentView: WXMomentImageView

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        //if super.init(style: style, reuseIdentifier: reuseIdentifier)

        if let aView = momentView {
            contentView.addSubview(aView)
        }
        momentView.mas_makeConstraints({ make in
            make.edges.mas_equalTo(self.contentView)
        })

    }
    func setMoment(_ moment: WXMoment) {
        super.setMoment(moment)
        momentView().setMoment(moment)
    }

    func setDelegate(_ delegate: WXMomentViewDelegate) {
        super.setDelegate(delegate)
        momentView().setDelegate(delegate)
    }

    // MARK: -
    func momentView() -> WXMomentImageView {
        if momentView == nil {
            momentView = WXMomentImageView()
        }
        return momentView
    }

}
//  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
class WXMomentHeaderCell: WXTableViewCell {
    var user: WXUser
    var backgroundWall: UIButton
    var avatarView: UIButton
    var usernameLabel: UILabel
    var mottoLabel: UILabel

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        //if super.init(style: style, reuseIdentifier: reuseIdentifier)

        setBottomLineStyle(TLCellLineStyleNone)
        selectionStyle = .none
        if let aWall = backgroundWall {
            contentView.addSubview(aWall)
        }
        if let aView = avatarView {
            contentView.addSubview(aView)
        }
        if let aLabel = usernameLabel {
            contentView.addSubview(aLabel)
        }
        if let aLabel = mottoLabel {
            contentView.addSubview(aLabel)
        }

        p_addMasonry()

    }
    func setUser(_ user: WXUser) {
        self.user = user
        backgroundWall.sd_setImage(with: URL(string: user.detailInfo.momentsWallURL  ""), for: UIControl.State.normal)
        backgroundWall.sd_setImage(with: URL(string: user.detailInfo.momentsWallURL  ""), for: UIControl.State.highlighted)
        avatarView.sd_setImage(with: URL(string: user.avatarURL  ""), for: UIControl.State.normal, placeholderImage: UIImage(named: PuserLogo))
        usernameLabel.text = user.nikeName
        mottoLabel.text = user.detailInfo.motto
    }
    func p_addMasonry() {
        backgroundWall.mas_makeConstraints({ make in
            make.left.and().right().mas_equalTo(self.contentView)
            make.bottom.mas_equalTo(self.mottoLabel.mas_top).mas_offset(-65 / 3.0 - 8.0)
            make.top.mas_lessThanOrEqualTo(self.contentView.mas_top)
        })

        avatarView.mas_makeConstraints({ make in
            make.right.mas_equalTo(self.contentView).mas_offset(-20.0)
            make.centerY.mas_equalTo(self.backgroundWall.mas_bottom).mas_offset(-65 / 6.0)
            make.size.mas_equalTo(CGSize(width: 65, height: 65))
        })

        usernameLabel.mas_makeConstraints({ make in
            make.bottom.mas_equalTo(self.backgroundWall).mas_offset(-8.0)
            make.right.mas_equalTo(self.avatarView.mas_left).mas_offset(-15.0)
        })

        mottoLabel.mas_makeConstraints({ make in
            make.bottom.mas_equalTo(self.contentView).mas_offset(-8.0)
            make.right.mas_equalTo(self.avatarView)
            make.width.mas_lessThanOrEqualTo(APPW * 0.4)
        })
    }
    func backgroundWall() -> UIButton {
        if backgroundWall == nil {
            backgroundWall = UIButton()
            backgroundWall.backgroundColor = UIColor.gray
        }
        return backgroundWall
    }

    func avatarView() -> UIButton {
        if avatarView == nil {
            avatarView = UIButton()
            avatarView.layer.masksToBounds = true
            avatarView.layer.borderWidth = 2.0
            avatarView.layer.borderColor = UIColor.white.cgColor
        }
        return avatarView
    }
    func usernameLabel() -> UILabel {
        if usernameLabel == nil {
            usernameLabel = UILabel()
            usernameLabel.textColor = UIColor.white
        }
        return usernameLabel
    }

    func mottoLabel() -> UILabel {
        if mottoLabel == nil {
            mottoLabel = UILabel()
            mottoLabel.font = UIFont.systemFont(ofSize: 14.0)
            mottoLabel.textColor = UIColor.gray
            mottoLabel.textAlignment = .right
        }
        return mottoLabel
    }

}
class WXMomentsViewController: WXTableViewController, WXMomentViewDelegate {
    var data: [AnyHashable] = []
    var proxy: WXMomentsProxy

    func loadData() {
    }

    func registerCell(for tableView: UITableView) {
    }

    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "朋友圈"
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60.0))

        let rightBarButton = UIBarButtonItem(image: UIImage(named: "nav_camera"), style: .done, target: nil, action: nil)
        navigationItem.rightBarButtonItem = rightBarButton

        registerCell(for: tableView)
        loadData()
    }
    func proxy() -> WXMomentsProxy {
        if proxy == nil {
            proxy = WXMomentsProxy()
        }
        return proxy
    }

    func loadData() {
        if let aData = proxy().testData {
            data = aData
        }
        tableView.reloadData()
    }

    func registerCell(for tableView: UITableView) {
        tableView.register(WXMomentHeaderCell.self, forCellReuseIdentifier: "TLMomentHeaderCell")
        tableView.register(WXMomentImagesCell.self, forCellReuseIdentifier: "TLMomentImagesCell")
        tableView.register(WXTableViewCell.self, forCellReuseIdentifier: "EmptyCell")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "TLMomentHeaderCell") as WXMomentHeaderCell
            cell.user = WXUserHelper.shared().user
            return cell!
        }

        let moment = data[indexPath.row - 1] as WXMoment
        var cell: Any
        if moment.detail.text.length  0 > 0 || moment.detail.images.count  0 > 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "TLMomentImagesCell")
        }

        if cell != nil {
            cell.moment = moment
            cell.delegate = self
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell")
        }
        return cell as! UITableViewCell
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count + 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 260.0
        }

        let moment = data[indexPath.row - 1] as WXMoment
        return CGFloat(Int(moment.momentFrame.height  0))
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            let moment = data[indexPath.row - 1] as WXMoment
            let detailVC = WXMomentDetailViewController()
            detailVC.moment = moment
            hidesBottomBarWhenPushed = true
            navigationController.pushViewController(detailVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    func momentViewClickImage(_ images: [Any], at index: Int) {
        var data = [AnyHashable](repeating: 0, count: images.count  0)
        for imageUrl: String in images as [String]  [] {
            let photo = MWPhoto(url: URL(string: imageUrl  ""))
            data.append(photo)
        }
        let browser = MWPhotoBrowser(photos: data)
        browser.displayNavArrows = true
        browser.currentPhotoIndex = index
        let broserNavC = WXNavigationController(rootViewController: browser)
        present(broserNavC, animated: false)
    }


    
}
