//
//  IqiyiAPI.swift
//  Freedom
import UIKit
import RxSwift
//FIXME:爱奇艺*******************/
enum IQIYIURL: String {
    //banner
    case faceHotBanner  = "http://iface.iqiyi.com/api/hotDoc?key=8e48946f144759d86a50075555fd5862&type=json"
    //banner
    case faceGetNewAdBanner = "http://iface.iqiyi.com/api/getMyMenu?key=8e48946f144759d86a50075555fd5862&type=json&version=7.8"
    //banner
    case faceGetBanner = "http://iface.iqiyi.com/api/getDiscover?key=8e48946f144759d86a50075555fd5862&type=json&version=7.8"
    //泡泡表情包
    case classifyEmoji  = "http://cmts.iqiyi.com/emoticon/ep_config.json"
    //刷新首页视频列表
    case videoList = "http://l.rcd.iqiyi.com/apis/mbd/download.action?agent_type=20&version=7.8&auth=c3Q7OJjyl8O1MXwm1W1WuBuGZLrKsaBYY2VMrbAZm2ihfEAucRUm2QSUm2SZ1m19HWdR5ls72&page_num=1&page_size=3"
    /******************服务*******************/
    //不清楚
    case yueduHome4 = "http://api.yuedu.iqiyi.com/book/home?apiKey=&appVer=1.8.0&gender=wenxue&md5=684774c94bdf749b512e8889306c1d62&qiyiId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&srcPlatform=12&timeStamp=409514&userId=1233167644"
    //列表
    case yueduHomeList = "http://api.yuedu.iqiyi.com/book/home?apiKey=&appVer=1.8.0&gender=male&md5=684774c94bdf749b512e8889306c1d62&qiyiId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&srcPlatform=12&timeStamp=409514&userId=1233167644"
    //列表
    case yueduHomeList2 = "http://api.yuedu.iqiyi.com/book/home?apiKey=&appVer=1.8.0&gender=female&md5=684774c94bdf749b512e8889306c1d62&qiyiId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&srcPlatform=12&timeStamp=409514&userId=1233167644"
    //列表
    case yueduFontList = "http://api.yuedu.iqiyi.com/book/font?appVer=1.8.0&md5=684774c94bdf749b512e8889306c1d62&qiyiId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&srcPlatform=12&timeStamp=409514&userId=1233167644"
    //列表
    case qiyuSaleList = "http://qiyu.iqiyi.com/book/top/sale?appVer=1.8.0&area=m_cabbage&md5=684774c94bdf749b512e8889306c1d62&num=10&ppuid=1233167644&qiyiId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&timeStamp=409514&userId=1233167644"
    //获取个人资料
    case piaoUserInfo = "http://piao.iqiyi.com/f/h5/v1/app/users/1233167644?src=ios&format=json&deviceId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&platform=iPhone&mkey=8e48946f144759d86a50075555fd5862&version=7.8&passportId=1233167644&pps=0&tkversion=5.3&location=121.498923,31.279685&gateway=fx:fx01&sessionId=49328400743471474253552000000000"
    //列表
    case piaoMovieRecommend = "http://piao.iqiyi.com/f/h5/v1/app/movie/recommend/?locationOrCityId=1400254893&src=ios&format=json&tkversion=5.3&src=ios&format=json&deviceId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&platform=iPhone&mkey=8e48946f144759d86a50075555fd5862&version=7.8&passportId=1233167644&pps=0&tkversion=5.3&deviceId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&passportId=1233167644&gateway=fx:fx01&sessionId=34916217150031474253552000000000"
    //列表
    case piaoCinemalist  = "http://piao.iqiyi.com/f/h5/v1/app/cinemaList/121.498923,31.279685/1400254893/0/0/0/1233167644?src=ios&format=json&deviceId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&platform=iPhone&mkey=8e48946f144759d86a50075555fd5862&version=7.8&passportId=1233167644&pps=0&tkversion=5.3&uid=1233167644&imei=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&gateway=fx:fx01&sessionId=-5935241422571474253552000000000"
    //列表
    case piaoCinemaRecommend = "http://piao.iqiyi.com/f/h5/v1/app/cinema/recommend/121.494260,31.279545/1400254893/0/0/0/1233167644?src=ios&format=json&tkversion=5.3&src=ios&format=json&deviceId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&platform=iPhone&mkey=8e48946f144759d86a50075555fd5862&version=7.8&passportId=1233167644&pps=0&tkversion=5.3&deviceId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&gateway=fx:fx01&sessionId=49762826167951474253553000000000"
    //列表
    case piaoMovieInfo  = "http://piao.iqiyi.com/f/h5/v1/app/movieInfo/1401277599/1400254893/1233167644?src=ios&format=json&deviceId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&platform=iPhone&mkey=8e48946f144759d86a50075555fd5862&version=7.8&passportId=1233167644&pps=0&tkversion=5.3&location=121.498892,31.279727&gateway=fx:fx03&sessionId=-3833660550301474253573000000000"
    //获取个人资料
    case piaoAppusers  = "http://piao.iqiyi.com/f/h5/v1/app/users/1233167644?src=ios&format=json&deviceId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&platform=iPhone&mkey=8e48946f144759d86a50075555fd5862&version=7.8&passportId=1233167644&pps=0&tkversion=5.3&location=121.498493,31.279614&gateway=fx:fx01&sessionId=-1760474874671474253952000000000"
    //广告
    case pubGetNewAdinfo  = "http://pub.m.iqiyi.com/api/getNewAdInfo?pageName=other&appNum=4&key=20359201cba5f0b43704e65d1e0cbec7&version=1.0&batch=1&slotid=42&type=json&cors=true&qyid=131628d7ac08634b7852dff1d3baf800"
    //书籍列表
    case yueduHome1 = "http://api.yuedu.iqiyi.com/book/home?apiKey=NUE5Nzc0QzctMDhGMy00QjE2LUE0RDMtNzBCMzZCQjMyQTQ3zzz&appVer=1.8.0&gender=wenxue&md5=684774c94bdf749b512e8889306c1d62&qiyiId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&srcPlatform=12&timeStamp=409514&userId=1233167644"
    //列表
    case yueduHome2 = "http://api.yuedu.iqiyi.com/book/home?apiKey=NUE5Nzc0QzctMDhGMy00QjE2LUE0RDMtNzBCMzZCQjMyQTQ3zzz&appVer=1.8.0&gender=male&md5=684774c94bdf749b512e8889306c1d62&qiyiId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&srcPlatform=12&timeStamp=409514&userId=1233167644"
    //列表
    case yueduHome3 = "http://api.yuedu.iqiyi.com/book/home?apiKey=NUE5Nzc0QzctMDhGMy00QjE2LUE0RDMtNzBCMzZCQjMyQTQ3zzz&appVer=1.8.0&gender=female&md5=684774c94bdf749b512e8889306c1d62&qiyiId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&srcPlatform=12&timeStamp=409514&userId=1233167644"
    //书籍列表
    case yueduBookCategory = "http://api.yuedu.iqiyi.com/book/category?apiKey=NUE5Nzc0QzctMDhGMy00QjE2LUE0RDMtNzBCMzZCQjMyQTQ3zzz&appVer=1.8.0&gender=wenxue%2Cmale%2Cfemale&md5=684774c94bdf749b512e8889306c1d62&qiyiId=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&srcPlatform=12&timeStamp=409514&userId=1233167644"
    //首页列表
    case mallindexaction  = "http://mall.iqiyi.com/apis/app/index.action"
    //爱奇艺商城
    case mallindex = "http://mall.iqiyi.com/m/index?block=R:206833312"
    case faceGetComments = "http://iface.iqiyi.com/api/getComments?key=8e48946f144759d86a50075555fd5862&api_v=4.2&app_key=8e48946f144759d86a50075555fd5862&type=json&version=7.8&ppid=1233167644&uid=1233167644&uniqid=0f607264fc6318a92b9e13c65db7cd3c&qyid=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&qitanid=13632893&qitanid_res_type=6&sort=add_time&qitan_comment_type=8&page=1&page_size=20"
    /******************我   的*******************/
    //个人资料
    case faceGet2UserInfo = "http://iface.iqiyi.com/api/get2UserInfo?uid=1233167644&idfa=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&key=8e48946f144759d86a50075555fd5862&cookie=c3Q7OJjyl8O1MXwm1W1WuBuGZLrKsaBYY2VMrbAZm2ihfEAucRUm2QSUm2SZ1m19HWdR5ls72&app_key=8e48946f144759d86a50075555fd5862&ppid=1233167644&did=14804771a716c715&lang=zh_CN&app_lm=cn&api_v=4.2&ua=iPhone7,2&agenttype=20&resolution=750*1334&udid=3761e933e179c95fb5f7f8de85ffb55baedb1e1e&version=7.8&type=json&os=9.3.5&qyid=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&openudid=3761e933e179c95fb5f7f8de85ffb55baedb1e1e&secure_p=iPhone&mac_md5=e3f5536a141811db40efd6400f1d0a4e&idfv=5A9774C7-08F3-4B16-A4D3-70B36BB32A47&cupid_v=3.1.006&network=1&screen_status=1&ss=1&screen_res=750*1334&req_sn=1474254723670&cupid_uid=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&uniqid=0f607264fc6318a92b9e13c65db7cd3c&video=0&source=68&sort=0&albumId=(null)&page_size=20&page=1&isneed_account=1&platform=iphone-iqiyi&platform_code=bb35a104d95490f6&access_code=huiyuan&mix=0&testMode=0&pps=0&req_times=1"
    //设置
    case faceGetMymenu2 = "http://iface.iqiyi.com/api/getMyMenu?key=8e48946f144759d86a50075555fd5862&api_v=4.2&app_key=8e48946f144759d86a50075555fd5862&did=14804771a716c715&secure_p=iPhone&type=json&version=7.8&os=9.3.5&ua=iPhone7,2&network=1&screen_status=1&udid=3761e933e179c95fb5f7f8de85ffb55baedb1e1e&ss=1&ppid=1233167644&uid=1233167644&cookie=c3Q7OJjyl8O1MXwm1W1WuBuGZLrKsaBYY2VMrbAZm2ihfEAucRUm2QSUm2SZ1m19HWdR5ls72&uniqid=0f607264fc6318a92b9e13c65db7cd3c&openudid=3761e933e179c95fb5f7f8de85ffb55baedb1e1e&idfv=5A9774C7-08F3-4B16-A4D3-70B36BB32A47&idfa=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&qyid=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&mac_md5=e3f5536a141811db40efd6400f1d0a4e&agenttype=20&screen_res=750*1334&resolution=750*1334&lang=zh_CN&app_lm=cn&cupid_uid=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&cupid_v=3.1.006&req_sn=1474254736543&pps=0&req_times=1"
    //推荐列表
    case rcdmbdDownloadaction1 = "http://l.rcd.iqiyi.com/apis/mbd/download.action?agent_type=20&version=7.8&ua=iPhone7,2&network=1&os=9.3.5&com=1&authcookie=c3Q7OJjyl8O1MXwm1W1WuBuGZLrKsaBYY2VMrbAZm2ihfEAucRUm2QSUm2SZ1m19HWdR5ls72&auth=c3Q7OJjyl8O1MXwm1W1WuBuGZLrKsaBYY2VMrbAZm2ihfEAucRUm2QSUm2SZ1m19HWdR5ls72&dp=3&only_long=1&page_num=1&page_size=20"
    //视频播放地址
    case subscriptionmbdreglist = "http://subscription.iqiyi.com/apis/mbd/reg/list.action?agent_type=20&authcookie=c3Q7OJjyl8O1MXwm1W1WuBuGZLrKsaBYY2VMrbAZm2ihfEAucRUm2QSUm2SZ1m19HWdR5ls72&antiCsrf=77be7c85891681a43b46c73a5db7f35c&all=1&subTypes=1,7"
    //常见问题
    case servProductRecommend = "http://serv.vip.iqiyi.com/mobile/productRecommend.action?version=4.0&platform=bb35a104d95490f6&P00001=c3Q7OJjyl8O1MXwm1W1WuBuGZLrKsaBYY2VMrbAZm2ihfEAucRUm2QSUm2SZ1m19HWdR5ls72&apple=1&bid=1&pid=a0226bd958843452&lang=zh_CN&app_lm=cn&device_id=470C6D16-2F27-41F5-A4B1-DEAADC9B491E"
    //视频分类
    case mixerRecommendVideos = "http://mixer.video.iqiyi.com/jp/recommend/videos?referenceId=&albumId=&channelId=-1&cookieId=fb24bedac0050dbb6f05aab8969825fb&userId=&pru=&withRefer=false&area=lizard&size=39&type=user&playPlatform=PC_QIYI&callback=window.Q.__callbacks__.cbw7k84u"
    /******************泡   泡*******************/
    //钱包信息
    case getfeeds1 = "http://api.t.iqiyi.com/feed/get_feeds?agenttype=116&agentversion=7.8&appid=44&atoken=4520160m2tL9dkCUZGPlHIYVM6IW95uzMYha8bt5dCUIB6koMm4&authcookie=c3Q7OJjyl8O1MXwm1W1WuBuGZLrKsaBYY2VMrbAZm2ihfEAucRUm2QSUm2SZ1m19HWdR5ls72&business_type=1&count=20&device_id=3761e933e179c95fb5f7f8de85ffb55baedb1e1e&feedTypes=1%2C6%2C7%2C8%2C9%2C10%2C29%2C101&hasRecomCard=11&m_device_id=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&needEvent=1&needStartAction=1&needTotal=0&needTotalUser=0&notice=1&orderBy=1&playPlatform=12&praise=0&qypid=02032001010000000000&snsTime=1&sourceid=44&top=1&uid=1233167644&version=1&wallId=200124347"
    //搜索列表
    case searchm = "http://search.video.qiyi.com/m?if=defaultQuery&is_qipu_platform=1&platform=12&u=470C6D16-2F27-41F5-A4B1-DEAADC9B491E&pu=1233167644&channel=0"
}

extension XNetKit {
    static func iqiyiTest(_ url: String, next: PublishSubject<TopicModel>) {
        get(url) { (response) in
            let model = TopicModel.parse(response.body as NSDictionary)
            next.onNext(model)
        }
    }
}
