//
//  FreedomTools.swift
//  Freedom
//
//  Created by Super on 7/5/18.
//  Copyright © 2018 薛超. All rights reserved.
//
import Foundation
import UIKit
import Social
import LocalAuthentication
import RealmSwift
import Realm
public var realmWX: RLMRealm!
public func BoldFont(_ fontSize:CGFloat)->UIFont{
    return UIFont.boldSystemFont(ofSize: fontSize)
}
public func FFont(_ size: CGFloat) -> UIFont{
    return UIFont.systemFont(ofSize: size)
}
///苹果自带的社会化分享,type是静态字符串:SLServiceTypeTwitter,Facebook,SinaWeibo,TencentWeibo,LinkedIn
func appleLocalShare(_ fromVC:UIViewController, _ title:String,image:UIImage? ,_ type:String = SLServiceTypeFacebook){
    let cvv = SLComposeViewController(forServiceType:type)
    cvv?.setInitialText(title)
    if let aimage = image {
        cvv?.add(aimage)
    }
    cvv?.completionHandler = { result in
        if result == .cancelled {
            print("取消发送")
        } else {
            print("发送完毕")
        }
    }
    fromVC.present(cvv!, animated: true)
}
///验证TouchID
func checkTouchID(){
    var error: NSError?
    if #available(iOS 8.0, *) {
        let isTouchIdAvailable = LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,error: &error)
        if isTouchIdAvailable{
            NSLog("恭喜，Touch ID可以使用！")
            //步骤2：获取指纹验证结果
            LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "需要验证您的指纹来确认您的身份信息", reply: {
                (success, error) -> Void in
                if success{
                    NSLog("恭喜，您通过了Touch ID指纹验证！")
                }else{
                    NSLog("抱歉，您未能通过Touch ID指纹验证！\n\(String(describing: error))")
                }
            })
        }
    }else{
        NSLog("抱歉，Touch ID不可以使用！\n\(String(describing: error))")
    }
}
struct Student: Codable {
    var name: String?
}
public extension Encodable {
    /// 将 model 编码成参数字典
    public func fd_toDic() -> [String: Any] {
        do {
            let data = try JSONEncoder().encode(self)
            let dic = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            return dic ?? [:]
        } catch {
            print(error)
            return [:]
        }
    }
}

public extension Decodable {
    // 将字典解码成 model
    public static func fd_fromDic(dic: [String: Any?]) throws -> Self {
        let jsonData = try JSONSerialization.data(withJSONObject: dic)
        let model = try JSONDecoder().decode(Self.self, from: jsonData)
        return model
    }
}
