//
//  User.swift
import UIKit
///FIXME:用户信息
@objcMembers
open class User: NSObject {///账号
    public var account:String?///ID
    public var Id:String?///用户名
    public var name:String?///密码
    public var pwd:String?///真实姓名
    public var realName:String?///头像
    public var logo:String?///口令
    public var token:String?///经度
    public var longitude:Double?///维度
    public var latitude:String?///用户级别
    public var type:String?///用户签名
    public var sign:String?///用户金额
    public var mony:String?///用户状态
    public var status:String?///用户银行卡号
    public var cards:String?///手机号
    public var phone:String?///身份证号
    public var idcard:String?///微信号
    public var wechartnum:String?///QQ号
    public var QQnumber:String?///性别
    public var sex:String?///年龄
    public var age:String?///账号保护
    public var protect:String?///邮箱
    public var email:String?///登录设备
    public var devices:String?///手机系统
    public var system:String?///手机登录的IP地址
    public var IP:String?///地址
    public var address:String?///国家
    public var country:String?///省
    public var province:String?///市
    public var city:String?///县
    public var area:String?///街道
    public var street:String?///语言
    public var language:String?
    public override init() {
        super.init()
    }
    public convenience init(name:String,pwd:String="",account:String?,token:String="") {
        self.init()
        self.name = name
        self.pwd = pwd
        self.account = account
    }
}
