//
//  NetworkHelper.swift
//  Douyin
//
//  Created by Qiao Shi on 2018/8/2.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

import Foundation
import Alamofire
import Starscream
let NetworkStatesChangeNotification:String = "NetworkStatesChangeNotification"

typealias UploadProgress = (_ percent:CGFloat) -> Void
typealias HttpSuccess = (_ data:Any) -> Void
typealias HttpFailure = (_ error:Error) -> Void

class NetworkManager: NSObject {
    private static let reachabilityManager = { () -> NetworkReachabilityManager in
        let manager = NetworkReachabilityManager.init()
        return manager!
    }()
    private static let sessionManager = { () -> SessionManager in
        let manager = SessionManager.default
        return manager
    }()
}

//Http Method Extension
extension NetworkManager {
    static func processData(data:[String:Any], success:@escaping HttpSuccess, failure:@escaping HttpFailure) {
        let code:Int = data["code"] as! Int
        if(code == 0) {
            success(data)
        }else {
            let message:String = data["message"] as! String
            let error = NSError.init(domain: NetworkDomain, code: NetworkError.HttpResquestFailed.rawValue, userInfo: [NSLocalizedDescriptionKey : message])
            failure(error)
        }
    }
    
    static func getRequest(urlPath:String, request:BaseRequest, success:@escaping HttpSuccess, failure:@escaping HttpFailure) {
        let parameters = request.toJSON()
        sessionManager.request(BaseUrl + urlPath, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
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
                    if(path?.contains(FIND_USER_BY_UID_URL))! {
                        success(String.readJson2DicWithFileName(fileName: "user"))
                    }else if(path?.contains(FIND_AWEME_POST_BY_PAGE_URL))! {
                        success(String.readJson2DicWithFileName(fileName: "awemes"))
                    }else if(path?.contains(FIND_AWEME_FAVORITE_BY_PAGE_URL))! {
                        success(String.readJson2DicWithFileName(fileName: "favorites"))
                    }else if(path?.contains(FIND_COMMENT_BY_PAGE_URL))! {
                        success(String.readJson2DicWithFileName(fileName: "comments"))
                    }else if(path?.contains(FIND_GROUP_CHAT_BY_PAGE_URL))! {
                        success(String.readJson2DicWithFileName(fileName: "groupchats"))
                    }else {
                        failure(err)
                    }
                    break
                }
            })
    }
    
    static func deleteRequest(urlPath:String, request:BaseRequest, success:@escaping HttpSuccess, failure:@escaping HttpFailure){
        let parameters = request.toJSON()
        sessionManager.request(BaseUrl + urlPath, method: HTTPMethod.delete, parameters: parameters, encoding: URLEncoding.default, headers: nil)
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
        let parameters = request.toJSON()
        sessionManager.request(BaseUrl + urlPath, method: HTTPMethod.post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
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
        let parameters = request.toJSON()
        sessionManager.upload(multipartFormData: { multipartFormData in
            for (key,value) in parameters! {
                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
            }
            multipartFormData.append(data, withName: "file", fileName: "file", mimeType: "multipart/form-data")
        }, usingThreshold: UInt64.init(), to: BaseUrl + urlPath,
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
}

//Reachability Extension
extension NetworkManager {
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
        var components = URLComponents.init(url: URL.init(string: BaseUrl + "/groupchat")!, resolvingAgainstBaseURL: false)
        components?.scheme = "ws"
        let url = components?.url
        var request = URLRequest.init(url: url!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
        request.addValue(UDID, forHTTPHeaderField: "udid")
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
