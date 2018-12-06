//
//  FreedomTools.swift
//  Freedom
//
//  Created by Super on 7/5/18.
//  Copyright © 2018 薛超. All rights reserved.
//
import Foundation
import UIKit
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

