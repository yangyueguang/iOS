//
//  XNetKit.swift
//  Demo
import UIKit
//import XCarryOn
import Alamofire
import AFNetworking
typealias XP12Block = (String) -> SecIdentity?
typealias XQueryStringSerializationBlock = (URLRequest, Any, NSErrorPointer) -> String
typealias XAuthenticalBlock = ((URLSession, URLAuthenticationChallenge, AutoreleasingUnsafeMutablePointer<URLCredential?>?) -> URLSession.AuthChallengeDisposition)?
func runOnMainQueue(block: () -> Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.sync(execute: block)
    }
}
/// 网络请求配置
class XNetKitConfig: NSObject {
    enum XRequestSerializerType : Int {
        case http = 0
        case json
    }
    enum XResponseSerializerType : Int {
        case http
        case text
        case json
        case xml
    }
    static let shared = XNetKitConfig()
    var scheme = ""
    var domain = ""
    var port = ""
    var baseURL = ""
    var method:HTTPMethod = HTTPMethod.get
    var timeout: TimeInterval = 30.0
    var headers: [String: String] = [
        "Authorization": "",
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        "token": ""
    ]
    var realURL: String {
        return scheme + domain + port + "/" + baseURL + "/"
    }
    var requestType = XRequestSerializerType.json
    var responseType = XResponseSerializerType.json
    var policy = AFSecurityPolicy.default()
    var requestTask: URLSessionTask?
    var p12InfoBlock: XP12Block = { p12 in
        return nil
    }
    fileprivate var queryStringSerialization: XQueryStringSerializationBlock = { request, parameters, error in
        var str = ""
        let param = parameters as! [String: Any]
        for (key,value) in param {
            str += "\(key)=\(value)&"
        }
        return str
    }
    /// 有需要的时候这样设置，模版
    func setCompanyPolicy() {
        // 双向认证
        let cerPath = Bundle.main.url(forResource: "cer", withExtension: "der")!
        let cer = try? Data(contentsOf: cerPath)
        let certSet: Set<Data> = Set([cer!])
        let securityPolicy = AFSecurityPolicy(pinningMode: .certificate)
        securityPolicy.pinnedCertificates = certSet
        securityPolicy.allowInvalidCertificates = true
        securityPolicy.validatesDomainName = true
        policy = securityPolicy
    }
}

//FIXME: 以下是返回数据解析类
public struct APIResponse {
    enum ResponseType: Error {
        case success
        case timeOut
        case invalidToken
        case netError
        case unknown
    }
    public class APIResponseConfiguration {
        static let shared = APIResponseConfiguration()
        var tokenInavalidCode: Int = 500
        var tokenInvalid: (()->Void)? = nil
        var successCode: Int = 200
        var dataKey = "data"
        var messageKey = "message"
        var codeKey = "code"
    }
    var config = APIResponseConfiguration.shared
    var responseType = ResponseType.unknown
    let request: URLRequest?
    let response: URLResponse?
    let data: Data?
    let error: Error?

    var dictionary: [String: Any] = [:]
    var body:[String: Any] = [:]
    var message = ""

    public init(request: URLRequest?,
                response: URLResponse?,
                data: Data?,
                error: Error?,
                dictionary: [String: Any]?) {
        self.request = request
        self.response = response
        self.data = data
        self.error = error
        self.dictionary = dictionary ?? [:]
        if let err = self.error {
            let errorCode = (err as NSError).code
            if errorCode == NSURLErrorCancelled
                || errorCode == NSURLErrorCannotFindHost
                || errorCode == NSURLErrorNotConnectedToInternet
                || errorCode == NSURLErrorCannotConnectToHost
                || errorCode == NSURLErrorTimedOut {
                self.responseType = .netError
                return
            }
        }
        if let resultCode = (self.dictionary[config.codeKey] as? Int) {
            if resultCode == config.tokenInavalidCode {
                self.responseType = .invalidToken
                self.config.tokenInvalid?()
            }else if resultCode == config.successCode {
                self.responseType = .success
            }
        }
        if let body = self.dictionary[config.dataKey] as? [String : Any] {
            self.body = body
        }
        if let message = self.dictionary[config.messageKey] as? String {
            self.message = message
        }
    }
}

