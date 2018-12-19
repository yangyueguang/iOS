
//
//  FoundationSwift.swift
//  Freedom
//
//  Created by Super on 2018/5/18.
//  Copyright © 2018年 Super. All rights reserved.
//
import Foundation
import XExtension
import XCarryOn

extension NSObject {
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last! as String
    }
}
extension UICollectionViewCell {
}
extension UICollectionReusableView {
    class var identifier: String {
        return self.nameOfClass
    }
    class var bundle: Bundle? {
        return Bundle(for: self)
    }
}
extension UICollectionView {
    func register(_ view: UICollectionReusableView.Type, isCell: Bool = true,isHeader: Bool = true, isNib: Bool = false) {
        if isCell {
            if isNib {
                self.register(UINib(nibName: view.nameOfClass, bundle: Bundle(for: view.self)), forCellWithReuseIdentifier: view.identifier)
            }else{
                self.register(view.self, forCellWithReuseIdentifier: view.identifier)
            }
        }else{
            if isNib {
                self.register(UINib(nibName: view.nameOfClass, bundle: Bundle(for: view.self)), forSupplementaryViewOfKind: isHeader ? UICollectionView.elementKindSectionHeader : UICollectionView.elementKindSectionFooter, withReuseIdentifier: view.identifier)
            }else{
                self.register(view.self, forSupplementaryViewOfKind: isHeader ? UICollectionView.elementKindSectionHeader : UICollectionView.elementKindSectionFooter, withReuseIdentifier: view.identifier)
            }
        }
    }
}
extension UITableViewCell {
    class var identifier: String {
        return self.nameOfClass
    }

    class var bundle: Bundle? {
        return Bundle(for: self)
    }
}
extension UITableViewHeaderFooterView {
    class var identifier: String {
        return self.nameOfClass
    }

    class var bundle: Bundle? {
        return Bundle(for: self)
    }
}

extension UITableView {
    func register(_ cell: UITableViewCell.Type, isNib: Bool = false) {
        if isNib {
            self.register(UINib(nibName: cell.nameOfClass, bundle: cell.bundle), forCellReuseIdentifier: cell.identifier)
        }else{
            self.register(cell.self, forCellReuseIdentifier: cell.identifier)
        }
    }
    func register(_ headFoot: UITableViewHeaderFooterView.Type, isNib: Bool = false) {
        if isNib {
            self.register(UINib(nibName: headFoot.nameOfClass, bundle: headFoot.bundle), forHeaderFooterViewReuseIdentifier: headFoot.identifier)
        }else{
            self.register(headFoot.self, forHeaderFooterViewReuseIdentifier: headFoot.identifier)
        }
    }
}

public let fontTitle = Font(15)
public let fontMiddle = Font(14)
public let fontSmall = Font(13)
public let blacktextcolor = UIColor(33, 34, 35, 1)
public let gradtextcolor = UIColor(116, 117, 118, 1)
public let TabBarH:CGFloat = 49
public var TopHeight:CGFloat {
    if APPH >= 812.0{
        return 88.0
    }
    return 64.0
}
public let APPW = UIScreen.main.bounds.size.width
public let APPH = UIScreen.main.bounds.size.height

