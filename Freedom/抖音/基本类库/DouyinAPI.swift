
//
//  DouyinAPI.swift
//  Freedom
import UIKit
import Foundation
import Alamofire
import Starscream
enum DouyinURL: String {
    //请求地址
    case BaseUrl = "http://116.62.9.17:8080/douyin/"
    //let BaseUrl:String = "http://192.168.1.2:8080/"
    //let BaseUrl:String = "http://192.168.43.45:8080/"
    //创建访客用户接口
    case createVisitor = "visitor/create"
    //根据用户id获取用户信息
    case findUser = "user"
    //获取用户发布的短视频列表数据
    case findAwemePost = "aweme/post"
    //获取用户喜欢的短视频列表数据
    case findAwemeFavorite = "aweme/favorite"
    //发送文本类型群聊消息
    case chatText = "groupchat/text"
    //发送单张图片类型群聊消息//根据id获取指定图片
    case chatImage = "groupchat/image"
    //发送多张图片类型群聊消息
    case chatImages = "groupchat/images"
    //获取群聊列表数据
    case findGroupChatList = "groupchat/list"
    //根据id删除指定群聊消息
    case deleteGroupChat = "groupchat/delete"
    //根据视频id发送评论
    case comment = "comment/post"
    //根据id删除评论
    case deleteComment = "comment/delete"
    //获取评论列表
    case findComment = "comment/list"

}


//enum
enum LoadingType: Int {
    case LoadStateIdle
    case LoadStateLoading
    case LoadStateAll
    case LoadStateFailed
}

enum RefreshingType: Int {
    case RefreshHeaderStateIdle
    case RefreshHeaderStatePulling
    case RefreshHeaderStateRefreshing
    case RefreshHeaderStateAll
}

enum ChatEditMessageType: Int {
    case EditTextMessage
    case EditPhotoMessage
    case EditEmotionMessage
    case EditNoneMessage
}

enum MenuActionType: Int {
    case DeleteAction
    case CopyAction
    case PasteAction
}

//
let NetworkStatesChangeNotification:String = "NetworkStatesChangeNotification"

