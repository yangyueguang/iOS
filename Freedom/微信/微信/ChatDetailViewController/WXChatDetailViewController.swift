////
////  WXChatDetailViewController.swift
////  Freedom
//
//import Foundation
//class WXChatDetailViewController: WXSettingViewController, WechatUserGroupCellDelegate {
//    var user: WXUser
//    var collectionView: UICollectionView
//    var helper: WXMessageManager
//
//    func viewDidLoad() {
//        super.viewDidLoad()
//        navigationItem.title = "聊天详情"
//
//        helper = WXMessageManager.sharedInstance()
//        data = helper.chatDetailData(byUserInfo: user)
//
//        tableView.register(WXUserGroupCell.self, forCellReuseIdentifier: "TLUserGroupCell")
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 && indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "TLUserGroupCell") as WXUserGroupCell
//            cell.users = [user]
//            cell.delegate = self
//            return cell!
//        }
//        return super.tableView(tableView, cellForRowAt: indexPath)
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item = data[indexPath.section][indexPath.row] as WXSettingItem
//        if (item.title == "聊天文件") {
//            let chatFileVC = WXChatFileViewController()
//            chatFileVC.partnerID = user.userID
//            hidesBottomBarWhenPushed = true
//            navigationController.pushViewController(chatFileVC, animated: true)
//        } else if (item.title == "设置当前聊天背景") {
//            let chatBGSettingVC = WXBgSettingViewController()
//            chatBGSettingVC.partnerID = user.userID
//            hidesBottomBarWhenPushed = true
//            navigationController.pushViewController(chatBGSettingVC, animated: true)
//        } else if (item.title == "清空聊天记录") {
//            showAlerWithtitle(nil, message: nil, style: UIAlertController.Style.actionSheet, ac1: {
//                return UIAlertAction(title: "清空聊天记录", style: .default, handler: { action in
//                    let ok = WXMessageManager.sharedInstance().deleteMessages(byPartnerID: self.user.userID)
//                    if !ok {
//                        SVProgressHUD.showError(withStatus: "清空聊天记录失败")
//                    } else {
//                        WXChatViewController.sharedChatVC().resetChatVC()
//                    }
//                })
//            }, ac2: {
//                return UIAlertAction(title: "取消", style: .cancel, handler: { action in
//                })
//            }, ac3: nil, completion: nil)
//        }
//        self.tableView.deselectRow(at: indexPath, animated: false)
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 && indexPath.row == 0 {
//            let count: Int = user  1 : 0
//            return CGFloat(((count + 1) / 4 + ((((count + 1) % 4) == 0) ? 0 : 1)) * 90 + 15)
//        }
//        return super.tableView(tableView, heightForRowAt: indexPath)
//    }
//
//    //MARK: TLUserGroupCellDelegate
//    func userGroupCellDidSelect(_ user: WXUser) {
//        let detailVC = WXFriendDetailViewController()
//        detailVC.user = user
//        hidesBottomBarWhenPushed = true
//        navigationController.pushViewController(detailVC, animated: true)
//    }
//
//    func userGroupCellAddUserButtonDown() {
//        SVProgressHUD.showInfo(withStatus: "添加讨论组成员")
//    }
//
//
//
//
//    
//}
