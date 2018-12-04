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
public func W(_ obj:UIView?)->CGFloat{
    if obj != nil {
        return obj!.frame.size.width
    }else{
        return 0
    }
}
public func H(_ obj:UIView?)->CGFloat{
    if obj != nil {
        return obj!.frame.size.height
    }else{
        return 0
    }
}
public func X(_ obj:UIView?)->CGFloat{
    if obj != nil {
        return obj!.frame.origin.x
    }else{
        return 0
    }
}
public func Y(_ obj:UIView)->CGFloat{
    return obj.frame.origin.y
}
public func XW(_ obj:UIView?)->CGFloat{
    if obj != nil{
        return obj!.frame.origin.x + obj!.frame.size.width
    }else{
        return 0
    }
}
public func YH(_ obj:UIView?)->CGFloat{
    if obj != nil{
        return obj!.frame.origin.y + obj!.frame.size.height
    }else{
        return 0
    }
}

///验证TouchID
func checkTouchID(){
    //步骤1：检查Touch ID是否可用
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