/*爱奇艺主界面的数据*/
public let urlWithHomeData = "http://api.3g.tudou.com/v4/home?guid=7066707c5bdc38af1621eaf94a6fe779&idfa=ACAF9226-F987-417B-A708-C95D482A732D&ios=1&network=WIFI&operator=%E4%B8%AD%E5%9B%BD%E8%81%94%E9%80%9A_46001&ouid=10099212c9e3829656d4ea61e3858d53253b2f07&pg=1&pid=c0637223f8b69b02&pz=30&show_url=1&vdid=9AFEE982-6F94-4F57-9B33-69523E044CF4&ver=4.9.1"
/*爱奇艺泡泡分类的数据*/
public let urlWithclassifyData = "http://api.3g.tudou.com/v4_5/recommended_channels?excludeNew=0&guid=7066707c5bdc38af1621eaf94a6fe779&idfa=ACAF9226-F987-417B-A708-C95D482A732D&network=WIFI&operator=%E4%B8%AD%E5%9B%BD%E8%81%94%E9%80%9A_46001&ouid=10099212c9e3829656d4ea61e3858d53253b2f07&pg=1&pid=c0637223f8b69b02&pz=30&vdid=9AFEE982-6F94-4F57-9B33-69523E044CF4&ver=4.9.1"
/*爱奇艺发现的数据*/
public let urlWithDiscoverData = "http://discover.api.3g.tudou.com/v4_7/rec_discover?guid=7066707c5bdc38af1621eaf94a6fe779&idfa=ACAF9226-F987-417B-A708-C95D482A732D&network=WIFI&operator=%E4%B8%AD%E5%9B%BD%E8%81%94%E9%80%9A_46001&ouid=10099212c9e3829656d4ea61e3858d53253b2f07&pg=1&pid=c0637223f8b69b02&pz=30&vdid=9AFEE982-6F94-4F57-9B33-69523E044CF4&ver=4.9.1"
/*爱奇艺订阅的数据*/
public let urlWithSubscribeData = "http://user.api.3g.tudou.com/v4_3/user/sub/update?guid=7066707c5bdc38af1621eaf94a6fe779&idfa=ACAF9226-F987-417B-A708-C95D482A732D&network=WIFI&operator=%E4%B8%AD%E5%9B%BD%E8%81%94%E9%80%9A_46001&ouid=10099212c9e3829656d4ea61e3858d53253b2f07&pg=1&pid=c0637223f8b69b02&pz=20&ty=0&u_item_size=3&update_time=0&vdid=9AFEE982-6F94-4F57-9B33-69523E044CF4&ver=4.9.1"
public let TestWebURL = "https://www.baidu.com"
let APP_CHANNEL = "Github"
let PlaceHolder = " "
let PQRCode = "u_QRCode"
let PuserLogo = "userLogo"
let baseDomain = "www.baidu.com"
let basePort = "80"
let basePath = "app"
let basePicPath = "www.baidu.com/"
let BaseURL = "http://www.isolar88.com/app/upload/xuechao"
//*****************           支      付     宝           ******************
let PartnerID = ""
let SellerID = "zfb@"
let MD5_KEY = ""
let AlipayPubKey = ""
let alipayBackUrl = ""
//*****************           微             信           ******************
// UMeng

public let UMENG_APPKEY = "563755cbe0f55a5cb300139c"
//let UMENG_APPKEY = "56b8ba33e0f55a15480020b0"
let JSPATCH_APPKEY = "7eadab71a29a784e"
// 七牛云存储
let QINIU_APPKEY = "28ed72E3r7nfEjApnsHWQhItdqyZqTLCtcfQZp9I"
let QINIU_SECRET = "aRYPqQYF9rK9EVJfcu849VY0PAky2Sfj97Sp349S"
// Mob SMS
let MOB_SMS_APPKEY = "1133dc881b63b"
let MOB_SMS_SECRET = "b4882225b9baee69761071c8cfa848f3"
let GoogleAppKey = "AIzaSyCegO8LjPujwaTtxijzowN3kCUQTop8tRA"
// 融云
let RONGCLOUD_IM_APPKEY = "n19jmcy59f1q9"
//@"k51hidwqked9b" //自由主义
//@"n19jmcy59f1q9" //online key
//@"c9kqb3rdkbb8j" //pre key
//@"e0x9wycfx7flq" //offline key
//*****************           微             博           ******************
//*****************               shareSDK               ******************
//*****************           百      度    SDK           ******************
//*****************           科   大   讯   飞           ******************
//*****************           易            信           ******************
//*****************           蓝            牙           ******************
