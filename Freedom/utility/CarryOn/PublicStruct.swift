//
//  PublicStruct.swift
//  MyCocoaPods
//
//  Created by Chao Xue 薛超 on 2018/12/12.
//  Copyright © 2018 Super. All rights reserved.
//

import UIKit
import Foundation

//MARK: 正则表达式
public enum Regular: String {
    case double = "-?([0-9]\\d*\\.?\\d*)"
    case int = "-?([0-9]*)"
    case phone = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$"
    case email = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$"
    case binary16 = "^#?([a-f0-9]{6}|[a-f0-9]{3})$" // 16进制
    case url = "[a-zA-z]+://[^\\s]*"
    case chinese = "^[\u{2E80}-\u{9FFF}]+$"
    case div = "^<([a-z]+)([^<]+)*(?:>(.*)</1>|\\s+/>)$"
    case userName = "[0-9A-Za-z]*"
    case name = "^[\u{4E00}-\u{9FA5}A-Za-z0-9_]+$"
    case domain = "[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(/.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+/.?"
    case idCard = "^\\d{15}|\\d{18}$"
    case xml = "^([a-zA-Z]+-?)+[a-zA-Z0-9]+\\.[x|X][m|M][l|L]$"
    case QQ = "[1-9][0-9]{4,}"
    case ip = "\\d+\\.\\d+\\.\\d+\\.\\d+"
    case postCode = "[1-9]\\d{5}(?!\\d)" // 邮编
}

/// 系统路径
public struct XPath {
    public let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    public let library = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first
    public let caches = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first
    public let temp = NSTemporaryDirectory()
    public let home = NSHomeDirectory()
}

/// 文件类型
public enum FileType:String {
    case video = "video"
    case gif = "gif"
    case image = "image"
    case text = "text"
    case html = "html"
}

struct Color {
    static let red      = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
    static let green    = #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)
    static let blue     = #colorLiteral(red: 0, green: 0, blue: 1, alpha: 1)
    static let white    = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let black    = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    static let gray     = #colorLiteral(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
    static let lightRay = #colorLiteral(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    static let normal   = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
}

struct Font {
    static let mini   = UIFont.systemFont(ofSize: 9)
    static let small  = UIFont.systemFont(ofSize: 10)
    static let middle = UIFont.systemFont(ofSize: 12)
    static let normal = UIFont.systemFont(ofSize: 14)
    static let big    = UIFont.systemFont(ofSize: 16)
    static let large  = UIFont.systemFont(ofSize: 20)

}
