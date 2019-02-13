//
//  IqiyiModels.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2019/1/22.
//  Copyright © 2019 薛超. All rights reserved.
//

import UIKit

class IqiyiHomeModel: NSObject {
    var search_default_word_for_ipad = ""
    var boxes = [AnyHashable]()
    var banner = [AnyHashable]()
    var index_channel_content_version = ""
}
class IqiyiBoxesModel: NSObject {
    var videos = [AnyHashable]()
    var ipad_display_type: NSNumber?
    var index_page_channel_icon = ""
    var display_type: NSNumber?
    var index_page_channel_icon_for_ipad = ""
    var video_count_for_ipad_index_page: NSNumber?
    var cid = ""
    var title = ""
    var sub_title = ""
    var redirect_type = ""
    var url_for_more_link = ""
    var is_podcast = ""
    var height: Float = 0.0
}
class IqiyiBannerModel: NSObject {
    var is_albumcover: NSNumber?
    var image_1452_578 = ""
    var image_800_450 = ""
    var platform_for_url_type = ""
    var title = ""
    var url = ""
    var url_include_ids_count: NSNumber?
    var vip_information: NSObject?
    var plid = ""
    var short_desc = ""
    var image_726_289 = ""
    var iid = ""
    var small_img = ""
    var game_information: NSObject?
    var aid = ""
    var image_640_310 = ""
    var big_img = ""
    var type = ""
    var browser_for_url_type: NSNumber?
}
class IqiyiVideosModel: NSObject {
    var yaofeng = ""
    var is_albumcover: NSNumber?
    var pv = ""
    var corner_image = ""
    var title = ""
    var url = ""
    var url_include_ids_count: NSNumber?
    var owner_nick = ""
    var short_desc = ""
    var game_information: NSObject?
    var iid = ""
    var small_img = ""
    var stripe_b_r = ""
    var plid = ""
    var aid = ""
    var owner_id = ""
    var type = ""
    var image_800x450 = ""
    var big_img = ""
}

class IqiyiVideoDetailModel: NSObject {
    var total_vv = ""
    var duration: NSNumber?
    var total_comment: NSNumber?
    var img = ""
    var title = ""
    var play_url = ""
    var channel_pic = ""
    var cats = ""
    var plid = ""
    var isVuser = ""
    var type = ""
    var username = ""
    var format_flag: NSNumber?
    var img_hd = ""
    var iid = ""
    var subed_num: NSNumber?
    var item_id = ""
    var user_desc = ""
    var desc = ""
    var user_play_times = ""
    var stripe_bottom = ""
    var cid: NSNumber?
    var userid: NSNumber?
    var total_fav: NSNumber?
    var limit: NSNumber?
    var item_media_type = ""
}
class IqiyiRecommentModel: NSObject {
    var total_pv: NSNumber?
    var pubdate = ""
    var img_16_9 = ""
    var pv_pr = ""
    var duration: NSNumber?
    var pv = ""
    var total_comment: NSNumber?
    var img = ""
    var title = ""
    var state = ""
    var cats = ""
    var username = ""
    var tags = [String]()
    var img_hd = ""
    var itemCode = ""
    var total_down = ""
    var total_up = ""
    var desc = ""
    var stripe_bottom = ""
    var userid = ""
    var total_fav: NSNumber?
    var reputation = ""
    var limit = ""
    var time = ""
}
class IqiyiDiscoverModel: NSObject {
    var group_number: NSNumber?
    var title = ""
    var items = [AnyHashable]()
    var skip_url = ""
    var sub_title = ""
    var module_icon = ""
    var sub_type = ""
    var group_location: NSNumber?
}

class IqiyiSubItemModel: NSObject {
    var itemID: NSNumber?
    var formatTotalTime = ""
    var code = ""
    var totalTime: NSNumber?
    var pubDate: NSNumber?
    var playLink = ""
    var title = ""
    var userpic_220_220 = ""
    var playNum: NSNumber?
    var bigPic = ""
    var limit: NSNumber?
    var picurl = ""
    var playtimes: NSNumber?
    var userpic = ""
    var formatPubDate = ""
    var type = ""
    var uid: NSNumber?
}
class IqiyiSubscribeModel: NSObject {
    var video_count: NSNumber?
    var des = ""
    var title = ""
    var channelized_type = ""
    var subed_count = ""
    var last_item = [AnyHashable]()
    var podcast_user_id = ""
    var isVuser = ""
    var image = ""
    var avatar = ""
}

class IqiyiClassifyModel: NSObject {
    var normal_icon_for_ipad_v_4 = ""
    var top_state: NSNumber?
    var selected_icon_for_v_4 = ""
    var tabs = [AnyHashable]()
    var image_at_bottom = ""
    var the_whole_state: NSNumber?
    var display_flag: NSNumber?
    var selected_icon = ""
    var label_top_state: NSNumber?
    var selected_icon_for_apad_v_4 = ""
    var normal_icon_for_apad_v_4 = ""
    var choiceness_state: NSNumber?
    var is_listing: NSNumber?
    var redirect_type = ""
    var channel_order_for_pad: NSNumber?
    var icon = ""
    var image_at_top = ""
    var show_operation: NSNumber?
    var display_flag_bak: NSNumber?
    var selected_icon_for_ipad_v_4_1_plus = ""
    var tagType: NSNumber?
    var label_tops = [AnyHashable]()
    var tabs_state: NSNumber?
    var young_app_launcher = ""
    var normal_icon_for_v_4 = ""
}