typealias UploadProgress = (_ percent:CGFloat) -> Void
typealias HttpSuccess = (_ data:Any) -> Void
typealias HttpFailure = (_ error:Error) -> Void
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
        request.udid = String.uuid
        NetworkManager.postRequest(urlPath: DouyinURL.createVisitor.rawValue, request: request, success: { data in
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
        NetworkManager.getRequest(urlPath: DouyinURL.findUser.rawValue, request: request, success: { data in
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
        NetworkManager.getRequest(urlPath:DouyinURL.findAwemePost.rawValue, request: request, success: { data in
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
        NetworkManager.getRequest(urlPath:DouyinURL.findAwemeFavorite.rawValue, request: request, success: { data in
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
        NetworkManager.getRequest(urlPath:DouyinURL.findGroupChatList.rawValue, request: request, success: { data in
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
        request.udid = String.uuid
        request.text = text
        NetworkManager.postRequest(urlPath:DouyinURL.chatText.rawValue, request: request, success: { data in
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
        request.udid = String.uuid
        NetworkManager.uploadRequest(urlPath:DouyinURL.chatImage.rawValue, data: data, request: request, progress: { percent in
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
        request.udid = String.uuid
        NetworkManager.deleteRequest(urlPath:DouyinURL.deleteGroupChat.rawValue, request: request, success: { data in
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
        NetworkManager.getRequest(urlPath:DouyinURL.findComment.rawValue, request: request, success: { data in
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
        request.udid = String.uuid
        NetworkManager.postRequest(urlPath:DouyinURL.comment.rawValue, request: request, success: { data in
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
        request.udid = String.uuid
        NetworkManager.deleteRequest(urlPath:DouyinURL.deleteComment.rawValue, request: request, success: { data in
            let response = BaseResponse.parse(data as! NSDictionary)
            success(response)
        }, failure: { error in
            failure(error)
        })
    }

}

class NetworkManager: NSObject {
    private static let reachabilityManager = { () -> NetworkReachabilityManager in
        let manager = NetworkReachabilityManager.init()
        return manager!
    }()
    private static let sessionManager = { () -> SessionManager in
        let manager = SessionManager.default
        return manager
    }()

    static func processData(data:[String:Any], success:@escaping HttpSuccess, failure:@escaping HttpFailure) {
        let code:Int = data["code"] as! Int
        if(code == 0) {
            success(data)
        }else {
            let message:String = data["message"] as! String
            let error = NSError(domain: "", code: -1000, userInfo: [NSLocalizedDescriptionKey : message])
            failure(error)
        }
    }

    static func getRequest(urlPath:String, request:BaseRequest, success:@escaping HttpSuccess, failure:@escaping HttpFailure) {
        let parameters = request.toDict()
        sessionManager.request(DouyinURL.BaseUrl.rawValue + urlPath, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success:
                    let data:[String:Any] = response.result.value as! [String:Any]
                    processData(data: data, success: success, failure: failure)
                    break
                case .failure(let error):
                    let err:NSError = error as NSError
                    if(NetworkReachabilityManager.init()?.networkReachabilityStatus == .notReachable) {
                        failure(err)
                        return;
                    }

                    let path = response.request?.url?.path
                    if(path?.contains(DouyinURL.findUser.rawValue))! {
                        success(FileManager.readJson2Dict(fileName: "user"))
                    }else if(path?.contains(DouyinURL.findAwemePost.rawValue))! {
                        success(FileManager.readJson2Dict(fileName: "awemes"))
                    }else if(path?.contains(DouyinURL.findAwemeFavorite.rawValue))! {
                        success(FileManager.readJson2Dict(fileName: "favorites"))
                    }else if(path?.contains(DouyinURL.findComment.rawValue))! {
                        success(FileManager.readJson2Dict(fileName: "comments"))
                    }else if(path?.contains(DouyinURL.findGroupChatList.rawValue))! {
                        success(FileManager.readJson2Dict(fileName: "groupchats"))
                    }else {
                        failure(err)
                    }
                    break
                }
            })
    }

    static func deleteRequest(urlPath:String, request:BaseRequest, success:@escaping HttpSuccess, failure:@escaping HttpFailure){
        let parameters = request.toDict()
        sessionManager.request(DouyinURL.BaseUrl.rawValue + urlPath, method: HTTPMethod.delete, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success:
                    let data:[String:Any] = response.result.value as! [String:Any]
                    processData(data: data, success: success, failure: failure)
                    break
                case .failure(let error):
                    let err:NSError = error as NSError
                    failure(err)
                    break
                }
            })
    }

    static func postRequest(urlPath:String, request:BaseRequest, success:@escaping HttpSuccess, failure:@escaping HttpFailure) {
        let parameters = request.toDict()
        sessionManager.request(DouyinURL.BaseUrl.rawValue + urlPath, method: HTTPMethod.post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success:
                    let data:[String:Any] = response.result.value as! [String:Any]
                    processData(data: data, success: success, failure: failure)
                    break
                case .failure(let error):
                    let err:NSError = error as NSError
                    failure(err)
                    break
                }
            })
    }

    static func uploadRequest(urlPath:String, data:Data, request:BaseRequest, progress:@escaping UploadProgress, success:@escaping HttpSuccess, failure:@escaping HttpFailure) {
        let parameters = request.toDict()
        sessionManager.upload(multipartFormData: { multipartFormData in
            for (key,value) in parameters {
                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
            }
            multipartFormData.append(data, withName: "file", fileName: "file", mimeType: "multipart/form-data")
        }, usingThreshold: UInt64.init(), to: DouyinURL.BaseUrl.rawValue + urlPath,
           method: HTTPMethod.post,
           headers: nil,
           encodingCompletion: { encodingResult in
            switch(encodingResult) {
            case .success(let request, _, _):
                request.uploadProgress(closure: { uploadProgress in
                    progress(CGFloat(uploadProgress.completedUnitCount)/CGFloat(uploadProgress.totalUnitCount))
                }).responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success:
                        let data:[String:Any] = response.result.value as! [String:Any]
                        processData(data: data, success: success, failure: failure)
                        break
                    case .failure(let error):
                        let err:NSError = error as NSError
                        failure(err)
                        break
                    }
                })
                break
            case .failure(let error):
                let err:NSError = error as NSError
                failure(err)
                break
            }
        })
    }

    static func startMonitoring() {
        reachabilityManager.startListening()
        reachabilityManager.listener = { status in
            NotificationCenter.default.post(name:Notification.Name(rawValue: NetworkStatesChangeNotification), object: status)
        }
    }
    static func networkStatus() ->NetworkReachabilityManager.NetworkReachabilityStatus {
        return reachabilityManager.networkReachabilityStatus
    }

    static func isNotReachableStatus(status:Any?) -> Bool {
        let netStatus = status as! NetworkReachabilityManager.NetworkReachabilityStatus
        return netStatus == .notReachable
    }
}
let WebSocketDidReceiveMessageNotification:String = "WebSocketDidReceiveMessageNotification"
let MaxReConnectCount = 5

class WebSocketManger:NSObject {
    var reOpenCount:Int = 0
    let websocket = { () -> WebSocket in
        var components = URLComponents.init(url: URL.init(string: DouyinURL.BaseUrl.rawValue + "/groupchat")!, resolvingAgainstBaseURL: false)
        components?.scheme = "ws"
        let url = components?.url
        var request = URLRequest.init(url: url!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
        request.addValue(String.uuid, forHTTPHeaderField: "udid")
        let websocket = WebSocket.init(request: request)
        return websocket
    }()
    private static let instance = { () -> WebSocketManger in
        return WebSocketManger.init()
    }()
    private override init() {
        super.init()
        websocket.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(onNetworkStatusChange(notification:)), name: Notification.Name(rawValue: NetworkStatesChangeNotification), object: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func shared() -> WebSocketManger {
        return instance
    }
    func connect() {
        if(websocket.isConnected) {
            disConnect()
        }
        websocket.connect()
    }
    func disConnect() {
        websocket.disconnect()
    }
    func reConnect() {
        if(websocket.isConnected) {
            disConnect()
        }
        connect()
    }
    func sendMessage(msg:String) {
        if(websocket.isConnected) {
            websocket.write(string: msg)
        }
    }
    @objc func onNetworkStatusChange(notification:NSNotification) {
        if(!NetworkManager.isNotReachableStatus(status: notification.object) && !(websocket.isConnected)) {
            reConnect()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension WebSocketManger:WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        self.reOpenCount = 0
    }
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if(NetworkManager.networkStatus() != .notReachable) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.0 , execute: {
                if(self.websocket.isConnected) {
                    self.reOpenCount = 0
                    return
                }
                if(self.reOpenCount >= MaxReConnectCount) {
                    self.reOpenCount = 0
                    return
                }
                self.reConnect()
                self.reOpenCount += 1
            })
        }
    }
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WebSocketDidReceiveMessageNotification), object: text)
    }
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {

    }
}
