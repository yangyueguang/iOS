//
//  MyDatabaseViewController.swift
//  Freedom
import UIKit
import XExtension
import XCarryOn
class MyDatabaseViewController: MyDatabaseBaseViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkGray
        let starsView = Circular3DStarView(frame: CGRect(x: 0, y: 100, width: APPW, height: APPW))
        var stars: [UIView] = []
        let items = ["微信","支付宝","酷狗","爱奇艺","抖音","淘宝","新浪微博","大众点评","今日头条","微能量","微信阅读","个性特色自由主义"]
        for i in 0..<100 {
            let index = Int(arc4random() % 12)
            let text = items[index]
            let item = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30), font: UIFont.systemFont(ofSize: 10), color: UIColor.white, text: text)
            item.textAlignment = .center
            item.isTapEffectEnabled = false
            let pointView = UIButton(frame: CGRect(x: 45, y: 20, width: 10, height: 10))
            pointView.layer.cornerRadius = 5
            pointView.backgroundColor = UIColor.random
            pointView.tag = i
            item.addSubview(pointView)
            stars.append(item)
        }
        starsView.stars = stars
        view.addSubview(starsView)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.edgesForExtendedLayout = .all
    }

    @objc func touchedItem(_ sender: UIButton) {
        let log = "你选择的是\(sender.tag)"
        noticeInfo(log, autoClear: true, autoClearTime: 3)
        push(MyDatabaseEditViewController(), info: "", title: "数据库编辑详情")
    }
}
