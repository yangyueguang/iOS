
import UIKit
import RxSwift
//import XCarryOn
import Alamofire
extension XNetKit {
    //FIXME: Freedom
    /// 启动图片
    static func luanch(_ closure: @escaping (_ resource: String) -> Void) {
        self.request(API.freedom.luanch.rawValue, parameters: nil) { (response) in
            print(response.body)
            closure(response.body["luanch"] as! String)
        }
    }
    /// 注册
    static func sendMcode(_ parameters: Parameters, closure: @escaping (_ code: String) -> Void) {
        request(API.freedom.sendMcode.rawValue, parameters: parameters) { (response) in
            print(response.body)
            closure(response.body["code"] as! String)
        }
    }
    /// 注册
    static func register(_ parameters: Parameters, closure: @escaping (_ success: Bool) -> Void) {
        request(API.freedom.register.rawValue, parameters: parameters) { (response) in
            print(response.body)
            closure(true)
        }
    }
    /// 登陆
    static func login(_ param: Parameters, closure: @escaping (_ success: Bool) -> Void) {
        request(API.freedom.login.rawValue, parameters: param) { (response) in
            print(response.body)
            closure(true)
        }
    }
    /// 获取用户信息
    static func profile(_ param: Parameters, next: PublishSubject<User>) {
        request(API.freedom.profile.rawValue, parameters: param) { (response) in
            let user = User.parse(response.body as NSDictionary)
            next.onNext(user)
        }
    }

    //FIXME: 通用
    /// 通用评论列表
    static func comment(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.global.comment.rawValue, parameters: param, method: .get) { (response) in
            next.onNext(response)
        }
    }
    /// 通用城市列表
    static func citys(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.global.citys.rawValue, parameters: param, method: .get) { (response) in
            next.onNext(response)
        }
    }

    //FIXME: 微信
    /// 微信/用户信息
    static func wechatProfile(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.wechat.profile.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 微信/钱包
    static func wechatPocket(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.wechat.pocket.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 微信/朋友圈
    static func wechatCircleFriends(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.wechat.circleFriends.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 微信/通讯录
    static func wechatFriends(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.wechat.friends.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 微信/交流的消息列表
    static func wechatCircleMessageDetailList(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.wechat.messageDetailList.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 微信/微信消息列表
    static func wechatMessage(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.wechat.message.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }

    //FIXME: 支付宝
    /// 支付宝/我的
    static func alipayMe(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.alipay.me.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 支付宝/朋友页面的信息列表
    static func alipayMessage(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.alipay.message.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 支付宝/朋友
    static func alipayFriends(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.alipay.friends.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 支付宝/口碑
    static func alipayMouth(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.alipay.mouth.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 支付宝/财富
    static func alipayWealth(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.alipay.wealth.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 支付宝/首页
    static func alipayHome(_ param: Parameters, next: PublishSubject<AlipayHomeModel>) {
        request(API.alipay.home.rawValue, parameters: param) { (response) in
            print(response.dictionary)
            let model = AlipayHomeModel.parse(response.body as NSDictionary)
            next.onNext(model)
        }
    }

    //FIXME: 爱奇艺
    /// 爱奇艺/泡泡
    static func iqiyiBubble(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.iqiyi.bubble.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 爱奇艺/我的
    static func iqiyiMe(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.iqiyi.me.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 爱奇艺/VIP会员
    static func iqiyiVip(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.iqiyi.vip.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 爱奇艺/热点
    static func iqiyiHot(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.iqiyi.hot.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 爱奇艺/首页
    static func iqiyiHome(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.iqiyi.home.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }

    //FIXME: 抖音
    /// 抖音/我的
    static func douyinMe(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.douyin.me.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 抖音/消息
    static func douyinMessage(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.douyin.message.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 抖音/关注
    static func douyinNotice(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.douyin.notice.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 抖音/首页
    static func douyinHome(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.douyin.home.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }

    //FIXME: 淘宝
    /// 淘宝/我的
    static func taobaoMe(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.taobao.me.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 淘宝/购物车
    static func taobaoShopCar(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.taobao.shopCar.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 淘宝/消息
    static func taobaoMessage(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.taobao.message.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 淘宝/微淘
    static func taobaoMini(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.taobao.mini.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 淘宝/首页
    static func taobaoHome(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.taobao.home.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }

    //FIXME: 新浪微博
    /// 新浪微博/我的
    static func sinaMe(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.sina.me.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 新浪微博/发现
    static func sinaFind(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.sina.find.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 新浪微博/消息列表
    static func sinaMessage(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.sina.message.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 新浪微博/微博详情
    static func sinaSinadetail(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.sina.sinadetail.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 新浪微博/首页微博列表
    static func sinaHomeList(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.sina.homeList.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }

    //FIXME: 大众点评
    /// 大众点评/我的
    static func peopleMe(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.people.me.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 大众点评/评论详情
    static func peopleDiscussDetail(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.people.discussDetail.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 大众点评/关注列表
    static func peopleNoticeList(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.people.noticeList.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 大众点评/攻略列表
    static func peopleSuggest(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.people.suggest.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 大众点评/信息详情
    static func peopleDetail(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.people.detail.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 大众点评/分类标题下的信息列表
    static func peopleMessageList(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.people.messageList.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 大众点评/首页顶部功能键及分类列表
    static func peopleTopList(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.people.topList.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }

    //FIXME: 今日头条
    /// 今日头条/新闻详情
    static func topicDetail(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.topic.detail.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 今日头条/个人中心
    static func topicMe(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.topic.me.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 今日头条/新闻分类列表
    static func topicList(_ param: Parameters, next: PublishSubject<[BaseModel]>) {
        request(API.topic.list.rawValue, parameters: param) { (response) in
            let topicsTemp = response.body["list"] as! [Any]
            let topics = BaseModel.parses(topicsTemp) as! [BaseModel]
            next.onNext(topics)
        }
    }
    /// 今日头条/某个分类的新闻列表
    static func topicNewsList(_ url: String, next: PublishSubject<TopicModel>) {
        get(url) { (response) in
            let model = TopicModel.parse(response.body as NSDictionary)
            next.onNext(model)
        }
    }

    //FIXME: 微能量
    /// 微能量/联系我们
    static func microEnergyConnect(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.energy.connect.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 微能量/精品人人店
    static func microEnergySuperMarket(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.energy.superMarket.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 微能量/首页功能列表
    static func microEnergyHomeList(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.energy.homeList.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 微能量/最新动态
    static func microEnergyDynamic(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.energy.dynamic.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 微能量/公司案例详情
    static func microEnergyDetail(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.energy.detail.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 微能量/经典行业案例列表
    static func microEnergyIndustryList(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.energy.industryList.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 微能量/行业内企业案例列表
    static func microEnergyDemoList(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.energy.demoList.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }

    //FIXME: 个性特色自由主义
    /// 个性特色自由主义
    static func freedomBooks(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.books.books.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }

    //FIXME: 微信阅读
    /// 微信阅读/列表
    static func booksList(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.books.list.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }

    //FIXME: 我的数据库
    /// 我的数据库
    static func database(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.database.database.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }

    //FIXME: 酷狗
    /// 酷狗/唱歌列表
    static func kugouSing(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.kugou.sing.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 酷狗/看的列表
    static func kugouLook(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.kugou.look.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
    /// 酷狗/听歌列表
    static func kugouListen(_ param: Parameters, next: PublishSubject<Any>) {
        request(API.kugou.listen.rawValue, parameters: param) { (response) in
            next.onNext(response)
        }
    }
}
