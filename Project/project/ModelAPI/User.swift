//
//  User.swift
//  project
//
//  Created by Super on 2017/9/8.
//  Copyright © 2017年 Super. All rights reserved.
//

import UIKit
///FIXME:用户信息
class User: NSObject {
    var account:String?//账号
    var Id:String?//ID
    var name:String?//用户名
    var pwd:String?//密码
    var realName:String?//真实姓名
    var logo:String?//头像
    var token:String?//口令
    var longitude:Double?//经度
    var latitude:String?//维度
    var type:String?//用户级别
    var sign:String?//用户签名
    var mony:String?//用户金额
    var status:String?//用户状态
    var cards:String?//用户银行卡号
    var phone:String?//手机号
    var idcard:String?//身份证号
    var wechartnum:String?//微信号
    var QQnumber:String?//QQ号
    var sex:String?//性别
    var age:String?//年龄
    var protect:String?//账号保护
    var email:String?//邮箱
    var devices:String?//登录设备
    var system:String?//手机系统
    var IP:String?//手机登录的IP地址
    var address:String?//地址
    var country:String?//国家
    var province:String?//省
    var city:String?//市
    var area:String?//县
    var street:String?//街道
    var language:String?//语言
    init(with accoun:String,password:String){
        account = accoun
        pwd = password
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
