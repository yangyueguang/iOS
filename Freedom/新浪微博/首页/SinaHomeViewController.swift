//
//  SinaHomeViewController.swift
//  Freedom
//  Created by Super on 6/28/18.
//  Copyright © 2018 薛超. All rights reserved.
import UIKit
import BaseFile
import XExtension
import AFNetworking
class SinaUser: NSObject {
    var idstr = ""/*字符串型的用户UID*/
    var name = ""/**友好显示名称*/
    var profile_image_url = "" /*用户头像地址，50×50像素*/
    var mbtype: Int = 0/** 会员类型 > 2代表是会员 */
    var mbrank: Int = 0/** 会员等级 */
    var vip = false
    var verified_type: Int = 0/** 认证类型 */
}
class SinaStatus: NSObject {
    var idstr = ""/**字符串型的微博ID*/
    var text = ""/**微博信息内容*/
    var user: SinaUser? /**微博作者的用户信息字段 详细*/
    var created_at = ""/**微博创建时间*/
    var source = ""/**微博来源*/
    var pic_urls = [Any]()/** 微博配图地址。多图时返回多图链接。无配图返回“[]” */
    var retweeted_status: SinaStatus?/** 被转发的原微博信息字段，当该微博为转发微博时返回 */
    var reposts_count: Int = 0/**转发数*/
    var comments_count: Int = 0/**评论数*/
    var attitudes_count: Int = 0/**表态数*/
}
/* 原创微博 */
class SinaStatusViewCell: UITableViewCell {
    var originalView = UIView()/** 原创微博整体 */
    var iconView = UIImageView()/** 头像 */
    var vipView = UIImageView()/** 会员图标 */
    var photosView = UIImageView()/** 配图 */
    var nameLabel = UILabel()/** 昵称 */
    var timeLabel = UILabel()/** 时间 */
    var sourceLabel = UILabel()/** 来源 */
    var contentLabel = UILabel()/** 正文 */
    var retweetView = UIView()/** 转发微博整体 */
    var retweetContentLabel = UILabel()/** 转发微博正文 + 昵称 */
    var retweetPhotosView = UIImageView()/** 转发配图 */
    var toolbar = UIView()/** 工具条 */
    var status: SinaStatus?
}
class SinaHomeViewController: SinaBaseViewController {
    var list = [SinaStatus]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let account = SinaAccount.account()
        title = account?.name
        tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: CGFloat(APPH - TopHeight)))
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "u_personAdd"), style: .done, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "u_scan"), style: .plain, target: nil, action: nil)
        // 设置图片和文字
        let url = "https://api.weibo.com/2/users/show.json"
        var params = [AnyHashable: Any]()
        params["access_token"] = account?.access_token
        params["uid"] = account?.uid
        let manager = AFHTTPSessionManager()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("text/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        manager.responseSerializer.acceptableContentTypes = Set<AnyHashable>(["application/json", "text/json", "text/plain", "application/xml", "text/xml", "text/html", "text/javascript", "application/x-plist", "image/tiff", "image/jpeg", "image/gif", "image/png", "image/ico", "image/x-icon", "image/bmp", "image/x-bmp", "image/x-xbitmap", "image/x-win-bitmap"]) as? Set<String>
        manager.get(url, parameters: params, progress: nil, success: { task, responseObject in
            let name = (responseObject! as! [String:String])["name"]
            self.title = name
            account?.name = name!
            SinaAccount.save(account)
        }, failure: { task, error in
        })
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refreshStatus(_:)), for: .valueChanged)
        tableView.addSubview(refresh)
        refresh.beginRefreshing()
        AFHTTPSessionManager().get("https://rm.api.weibo.com/2/remind/unread_count.json", parameters: params, progress: nil, success: { task, responseObject in
            let status = (responseObject! as! [String:Any])["status"] as! NSNumber
            self.tabBarItem.badgeValue = status.stringValue
            UIApplication.shared.applicationIconBadgeNumber = Int(truncating: status)
        }, failure: { task, error in
        })
    }
    /*UIRefreshControl进入刷新状态：加载最新的数据*/
    func refreshStatus(_ control: UIRefreshControl?) {
        let url = "https://api.weibo.com/2/statuses/friends_timeline.json"
        let account = SinaAccount.account()
        var params = [AnyHashable: Any]()
        params["access_token"] = account?.access_token
        params["since_id"] = 0
        AFHTTPSessionManager().get(url, parameters: params, progress: nil, success: { task, responseObject in
            let newStatuses = SinaStatus.mj_objectArray(withKeyValuesArray: (responseObject! as! [String:Any])["statuses"]) as! [SinaStatus]
            self.list.append(contentsOf: newStatuses)
            self.tableView.reloadData()
            control?.endRefreshing()
            self.tabBarItem.badgeValue = nil
            UIApplication.shared.applicationIconBadgeNumber = 0
        }, failure: { task, error in
        })
    }
    // 加载更多的微博数据
    func loadMoreStatus() {
        let account = SinaAccount.account()
        var params = [AnyHashable: Any]()
        params["access_token"] = account?.access_token
        params["max_id"] = 0
        AFHTTPSessionManager().get("https://api.weibo.com/2/statuses/friends_timeline.json", parameters: params, progress: nil, success: { task, responseObject in
            let newStatuses = SinaStatus.mj_objectArray(withKeyValuesArray: (responseObject! as! [String:Any])["statuses"]) as! [SinaStatus]
            self.list.append(contentsOf: newStatuses)
            self.tableView.reloadData()
            self.tableView.tableFooterView?.isHidden = true
        }, failure: { task, error in
        })
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    //数据源
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ID = "status"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID) as? SinaStatusViewCell
        if cell == nil {
            cell = SinaStatusViewCell(style: .subtitle, reuseIdentifier: ID)
            cell?.backgroundColor = UIColor.clear
            if let acell = cell{
                acell.originalView.addSubviews([acell.iconView, acell.vipView, acell.photosView, acell.nameLabel, acell.timeLabel, acell.sourceLabel, acell.contentLabel, acell.retweetContentLabel, acell.retweetPhotosView])
                acell.contentView.addSubviews([acell.originalView, acell.retweetView, acell.toolbar])
            }
        }
        return cell!
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
