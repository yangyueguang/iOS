
//
//  FoundationAPI.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/21.
//  Copyright © 2018 薛超. All rights reserved.
//

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
    ///个人应用
    enum apply: String {
        case companyDetail = "personalApply/companyDetail"//公司详情
        case companyList = "personalApply/companyList"//企业列表
        case industryList = "personalApply/industryList"//行业列表
    }
    ///书籍收藏
    enum books: String {
        case books = "freedom/books"//个性特色自由主义
        case list = "books/list"//列表
    }
    enum database: String {
        case database = "database"//我的数据库
    }
    ///个人简历
    enum resume: String {
        case theory = "resume/theory"//理论体系
        case business = "resume/business"//事业合作
        case home = "resume/home"//首页
    }
    ///聚合数据
    enum juhe: String {
        case dynamics = "juhe/dynamics"//动态列表
        case apis = "juhe/apis"//数据接口
        case questions = "juhe/questions"//常见问题
        case connect = "juhe/connect"//联系我们
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

    //FIXME:聚合数据*******************/
    case JHLogin =   "http://m.juhe.cn/login"//
    case JHCN =   "https://www.juhe.cn/"//
    case JHCodeCN =   "https://code.juhe.cn"//
    case JHData =   "http://m.juhe.cn/data"//首页
    case JHQA =   "http://m.juhe.cn/qa"//问题
    case JHDocsapiid =   "https://www.juhe.cn/docs/api/id/235"//API数据代码
    case JH =   "http://m.juhe.cn/"//数据接口
    case JHNews =   "http://m.juhe.cn/news"//聚合动态
    case TTGoodClass = "https://learning.snssdk.com/feoffline/toutiao_wallet_bundles/toutiao_wallet_web_page/page/channel.html"// 今日头条/精品课


    var url: URL? {
        return URL(string: self.rawValue)
    }
}

enum CustomURL: String {
    /// 根据输入的信息推荐要搜索的关键词
    case TTIsArticleSearchsug = "http://is.snssdk.com/2/article/search_sug/?version_code=5.7.7&app_name=news_article&vid=C0136D0B-9B89-4D42-9AE4-78F96CDC2AFF&device_id=22794530286&channel=App%20Store&resolution=750*1334&aid=13&ab_version=72368,82650,79288&ab_feature=z1&ab_group=z1&openudid=29da7256a52d98281947cb96a6357791c40289b9&live_sdk_version=1.3.0&idfv=C0136D0B-9B89-4D42-9AE4-78F96CDC2AFF&ac=WIFI&os_version=9.3.5&ssmix=a&device_platform=iphone&iid=5464891932&ab_client=a1,b1,b7,f2,f7,e1&device_type=iPhone%206&idfa=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&keyword=%@"
}
//FIXME:酷          狗*******************/酷 狗 图片size一律为600

