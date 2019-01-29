//
//  FoundationImage.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2019/1/29.
//  Copyright © 2019 薛超. All rights reserved.
//

import Foundation

enum Image: String {
    case `default` = "userLogo1"
    case logo = "userLogo"
    case code = "u_QRCode"
    var image: UIImage {
        let ima = UIImage(asset: rawValue)
        assert(ima != nil, "图片资源丢失\(rawValue)")
        return ima!
    }
}
enum WXImage: String {
    case `default` = "userLogo"
    case icon = "icon"
    case addFriend = "u_white_addfriend"
    case add = "u_message_add"
    case addHL = "u_message_addHL"
    var image: UIImage {
        let ima = UIImage(asset: rawValue)
        assert(ima != nil, "图片资源丢失\(rawValue)")
        return ima!
    }
}
enum ALImage: String {
    case icon = ""
    var image: UIImage {
        let ima = UIImage(asset: rawValue)
        assert(ima != nil, "图片资源丢失\(rawValue)")
        return ima!
    }
}
extension UIImage {
    convenience init?(asset: String) {
        self.init(named: asset, in: Bundle.main, compatibleWith: nil)
    }
}