/// 以下是AFNetworking网络请求类
class XNetKit: NSObject {
    static let kit = XNetKit()
    var config = XNetKitConfig.shared
    private var m_requestRecord: [String : XNetKitConfig] = [:]
    private var m_lock: pthread_mutex_t = pthread_mutex_t.init()
    let serverTrustPolicies: [String: ServerTrustPolicy] = [
        "test.example.com": .pinCertificates(
            certificates: ServerTrustPolicy.certificates(),
            validateCertificateChain: true,
            validateHost: true
        ),
        "insecure.expired-apis.com": ServerTrustPolicy.disableEvaluation
    ]
    private lazy var sessionManager: AFHTTPSessionManager = {
        let manager = AFHTTPSessionManager(baseURL: nil)
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.securityPolicy = config.policy
        manager.setSessionDidReceiveAuthenticationChallenge(self.authenticationChallengeBlock())
        return manager
    }()
    /// 取消所有的请求
    func cancelAllRequests() {
        pthread_mutex_lock(&m_lock)
        let allKeys = m_requestRecord.keys
        pthread_mutex_unlock(&m_lock)
        for key in allKeys {
            pthread_mutex_lock(&m_lock)
            let requestAPI = m_requestRecord[key]
            pthread_mutex_unlock(&m_lock)
            requestAPI?.requestTask?.cancel()
        }
        pthread_mutex_lock(&m_lock)
        m_requestRecord.removeAll()
        pthread_mutex_unlock(&m_lock)
    }