public let RECOMMEND          =   "http://iosservice.kugou.com/api/v3/recommend/index?plat=2&showtype=1"//乐库推荐订阅
public let RANKTOTAL          =   "http://iosservice.kugou.com/api/v3/rank/list"//排行总界面各种排行榜列表
public let BANNER             =   "http://ioscdn.kugou.com/api/v3/banner/index?plat=2&count=5"//歌单总界面横幅图片
public let CATEGORY           =   "http://ioscdn.kugou.com/api/v3/category/list"//歌单总界面分类列表
public let FMALL              =   "http://lib3.service.kugou.com/index.php?cmd=12&ver=4070&pid=ios"//电台全部
func RANKDETAIL(_ rankid:String,_ ranktype: Int,_ page: Int,_ pagesize: Int) -> String {
return "http://ioscdn.kugou.com/api/v3/rank/song?rankid=\(rankid)&ranktype=\(ranktype)&page=\(page)&pagesize=\(pagesize)"//排行具体界面
}
func SPECIALLIST(_ categoryid: String,_ page: Int,_ pagesize: Int) ->String {
    return "http://ioscdn.kugou.com/api/v3/category/special?categoryid=\(categoryid)&page=\(page)&pagesize=\(pagesize)"//歌单二级界面分类列表
}
func MUSICURL(_ hash: String) -> String {
    return "http://cloud.kugou.com/app/checkIllegal.php?hash=\(hash)"//歌曲信息
}
func MUSICINFO(_ hash:String) -> String {
return "http://m.kugou.com/app/i/getSongInfo.php?hash=\(hash)&cmd=playInfo"
}
func SINGER(_ type: Int) -> String{
    return "http://ioscdn.kugou.com/api/v3/singer/recommend?type=\(type)"//歌手列表(语言)
}
func SINGERCAT(_ type: Int,_ sextype: Int) -> String {
return "http://ioscdn.kugou.com/api/v3/singer/list?type=\(type)&sextype=\(sextype)&showtype=2"//歌手列表(语言,性别)
}
func SINGERSONG(_ singerid: String,_ page: Int,_ pagesize: Int) -> String {
    return "http://ioscdn.kugou.com/api/v3/singer/song?singerid=\(singerid)&page=\(page)&pagesize=\(pagesize)"//歌手音乐列表(单曲)
}
func SINGERALBUM(_ singerid: String,_ page: Int,_ pagesize: Int) -> String {
    return "http://ioscdn.kugou.com/api/v3/singer/album?singerid=\(singerid)&page=\(page)&pagesize=\(pagesize)"//歌手音乐列表(专辑)
}
func SINGERINFO(_ singerid: String) -> String {
return "http://iosservice.kugou.com/api/v3/singer/info?singerid=\(singerid)"//歌手头像
}
func ALBUMINFO(_ albumid: String) -> String {
    return "http://ioscdn.kugou.com/api/v3/album/info?albumid=\(albumid)"//专辑信息
}
func ALBUMSONG(_ albumid: String) -> String {
return "http://ioscdn.kugou.com/api/v3/album/song?albumid=\(albumid)&page=1&pagesize=-1&plat=2"//专辑歌曲
}
func FULLPATH(_ filename: String) -> String {
return "\(NSHomeDirectory())/Documents/\(filename).mp3"//本地歌曲的完整地址
}
func SINGERMV(_ singerid: String,_ singername: String,_ page: Int,_ pagesize: Int) -> String {
    return "http://ioscdn.kugou.com/api/v3/singer/mv?singerid=\(singerid)&singername=\(singername)&page=\(page)&pagesize=\(pagesize)"//MV列表
}
func FMMUSIC(_ offset0: String,_ fmtype0: String,_ offset: String,_ fmid0: String)-> String{
    return "http://lib3.service.kugou.com/index.php?size=20&pid=ios&offset0=\(offset0)&ver=4070&fmtype0=\(fmtype0)&offset=\(offset)&fmcount=1&fmid0=\(fmid0)"//电台歌单
}
public let TBaiduRestserver1 =   "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.search.catalogSug&format=json&query=%E5%B0%8F%E8%8B%B9%E6%9E%9C"   //搜索建议
public let TBaiduRestserver2 =   "http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.search.suggestion&query=%E5%B0%8F%E8%8B%B9%E6%9E%9C&format=json&from=ios&version=2.1.1"  //搜索建议：只有歌名
public let TBaiduRestserver3 =   "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.search.common&format=json&query=%E5%B0%8F%E8%8B%B9%E6%9E%9C&page_no=1&page_size=30" //搜索结果
public let TBaiduRestserver4 =   "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.artist.getList&format=json&order=1&offset=0&limit=5"
public let TBaiduRestserver5 =   "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.billboard.billList&format=json&type=1&offset=0&size=50"  //新歌榜
public let TBaiduRestserver6 =   "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.billboard.billList&format=json&type=2&offset=0&size=50" //热歌榜注意这个和上边的区别，type=1
public let TBaiduRestserver7 =   "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.billboard.billList&format=json&type=8&offset=0&size=507" //Hito中文榜
public let TBaiduRestserver8 =   "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.billboard.billList&format=json&type=18&offset=0&size=50"  // Hito中文榜
public let TBaiduRestserver9 =   "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.billboard.billList&format=json&type=6&offset=0&size=50"  // KTV热歌榜
public let TBaiduRestserver10 =  "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.radio.getCategoryList&format=json"  //电台列表
public let TBaiduRestserver11 =  "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.radio.getChannelSong&format=json&pn=0&rn=10&channelname=public_tuijian_ktv"  //获取某个电台下的歌曲列表
public let TBaiduRestserver12 =  "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.song.getInfos&format=json&songid=8059247&ts=1408284347323&e=JoN56kTXnnbEpd9MVczkYJCSx%2FE1mkLx%2BPMIkTcOEu4%3D&nw=2&ucf=1&res=1"   //获取songid的歌曲信息
public let TBaiduRestserver13 =  "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.artist.get72HotArtist&format=json&order=1&offset=0&limit=50"  //歌手列表
public let TBaiduRestserver14 =  "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.artist.getinfo&format=json&tinguid=7994"  //歌手简介，tinguid为歌手id
public let TBaiduRestserver15 =  "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.artist.getSongList&format=json&order=2&tinguid=7994&offset=0&limits=50"  //歌手歌曲列表，tinguid为歌手id
public let TBaiduRestserver16 =  "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.plaza.getRecommendAlbum&format=json&offset=0&limit=50"  //新碟上架
public let TBaiduRestserver17 =  "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.album.getAlbumInfo&format=json&album_id=122314357"  //专辑信息
public let TBaiduRestserver18 =  "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.plaza.getNewSongs&format=json&limit=50"//新歌速递
/******************听*******************/
public let KGBanner           =   "http://mvads.kugou.com/mobile/?type=1&version=8200"//启动广告,没有图片，只有跳转链接
public let KGAdsflash         =   "http://ads.service.kugou.com/v1/mobile_flash?plat=2&version=8200&pre_ad=1"//竖屏banner有图片无跳转
public let KGVIPPage          =   "http://m.kugou.com/vip/v2/vippage.html"//VIP中心
public let KGSearchSong       =   "http://ioscdn.kugou.com/api/v3/search/song?keyword=%@&page=1&pagesize=30"//根据关键词搜索歌曲列表
public let KGNewAPPSearchphp  =   "http://ioscdn.kugou.com/new/app/i/search.php?cmd=302&keyword=%@"//根据关键词筛选出推荐搜索的关键词及个数
public let KGTrackercdnV2     =   "http://trackercdn.kugou.com/i/v2/?cmd=25&pid=%d&hash=afee18a8283701f25b71d8a6cf7697bc&key=dd39bb50b704838e49765144d40f57fe&behavior=play"//歌曲下载链接根据pid和hash还有key
public let KGLyricsSearch     =   "http://lyrics.kugou.com/search?ver=1&keyword=%E9%85%92%E5%B9%B2%E5%80%98%E5%8D%96%E6%97%A0&hash=afee18a8283701f25b71d8a6cf7697bc"//歌词下载根据keyword和hash值获取accesskey和id
public let KGLyricsDownload   =   "http://lyrics.kugou.com/download?id=16629393&accesskey=927C03F3D7F98A122B363F69808F0F5D&ver=1&fmt=krc"//根据上面的accesseskey和id获取歌词内容
public let KGServiceFmbanner  =   "http://ads.service.kugou.com/v1/mobile_fmbanner?appid=1000&clientver=8200&clienttime=1474248821&key=00f1890520bb0ed49a0de1f3bea5b5d4"//广告banner
public let KGServiceYuekuspecialRecommend =  "http://service.mobile.kugou.com/v1/yueku/multi_special_recommend?hash=1c0e79230db3a127ff9d7e252ac9d650"//
public let KGServiceYueKuRecommend =  "http://service.mobile.kugou.com/v1/yueku/recommend?type=7&plat=2&version=8200&operator=1"//没用
public let KGIoscdnRanklist   =   "http://ioscdn.kugou.com/api/v3/rank/list?withsong=1"//某种列表
public let KGRadioliveHotlist =   "http://radiolive.mobile.kugou.com/hot_list/0/0"//热播列表
public let KGRadioliveRankLocation =  "http://radiolive.mobile.kugou.com/v7/rank/location/30"//广播列表
/******************看*******************/
public let KGServiceShowBanner =  "http://service.mobile.kugou.com/v1/show/banner?plat=1&version=8200"//banner
public let KGServiceVspecialdetail =  "http://service.mobile.kugou.com/v1/mv/vspecialdetail?vid=51190"//banner 根据vid的banner
public let KGAcshowindexGetclassify =  "http://acshow.kugou.com/show7/json/v2/cdn/index/getclassify?platform=2&version=8200"//分类列表
public let KGAcshowRankCityPage =  "http://acshow.kugou.com/show7/rank/json/v2/cdn/banner/get_banner?platform=2&version=8200"//主播列表
public let KGToolsPerfomGetbycity =  "http://tools.mobile.kugou.com/api/v1/perform/get_by_city?plat=2&version=8200&city=%@"//根据城市看直播
public let KGIoscdnMultBanner =   "http://ioscdn.kugou.com/api/v3/mv/multBanner?plat=2&version=8200"//banner
public let KGIoscdnRecommend  =   "http://ioscdn.kugou.com/api/v3/mv/recommend?plat=2&version=8200"//baner
public let KGIoscdnList       =   "http://ioscdn.kugou.com/api/v3/mv/tagListV2?plat=2"//分类
public let KGIoscdnTagListv2  =   "http://ioscdn.kugou.com/api/v3/mv/list?type=1&page=2&pagesize=20&plat=2"//banner
public let KGIoscdnTagMvs     =   "http://ioscdn.kugou.com/api/v3/mv/tagMvsV2?type=2&ids=&page=1&pagesize=20"//获取mv列表
public let KGIoscdnYuekuphp1  =   "http://ioscdn.kugou.com/new/app/i/yueku.php?cmd=104&singer=%@"//获取歌手的图片
public let KGTrackermvindex   =   "http://trackermv.kugou.com/interface/index/cmd=100&hash=DA27295F2033CAF3DE512020F9BBB200&key=1225a00b7b2a962a8e0745363b4b8299&pid=1&ext=mp4"//根据hash和key下载mv
/******************唱*******************/
public let KGAcsingSongnewHundred  =   "http://acsing.kugou.com/sing7/song/json/v2/cdn/song_new_hundred.do?platform=2&sign=39f12683b7697f55&pageSize=100&version=8200"//
public let KGAcsingListhtml        =   "http://acsing.kugou.com/sing7/web/static/mobile/KSongGame/views/list.html?sign=051e5eb1"//
public let KGAcsingActivityIndex   =   "http://acsing.kugou.com/sing7/web/activity/index?sign=051e5eb1"//



