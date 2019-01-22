//
//  KugouAPI.swift
//  Freedom
import UIKit
import RxSwift
import Alamofire
//FIXME:酷 狗 size = 600
enum KugouURL: String {
    //乐库推荐订阅
    case recommand = "http://iosservice.kugou.com/api/v3/recommend/index"
    //排行总界面各种排行榜列表
    case ranktotal = "http://iosservice.kugou.com/api/v3/rank/list"
    //歌单总界面横幅图片
    case banner = "http://ioscdn.kugou.com/api/v3/banner/index"
    //歌单总界面分类列表
    case category = "http://ioscdn.kugou.com/api/v3/category/list"
    //电台全部
    case fmall = "http://lib3.service.kugou.com/index.php?cmd=12&ver=4070&pid=ios"
    //搜索建议
    case suggestSearch = "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.search.catalogSug&format=json&query=%E5%B0%8F%E8%8B%B9%E6%9E%9C"
    //搜索建议：只有歌名
    case suggestSearch2 = "http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.search.suggestion&query=%E5%B0%8F%E8%8B%B9%E6%9E%9C&format=json&from=ios&version=2.1.1"
    //搜索结果
    case searchResult = "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.search.common&format=json&query=%E5%B0%8F%E8%8B%B9%E6%9E%9C&page_no=1&page_size=30"
    case searchResult2 = "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.artist.getList&format=json&order=1&offset=0&limit=5"
    //新歌榜
    case newSongList = "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.billboard.billList&format=json&type=1&offset=0&size=50"
    //热歌榜注意这个和上边的区别，type=1
    case hotNewSongList = "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.billboard.billList&format=json&type=2&offset=0&size=50"
    // Hito中文榜
    case hotSongList = "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.billboard.billList&format=json&type=18&offset=0&size=50"
    // KTV热歌榜
    case ktvList = "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.billboard.billList&format=json&type=6&offset=0&size=50"
    //电台列表
    case radioList = "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.radio.getCategoryList&format=json"
    //获取某个电台下的歌曲列表
    case radioSongList = "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.radio.getChannelSong&format=json&pn=0&rn=10&channelname=public_tuijian_ktv"
    //获取songid的歌曲信息
    case songInfo = "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.song.getInfos&format=json&songid=8059247&ts=1408284347323&e=JoN56kTXnnbEpd9MVczkYJCSx%2FE1mkLx%2BPMIkTcOEu4%3D&nw=2&ucf=1&res=1"
    //歌手列表
    case singerList = "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.artist.get72HotArtist&format=json&order=1&offset=0&limit=50"
    //歌手简介，tinguid为歌手id
    case singerInfo = "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.artist.getinfo&format=json&tinguid=7994"
    //歌手歌曲列表，tinguid为歌手id
    case singerSongList = "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.artist.getSongList&format=json&order=2&tinguid=7994&offset=0&limits=50"
    //新碟上架
    case newCD = "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.plaza.getRecommendAlbum&format=json&offset=0&limit=50"
    //专辑信息
    case cdInfo = "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.album.getAlbumInfo&format=json&album_id=122314357"
    //新歌速递
    case newSongs = "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.plaza.getNewSongs&format=json&limit=50"
    /******************听*******************/
    //启动广告,没有图片，只有跳转链接
    case banner2 = "http://mvads.kugou.com/mobile/?type=1&version=8200"
    //竖屏banner有图片无跳转
    case bannerAdsFlash   = "http://ads.service.kugou.com/v1/mobile_flash?plat=2&version=8200&pre_ad=1"
    //VIP中心
    case VIPPage = "http://m.kugou.com/vip/v2/vippage.html"
    //根据关键词搜索歌曲列表
    case searchSongList  = "http://ioscdn.kugou.com/api/v3/search/song?keyword=%@&page=1&pagesize=30"
    //根据关键词筛选出推荐搜索的关键词及个数
    case suggestSearchList = "http://ioscdn.kugou.com/new/app/i/search.php?cmd=302&keyword=%@"
    //歌曲下载链接根据pid和hash还有key
    case downloadInfo  = "http://trackercdn.kugou.com/i/v2/?cmd=25&pid=%d&hash=afee18a8283701f25b71d8a6cf7697bc&key=dd39bb50b704838e49765144d40f57fe&behavior=play"
    //歌词下载根据keyword和hash值获取accesskey和id
    case downloadKRCInfo  = "http://lyrics.kugou.com/search?ver=1&keyword=%E9%85%92%E5%B9%B2%E5%80%98%E5%8D%96%E6%97%A0&hash=afee18a8283701f25b71d8a6cf7697bc"
    //根据上面的accesseskey和id获取歌词内容
    case downloadKRC = "http://lyrics.kugou.com/download?id=16629393&accesskey=927C03F3D7F98A122B363F69808F0F5D&ver=1&fmt=krc"
    //广告banner
    case advertiseBanner = "http://ads.service.kugou.com/v1/mobile_fmbanner?appid=1000&clientver=8200&clienttime=1474248821&key=00f1890520bb0ed49a0de1f3bea5b5d4"
    case recommandBanner = "http://service.mobile.kugou.com/v1/yueku/multi_special_recommend?hash=1c0e79230db3a127ff9d7e252ac9d650"//
    //没用
    case serviceBanner = "http://service.mobile.kugou.com/v1/yueku/recommend?type=7&plat=2&version=8200&operator=1"
    //某种列表
    case bankList = "http://ioscdn.kugou.com/api/v3/rank/list?withsong=1"
    //热播列表
    case radioliveHotlist = "http://radiolive.mobile.kugou.com/hot_list/0/0"
    //广播列表
    case radioliveRankLocation = "http://radiolive.mobile.kugou.com/v7/rank/location/30"
    /******************看*******************/
    //banner
    case serviceShowBanner = "http://service.mobile.kugou.com/v1/show/banner?plat=1&version=8200"
    //banner 根据vid的banner
    case serviceVspecialdetail = "http://service.mobile.kugou.com/v1/mv/vspecialdetail?vid=51190"
    //分类列表
    case acshowindexGetclassify = "http://acshow.kugou.com/show7/json/v2/cdn/index/getclassify?platform=2&version=8200"
    //主播列表
    case acshowRankCityPage = "http://acshow.kugou.com/show7/rank/json/v2/cdn/banner/get_banner?platform=2&version=8200"
    //根据城市看直播
    case toolsPerfomGetbycity = "http://tools.mobile.kugou.com/api/v1/perform/get_by_city?plat=2&version=8200&city=%@"
    //banner
    case multBanner = "http://ioscdn.kugou.com/api/v3/mv/multBanner?plat=2&version=8200"
    //banner
    case recommendBanner = "http://ioscdn.kugou.com/api/v3/mv/recommend?plat=2&version=8200"
    //分类
    case scdnList  = "http://ioscdn.kugou.com/api/v3/mv/tagListV2?plat=2"
    //banner
    case scdnTagListv2 = "http://ioscdn.kugou.com/api/v3/mv/list?type=1&page=2&pagesize=20&plat=2"
    //获取mv列表
    case scdnTagMvs  = "http://ioscdn.kugou.com/api/v3/mv/tagMvsV2?type=2&ids=&page=1&pagesize=20"
    //获取歌手的图片
    case scdnYuekuphp1 = "http://ioscdn.kugou.com/new/app/i/yueku.php?cmd=104&singer=%@"
    //根据hash和key下载mv
    case trackermvindex = "http://trackermv.kugou.com/interface/index/cmd=100&hash=DA27295F2033CAF3DE512020F9BBB200&key=1225a00b7b2a962a8e0745363b4b8299&pid=1&ext=mp4"
    /******************唱*******************/
    case acsingSongnewHundred = "http://acsing.kugou.com/sing7/song/json/v2/cdn/song_new_hundred.do?platform=2&sign=39f12683b7697f55&pageSize=100&version=8200"//
    case acsingListhtml  = "http://acsing.kugou.com/sing7/web/static/mobile/KSongGame/views/list.html?sign=051e5eb1"//
    case acsingActivityIndex = "http://acsing.kugou.com/sing7/web/activity/index?sign=051e5eb1"//
}