    func configFromPath(_ path: String) -> XNetKitConfig? {
        return m_requestRecord[path]
    }
    /// AFN请求
    static public func requestAFN(_ url: String, parameters: [String: Any], method: HTTPMethod = HTTPMethod.get, completion:@escaping (APIResponse) -> Void) -> Void {
        self.kit.requestAFN(url, parameters: parameters, method: method, completion: completion)
    }
    /// AFN请求
    func requestAFN(_ url: String, parameters: [String: Any], method: HTTPMethod = HTTPMethod.get, completion:@escaping (APIResponse) -> Void) -> Void {
        config.method = method
        sessionManager.requestSerializer = requestSerizlizer(forAPI: config)
        sessionManager.responseSerializer = responseSerizlizer(forAPI: config)
        let request = sessionManager.requestSerializer.request(withMethod: config.method.rawValue, urlString: config.realURL + url, parameters: parameters, error: nil) as URLRequest
        //        sessionManager.setDataTaskDidReceiveDataBlock { (session, task, obj) in
        //            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        //            print(obj)
        //        }
        config.requestTask = sessionManager.dataTask(with: request, uploadProgress: nil, downloadProgress: nil) { (response: URLResponse, obj: Any?, error: Error?) -> Void in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            let res = APIResponse(request: request, response: response, data: obj as? Data, error: error, dictionary: (obj as? [String: Any]))
            completion(res)
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        pthread_mutex_lock(&m_lock)
        m_requestRecord[url] = config
        pthread_mutex_unlock(&m_lock)
        config.requestTask?.resume()
    }

    private func requestSerizlizer(forAPI api: XNetKitConfig) -> AFHTTPRequestSerializer {
        var requestSerializer = AFHTTPRequestSerializer()
        if config.requestType == .http {
            requestSerializer = AFHTTPRequestSerializer()
            requestSerializer.setValue("text/html", forHTTPHeaderField: "Accept")
        } else if config.requestType == .json {
            requestSerializer = AFJSONRequestSerializer()
            requestSerializer.setValue("text/json", forHTTPHeaderField: "Accept")
        }
        requestSerializer.httpMethodsEncodingParametersInURI = Set<String>(["GET", "HEAD", "DELETE", "PUT"])
        requestSerializer.timeoutInterval = config.timeout
        requestSerializer.cachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
        requestSerializer.allowsCellularAccess = true
        requestSerializer.setAuthorizationHeaderFieldWithUsername("name", password: "password")
        requestSerializer.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        requestSerializer.setQueryStringSerializationWith(config.queryStringSerialization)
        for (key,value) in config.headers {
            requestSerializer.setValue(value, forHTTPHeaderField: key)
        }
        return requestSerializer
    }
    private func responseSerizlizer(forAPI api: XNetKitConfig) -> AFHTTPResponseSerializer {
        var responseSerializer: AFHTTPResponseSerializer
        if config.responseType == .json {
            let jsonSerializer = AFJSONResponseSerializer()
            jsonSerializer.acceptableContentTypes = Set<String>(["application/x-www-form-urlencoded", "application/json"])
            jsonSerializer.acceptableStatusCodes = IndexSet(integersIn: Range(NSRange(location: 100, length: 500))!)
            responseSerializer = jsonSerializer
        }else{
            let xmlSerializer = AFXMLParserResponseSerializer()
            xmlSerializer.acceptableStatusCodes = IndexSet(integersIn: Range(NSRange(location: 100, length: 500))!)
            responseSerializer = xmlSerializer
        }
        let acceptTypes = ["application/json", "text/json", "text/plain", "application/xml", "text/xml", "text/html", "text/javascript", "application/x-plist", "image/tiff", "image/jpeg", "image/gif", "image/png", "image/ico", "image/x-icon", "image/bmp", "image/x-bmp", "image/x-xbitmap", "image/x-win-bitmap"]
        responseSerializer.acceptableContentTypes = Set<String>(acceptTypes)
        return responseSerializer
    }
    private func authenticationChallengeBlock() -> XAuthenticalBlock {
        let block = {(session:URLSession, challenge: URLAuthenticationChallenge, _credential: AutoreleasingUnsafeMutablePointer<URLCredential?>?) -> URLSession.AuthChallengeDisposition in
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?
            if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
                let policy = self.config.policy
                if let trust = challenge.protectionSpace.serverTrust, policy.evaluateServerTrust(trust, forDomain: challenge.protectionSpace.host) {
                    credential = URLCredential(trust: trust)
                    if credential != nil {
                        disposition = .useCredential
                    } else {
                        disposition = URLSession.AuthChallengeDisposition.performDefaultHandling
                    }
                } else {
                    disposition = URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge
                }
            } else {
                var identity: SecIdentity? = nil
                identity = self.config.p12InfoBlock(challenge.protectionSpace.host)
                if let identity = identity {
                    var certificate: SecCertificate!
                    SecIdentityCopyCertificate(identity, &certificate)
                    let certsArray = [certificate!]
                    var rawPointer: UnsafeRawPointer? = UnsafeRawPointer(certsArray)
                    let cfArray = withUnsafeMutablePointer(to: &rawPointer) { certs in
                        CFArrayCreate(kCFAllocatorDefault, certs, certsArray.count, nil)
                    }
                    credential = URLCredential(identity: identity, certificates: cfArray! as? [Any], persistence: .permanent)
                    disposition = URLSession.AuthChallengeDisposition.useCredential
                }
            }
            _credential?.pointee = credential
            return disposition
        }
        return block
    }


    //FIXME: 以下是Almofire的网络请求
    @discardableResult
    public func requestPolicy(_ url: String,
                              parameters: Parameters?,
                              method: HTTPMethod = .get ,
                              encoding: ParameterEncoding = URLEncoding.default,
                              headers: HTTPHeaders = [:], completion:@escaping (APIResponse) -> Void) -> DataRequest{
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let manager = SessionManager(serverTrustPolicyManager: ServerTrustPolicyManager(policies: self.serverTrustPolicies))
        let baseRequest = manager.request(config.realURL + url, method: method, parameters: parameters, encoding: encoding, headers: headers)
        baseRequest.responseJSON { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            let res = APIResponse(request: baseRequest.request, response: nil, data: nil, error: response.result.error, dictionary: response.result.value as? [String: Any])
            completion(res)
        }
        return baseRequest
    }