//FIXME:爱奇艺*******************/
public let QYIfaceHotdoc       =   "http://iface.iqiyi.com/api/hotDoc?key=8e48946f144759d86a50075555fd5862&type=json"//banner
public let QYIfaceGetNewAdinfo =   "http://iface.iqiyi.com/api/getMyMenu?key=8e48946f144759d86a50075555fd5862&type=json&version=7.8"//banner
public let QYIfaceGetdiscover  =   "http://iface.iqiyi.com/api/getDiscover?key=8e48946f144759d86a50075555fd5862&type=json&version=7.8"//banner
public let QYCmtsEpconfig      =   "http://cmts.iqiyi.com/emoticon/ep_config.json"//泡泡表情包
public let QYLdownloadaction   =   "http://l.rcd.iqiyi.com/apis/mbd/download.action?agent_type=20&version=7.8&auth=c3Q7OJjyl8O1MXwm1W1WuBuGZLrKsaBYY2VMrbAZm2ihfEAucRUm2QSUm2SZ1m19HWdR5ls72&page_num=1&page_size=3"//刷新首页视频列表
/******************服务*******************/
public let QYYueduHome4          =   "http://api.yuedu.iqiyi.com/book/home?apiKey=&appVer=1.8.0&gender=wenxue&md5=684774c94bdf749b512e8889306c1d62&qiyiId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&srcPlatform=12&timeStamp=409514&userId=1233167644"//不清楚
public let QYYueduHome5          =   "http://api.yuedu.iqiyi.com/book/home?apiKey=&appVer=1.8.0&gender=male&md5=684774c94bdf749b512e8889306c1d62&qiyiId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&srcPlatform=12&timeStamp=409514&userId=1233167644"//列表
public let QYYueduHome6          =   "http://api.yuedu.iqiyi.com/book/home?apiKey=&appVer=1.8.0&gender=female&md5=684774c94bdf749b512e8889306c1d62&qiyiId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&srcPlatform=12&timeStamp=409514&userId=1233167644"//列表
public let QYYueduFont           =   "http://api.yuedu.iqiyi.com/book/font?appVer=1.8.0&md5=684774c94bdf749b512e8889306c1d62&qiyiId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&srcPlatform=12&timeStamp=409514&userId=1233167644"//列表
public let QYYueduCategory       =   "http://api.yuedu.iqiyi.com/book/category?apiKey=NUE5Nzc0QzctMDhGMy00QjE2LUE0RDMtNzBCMzZCQjMyQTQ3zzz&appVer=1.8.0&gender=wenxue%2Cmale%2Cfemale&md5=684774c94bdf749b512e8889306c1d62&qiyiId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&srcPlatform=12&timeStamp=409514&userId=1233167644"//列表
public let QYQiyuSale            =   "http://qiyu.iqiyi.com/book/top/sale?appVer=1.8.0&area=m_cabbage&md5=684774c94bdf749b512e8889306c1d62&num=10&ppuid=1233167644&qiyiId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&timeStamp=409514&userId=1233167644"//列表
public let QYPiaoUsers           =   "http://piao.iqiyi.com/f/h5/v1/app/users/1233167644?src=ios&format=json&deviceId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&platform=iPhone&mkey=8e48946f144759d86a50075555fd5862&version=7.8&passportId=1233167644&pps=0&tkversion=5.3&location=121.498923,31.279685&gateway=fx:fx01&sessionId=49328400743471474253552000000000"//获取个人资料
public let QYPiaoMovieRecommend  =   "http://piao.iqiyi.com/f/h5/v1/app/movie/recommend/?locationOrCityId=1400254893&src=ios&format=json&tkversion=5.3&src=ios&format=json&deviceId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&platform=iPhone&mkey=8e48946f144759d86a50075555fd5862&version=7.8&passportId=1233167644&pps=0&tkversion=5.3&deviceId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&passportId=1233167644&gateway=fx:fx01&sessionId=34916217150031474253552000000000"//列表
public let QYPiaoCinemalist      =   "http://piao.iqiyi.com/f/h5/v1/app/cinemaList/121.498923,31.279685/1400254893/0/0/0/1233167644?src=ios&format=json&deviceId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&platform=iPhone&mkey=8e48946f144759d86a50075555fd5862&version=7.8&passportId=1233167644&pps=0&tkversion=5.3&uid=1233167644&imei=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&gateway=fx:fx01&sessionId=-5935241422571474253552000000000"//列表
public let QYPiaoCinemaRecommend =   "http://piao.iqiyi.com/f/h5/v1/app/cinema/recommend/121.494260,31.279545/1400254893/0/0/0/1233167644?src=ios&format=json&tkversion=5.3&src=ios&format=json&deviceId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&platform=iPhone&mkey=8e48946f144759d86a50075555fd5862&version=7.8&passportId=1233167644&pps=0&tkversion=5.3&deviceId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&gateway=fx:fx01&sessionId=49762826167951474253553000000000"//列表
public let QYPiaoMovieInfo       =   "http://piao.iqiyi.com/f/h5/v1/app/movieInfo/1401277599/1400254893/1233167644?src=ios&format=json&deviceId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&platform=iPhone&mkey=8e48946f144759d86a50075555fd5862&version=7.8&passportId=1233167644&pps=0&tkversion=5.3&location=121.498892,31.279727&gateway=fx:fx03&sessionId=-3833660550301474253573000000000"//列表
public let QYPiaoAppusers        =   "http://piao.iqiyi.com/f/h5/v1/app/users/1233167644?src=ios&format=json&deviceId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&platform=iPhone&mkey=8e48946f144759d86a50075555fd5862&version=7.8&passportId=1233167644&pps=0&tkversion=5.3&location=121.498493,31.279614&gateway=fx:fx01&sessionId=-1760474874671474253952000000000"//获取个人资料
public let QYPubGetNewAdinfo     =   "http://pub.m.iqiyi.com/api/getNewAdInfo?pageName=other&appNum=4&key=20359201cba5f0b43704e65d1e0cbec7&version=1.0&batch=1&slotid=42&type=json&cors=true&qyid=131628d7ac08634b7852dff1d3baf800"//广告
public let QYYueduHome1          =   "http://api.yuedu.iqiyi.com/book/home?apiKey=NUE5Nzc0QzctMDhGMy00QjE2LUE0RDMtNzBCMzZCQjMyQTQ3zzz&appVer=1.8.0&gender=wenxue&md5=684774c94bdf749b512e8889306c1d62&qiyiId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&srcPlatform=12&timeStamp=409514&userId=1233167644"//书籍列表
public let QYYueduHome2          =   "http://api.yuedu.iqiyi.com/book/home?apiKey=NUE5Nzc0QzctMDhGMy00QjE2LUE0RDMtNzBCMzZCQjMyQTQ3zzz&appVer=1.8.0&gender=male&md5=684774c94bdf749b512e8889306c1d62&qiyiId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&srcPlatform=12&timeStamp=409514&userId=1233167644"//列表
public let QYYueduHome3          =   "http://api.yuedu.iqiyi.com/book/home?apiKey=NUE5Nzc0QzctMDhGMy00QjE2LUE0RDMtNzBCMzZCQjMyQTQ3zzz&appVer=1.8.0&gender=female&md5=684774c94bdf749b512e8889306c1d62&qiyiId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&srcPlatform=12&timeStamp=409514&userId=1233167644"//列表
public let QYYueduBookCategory   =   "http://api.yuedu.iqiyi.com/book/category?apiKey=NUE5Nzc0QzctMDhGMy00QjE2LUE0RDMtNzBCMzZCQjMyQTQ3zzz&appVer=1.8.0&gender=wenxue%2Cmale%2Cfemale&md5=684774c94bdf749b512e8889306c1d62&qiyiId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&srcPlatform=12&timeStamp=409514&userId=1233167644"//书籍列表
public let QYMallindexaction     =   "http://mall.iqiyi.com/apis/app/index.action"//首页列表
public let QYMallindex           =   "http://mall.iqiyi.com/m/index?block=R:206833312"//爱奇艺商城
public let QYIfaceGetComments    =   "http://iface.iqiyi.com/api/getComments?key=8e48946f144759d86a50075555fd5862&api_v=4.2&app_key=8e48946f144759d86a50075555fd5862&type=json&version=7.8&ppid=1233167644&uid=1233167644&uniqid=0f607264fc6318a92b9e13c65db7cd3c&qyid=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&qitanid=13632893&qitanid_res_type=6&sort=add_time&qitan_comment_type=8&page=1&page_size=20"
/******************我         的*******************/
public let QYIfaceGet2UserInfo =  "http://iface.iqiyi.com/api/get2UserInfo?uid=1233167644&idfa=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&key=8e48946f144759d86a50075555fd5862&cookie=c3Q7OJjyl8O1MXwm1W1WuBuGZLrKsaBYY2VMrbAZm2ihfEAucRUm2QSUm2SZ1m19HWdR5ls72&app_key=8e48946f144759d86a50075555fd5862&ppid=1233167644&did=14804771a716c715&lang=zh_CN&app_lm=cn&api_v=4.2&ua=iPhone7,2&agenttype=20&resolution=750*1334&udid=3761e933e179c95fb5f7f8de85ffb55baedb1e1e&version=7.8&type=json&os=9.3.5&qyid=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&openudid=3761e933e179c95fb5f7f8de85ffb55baedb1e1e&secure_p=iPhone&mac_md5=e3f5536a141811db40efd6400f1d0a4e&idfv=5A9774C7-08F3-4B16-A4D3-70B36BB32A47&cupid_v=3.1.006&network=1&screen_status=1&ss=1&screen_res=750*1334&req_sn=1474254723670&cupid_uid=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&uniqid=0f607264fc6318a92b9e13c65db7cd3c&video=0&source=68&sort=0&albumId=(null)&page_size=20&page=1&isneed_account=1&platform=iphone-iqiyi&platform_code=bb35a104d95490f6&access_code=huiyuan&mix=0&testMode=0&pps=0&req_times=1"//个人资料
public let QYIfaceGetMymenu2 =  "http://iface.iqiyi.com/api/getMyMenu?key=8e48946f144759d86a50075555fd5862&api_v=4.2&app_key=8e48946f144759d86a50075555fd5862&did=14804771a716c715&secure_p=iPhone&type=json&version=7.8&os=9.3.5&ua=iPhone7,2&network=1&screen_status=1&udid=3761e933e179c95fb5f7f8de85ffb55baedb1e1e&ss=1&ppid=1233167644&uid=1233167644&cookie=c3Q7OJjyl8O1MXwm1W1WuBuGZLrKsaBYY2VMrbAZm2ihfEAucRUm2QSUm2SZ1m19HWdR5ls72&uniqid=0f607264fc6318a92b9e13c65db7cd3c&openudid=3761e933e179c95fb5f7f8de85ffb55baedb1e1e&idfv=5A9774C7-08F3-4B16-A4D3-70B36BB32A47&idfa=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&qyid=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&mac_md5=e3f5536a141811db40efd6400f1d0a4e&agenttype=20&screen_res=750*1334&resolution=750*1334&lang=zh_CN&app_lm=cn&cupid_uid=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&cupid_v=3.1.006&req_sn=1474254736543&pps=0&req_times=1"//设置
public let QYRcdmbdDownloadaction1 =   "http://l.rcd.iqiyi.com/apis/mbd/download.action?agent_type=20&version=7.8&ua=iPhone7,2&network=1&os=9.3.5&com=1&authcookie=c3Q7OJjyl8O1MXwm1W1WuBuGZLrKsaBYY2VMrbAZm2ihfEAucRUm2QSUm2SZ1m19HWdR5ls72&auth=c3Q7OJjyl8O1MXwm1W1WuBuGZLrKsaBYY2VMrbAZm2ihfEAucRUm2QSUm2SZ1m19HWdR5ls72&dp=3&only_long=1&page_num=1&page_size=20"//推荐列表
public let QYSubscriptionmbdreglist =  "http://subscription.iqiyi.com/apis/mbd/reg/list.action?agent_type=20&authcookie=c3Q7OJjyl8O1MXwm1W1WuBuGZLrKsaBYY2VMrbAZm2ihfEAucRUm2QSUm2SZ1m19HWdR5ls72&antiCsrf=77be7c85891681a43b46c73a5db7f35c&all=1&subTypes=1,7"//视频播放地址
public let QYServProductRecommend  =   "http://serv.vip.iqiyi.com/mobile/productRecommend.action?version=4.0&platform=bb35a104d95490f6&P00001=c3Q7OJjyl8O1MXwm1W1WuBuGZLrKsaBYY2VMrbAZm2ihfEAucRUm2QSUm2SZ1m19HWdR5ls72&apple=1&bid=1&pid=a0226bd958843452&lang=zh_CN&app_lm=cn&device_id=470C6D16-2F27-41F5-A4B1-DEAADC9B491E"//常见问题
public let QYMixerRecommendVideos  =   "http://mixer.video.iqiyi.com/jp/recommend/videos?referenceId=&albumId=&channelId=-1&cookieId=fb24bedac0050dbb6f05aab8969825fb&userId=&pru=&withRefer=false&area=lizard&size=39&type=user&playPlatform=PC_QIYI&callback=window.Q.__callbacks__.cbw7k84u"//视频分类
/******************泡         泡*******************/
public let QYTGetfeeds1   =   "http://api.t.iqiyi.com/feed/get_feeds?agenttype=116&agentversion=7.8&appid=44&atoken=4520160m2tL9dkCUZGPlHIYVM6IW95uzMYha8bt5dCUIB6koMm4&authcookie=c3Q7OJjyl8O1MXwm1W1WuBuGZLrKsaBYY2VMrbAZm2ihfEAucRUm2QSUm2SZ1m19HWdR5ls72&business_type=1&count=20&device_id=3761e933e179c95fb5f7f8de85ffb55baedb1e1e&feedTypes=1%2C6%2C7%2C8%2C9%2C10%2C29%2C101&hasRecomCard=11&m_device_id=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&needEvent=1&needStartAction=1&needTotal=0&needTotalUser=0&notice=1&orderBy=1&playPlatform=12&praise=0&qypid=02032001010000000000&snsTime=1&sourceid=44&top=1&uid=1233167644&version=1&wallId=200124347"//钱包信息
public let QYSearchm =  "http://search.video.qiyi.com/m?if=defaultQuery&is_qipu_platform=1&platform=12&u=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&pu=1233167644&channel=0"//搜索列表

