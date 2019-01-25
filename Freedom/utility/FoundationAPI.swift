
//
// FoundationAPI.swift
// Freedom
import Foundation
//FIXME: Freedom by Super
public struct API {
    ///通用
    enum global: String {
        case comment = "global/comment"//评论列表
        case citys = "global/citys"//城市列表
    }
    ///自由主义
    enum freedom: String {
        case luanch = "luanch"//启动
        case applications = "applications"//应用列表
        case profile = "profile"//用户信息
        case login = "login"//登陆
        case register = "register"//注册
        case sendMcode = "sendMcode"//发送验证码
    }
    ///微信
    enum wechat: String {
        case profile = "wechat/profile"//微信/用户信息
        case pocket = "wechat/pocket"//钱包
        case circleFriends = "wechat/circleFriends"//朋友圈
        case friends = "wechat/friends"//通讯录
        case messageDetailList = "wechat/messageDetailList"//交流的消息列表
        case message = "wechat/message"//微信消息列表
    }
    /// 支付宝
    enum alipay: String {
        case me = "alipay/me"//我的
        case message = "alipay/message"//朋友页面的信息列表
        case friends = "alipay/friends"//朋友
        case mouth = "alipay/mouth"//口碑
        case wealth = "alipay/wealth"//财富
        case home = "alipay/home"//首页
    }
    /// 爱奇艺
    enum iqiyi: String {
        case bubble = "iqiyi/bubble"//泡泡
        case me = "iqiyi/me"//我的
        case vip = "iqiyi/vip"//VIP会员
        case hot = "iqiyi/hot"//热点
        case home = "iqiyi/home"//首页
    }
    ///抖音
    enum douyin: String {
        case me = "douyin/me"//我的
        case message = "douyin/message"//消息
        case notice = "douyin/notice"//关注
        case home = "douyin/home"//首页
    }
    ///淘宝
    enum taobao: String {
        case me = "taobao/me"//我的
        case shopCar = "taobao/shopCar"//购物车
        case message = "taobao/message"//消息
        case mini = "taobao/mini"//微淘
        case home = "taobao/home"//首页
    }
    ///新浪微博
    enum sina: String {
        case me = "sina/me"//新浪微博/我的
        case find = "sina/find"//新浪微博/发现
        case message = "sina/message"//新浪微博/消息列表
        case sinadetail = "sina/sinadetail"//微博详情
        case homeList = "sina/homeList"//新浪微博/首页微博列表
    }
    ///大众点评
    enum people: String {
        case me = "people/me"//我的
        case discussDetail = "people/discussDetail"//评论详情
        case noticeList = "people/noticeList"//关注列表
        case suggest = "people/suggest"//攻略列表
        case detail = "people/detail"//信息详情
        case messageList = "people/messageList"//分类标题下的信息列表
        case topList = "people/topList"//首页顶部功能键及分类列表
    }
    ///今日头条
    enum topic: String {
        case detail = "topic/detail"//新闻详情
        case me = "topic/me"//个人中心
        case list = "topic/list"//新闻列表
    }
    ///微能量
    enum energy: String {
        case connect = "microEnergy/connect"//联系我们
        case superMarket = "microEnergy/superMarket"//精品人人店
        case homeList = "microEnergy/homeList"//首页功能列表
        case dynamic = "microEnergy/dynamic"//最新动态
        case detail = "microEnergy/detail"//公司案例详情
        case industryList = "microEnergy/industryList"//经典行业案例列表
        case demoList = "microEnergy/demoList"//行业内企业案例列表
    }
    ///微信阅读
    enum books: String {
        case books = "freedom/books"//个性特色自由主义
        case list = "books/list"//列表
    }
    enum database: String {
        case database = "database"//我的数据库
    }
    ///酷狗
    enum kugou: String {
        case sing = "kugou/sing"//唱歌列表
        case look = "kugou/look"//看的列表
        case listen = "kugou/listen"//听歌列表
    }
}
enum WebURL: String {
     case TBTejia = "https://tejia.taobao.com/"//淘宝天天特价
     case WXWqsjd = "http://wqs.jd.com/portal/wx/portal_indexV4.shtml?PTAG=17007.13.1&ptype=1"//微信/发现/购物
     case WBLogin = "http://weibo.com/login.php"//微博/登陆
     case WBMovie = "http://movie.weibo.com/"//微博/电影
     case booksHomeURL = "http://ih2.zhangyue.com/zybook4/app/iphone.php?ca=Channel.Index&pk=5B4&usr=i623907218&idfa=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&key=PR957"//书籍收藏首页
     case booksCityRUL = "http://ih2.zhangyue.com/zybk/category/vipCategory" //书籍收藏/书城