enum KugouHalfURL: String {
    case rankDetail = "http://ioscdn.kugou.com/api/v3/rank/song"
    case spacialList = "http://ioscdn.kugou.com/api/v3/category/special"
    case music = "http://cloud.kugou.com/app/checkIllegal.php"
    case musicInfo = "http://m.kugou.com/app/i/getSongInfo.php"
    case singer = "http://ioscdn.kugou.com/api/v3/singer/recommend"
    case singerList = "http://ioscdn.kugou.com/api/v3/singer/list"
    case singerSongList = "http://ioscdn.kugou.com/api/v3/singer/song"
    case singerAlbum = "http://ioscdn.kugou.com/api/v3/singer/album"
    case singerInfo = "http://iosservice.kugou.com/api/v3/singer/info"
    case albumInfo = "http://ioscdn.kugou.com/api/v3/album/info"
    case albumSong = "http://ioscdn.kugou.com/api/v3/album/song"
    case singerMV = "http://ioscdn.kugou.com/api/v3/singer/mv"
    case FMMusic = "http://lib3.service.kugou.com/index.php"
}

extension XNetKit {
    //排行具体界面
    static func kugouRankDetail(_ rankid:String,_ ranktype: Int,_ page: Int,_ pagesize: Int, next: PublishSubject<TopicModel>) {
        let param: Parameters = ["rankid": rankid, "ranktype": ranktype, "page": page, "pagesize": pagesize]
        get(KugouHalfURL.rankDetail.rawValue, param: param) { (response) in
            let model = TopicModel.parse(response.dictionary as NSDictionary)
            next.onNext(model)
        }
    }
    //歌单二级界面分类列表
    static func kugouSpacialList(_ categoryid: String,_ page: Int,_ pagesize: Int, next: PublishSubject<TopicModel>) {
        let param: Parameters = ["categoryid":categoryid, "page": page, "pagesize": pagesize]
        get(KugouHalfURL.spacialList.rawValue, param: param) { (response) in
            let model = TopicModel.parse(response.dictionary as NSDictionary)
            next.onNext(model)
        }
    }
    //歌曲信息
    static func kugouMusic(_ hash: String, next: PublishSubject<TopicModel>) {
        let param: Parameters = ["hash": hash]
        get(KugouHalfURL.music.rawValue, param: param) { (response) in
            let model = TopicModel.parse(response.dictionary as NSDictionary)
            next.onNext(model)
        }
    }
    static func kugouMusicInfo(_ hash:String, next: PublishSubject<TopicModel>) {
        let param: Parameters = ["hash":hash,"cmd":"playInfo"]
        get(KugouHalfURL.musicInfo.rawValue, param: param) { (response) in
            let model = TopicModel.parse(response.dictionary as NSDictionary)
            next.onNext(model)
        }
    }
    //歌手列表(语言)
    static func kugouSinger(_ type: Int, next: PublishSubject<TopicModel>){
        let param: Parameters = ["type": type]
        get(KugouHalfURL.singer.rawValue, param: param) { (response) in
            let model = TopicModel.parse(response.dictionary as NSDictionary)
            next.onNext(model)
        }
    }
    //歌手列表(语言,性别)
    static func kugouSingerList(_ type: Int,_ sextype: Int, next: PublishSubject<TopicModel>) {
        let param: Parameters = ["type":type,"sextype":sextype,"showtype":2]
        get(KugouHalfURL.singerList.rawValue, param: param) { (response) in
            let model = TopicModel.parse(response.dictionary as NSDictionary)
            next.onNext(model)
        }
    }
    //歌手音乐列表(单曲)
    static func kugouSingerSongList(_ singerid: String,_ page: Int,_ pagesize: Int, next: PublishSubject<TopicModel>) {
        let param: Parameters = ["singerid":singerid, "page": page, "pagesize": pagesize]
        get(KugouHalfURL.singerSongList.rawValue, param: param) { (response) in
            let model = TopicModel.parse(response.dictionary as NSDictionary)
            next.onNext(model)
        }
    }
    //歌手音乐列表(专辑)
    static func kugouSingerAlbum(_ singerid: String,_ page: Int,_ pagesize: Int, next: PublishSubject<TopicModel>) {
        let param: Parameters = ["singerid":singerid, "page": page, "pagesize": pagesize]
        get(KugouHalfURL.singerAlbum.rawValue, param: param) { (response) in
            let model = TopicModel.parse(response.dictionary as NSDictionary)
            next.onNext(model)
        }
    }
    //歌手头像
    static func kugouSingerInfo(_ singerid: String, next: PublishSubject<TopicModel>) {
        let param: Parameters = ["singerid": singerid]
        get(KugouHalfURL.singerInfo.rawValue, param: param) { (response) in
            let model = TopicModel.parse(response.dictionary as NSDictionary)
            next.onNext(model)
        }
    }
    //专辑信息
    static func kugouAlbumInfo(_ albumid: String, next: PublishSubject<TopicModel>) {
        let param: Parameters = ["albumid": albumid]
        get(KugouHalfURL.albumInfo.rawValue, param: param) { (response) in
            let model = TopicModel.parse(response.dictionary as NSDictionary)
            next.onNext(model)
        }
    }
    //专辑歌曲
    static func kugouAlbumSong(_ albumid: String, next: PublishSubject<TopicModel>) {
        let param: Parameters = ["albumid": albumid, "page":1, "pagesize": -1, "plat":2]
        get(KugouHalfURL.albumSong.rawValue, param: param) { (response) in
            let model = TopicModel.parse(response.dictionary as NSDictionary)
            next.onNext(model)
        }
    }
    //本地歌曲的完整地址
    static func FULLPATH(_ filename: String) -> String {
        return "\(NSHomeDirectory())/Documents/\(filename).mp3"
    }
    //MV列表
    static func kugouSingerMV(_ singerid: String,_ singername: String,_ page: Int,_ pagesize: Int, next: PublishSubject<TopicModel>) {
        let param: Parameters = ["singerid": singerid, "singername": singername, "page": page,"pagesize": pagesize]
        get(KugouHalfURL.singerMV.rawValue, param: param) { (response) in
            let model = TopicModel.parse(response.dictionary as NSDictionary)
            next.onNext(model)
        }
    }
    //电台歌单
    static func kugouFMMusic(_ offset0: String,_ fmtype0: String,_ offset: String,_ fmid0: String, next: PublishSubject<TopicModel>){
        let param: Parameters = ["size":20, "pid":"ios","offset0": offset0,"ver":4070,"fmtype0": fmtype0, "offset": offset, "fmcount":1, "fmid0": fmid0]
        get(KugouHalfURL.FMMusic.rawValue, param: param) { (response) in
            let model = TopicModel.parse(response.dictionary as NSDictionary)
            next.onNext(model)
        }
    }
}