//FIXME:iReader*******************/
public let IRAdInternal    =   "http://m.ad.zhangyue.com/api/internal.do?zysid=8c3940fb3c3df86f2ea5d6318e91d396&rgt=7&usr=i623907218&pc=10&p1=181F5D8E709345A0AE22F92766F1F571&p2=111010&p3=657007&p4=501607&p5=1001&p6=AAAAAAAAAAAAAAAAAAAA&p7=AAAAAAAAAAAAAAA&p9=0&p11=584&p12=&p16=iPhone7,2&p21=00003&p22=iPhone_OS,9.3.5&idfa=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&adcmd=1001&app_id=5&channel_id=111010&phone_model=iPhone7%2C2&support_ad_type=41%2C45%2C58&support_platform=0%2C1&support_position=36&usrid=i623907218&version_id=657007"//精选

public let IRIh2iphonephp51 =  "http://ih2.zhangyue.com/zybook4/app/iphone.php?ca=Channel.Index&pk=5B4&p1=181F5D8E709345A0AE22F92766F1F571&p2=111010&p3=657007&p4=501607&p5=1001&p6=AAAAAAAAAAAAAAAAAAAA&p7=AAAAAAAAAAAAAAA&p9=0&p11=584&p12=&p16=iPhone7,2&p21=00003&p22=iPhone_OS,9.3.5&usr=i623907218&rgt=7&zysid=8c3940fb3c3df86f2ea5d6318e91d396&idfa=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&key=PR957&a0=jxdh_gdi&zysid=8c3940fb3c3df86f2ea5d6318e91d396&rgt=7&usr=i623907218&pc=10&p1=181F5D8E709345A0AE22F92766F1F571&p2=111010&p3=657007&p4=501607&p5=1001&p6=AAAAAAAAAAAAAAAAAAAA&p7=AAAAAAAAAAAAAAA&p9=0&p11=584&p12=&p16=iPhone7,2&p21=00003&p22=iPhone_OS,9.3.5&idfa=470C6D16-2F27-41F5-A4B1-DEAADC9B491E"//精选


