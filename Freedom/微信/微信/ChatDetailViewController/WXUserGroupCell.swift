//
//  WXUserGroupCell.swift
//  Freedom

import Foundation
protocol WechatUserGroupCellDelegate: NSObjectProtocol {
    func userGroupCellDidSelect(_ user: WXUser)
    func userGroupCellAddUserButtonDown()
}

class WXUserGroupCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    private var collectionView: UICollectionView
    weak var delegate: WechatUserGroupCellDelegate
    var users: [AnyHashable] = []
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        if let aView = collectionView {
            contentView.addSubview(aView)
        }
        collectionView.register(WXUserGroupItemCell.self, forCellWithReuseIdentifier: "TLUserGroupItemCell")
        p_addMasonry()

    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TLUserGroupItemCell", for: indexPath) as WXUserGroupItemCell
        if indexPath.row < users.count {
            cell.user = users[indexPath.row]
        } else {
            cell.user = nil
        }
        cell.clickBlock = { user in
            if user != nil && delegate != nil {
                delegate?.userGroupCellDidSelect(user)
            } else {
                delegate.userGroupCellAddUserButtonDown()
            }
        }
        return cell!
    }
    func p_addMasonry() {
        collectionView.mas_makeConstraints({ make in
            make.edges.mas_equalTo(self.contentView)
        })
    }

    var collectionView: UICollectionView! {
        if collectionView == nil {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 57, height: 75)
            layout.minimumInteritemSpacing = (APPW - 57 * 4) / 5
            layout.sectionInset = UIEdgeInsetsMake(15, (APPW - 57 * 4) / 5 * 0.9, 15, 15 * 0.9)
            collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            collectionView.backgroundColor = UIColor.white
            collectionView.isScrollEnabled = false
            collectionView.isPagingEnabled = true
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.scrollsToTop = false
        }
        return collectionView
    }
}

class WXUserGroupItemCell: UICollectionViewCell {
    var user: WXUser
    var clickBlock: ((_ user: WXUser) -> Void)
    var avatarView: UIButton
    var usernameLabel: UILabel

    override init(frame: CGRect) {
        super.init(frame: frame)
        if let aView = avatarView {
            contentView.addSubview(aView)
        }
        if let aLabel = usernameLabel {
            contentView.addSubview(aLabel)
        }
        p_addMasonry()

    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setUser(_ user: WXUser) {
        self.user = user
        if user != nil {
            avatarView.sd_setImage(with: URL(string: user.avatarURL), for: UIControl.State.normal, placeholderImage: UIImage(named: PuserLogo))
            usernameLabel.text = user.showName
        } else {
            avatarView.setImage(UIImage(named: "chatdetail_add_member"), for: .normal)
            avatarView.setImage(UIImage(named: "chatdetail_add_memberHL"), for: .highlighted)
            usernameLabel.text = nil
        }
    }

    func avatarButtonDown() {
        clickBlock(user)
    }

    func p_addMasonry() {
        avatarView().mas_makeConstraints({ make in
            make.top.and().left().and().right().mas_equalTo(self.contentView)
            make.height.mas_equalTo(self.avatarView().mas_width)
        })
        usernameLabel.mas_makeConstraints({ make in
            make.centerX.and.bottom.mas_equalTo(self.contentView)
            make.left.and().right().mas_lessThanOrEqualTo(self.contentView)
        })
    }
    func avatarView() -> UIButton {
        if avatarView == nil {
            avatarView = UIButton()
            avatarView.layer.masksToBounds = true
            avatarView.layer.cornerRadius = 5.0
            avatarView.addTarget(self, action: #selector(self.avatarButtonDown), for: .touchUpInside)
        }
        return avatarView
    }
    func usernameLabel() -> UILabel {
        if usernameLabel == nil {
            usernameLabel = UILabel()
            usernameLabel.font = UIFont.systemFont(ofSize: 12.0)
            usernameLabel.textAlignment = .center
        }
        return usernameLabel
    }

}
