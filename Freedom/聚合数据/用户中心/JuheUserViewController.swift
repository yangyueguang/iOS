//
//  JuheUserViewController.swift
//  Freedom
import UIKit
import XExtension
import XCarryOn
class JuheUserViewCell:BaseTableViewCell{
    override func initUI() {
        self.icon = UIImageView(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
        self.title = UILabel(frame: CGRect(x:XW(self.icon)+10, y:20, width:200, height: 20))
        self.line = UIView(frame: CGRect(x: 10, y: 59, width: APPW-20, height: 1))
        self.addSubviews([self.title,self.icon,self.line])
        self.title.text = "name"
        self.icon.image = UIImage(named:"taobaomini2")
    }
}
class JuheUserViewController: JuheBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cellHeight = 60
        title = "个人中心"
        self.tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH-TopHeight))
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 260))
    let icon = UIImageView(frame: CGRect(x: 10, y: 15, width: 60, height:60))
    icon.layer.cornerRadius = 30
    icon.layer.masksToBounds = true
        let name = UILabel(frame: CGRect(x: XW(icon)+10, y: 10, width: 300, height: 20))
    name.text = "用户名：18326891683  👑已认证"
        let openid = UILabel(frame: CGRect(x: name.frame.origin.x, y:YH(name), width: 400, height: 20))
        openid.text = "OpenId:JH12bd23ef316e3d8a9dfe7402ef8bc453"
        let email = UILabel(frame: CGRect(x: name.frame.origin.x, y: YH(openid), width: 300, height: 20))
    email.text = "绑定邮箱:1069106050@qq.com"
        let phone = UILabel(frame: CGRect(x: name.frame.origin.x, y: YH(email), width: 300, height: 20))
       phone.text = "手机号码:18721064516"
    headerView.addSubviews([icon,name,openid,email,phone])
    icon.image = UIImage(named:"userLogo")
    let v = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 50))
    let quit = UIButton(frame: CGRect(x: APPW/2-50, y: 10, width: 100, height: 30))
        quit.setTitle("", for: .normal)
        quit.setTitleColor(.white, for: .normal)
        quit.backgroundColor = .red
        v.addSubview(quit)
    let titles = ["我的聚合","我的数据","我的收藏","我的余额","聚合币","优惠券","发票管理","其他信息"]
    let icons = ["juheintopublic","juheintopublic","juheintopublic","juheintopublic","juheintopublic","juheintopublic","juheintopublic","juheintopublic"]
    let banItemSV = BaseScrollView(baseItem: CGRect(x: 0, y: 100, width: APPW, height: 160), icons: icons, titles: titles, size: CGSize(width: APPW/4.0, height: 80), round:false)
        headerView.addSubview(banItemSV)
        banItemSV.selectBlock = {(index,dict) in
            print("点击了\(index),\(String(describing: dict))")
        }
        self.tableView.dataArray = NSMutableArray(array: ["我的充值记录","我的消费记录","账户信息","密码修改","实名认证"])
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        view.addSubview(tableView)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: JuheUserViewCell.identifier()) as? JuheUserViewCell
        if cell == nil{
            cell = JuheUserViewCell.getInstance() as? JuheUserViewCell
        }
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个单元格")
    }
}