public let IRIh2UPZyappphp1 =  "http://ih2.zhangyue.com/zybook4/iphone/u/p/zyApp.php?ca=Channel.Index&key=1U18&zysid=8c3940fb3c3df86f2ea5d6318e91d396&rgt=7&usr=i623907218&pc=10&p1=181F5D8E709345A0AE22F92766F1F571&p2=111010&p3=657007&p4=501607&p5=1001&p6=AAAAAAAAAAAAAAAAAAAA&p7=AAAAAAAAAAAAAAA&p9=0&p11=584&p12=&p16=iPhone7,2&p21=00003&p22=iPhone_OS,9.3.5&idfa=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&pk=my_vip&pca=slidePage"//VIP专区
public let IRIh2UPZyappphp2 =  "http://ih2.zhangyue.com/zybook4/iphone/u/p/zyApp.php?ca=Channel.Index&key=PR121&a0=ioscbl_Pdhdpd&zysid=8c3940fb3c3df86f2ea5d6318e91d396&rgt=7&usr=i623907218&pc=10&p1=181F5D8E709345A0AE22F92766F1F571&p2=111010&p3=657007&p4=501607&p5=1001&p6=AAAAAAAAAAAAAAAAAAAA&p7=AAAAAAAAAAAAAAA&p9=0&p11=584&p12=&p16=iPhone7,2&p21=00003&p22=iPhone_OS,9.3.5&idfa=470C6D16-2F27-41F5-A4B1-DEAADC9B491E"//活动
public let IRIh2UPZyappphp3 =  "http://ih2.zhangyue.com/zybook4/iphone/u/p/zyApp.php?ca=Channel.Index&key=PR1021&a0=ioscbl_bznhd0819&zysid=8c3940fb3c3df86f2ea5d6318e91d396&rgt=7&usr=i623907218&pc=10&p1=181F5D8E709345A0AE22F92766F1F571&p2=111010&p3=657007&p4=501607&p5=1001&p6=AAAAAAAAAAAAAAAAAAAA&p7=AAAAAAAAAAAAAAA&p9=0&p11=584&p12=&p16=iPhone7,2&p21=00003&p22=iPhone_OS,9.3.5&idfa=470C6D16-2F27-41F5-A4B1-DEAADC9B491E"//活动主会场
public let IRIh2UPZyappphp4 =  "http://ih2.zhangyue.com/zybook4/iphone/u/p/zyApp.php?ca=Channel.Index&key=PR666&pk=scdh_01&a0=cbliosscdh21&zysid=8c3940fb3c3df86f2ea5d6318e91d396&rgt=7&usr=i623907218&pc=10&p1=181F5D8E709345A0AE22F92766F1F571&p2=111010&p3=657007&p4=501607&p5=1001&p6=AAAAAAAAAAAAAAAAAAAA&p7=AAAAAAAAAAAAAAA&p9=0&p11=584&p12=&p16=iPhone7,2&p21=00003&p22=iPhone_OS,9.3.5&idfa=470C6D16-2F27-41F5-A4B1-DEAADC9B491E"//书城导航
public let IRIh2UPBookphp  =   "http://ih2.zhangyue.com/zybook4/iphone/u/p/book.php?key=4B102&pk=SDcbl&a0=cbliosjrmf&zysid=8c3940fb3c3df86f2ea5d6318e91d396&rgt=7&usr=i623907218&pc=10&p1=181F5D8E709345A0AE22F92766F1F571&p2=111010&p3=657007&p4=501607&p5=1001&p6=AAAAAAAAAAAAAAAAAAAA&p7=AAAAAAAAAAAAAAA&p9=0&p11=584&p12=&p16=iPhone7,2&p21=00003&p22=iPhone_OS,9.3.5&idfa=470C6D16-2F27-41F5-A4B1-DEAADC9B491E"//免费
public let IRIh2UPapiphp6  =   "http://ih2.zhangyue.com/zybook4/iphone/u/p/api.php?Act=searchIndexPage&zysid=8c3940fb3c3df86f2ea5d6318e91d396&rgt=7&usr=i623907218&pc=10&p1=181F5D8E709345A0AE22F92766F1F571&p2=111010&p3=657007&p4=501607&p5=1001&p6=AAAAAAAAAAAAAAAAAAAA&p7=AAAAAAAAAAAAAAA&p9=0&p11=584&p12=&p16=iPhone7,2&p21=00003&p22=iPhone_OS,9.3.5&idfa=470C6D16-2F27-41F5-A4B1-DEAADC9B491E"//分类
public let IRIh2UPapiphp7  =   "http://ih2.zhangyue.com/zybook4/iphone/u/p/api.php?zysid=8c3940fb3c3df86f2ea5d6318e91d396&rgt=7&usr=i623907218&pc=10&p1=181F5D8E709345A0AE22F92766F1F571&p2=111010&p3=657007&p4=501607&p5=1001&p6=AAAAAAAAAAAAAAAAAAAA&p7=AAAAAAAAAAAAAAA&p9=0&p11=584&p12=&p16=iPhone7,2&p21=00003&p22=iPhone_OS,9.3.5&idfa=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&Act=getSuggestionWithType&word=%E5%8F%B7"//根据word搜索相关书籍
public let IRIh2UPapiphp8  =   "http://ih2.zhangyue.com/zybook4/iphone/u/p/api.php?zysid=8c3940fb3c3df86f2ea5d6318e91d396&rgt=7&usr=i623907218&pc=10&p1=181F5D8E709345A0AE22F92766F1F571&p2=111010&p3=657007&p4=501607&p5=1001&p6=AAAAAAAAAAAAAAAAAAAA&p7=AAAAAAAAAAAAAAA&p9=0&p11=584&p12=&p16=iPhone7,2&p21=00003&p22=iPhone_OS,9.3.5&idfa=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&Act=searchMultiple&currentPage=1&keyWord=%E5%8F%B7%E4%BB%A4%E4%B8%89%E7%95%8C&optMgz=1&pageSize=20&resId=1027191&suggestType=2&type=book&version=2"//书籍列表

