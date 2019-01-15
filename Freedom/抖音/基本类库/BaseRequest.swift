//
class BaseResponse: BaseModel {
    var code:Int?
    var message:String?
    var has_more:Int = 0
    var total_count:Int = 0
}
class VisitorResponse: BaseResponse {
    var data:Visitor?
}
class UserResponse: BaseResponse {
    var data:User?
}

class AwemeResponse: BaseResponse {
    var data:Aweme?
}
class AwemeListResponse: BaseResponse {
    var data = [Aweme]()
}

class GroupChatResponse: BaseResponse {
    var data:GroupChat?
}
class GroupChatListResponse: BaseResponse {
    var data = [GroupChat]()
}
class CommentResponse: BaseResponse {
    var data:Comment?
}
class CommentListResponse: BaseResponse {
    var data = [Comment]()
}

class BaseRequest: BaseModel {
}
class VisitorRequest: BaseRequest {

    var udid:String?

    static func saveOrFindVisitor(success:@escaping HttpSuccess, failure:@escaping HttpFailure) {
        let request = VisitorRequest.init()
        request.udid = UDID
        NetworkManager.postRequest(urlPath: CREATE_VISITOR_BY_UDID_URL, request: request, success: { data in
            let response = VisitorResponse.parse(data as! NSDictionary)
            success(response)
        }, failure: { error in
            failure(error)
        })
    }

}

class UserRequest: BaseRequest {

    var uid:String?

    static func findUser(uid:String, success:@escaping HttpSuccess, failure:@escaping HttpFailure) {
        let request = UserRequest.init()
        request.uid = uid
        NetworkManager.getRequest(urlPath: FIND_USER_BY_UID_URL, request: request, success: { data in
            let response = UserResponse.parse(data as! NSDictionary)
            success(response.data ?? User.init())
        }, failure: { error in
            failure(error)
        })
    }

}

class AwemeListRequest: BaseRequest {

    var uid:String?
    var page:Int?
    var size:Int?

    static func findPostAwemesPaged(uid:String, page:Int, _ size:Int = 20, success:@escaping HttpSuccess, failure:@escaping HttpFailure) {
        let request = AwemeListRequest.init()
        request.uid = uid
        request.page = page
        request.size = size
        NetworkManager.getRequest(urlPath: FIND_AWEME_POST_BY_PAGE_URL, request: request, success: { data in
            let response = AwemeListResponse.parse(data as! NSDictionary)
            success(response)
        }, failure: { error in
            failure(error)
        })
    }

    static func findFavoriteAwemesPaged(uid:String, page:Int, _ size:Int = 20, success:@escaping HttpSuccess, failure:@escaping HttpFailure) {
        let request = AwemeListRequest.init()
        request.uid = uid
        request.page = page
        request.size = size
        NetworkManager.getRequest(urlPath: FIND_AWEME_FAVORITE_BY_PAGE_URL, request: request, success: { data in
            let response = AwemeListResponse.parse(data as! NSDictionary)
            success(response)
        }) { error in
            failure(error)
        }
    }

}

class GroupChatListRequest: BaseRequest {

    var page:Int?
    var size:Int?

    static func findGroupChatsPaged(page:Int, _ size:Int = 20, success:@escaping HttpSuccess, failure:@escaping HttpFailure) {
        let request = GroupChatListRequest.init()
        request.page = page
        request.size = size
        NetworkManager.getRequest(urlPath: FIND_GROUP_CHAT_BY_PAGE_URL, request: request, success: { data in
            let response = GroupChatListResponse.parse(data as! NSDictionary)
            success(response)
        }, failure: { error in
            failure(error)
        })
    }

}

class PostGroupChatTextRequest: BaseRequest {

    var udid:String?
    var text:String?

    static func postGroupChatText(text:String, success:@escaping HttpSuccess, failure:@escaping HttpFailure) {
        let request = PostGroupChatTextRequest.init()
        request.udid = UDID
        request.text = text
        NetworkManager.postRequest(urlPath: POST_GROUP_CHAT_TEXT_URL, request: request, success: { data in
            let response = GroupChatResponse.parse(data as! NSDictionary)
            success(response)
        }, failure: { error in
            failure(error)
        })
    }

}

class PostGroupChatImageRequest: BaseRequest {

    var udid:String?

    static func postGroupChatImage(data:Data, _ progress:@escaping UploadProgress, success:@escaping HttpSuccess, failure:@escaping HttpFailure) {
        let request = PostGroupChatImageRequest.init()
        request.udid = UDID
        NetworkManager.uploadRequest(urlPath: POST_GROUP_CHAT_IMAGE_URL, data: data, request: request, progress: { percent in
            progress(percent)
        }, success: { data in
            let response = GroupChatResponse.parse(data as! NSDictionary)
            success(response)
        }, failure: { error in
            failure(error)
        })
    }

}

class DeleteGroupChatRequest: BaseRequest {
    var udid:String?
    static func deleteGroupChat(id:Int, success:@escaping HttpSuccess, failure:@escaping HttpFailure) {
        let request = DeleteGroupChatRequest.init()
        request.id = id
        request.udid = UDID
        NetworkManager.deleteRequest(urlPath: DELETE_GROUP_CHAT_BY_ID_URL, request: request, success: { data in
            let response = BaseResponse.parse(data as! NSDictionary)
            success(response)
        }, failure: { error in
            failure(error)
        })
    }

}

class CommentListRequest: BaseRequest {

    var page:Int?
    var size:Int?
    var aweme_id:String?

    static func findCommentsPaged(aweme_id:String, page:Int, _ size:Int = 20, success:@escaping HttpSuccess, failure:@escaping HttpFailure) {
        let request = CommentListRequest.init()
        request.page = page
        request.size = size
        request.aweme_id = aweme_id
        NetworkManager.getRequest(urlPath: FIND_COMMENT_BY_PAGE_URL, request: request, success: { data in
            let response = CommentListResponse.parse(data as! NSDictionary)
            success(response)
        }, failure: { error in
            failure(error)
        })
    }

}

class PostCommentRequest: BaseRequest {

    var aweme_id:String?
    var text:String?
    var udid:String?
    static func postCommentText(aweme_id:String, text:String, success:@escaping HttpSuccess, failure:@escaping HttpFailure) {
        let request = PostCommentRequest.init()
        request.aweme_id = aweme_id
        request.text = text
        request.udid = UDID
        NetworkManager.postRequest(urlPath: POST_COMMENT_URL, request: request, success: { data in
            let response = CommentResponse.parse(data as! NSDictionary)
            success(response)
        }, failure: { error in
            failure(error)
        })
    }

}

class DeleteCommentRequest: BaseRequest {

    var cid:String?
    var udid:String?

    static func deleteComment(cid:String, success:@escaping HttpSuccess, failure:@escaping HttpFailure) {
        let request = DeleteCommentRequest.init()
        request.cid = cid
        request.udid = UDID
        NetworkManager.deleteRequest(urlPath: DELETE_COMMENT_BY_ID_URL, request: request, success: { data in
            let response = BaseResponse.parse(data as! NSDictionary)
            success(response)
        }, failure: { error in
            failure(error)
        })
    }

}
