//
//  Models.swift
//  Douyin
import UIKit
class WebPImage: UIImage {
    var imageData: Data?
    var curDisplayFrame: WebPFrame?
    var curDisplayImage: UIImage?
    var curDisplayIndex: Int = 0
    var curDecodeIndex: Int = 0
    var frameCount: Int = 0
    var frames: [WebPFrame] = []

    func curDisplayFrameDuration() -> CGFloat {
        return 0
    }

    func decodeCurFrame() -> WebPFrame? {
        return curDisplayFrame
    }

    func incrementCurDisplayIndex() {
        curDecodeIndex += 1
    }

    func isAllFrameDecoded() -> Bool {
        return true
    }
}
class WebPFrame: NSObject {
    var image: UIImage = UIImage()
    var duration: CGFloat = 0.0
//    var webPData = WebPData()
    var height: CGFloat = 0.0
    var width: CGFloat = 0.0
    var has_alpha: CGFloat = 0.0
}

class DouYinUser: BaseModel {
    var weibo_name:String?
    var google_account:String?
    var special_lock:Int?
    var is_binded_weibo:Bool?
    var shield_follow_notice:Int?
    var user_canceled:Bool?
    var avatar_larger:Avatar?
    var accept_private_policy:Bool?
    var follow_status:Int?
    var with_commerce_entry:Bool?
    var original_music_qrcode:String?
    var authority_status:Int?
    var youtube_channel_title:String?
    var is_ad_fake:Bool?
    var prevent_download:Bool?
    var verification_type:Int?
    var is_gov_media_vip:Bool?
    var weibo_url:String?
    var twitter_id:String?
    var need_recommend:Int?
    var comment_setting:Int?
    var status:Int?
    var unique_id:String?
    var hide_location:Bool?
    var enterprise_verify_reason:String?
    var aweme_count:Int?
    var story_count:Int?
    var unique_id_modify_time:Int?
    var follower_count:Int?
    var apple_account:Int?
    var short_id:String?
    var account_region:String?
    var signature:String?
    var twitter_name:String?
    var avatar_medium:Avatar?
    var verify_info:String?
    var create_time:Int?
    var story_open:Bool?
    var policy_version:Policy_version?
    var region:String?
    var hide_search:Bool?
    var avatar_thumb:Avatar?
    var school_poi_id:String?
    var shield_comment_notice:Int?
    var total_favorited:Int?
    var video_icon:Video_icon?
    var original_music_cover:String?
    var following_count:Int?
    var shield_digg_notice:Int?
    var  geofencing:[Geofencing]?
    var bind_phone:String?
    var has_email:Bool?
    var live_verify:Int?
    var birthday:String?
    var duet_setting:Int?
    var ins_id:String?
    var follower_status:Int?
    var live_agreement:Int?
    var neiguang_shield:Int?
    var uid:String?
    var secret:Int?
    var is_phone_binded:Bool?
    var live_agreement_time:Int?
    var weibo_schema:String?
    var is_verified:Bool?
    var custom_verify:String?
    var commerce_user_level:Int?
    var gender:Int?
    var has_orders:Bool?
    var youtube_channel_id:String?
    var reflow_page_gid:Int?
    var reflow_page_uid:Int?
    var nickname:String?
    var school_type:Int?
    var avatar_uri:String?
    var weibo_verify:String?
    var favoriting_count:Int?
    var share_qrcode_uri:String?
    var room_id:Int?
    var constellation:Int?
    var school_name:String?
    var activity:Activity?
    var user_rate:Int?
    var video_icon_virtual_URI:String?
}

class Avatar: BaseModel {
    var url_list = [String]()
    var uri:String?
}

class Policy_version: BaseModel {

}

class Geofencing: BaseModel {

}

class Video_icon: BaseModel {
    var url_list = [String]()
    var uri:String?
}

class Activity: BaseModel {
    var digg_count:String?
    var use_music_count:String?
}

class Aweme: BaseModel {
    var author:DouYinUser?
    var music:Music?
    var cmt_swt:Bool?
    var video_text = [Video_text]()
    var risk_infos:Risk_infos?
    var is_top:Int?
    var region:String?
    var user_digged:Int?
    var cha_list = [Cha_list]()
    var is_ads:Bool?
    var bodydance_score:Int?
    var law_critical_country:Bool?
    var author_user_id:Int?
    var create_time:Int?
    var statistics:Statistics?
    var video_labels = [Video_labels]()
    var sort_label:String?
    var descendants:Descendants?
    var geofencing = [Geofencing]()
    var is_relieve:Bool?
    var status:Status?
    var vr_type:Int?
    var aweme_type:Int?
    var aweme_id:String?
    var video:Video?
    var is_pgcshow:Bool?
    var desc:String?
    var is_hash_tag:Int?
    var share_info:Aweme_share_info?
    var share_url:String?
    var scenario:Int?
    var label_top:Label_top?
    var rate:Int?
    var can_play:Bool?
    var is_vr:Bool?
    var text_extra = [Text_extra]()

}

class Video_text: BaseModel {
}

class Risk_infos: BaseModel  {
    var warn:Bool?
    var content:String?
    var risk_sink:Bool?
    var type:Int?
}

class Cha_list: BaseModel  {
    var author:User?
    var user_count:Int?
    var schema:String?
    var sub_type:Int?
    var desc:String?
    var is_pgcshow:Bool?
    var cha_name:String?
    var type:Int?
    var cid:String?
}

class Statistics: BaseModel  {
    var digg_count:Int?
    var aweme_id:Int?
    var share_count:Int?
    var play_count:Int?
    var comment_count:Int?
}