public let IRIh2UPbookphp3 =   "http://ih2.zhangyue.com/zybook4/iphone/u/p/book.php?key=4B4&launch=inpage&zysid=8c3940fb3c3df86f2ea5d6318e91d396&rgt=7&usr=i623907218&pc=10&p1=181F5D8E709345A0AE22F92766F1F571&p2=111010&p3=657007&p4=501607&p5=1001&p6=AAAAAAAAAAAAAAAAAAAA&p7=AAAAAAAAAAAAAAA&p9=0&p11=584&p12=&p16=iPhone7,2&p21=00003&p22=iPhone_OS,9.3.5&idfa=470C6D16-2F27-41F5-A4B1-DEAADC9B491E"//精选


public let IRIh2Filterbooklist1 =  "http://ih2.zhangyue.com/webintf/Category_Create/FilterBookList?category_id=60&resource_id=13&order=download&info_type=book&status=0&pageSize=20&key=2C_60&pk=1K1&usr=i623907218&rgt=7&p1=181F5D8E709345A0AE22F92766F1F571&p2=111010&p3=657007&p4=501607&p5=1001&p6=AAAAAAAAAAAAAAAAAAAA&p7=AAAAAAAAAAAAAAA&p9=0&p11=584&p16=iPhone7%2C2&p21=00003&p22=iPhone_OS%2C9.3.5&zysid=8c3940fb3c3df86f2ea5d6318e91d396"//试读




