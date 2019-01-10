//
//  WXCGroupDetailViewController.swift
//  Freedom

import Foundation
class WXCGroupDetailViewController: WXSettingViewController, WechatUserGroupCellDelegate {
    var group: WXGroup = WXGroup()
    var helper = WXMessageManager.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "聊天详情"
        data = helper.chatDetailData(byGroupInfo: group)
        tableView.register(WXUserGroupCell.self, forCellReuseIdentifier: "TLUserGroupCell")
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TLUserGroupCell") as! WXUserGroupCell
            cell.users = group.users
            cell.delegate = self
            return cell
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.section].items[indexPath.row]
        if (item.title == "群二维码") {
            let gorupQRCodeVC = WXGroupQRCodeViewController()
            gorupQRCodeVC.group = group
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(gorupQRCodeVC, animated: true)
        } else if (item.title == "设置当前聊天背景") {
            let chatBGSettingVC = WXBgSettingViewController()
            chatBGSettingVC.partnerID = group.groupID
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(chatBGSettingVC, animated: true)
        } else if (item.title == "聊天文件") {
            let chatFileVC = WXChatFileViewController()
            chatFileVC.partnerID = group.groupID
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(chatFileVC, animated: true)
        } else if (item.title == "清空聊天记录") {
            let alertVC = UIAlertController("", "", T1: "清空聊天记录", T2: "取消", confirm1: {
                let ok = WXMessageManager.shared.deleteMessages(byPartnerID: self.group.groupID)
                WXChatViewController.shared.resetChatVC()
            }, confirm2: {

            })
            self.present(alertVC, animated: true, completion: nil)
        }
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            let count = group.count
            return CGFloat(((count + 1) / 4 + ((((count + 1) % 4) == 0) ? 0 : 1)) * 90 + 15)
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    func userGroupCellDidSelect(_ user: WXUser) {
        let detailVC = WXFriendDetailViewController()
        detailVC.user = user
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
    func userGroupCellAddUserButtonDown() {
        noticeInfo("添加讨论组成员")
    }
}
