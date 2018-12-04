
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
public func Font(_ fontSize:CGFloat)->UIFont{
    return UIFont.systemFont(ofSize: fontSize)
}
public func BoldFont(_ fontSize:CGFloat)->UIFont{
    return UIFont.boldSystemFont(ofSize: fontSize)
}
public func Dlog<T>(_ message: T, file: String = #file,method: String = #function,line: Int = #line){
    #if DEBUG
    print("\n\((file as NSString).lastPathComponent)[\(line)]: \(method)\n\(message)")
    #endif
}
public var TopHeight:CGFloat {
    if APPH >= 812.0{
        return 88.0
    }
    return 64.0
}
public let fontTitle = Font(15)
public let fontnomal = Font(13)
public let fontSmallTitle = Font(14)
public let clearcolor = UIColor.clear
public let gradcolor  = UIColor(224, 225, 226, 1)
public let redcolor = UIColor(229, 59, 25, 1)
public let yellowcolor = UIColor.yellow
public let greencolor = UIColor.green
public let whitecolor = UIColor.white
public let blacktextcolor = UIColor(33, 34, 35, 1)
public let gradtextcolor = UIColor(116, 117, 118, 1)
public let APPH = UIScreen.main.bounds.size.height
public let graycolor = UIColor.gray
public let TabBarH:CGFloat = 49
public let APPW = UIScreen.main.bounds.size.width
public let UMENG_APPKEY = "563755cbe0f55a5cb300139c"
/*爱奇艺主界面的数据*/
public let urlWithHomeData = "http://api.3g.tudou.com/v4/home?guid=7066707c5bdc38af1621eaf94a6fe779&idfa=ACAF9226-F987-417B-A708-C95D482A732D&ios=1&network=WIFI&operator=%E4%B8%AD%E5%9B%BD%E8%81%94%E9%80%9A_46001&ouid=10099212c9e3829656d4ea61e3858d53253b2f07&pg=1&pid=c0637223f8b69b02&pz=30&show_url=1&vdid=9AFEE982-6F94-4F57-9B33-69523E044CF4&ver=4.9.1"
/*爱奇艺泡泡分类的数据*/
public let urlWithclassifyData = "http://api.3g.tudou.com/v4_5/recommended_channels?excludeNew=0&guid=7066707c5bdc38af1621eaf94a6fe779&idfa=ACAF9226-F987-417B-A708-C95D482A732D&network=WIFI&operator=%E4%B8%AD%E5%9B%BD%E8%81%94%E9%80%9A_46001&ouid=10099212c9e3829656d4ea61e3858d53253b2f07&pg=1&pid=c0637223f8b69b02&pz=30&vdid=9AFEE982-6F94-4F57-9B33-69523E044CF4&ver=4.9.1"
/*爱奇艺发现的数据*/
public let urlWithDiscoverData = "http://discover.api.3g.tudou.com/v4_7/rec_discover?guid=7066707c5bdc38af1621eaf94a6fe779&idfa=ACAF9226-F987-417B-A708-C95D482A732D&network=WIFI&operator=%E4%B8%AD%E5%9B%BD%E8%81%94%E9%80%9A_46001&ouid=10099212c9e3829656d4ea61e3858d53253b2f07&pg=1&pid=c0637223f8b69b02&pz=30&vdid=9AFEE982-6F94-4F57-9B33-69523E044CF4&ver=4.9.1"
/*爱奇艺订阅的数据*/
public let urlWithSubscribeData = "http://user.api.3g.tudou.com/v4_3/user/sub/update?guid=7066707c5bdc38af1621eaf94a6fe779&idfa=ACAF9226-F987-417B-A708-C95D482A732D&network=WIFI&operator=%E4%B8%AD%E5%9B%BD%E8%81%94%E9%80%9A_46001&ouid=10099212c9e3829656d4ea61e3858d53253b2f07&pg=1&pid=c0637223f8b69b02&pz=20&ty=0&u_item_size=3&update_time=0&vdid=9AFEE982-6F94-4F57-9B33-69523E044CF4&ver=4.9.1"
public let TestWebURL = "https://www.baidu.com"