class Video_labels: BaseModel  {
}

class Descendants: BaseModel  {
    var notify_msg:String?
    var platforms = [String]()
}

class Status: BaseModel  {
    var allow_share:Bool?
    var private_status:Int?
    var is_delete:Bool?
    var with_goods:Bool?
    var is_private:Bool?
    var with_fusion_goods:Bool?
    var allow_comment:Bool?
}

class Aweme_share_info: BaseModel  {
    var share_weibo_desc:String?
    var share_title:String?
    var share_url:String?
    var share_desc:String?
}

class Label_top: BaseModel  {
    var url_list = [String]()
    var uri:String?
}

class Text_extra: BaseModel  {
}


class Music: BaseModel {
    var extra:String?
    var cover_large:Cover?
    var cover_thumb:Cover?
    var mid:String?
    var cover_hd:Cover?
    var author:String?
    var user_count:Int?
    var play_url:Play_url?
    var cover_medium:Cover?
    var id_str:String?
    var offline_desc:String?
    var is_restricted:Bool?
    var schema_url:String?
    var source_platform:Int?
    var duration:Int?
    var status:Int?
    var is_original:Bool?
}

class Cover: BaseModel {
    var url_list = [String]()
    var uri:String?
}

class Play_url: BaseModel {
    var url_list = [String]()
    var uri:String?
}

class Video: BaseModel {
    var dynamic_cover:Cover?
    var play_addr_lowbr:Play_url?
    var width:Int?
    var ratio:String?
    var play_addr:Play_url?
    var cover:Cover?
    var height:Int?
    var bit_rate = [Bit_rate]()
    var origin_cover:Cover?
    var duration:Int?
    var download_addr:Download_addr?
    var has_watermark:Bool?
}

class Bit_rate: BaseModel {
    var bit_rate:Int?
    var gear_name:String?
    var quality_type:Int?
}

class Download_addr: BaseModel {
    var url_list = [String]()
    var uri:String?
}

class GroupChat: BaseModel {
    var msg_type:String?
    var msg_content:String?
    var visitor:Visitor?
    var pic_original:PictureInfo?
    var pic_large:PictureInfo?
    var pic_medium:PictureInfo?
    var pic_thumbnail:PictureInfo?
    var create_time:Int?

    var taskId:Int?
    var isTemp:Bool = false
    var isFailed:Bool = false
    var isCompleted:Bool = false
    var percent:Float?
    var picImage:UIImage?
    var cellHeight:CGFloat = 0

    func createTimeChat() -> GroupChat {
        let timeChat = GroupChat.init()
        timeChat.msg_type = "time"
        timeChat.msg_content = Date.formatTime(timeInterval: TimeInterval(self.create_time ?? 0))
        timeChat.create_time = self.create_time
        timeChat.cellHeight = TimeCell.cellHeight(chat: timeChat)
        return timeChat
    }

    static func initImageChat(image:UIImage) -> GroupChat {
        let chat = GroupChat.init()
        chat.msg_type = "image"
        chat.isTemp = true
        chat.picImage = image
        let picInfo = PictureInfo.init()
        picInfo.width = image.size.width
        picInfo.height = image.size.height
        chat.pic_original = picInfo
        chat.pic_large = picInfo
        chat.pic_medium = picInfo
        chat.pic_thumbnail = picInfo
        return chat
    }


    static func initTextChat(text:String) -> GroupChat {
        let chat = GroupChat.init()
        chat.msg_type = "text"
        chat.isTemp = true
        chat.msg_content = text
        return chat
    }

    func updateTempImageChat(chat:GroupChat) {
        id = chat.id
        pic_original = chat.pic_original
        pic_large = chat.pic_large
        pic_medium = chat.pic_medium
        pic_thumbnail = chat.pic_thumbnail
        create_time = chat.create_time
        isTemp = true
        percent = 1.0
        isCompleted = true
        isFailed = false
    }

    func updateTempTextChat(chat:GroupChat) {
        id = chat.id
        create_time = chat.create_time
        isTemp = true
        isCompleted = true
        isFailed = false
    }
}

class Visitor: BaseModel {
    var uid:String?
    var udid:String?
    var avatar_thumbnail:PictureInfo?
    var avatar_medium:PictureInfo?
    var avatar_large:PictureInfo?

    static func write(visitor:Visitor) {
        let dic = visitor.toDict()
        let defaults = UserDefaults.standard
        defaults.set(dic, forKey: "visitor")
        defaults.synchronize()
    }
    static func read() ->Visitor {
        let defaults = UserDefaults.standard
        let dic = defaults.object(forKey: "visitor") as! [String:Any]
        let visitor = Visitor.parse(dic as NSDictionary)
        return visitor
    }
    static func formatUDID(udid:String) -> String {
        if udid.count < 8 {
            return "************"
        }
        return udid.substring(location: 0, length:4) + "****" + udid.substring(location: udid.count - 4, length:4)
    }
}

class PictureInfo: BaseModel {
    var file_id:String?
    var width:CGFloat?
    var height:CGFloat?
    var type:String?
}

class Comment: BaseModel {
    var cid:String?
    var status:Int?
    var text:String?
    var digg_count:Int?
    var create_time:Int?
    var reply_id:String?
    var aweme_id:String?
    var user_digged:Int?
    var text_extra = [Any]()
    var user_type:String?
    var user:DouYinUser?
    var visitor:Visitor?

    var isTemp:Bool = false
    var taskId:Int?
}
