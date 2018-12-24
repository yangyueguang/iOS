//
//  WXUserGroupCell.swift
//  Freedom

import Foundation
protocol WechatUserGroupCellDelegate: NSObjectProtocol {
    func userGroupCellDidSelect(_ user: WXUser)
    func userGroupCellAddUserButtonDown()
}

class WXUserGroupCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 57, height: 75)
        layout.minimumInteritemSpacing = (APPW - 57 * 4) / 5
        layout.sectionInset = UIEdgeInsets(top: 15, left: (APPW - 57 * 4) / 5 * 0.9, bottom: 15, right: 15 * 0.9)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.isScrollEnabled = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop = false
        return collectionView
    }()
    weak var delegate: WechatUserGroupCellDelegate?
    var users: [WXUser] = []
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(collectionView)
        collectionView.register(WXUserGroupItemCell.self, forCellWithReuseIdentifier: "TLUserGroupItemCell")
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TLUserGroupItemCell", for: indexPath) as! WXUserGroupItemCell
        if indexPath.row < users.count {
            cell.user = users[indexPath.row]
        } else {
            cell.user = nil
        }
        cell.clickBlock = { user in
            if self.delegate != nil {
                self.delegate?.userGroupCellDidSelect(user)
            } else {
                self.delegate?.userGroupCellAddUserButtonDown()
            }
        }
        return cell
    }
}

class WXUserGroupItemCell: UICollectionViewCell {
    var user: WXUser? {
        didSet {
            if user != nil {
                avatarView.sd_setImage(with: URL(string: user?.avatarURL ?? ""), for: UIControl.State.normal, placeholderImage: UIImage(named: PuserLogo))
                usernameLabel.text = user?.showName
            } else {
                avatarView.setImage(UIImage(named: "chatdetail_add_member"), for: .normal)
                avatarView.setImage(UIImage(named: "chatdetail_add_memberHL"), for: .highlighted)
                usernameLabel.text = nil
            }
        }
    }
    var clickBlock: ((_ user: WXUser) -> Void)?
    lazy var avatarView: UIButton = {
        let avatarView = UIButton()
        avatarView.layer.masksToBounds = true
        avatarView.layer.cornerRadius = 5.0
        avatarView.addTarget(self, action: #selector(self.avatarButtonDown), for: .touchUpInside)
        return avatarView
    }()
    lazy var usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.font = UIFont.systemFont(ofSize: 12.0)
        usernameLabel.textAlignment = .center
        return usernameLabel
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(avatarView)
        contentView.addSubview(usernameLabel)
        avatarView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.contentView)
            make.height.equalTo(self.avatarView.snp.width)
        }
        usernameLabel.snp.makeConstraints { (make) in
            make.centerX.bottom.equalTo(self.contentView)
            make.left.right.lessThanOrEqualTo(self.contentView)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    @objc func avatarButtonDown() {
        clickBlock?(user!)
    }
}