    @discardableResult
    static public func request(_ url: String,
                        parameters: Parameters?,
                        method: HTTPMethod = .connect ,
                        encoding: ParameterEncoding = URLEncoding.default,
                        headers: HTTPHeaders = [:], completion:@escaping (APIResponse) -> Void) -> DataRequest{
       return self.kit.request(url, parameters: parameters, method: method, encoding: encoding, headers: headers, completion: completion)
    }
    @discardableResult
    public func request(_ url: String,
                        parameters: Parameters?,
                        method: HTTPMethod = .connect,
                        encoding: ParameterEncoding = URLEncoding.default,
                        headers: HTTPHeaders = [:], completion:@escaping (APIResponse) -> Void) -> DataRequest{
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        XHud.show()
        let baseRequest = Alamofire.request(config.realURL + url, method: (method == .connect ? config.method : method), parameters: parameters, encoding: encoding, headers: headers)
        baseRequest.responseJSON { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            XHud.hide()
            let res = APIResponse(request: baseRequest.request, response: nil, data: nil, error: response.result.error, dictionary: response.result.value as? [String: Any])
            if res.responseType == .success {
                Dlog(res.dictionary.jsonString(prettify: true))
                completion(res)
            }else{
                XHud.flash(XHudStyle.withDetail(message: "网络请求失败"), delay: 3)
            }
        }
        return baseRequest
    }

    /// 直接返回需要对象的网络请求
    /// requestModel("", parameters: nil) { (stu: Student) in print(stu.name) }
    public func requestModel<T: NSObject>(_ url: String,
                        parameters: Parameters?,
                        method: HTTPMethod = .connect,
                        encoding: ParameterEncoding = URLEncoding.default,
                        headers: HTTPHeaders = [:], completion:@escaping (T) -> Void) -> DataRequest{
        return request(url, parameters: parameters,method: method,encoding: encoding,headers: headers) { (res) in
            let obj = T.parse(res.body)
            completion(obj)
        }
    }

    @discardableResult
    static public func requestProxy(_ url: String,
                        parameters: Parameters?,
                        method: HTTPMethod = .connect,
                        encoding: ParameterEncoding = URLEncoding.default,
                        headers: HTTPHeaders = [:], completion:@escaping (APIResponse) -> Void) -> DataRequest{
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        XHud.show()
        let baseRequest = Alamofire.request(kit.config.realURL + url, method: (method == .connect ? kit.config.method : method), parameters: parameters, encoding: encoding, headers: headers)
        baseRequest.responseJSON { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            XHud.hide()
            let res = APIResponse(request: baseRequest.request, response: nil, data: nil, error: response.result.error, dictionary: response.result.value as? [String: Any])
            completion(res)
        }
        return baseRequest
    }
    @discardableResult
    static public func get(_ url: String,
                           param: Parameters? = nil,
                           completion:@escaping (APIResponse) -> Void) -> DataRequest{
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        XHud.show()
        let baseRequest = Alamofire.request(url,
                                            method: .get,
                                            parameters: param)
        baseRequest.responseJSON { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            XHud.hide()
            let res = APIResponse(request: baseRequest.request, response: nil, data: nil, error: response.result.error, dictionary: response.result.value as? [String: Any])
            completion(res)
        }
        return baseRequest
    }


    @discardableResult
    public func download(_ url: String,
                        parameters: Parameters?,
                        method: HTTPMethod = .get,
                        encoding: ParameterEncoding = URLEncoding.default,
                        headers: HTTPHeaders = [:], completion:@escaping (APIResponse) -> Void) -> DownloadRequest {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        XHud.show()
        let baseRequest = Alamofire.download(url, method: method, parameters: parameters, encoding: encoding, headers: headers) { (url, urlresponse) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
            return (URL(fileURLWithPath: String(describing : NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, false)[0]+(urlresponse.suggestedFilename ?? "data"))), [.createIntermediateDirectories, .removePreviousFile])

        }
        baseRequest.downloadProgress { (progress) in
            let pro = progress.completedUnitCount / progress.totalUnitCount
            print(pro)
        }
        return baseRequest
    }

}