//FIXME:微         能         量                *******************/
public let WNCate7            =   "http://wxsyb.bama555.com/cate?id=516b6b1eade8d006&wxid="//经典案例
public let WNAsist2           =   "http://wxsyb.bama555.com/data/assist/?&callback=jQuery20308067237965296954_1474263692852&_=1474263692853"//首页四个分类
public let WNCatelist5        =   "http://wxsyb.bama555.com/data/cate_list/?&callback=jQuery20308067237965296954_1474263692862&_=1474263692863"//主界面信息
public let WNCatelist6        =   "http://wxsyb.bama555.com/data/cate_list/?&callback=jQuery20302716610536444932_1474263728544&_=1474263728545"//尾巴系列页面
public let WNDetaillist10     =   "http://wxsyb.bama555.com/data/detail_list/?&callback=jQuery20308067237965296954_1474263692850&cid=516b6b1eade8d006&_=1474263692865"//经典案例
public let WNDetaillist13     =   "http://wxsyb.bama555.com/data/detail_list/?&callback=jQuery20306829270389862359_1474263703369&cid=52de132e34a70051&_=1474263703370"//最新资讯
public let WNDetaillist14     =   "http://wxsyb.bama555.com/data/detail_list/?&callback=jQuery20307733513773418963_1474263708452&cid=51ff6e85d587f057&_=1474263708453"//加盟合作
public let WNDetaillist16     =   "http://wxsyb.bama555.com/data/detail_list/?&callback=jQuery20302716610536444932_1474263728532&cid=549b72ee29303037&_=1474263728547"//成交型应用
public let WNDetaillist17     =   "http://wxsyb.bama555.com/"//尾巴主界面
public let WNAccount2         =   "http://www.weiba66.com/"//尾巴官网
public let WNWechatjsapi8     =   "http://wxsyb.bama555.com/data/wechatjsapi?url=http%3A%2F%2Fwxsyb.bama555.com%2Fcate%3Fid%3D516b6b1eade8d006%26wxid%3D"//微信支付
public let WNWechatjsapi9     =   "http://wxsyb.bama555.com/data/wechatjsapi?url=http%3A%2F%2Fwxsyb.bama555.com%2Fcate%3Fid%3D52de132e34a70051"//微信支付
public let WNGcardtypes       =   "http://wxsyb.bama555.com/data/gcard/types"//贺卡列表
public let WNDatadetail       =   "http://wxsyb.bama555.com/data/detail?&callback=jQuery203024564540456049144_1474263730545&aid=537c7a708e994064&_=1474263730546"//微信支付案例
public let WNDatafooter       =   "http://wxsyb.bama555.com/data/footer?callback=jQuery20308872868272010237_1474263837715&_=1474263837716"//游戏
public let WNCate8            =   "http://wxsyb.bama555.com/cate?id=52de132e34a70051"//尾巴最新动态
public let WNCate9            =   "http://wxsyb.bama555.com/cate?id=51ff6e85d587f057&wxid="//加盟合作
public let WNCate10           =   "http://wxsyb.bama555.com/cate?id=549b72ee29303037"//成交型应用
public let WNDetail2          =   "http://wxsyb.bama555.com/detail?id=537c7a708e994064"//支付案例详情
public let WNXiangcemoban     =   "http://wxsyb.bama555.com/xiangce/moban/?id=5712"//微商城分销版
public let WNMge              =   "http://mge.wxrrd.com/"//地标回购店铺
public let WNMgeDesignfeature =   "http://mge.wxrrd.com/design/feature.json"//地标回购店铺信息
public let WNMpGetmassendmsg  =   "http://mp.weixin.qq.com/mp/getmasssendmsg?__biz=MjM5NzI4NDY1Mg==#wechat_webview_type=1&wechat_redirect"//历史消息
public let WNMpS              =   "http://mp.weixin.qq.com/s?__biz=MzIxNTAxMzQwMg==&mid=2655998669&idx=1&sn=8cf8f2fa84a4195eb3d787be261ff6cf&scene=1&srcid=09198bT2lseLcrghHTt51mZZ#rd"//软文
