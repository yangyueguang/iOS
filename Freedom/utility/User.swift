//
//  User.swift
import UIKit
///FIXME:用户信息
@objcMembers
open class User: NSObject {
    static let shared = User()///账号
    public var account:String = "2829969299"///ID
    public var Id:String = "Super"///用户名
    public var name:String = "123456"///密码
    public var pwd:String = "薛超"///真实姓名
    public var realName:String = ""///头像
    public var logo:String = ""///口令
    public var token:String = "236982929823"///经度
    public var longitude:Double = 121.33///维度
    public var latitude:Double = 31.22///用户级别
    public var type:String = "1"///用户签名
    public var sign:String = ""///用户金额
    public var mony:Double = 100.00///用户状态 -1未登录 0 登录成功 1 登录失败
    public var status:Int = -1///用户银行卡号
    public var cards:String = ""///手机号
    public var phone:String = "18721064516"///身份证号
    public var idcard:String = "34122219900717525X"///微信号
    public var wechartnum:String = "2829969299"///QQ号
    public var QQnumber:String = "2829969299"///性别
    public var sex:Bool = true///年龄
    public var age:Int = 25///账号保护
    public var protect:String = "2829969299@qq.com"///邮箱
    public var email:String = ""///登录设备
    public var devices:String = ""///手机系统
    public var system:String = ""///手机登录的IP地址
    public var IP:String = ""///地址
    public var address:String = ""///国家
    public var country:String = ""///省
    public var province:String = ""///市
    public var city:String = ""///县
    public var area:String = ""///街道
    public var street:String = ""///语言
    public var language:String = "cn"
    public override init() {
        super.init()
    }
}
