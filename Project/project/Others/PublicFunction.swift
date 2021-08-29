//
//  PublicFunction.swift
//  project
//
//  Created by Super on 2017/9/8.
//  Copyright © 2017年 Super. All rights reserved.
//
import UIKit
import Foundation

let APPW = UIScreen.main.bounds.width
let APPH = UIScreen.main.bounds.height
func Dlog<T>(_ message: T,file: String = #file,method: String = #function,line: Int = #line){
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}
func appBundleVersion()->String{
    return Bundle.main.infoDictionary!["bundle version"] as! String
}
func version() -> Float? {
    return Float(UIDevice.current.systemVersion)
}

func documentLocalPath()->String{
    return NSSearchPathForDirectoriesInDomains(.documentationDirectory, .userDomainMask, true)[0]
}
func RGBAColor(_ R:CGFloat,_ G:CGFloat,_ B:CGFloat,_ A:CGFloat = 1) -> UIColor{
    return UIColor(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: A)
}


