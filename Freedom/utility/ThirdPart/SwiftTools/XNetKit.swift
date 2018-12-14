//
//  XNetKit.swift
//  Demo
import UIKit
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
class XNetKitConfig: NSObject {
    static let shared = XNetKitConfig()
    var scheme = ""
    var port = ""
    var domain = ""
    var method = ""
    var path = ""
    var baseURL = ""
    var parameters: [String : Any] = [:]
    var timeout: TimeInterval = 30.0
    var headers: [String : String] = [:]
    var body: [String : Any] = [:] // 返回的数据
    var fileURL: URL? // 下载时候生成的存放文件的地址
    var requestType = XRequestSerializerType.json
    var responseType = XResponseSerializerType.json
    var policy = AFSecurityPolicy.default()
    var requestTask: URLSessionTask?
    var p12InfoBlock: XP12Block = { p12 in
        return nil
    }
    var queryStringSerialization: XQueryStringSerializationBlock = { request, parameters, error in
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
var downloadFolderPath = ""
class XNetKit: NSObject {
    static let kit = XNetKit()
    var config = XNetKitConfig.shared
    private var m_requestRecord: [String : XNetKitConfig] = [:]
    private var m_lock: pthread_mutex_t!
    lazy var sessionManager: AFHTTPSessionManager = {
        let sessionManager = AFHTTPSessionManager(baseURL: nil)
        sessionManager.responseSerializer = AFHTTPResponseSerializer()
        sessionManager.securityPolicy = config.policy
        sessionManager.setSessionDidReceiveAuthenticationChallenge(self.authenticationChallengeBlock())
        return sessionManager
    }()
    override init() {
        super.init()
        pthread_mutex_init(&m_lock, nil)
    }

    func cancelRequest(_ requestAPI: XNetKitConfig?, cleanImamediately imamediately: Bool) {
        assert(requestAPI != nil, "Invalid parameter not satisfying: requestAPI != nil")
        config.requestTask?.cancel()
        if imamediately {
            for key in m_requestRecord.keys {
                if m_requestRecord[key] == requestAPI {
                    m_requestRecord.removeValue(forKey: key)
                    return
                }
            }
        }
    }

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
    }

    func sessionTask(forAPI api: XNetKitConfig) throws -> URLSessionTask? {
        let requestSerializer = requestSerizlizer(forAPI: api)
        requestSerializer.setQueryStringSerializationWith(config.queryStringSerialization)
        let detailUrl = config.path
        let baseURL = config.domain
        let URLString = "\(baseURL)\(detailUrl)"
        let method = config.method
        let parameters = config.parameters
        let mutableRequest = requestSerializer.request(withMethod: method, urlString: URLString, parameters: parameters, error: nil)
        var dataTask: URLSessionDataTask?
        dataTask = sessionManager.dataTask(with: mutableRequest as URLRequest, completionHandler: { (response: URLResponse, obj: Any?, error: Error?) -> Void in
            self.handXResponse(for: dataTask!, of: self.sessionManager, withResponseObject: response)
        } )
        config.requestTask = dataTask
        pthread_mutex_lock(&m_lock)
        m_requestRecord[api.path] = api
        pthread_mutex_unlock(&m_lock)
        dataTask?.resume()
        return dataTask
    }
    func downloadTask(by sessionManager: AFHTTPSessionManager, with URLrequest: URLRequest, downloadPath: String, progress downloadProgressBlock: (((Progress) -> Void)?)) throws -> URLSessionDownloadTask? {
        var downloadTargetPath: String
        var isDirectory: ObjCBool = false
        if !(FileManager.default.fileExists(atPath: downloadPath, isDirectory: &isDirectory)) {
            isDirectory = false
        }
        if isDirectory.boolValue {
            let fileName = URLrequest.url?.lastPathComponent
            downloadTargetPath = NSString.path(withComponents: [downloadPath, fileName!])
        } else {
            downloadTargetPath = downloadPath
        }
        let resumeDataFileExists: Bool = FileManager.default.fileExists(atPath: incompleteDownloadTempPath(forDownloadPath: downloadPath)!.path)
        let data = try Data(contentsOf: incompleteDownloadTempPath(forDownloadPath: downloadPath)!)
        let resumeDataIsValid = true
        let canBeResumed: Bool = resumeDataFileExists && resumeDataIsValid
        var resumeSucceeded = false
        var downloadTask: URLSessionDownloadTask? = nil
        if canBeResumed {
                downloadTask = sessionManager.downloadTask(withResumeData: data, progress: downloadProgressBlock, destination: { targetPath, response in
                    return URL.init(fileURLWithPath: downloadTargetPath, isDirectory: false)
                }, completionHandler: { (response: URLResponse, filePath: URL?, error: Error?) in
                    self.config.fileURL = filePath
                    self.handXResponse(for: downloadTask!, of: sessionManager, withResponseObject: response)
                })
                resumeSucceeded = true

        }
        if !resumeSucceeded {
            downloadTask = sessionManager.downloadTask(with: URLrequest, progress: downloadProgressBlock, destination: { (url, response) -> URL in
                return URL.init(fileURLWithPath: downloadTargetPath, isDirectory: false)
            }, completionHandler: { (response:URLResponse, url:URL?, error:Error?) in
                self.config.fileURL = url
                self.handXResponse(for: downloadTask!, of: sessionManager, withResponseObject: response)
            }) as URLSessionDownloadTask
        }
        return downloadTask
    }

    func handXResponse(for task: URLSessionTask, of sessionManager: AFURLSessionManager, withResponseObject responseObject: URLResponse) {
        pthread_mutex_lock(&m_lock)
        let requestAPI = m_requestRecord[task.originalRequest?.url?.absoluteString ?? ""]
        print(requestAPI?.baseURL ?? "")
        pthread_mutex_unlock(&m_lock)
        let res = task.response
        let statusCode = (res as? HTTPURLResponse)?.statusCode
        print(res!)
        print(statusCode ?? 1)
        var resultObject: Any?
        var responseString: String
        print(responseObject)
        let encoding = String.Encoding.utf8
        guard let fileURL = requestAPI?.fileURL else {
            return
        }
        let data: Data = try! Data(contentsOf: fileURL)
        responseString = String(data: data, encoding: encoding) ?? ""
        switch config.responseType {
        case .http:
            let responseSerializer = AFJSONResponseSerializer()
            responseSerializer.acceptableContentTypes = Set<String>(["application/x-www-form-urlencoded", "application/json"])
            responseSerializer.acceptableStatusCodes = IndexSet(integersIn: Range(NSRange(location: 100, length: 500))!)
            resultObject = responseSerializer.responseObject(for: task.response, data: data, error:nil)
        case .json:
            let xmlSerializer = AFXMLParserResponseSerializer()
            xmlSerializer.acceptableStatusCodes = IndexSet(integersIn: Range(NSRange(location: 100, length: 500))!)
            resultObject = xmlSerializer.responseObject(for: task.response, data: data, error: nil)
        default:break
        }
        print("\(responseObject)\(String(describing: resultObject))\(responseString)")
    }
    func deleteAllRecordedRequestAPI() {
        pthread_mutex_lock(&m_lock)
        m_requestRecord.removeAll()
        pthread_mutex_unlock(&m_lock)
    }

    func cancel(_ oneTask: URLSessionTask, resumeDataPath resumePath: URL?) {
        if oneTask.state != .completed {
            if (oneTask is URLSessionDataTask) {
                oneTask.cancel()
            }
            if (oneTask is URLSessionDownloadTask) && resumePath != nil {
                if let path = resumePath, let downloadTask = oneTask as? URLSessionDownloadTask {
                downloadTask.cancel(byProducingResumeData: { resumeData in
                  try? resumeData?.write(to: path, options: Data.WritingOptions.atomic)
                })
                }
            }
        }
    }

    func incompleteDownloadTempPath(forDownloadPath downloadPath: String) -> URL? {
        var tempPath: String? = nil
        let md5URLString = downloadPath
        let fileManager = FileManager()
        if downloadFolderPath.isEmpty {
            let cacheDir = NSTemporaryDirectory()
            downloadFolderPath = URL(fileURLWithPath: cacheDir).appendingPathComponent("income").absoluteString
        }
        if (try? fileManager.createDirectory(atPath: downloadFolderPath, withIntermediateDirectories: true, attributes: nil)) == nil {
            downloadFolderPath = ""
        }
        tempPath = URL(fileURLWithPath: downloadFolderPath).appendingPathComponent(md5URLString).absoluteString
        return URL(fileURLWithPath: tempPath ?? "")
    }
    
    func requestSerizlizer(forAPI api: XNetKitConfig) -> AFHTTPRequestSerializer {
        var requestSerializer = AFHTTPRequestSerializer()
        if config.responseType == .http {
            requestSerializer = AFHTTPRequestSerializer()
        } else if config.responseType == .json {
            requestSerializer = AFJSONRequestSerializer()
        }
        requestSerializer.httpMethodsEncodingParametersInURI = Set<String>(["GET", "HEAD", "DELETE", "PUT"])
        requestSerializer.timeoutInterval = config.timeout
        requestSerializer.cachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
        requestSerializer.allowsCellularAccess = true
        requestSerializer.setAuthorizationHeaderFieldWithUsername("name", password: "password")
        for (key,value) in config.headers {
            requestSerializer.setValue(value, forHTTPHeaderField: key)
        }
        return requestSerializer
    }

    func authenticationChallengeBlock() -> XAuthenticalBlock {
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
}