     var url: URL? {
        return URL(string: self.rawValue)
     }
}

enum CustomURL: String {
     /// 根据输入的信息推荐要搜索的关键词
     case guessWordURL = "http://is.snssdk.com/2/article/search_sug/?version_code=5.7.7&app_name=news_article&vid=C0136D0B-9B89-4D42-9AE4-78F96CDC2AFF&device_id=22794530286&channel=App%20Store&resolution=750*1334&aid=13&ab_version=72368,82650,79288&ab_feature=z1&ab_group=z1&openudid=29da7256a52d98281947cb96a6357791c40289b9&live_sdk_version=1.3.0&idfv=C0136D0B-9B89-4D42-9AE4-78F96CDC2AFF&ac=WIFI&os_version=9.3.5&ssmix=a&device_platform=iphone&iid=5464891932&ab_client=a1,b1,b7,f2,f7,e1&device_type=iPhone%206&idfa=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&keyword=%@"
     ///根据word搜索相关书籍
     case guessBookURL = "http://ih2.zhangyue.com/zybook4/iphone/u/p/api.php?Act=getSuggestionWithType&word=%E5%8F%B7"
     ///搜索某个书籍
     case searchBookURL = "http://ih2.zhangyue.com/zybook4/iphone/u/p/api.php?zysid=8c3940fb3c3df86f2ea5d6318e91d396&rgt=7&usr=i623907218&pc=10&Act=searchMultiple&currentPage=1&keyWord=%E5%8F%B7%E4%BB%A4%E4%B8%89%E7%95%8C&optMgz=1&pageSize=20&resId=1027191&suggestType=2&type=book&version=2"
     ///试读
     case readBookURL = "http://ih2.zhangyue.com/webintf/Category_Create/FilterBookList?category_id=60&resource_id=13&order=download&info_type=book&status=0&pageSize=20&key=2C_60&pk=1K1&usr=i623907218&rgt=7&p1=181F5D8E709345A0AE22F92766F1F571&p2=111010&p3=657007&p4=501607&p5=1001&p6=AAAAAAAAAAAAAAAAAAAA&p7=AAAAAAAAAAAAAAA&p9=0&p11=584&p16=iPhone7%2C2&p21=00003&p22=iPhone_OS%2C9.3.5&zysid=8c3940fb3c3df86f2ea5d6318e91d396"

     //FIXME:微 能 量 ****/
     //首页四个分类
     case WNAsist2 = "http://wxsyb.bama555.com/data/assist/?&callback=jQuery20308067237965296954_1474263692852&_=1474263692853"
     //主界面信息
     case WNCatelist5 = "http://wxsyb.bama555.com/data/cate_list/?&callback=jQuery20308067237965296954_1474263692862&_=1474263692863"
     //尾巴系列页面
     case WNCatelist6 = "http://wxsyb.bama555.com/data/cate_list/?&callback=jQuery20302716610536444932_1474263728544&_=1474263728545"
     //经典案例
     case WNDetaillist10 = "http://wxsyb.bama555.com/data/detail_list/?&callback=jQuery20308067237965296954_1474263692850&cid=516b6b1eade8d006&_=1474263692865"
     //最新资讯
     case WNDetaillist13 = "http://wxsyb.bama555.com/data/detail_list/?&callback=jQuery20306829270389862359_1474263703369&cid=52de132e34a70051&_=1474263703370"
     //加盟合作
     case WNDetaillist14  = "http://wxsyb.bama555.com/data/detail_list/?&callback=jQuery20307733513773418963_1474263708452&cid=51ff6e85d587f057&_=1474263708453"
     //成交型应用
     case WNDetaillist16 = "http://wxsyb.bama555.com/data/detail_list/?&callback=jQuery20302716610536444932_1474263728532&cid=549b72ee29303037&_=1474263728547"
     //贺卡列表
     case WNGcardtypes = "http://wxsyb.bama555.com/data/gcard/types"
}
