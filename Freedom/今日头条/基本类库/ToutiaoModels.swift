//
//  ToutiaoModels.swift
//  Freedom
import UIKit
import RxSwift
@objcMembers
class TopicModel: NSObject {
    var nextUrl = ""
    var limit: Int = 0
    var total: Int = 0
    var currentPage: Int = 0
    var top: [TopicNew] = []
    var lists: [TopicNew] = []

    @objcMembers
    class TopicNew: NSObject {
        var read: Int = 0
        var video = false
        var comment = false
        var type = false
        var isTop = false
        var forbidShare = false
        var favorite = false
        var forbidComment = false
        var title = ""
        var rawUrl = ""
        var date = ""
        var topSpecial = ""
        var source = ""
        var mp_img = ""
        var topSpecialBgColor = ""
        var summary = ""
        var specialBgColor = ""
        var size = ""
        var summary_web = ""
        var checksum = ""
        var aId = ""
        var video_url = ""
        var special = ""
        var cateId: [Int] = []
        var tags: [String] = []
        var media: [TopicMedia] = []
        
        @objcMembers
        class TopicMedia: NSObject {
            var w: Int = 0
            var h: Int = 0
            var type: Int = 0
            var url = ""
            var suffix = ""
            var sUrl = ""
            var mUrl = ""
        }
    }
}
