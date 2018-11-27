//
//  AlipayModels.swift
//  Freedom
import UIKit
class AlipayTools: NSObject {
    class func itemsArray() -> [[String:String]] {
        var temp = UserDefaults.standard.object(forKey: "AlipayHomeIconsCacheKey") as? [[String:String]]
        if temp == nil {
            var ntemp = [[String:String]]()
            let names = ["淘宝" ,"生活缴费","教育缴费","红包","物流","信用卡","转账","爱心捐款","彩票","当面付","余额宝","AA付款","国际汇款","淘点点","淘宝电影","亲密付","股市行情","汇率换算"]
            for i in 0..<names.count{
                ntemp.append([names[i]:"alipayHome\(i)"])
            }
            self.saveItemsArray(ntemp)
            temp = ntemp
        }
        return temp!
    }
    
    class func saveItemsArray(_ array: [[String:String]]) {
        UserDefaults.standard.set(array, forKey: "AlipayHomeIconsCacheKey")
        UserDefaults.standard.synchronize()
    }
}
class AlipayAssetsTableViewControllerCellModel: NSObject {
    var title = ""
    var iconImageName = ""
    var destinationControllerClass: AnyClass?
    
    convenience init(title: String?, iconImageName: String?, destinationControllerClass: AnyClass) {
        self.init()
        self.title = title!
        self.iconImageName = iconImageName!
        self.destinationControllerClass = destinationControllerClass
    }
}
class AlipayModels: NSObject {
}
