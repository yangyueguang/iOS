/*
func test(){
    let downloader = DownloadService.service.takeDownloader(resource: CRResource())
    downloader.subscribe(observer: self) { (status, progress,task) in
        DispatchQueue.main.async {
            print(progress)
        }
    }
    downloader.begin()
    downloader.desubscribe(observer: self)
}
*/
import Foundation
import AFNetworking
@objc
enum ResourceStatus : Int {
    case normal = 0
    case downloading = 1
    case pause = 2
    case invalid = 3
    case finish = 4
    case failed = 5
}
public enum ResourceType : String {
    case pm = "pm"
    case rtf = "rtf"
    case rb = "rb"
    case wax = "wax"
    case ph3 = "ph3"
    case jar = "jar"
    case UTI3g2 = "3g2"
    case aifc = "aifc"
    case ph4 = "ph4"
    case ico = "ico"
    case exe = "exe"
    case mov = "mov"
    case ppt = "ppt"
    case hqx = "hqx"
    case ai = "ai"
    case xbm = "xbm"
    case UTI3gpp = "3gpp"
    case psd = "psd"
    case cpp = "cpp"
    case m4p = "m4p"
    case cxx = "cxx"
    case jav = "jav"
    case ram = "ram"
    case png = "png"
    case gz = "gz"
    case tiff = "tiff"
    case jnlp = "jnlp"
    case php = "php"
    case bmp = "bmp"
    case UTIclass = "class"
    case mig = "mig"
    case tif = "tif"
    case aiff = "aiff"
    case rm = "rm"
    case defs = "defs"
    case cc = "cc"
    case py = "py"
    case UTI3gp = "3gp"
    case sh = "sh"
    case c = "c"
    case qt = "qt"
    case pct = "pct"
    case bin = "bin"
    case UTIhPP = "h++"
    case vcard = "vcard"
    case wmp = "wmp"
    case h = "h"
    case plugin = "plugin"
    case zip = "zip"
    case rar = "rar"
    case qtif = "qtif"
    case gzip = "gzip"
    case htm = "htm"
    case qif = "qif"
    case au = "au"
    case m = "m"
    case m15 = "m15"
    case cpio = "cpio"
    case pict = "pict"
    case js = "js"
    case o = "o"
    case dll = "dll"
    case r = "r"
    case gif = "gif"
    case exp = "exp"
    case s = "s"
    case jscript = "jscript"
    case xml = "xml"
    case ttc = "ttc"
    case xls = "xls"
    case cp = "cp"
    case csh = "csh"
    case tgz = "tgz"
    case vcf = "vcf"
    case mpeg = "mpeg"
    case wmv = "wmv"
    case wvx = "wvx"
    case java = "java"
    case caf = "caf"
    case app = "app"
    case ttf = "ttf"
    case hpp = "hpp"
    case wmx = "wmx"
    case hxx = "hxx"
    case gtar = "gtar"
    case pntg = "pntg"
    case jpeg = "jpeg"
    case avi = "avi"
    case m4a = "m4a"
    case rtfd = "rtfd"
    case mm = "mm"
    case m4b = "m4b"
    case m75 = "m75"
    case aif = "aif"
    case html = "html"
    case mpg = "mpg"
    case rbw = "rbw"
    case doc = "doc"
    case icns = "icns"
    case vfw = "vfw"
    case ulw = "ulw"
    case wma = "wma"
    case bundle = "bundle"
    case UTIcPP = "c++"
    case javascript = "javascript"
    case wm = "wm"
    case php3 = "php3"
    case applescript = "applescript"
    case jpg = "jpg"
    case mp3 = "mp3"
    case command = "command"
    case php4 = "php4"
    case mp4 = "mp4"
    case tar = "tar"
    case scpt = "scpt"
    case UTI3gp2 = "3gp2"
    case snd = "snd"
    case wav = "wav"
    case txt = "txt"
    case jp2 = "jp2"
    case phtml = "phtml"
    case pic = "pic"
    case pl = "pl"
    case framework = "framework"
    case pdf = "pdf"
    case ra = "ra"
    case wave = "wave"
    case rmvb = "rmvb"
    case docx = "docx"
    case xlsx = "xlsx"
    case pptx = "pptx"
//    case vsd = "vsd"
//    case vsdx = "vsdx"
    case unknown = "other"
    func UTI() -> (String,String) {
        let UTIPath = Bundle.main.path(forResource: "UTI", ofType: "plist")
        let UTIDict = NSDictionary.init(contentsOfFile:UTIPath!)
        let key = self.rawValue
        var value = "public.content"
        if let uti = UTIDict?.object(forKey: key){
            value = uti as! String
        }
        return (key,value)
    }
}

open class CRResource: NSObject {
    dynamic var id:Int32=0//序号
    dynamic var password=""//密码
    dynamic var checkCode=""//唯一标识
//    dynamic var type : ResourceType = .unknown//文件类型
    dynamic var type:ResourceType{
        get {
            let exten = (self.name as NSString).pathExtension
            if let type = ResourceType(rawValue: exten.lowercased()){
                return type
            }else{
                return .unknown
            }
        }
        set {
//            self.type = ResourceType(rawValue: newValue.rawValue)!
        }
    }
    dynamic var name=""//文件名字
    dynamic var path=""//文件本地路径
    dynamic var url=""//文件网络地址
    dynamic var size:Double = 0//文件大小
    dynamic var resumeData : NSData?//文件数据流
    dynamic var status : ResourceStatus = .normal
}
@objcMembers
/// 下载器
open class ResourceDownloader : NSObject {
    typealias TaskObserverBlock = (_ status:ResourceStatus, _ progress: Float , _ task: AnyObject) -> Void
    fileprivate var insideDownloadTask : URLSessionDownloadTask?
    private let sessionManager : AFURLSessionManager
    fileprivate var resource : CRResource!
    private var observers = [AnyHashable: TaskObserverBlock]()
    fileprivate(set) var progress : Float = 0
    deinit {
        print("deinit ResourceDownloader")
    }
    private func copyResourceToRecorce(res:CRResource)->CRResource{
        let newRes = CRResource()
        newRes.url = res.url
        newRes.id = res.id
        newRes.password=res.password
        newRes.checkCode=res.checkCode
        newRes.name=res.name
        newRes.path=res.path
        newRes.size = res.size
        newRes.resumeData = res.resumeData
        newRes.status = res.status
        return newRes
    }
    fileprivate init(resource:CRResource,_ manager: AFURLSessionManager) {
        sessionManager = manager
        super.init()
        let pre = NSPredicate.init(format: "checkCode=%@",resource.checkCode)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) 没打算支持序列化")
    }
    // MARK: - 公开函数
    func subscribe(observer:AnyHashable, updateBlock: @escaping TaskObserverBlock) {
        observers.removeAll()
        observers[observer.hashValue] = updateBlock
        DispatchQueue.main.async {[unowned self] in
            updateBlock(self.resource.status,self.progress, self)
        }
    }
    func desubscribe(observer:AnyHashable) {
        observers.removeValue(forKey: observer.hashValue)
    }
    /// 开始下载
    func begin() {
        update(status: .downloading, progress: 0)
        self.insideDownloadTask?.resume()
    }
    func pause() {
        self.insideDownloadTask?.cancel(byProducingResumeData: { [unowned self] resumeData in
            self.resource.resumeData = resumeData! as NSData
            self.update(status:.pause,progress: self.progress)
        })
    }
    func cancel() {
        self.insideDownloadTask?.cancel()
        self.update(status: .failed, progress: 0)
    }
    // MARK: - 私有函数
    fileprivate func buildDownloadTask(resumeData:Data?) -> URLSessionDownloadTask {
        let progressBlock = {[unowned self] (downloadProgress : Progress) -> Void in
            let progress = 0.98 * Float(downloadProgress.completedUnitCount) / Float(downloadProgress.totalUnitCount)
            self.update(status: .downloading, progress: progress)
        }
        let destinationBlock = { (url : URL, response : URLResponse) -> URL in
            let rootUrl = DownloadService.service.documentURL
            return rootUrl.appendingPathComponent(response.suggestedFilename!)
        }
        let completionHandler = { [unowned self] (response : URLResponse, url : URL?, error : Error?) in
            var status = self.resource.status
            if error != nil {
                status = .failed
            }
            self.update(status:status, progress: self.progress)
            if self.resource.status != .pause && self.resource.status != .failed {
                if let url = url {
                    self.handleDownloadFinish(filePath: url)
                }
            }
        }
        if let resumeData = resumeData {
            // 恢复下载
            return sessionManager.downloadTask(withResumeData: resumeData,progress: progressBlock,
destination: destinationBlock,completionHandler: completionHandler)
        }else {
            let request = URLRequest(url:URL(string:self.resource.url)!)
            return sessionManager.downloadTask(with: request,
            progress:progressBlock,
            destination:destinationBlock,
            completionHandler:completionHandler)
        }
    }
    private func update(status:ResourceStatus, progress:Float) {
        self.progress = progress
        for updateBlock in observers.values {
            updateBlock(status, progress, self)
        }
        if status != self.resource.status && status != .downloading{
            self.resource.status = status
            let res = self.copyResourceToRecorce(res: self.resource)
        }
    }
    private func handleDownloadFinish(filePath:URL) {
        DispatchQueue.global().async {
            // path = /resource/checkCode
            var mus = filePath.lastPathComponent
            mus = mus.replacingOccurrences(of: "+", with: "")
            self.resource.name = mus.removingPercentEncoding!
            let encodePath = filePath
            let homeURL = DownloadService.service.documentURL
            let decoderPath = homeURL.appendingPathComponent(self.resource.checkCode+"."+self.resource.type.rawValue)
            let unzipPath = homeURL.appendingPathComponent("resource", isDirectory: true)
            let checkFileValidityBlock = {() -> Bool in
                print(encodePath)
                return true
            }
            let decoderBlock = {()->Bool in
                do{
                try FileManager.default.removeItem(at:decoderPath)
                }catch{}
                if self.resource.password == ""{
                    try! FileManager.default.moveItem(at: encodePath, to: decoderPath)
//                try! FileManager.default.copyItem(at: encodePath, to: decoderPath)
                }else{
                    print("请解密之后处理")
                    // 解密成功后删除加密文件
                    try? FileManager.default.removeItem(at:encodePath)
                }
                return true
            }
            let unzipBlock = {()->Bool in
                if self.resource.type == .zip || self.resource.type == .rar{
                if !FileManager.default.fileExists(atPath: unzipPath.path){
                    do{
                        try FileManager.default.createDirectory(at: unzipPath, withIntermediateDirectories: false, attributes: nil)
                    }catch{
                        print(error)
                    }
                }
                let unzipSuccess = true
//                    SSZipArchive.unzipFile(atPath:decoderPath.path, toDestination:unzipPath.path)
                print(unzipSuccess)
                if unzipSuccess{
                    // 删除压缩文件
                    do {
                        try FileManager.default.removeItem(at: decoderPath)
                    }catch { }
                }
                self.resource.path = unzipPath.path
                return true
                }else{
                    self.resource.path = decoderPath.path
                    return true
                }
            }
            //首先默认不成功
            self.update(status: .failed, progress: self.progress)
            //1. 检查文件完整性
            guard checkFileValidityBlock() else{
                 return
            }
            //2. 解密文件
            guard decoderBlock() else{
                return
            }
            //3. 解压缩文件
            guard unzipBlock() else {
                return
            }
            do {
                let attr = try FileManager.default.attributesOfItem(atPath: self.resource.path)
                self.resource.size = attr[FileAttributeKey.size] as! Double
//                self.resource.type = attr[FileAttributeKey.type] as! String
//                self.resource.resumeData = try Data(contentsOf: URL(fileURLWithPath: self.resource.path)) as NSData
            } catch  {
                print("获取文件信息失败:\(error)")
            }
            DownloadService.service.removeRuningDownloader(with: self.resource.checkCode)
            self.update(status: .finish, progress: 1.0)
            self.desubscribe(observer: DownloadService.service)
        }
    }
}
@objcMembers
public final class DownloadService : NSObject {
    public static let service = DownloadService()
    public let documentURL:URL
    public var completedClosure:(() -> Void)?
    private let sessionManager : AFHTTPSessionManager
    private var runingDownloaders = [AnyHashable: ResourceDownloader]()
    private let runingDownloadersQueue = DispatchQueue(label: "com.downloadService.ruingDownloaderQueue", attributes: .concurrent)
    override init() {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        documentURL = URL(fileURLWithPath: documentPath!, isDirectory: true)
        sessionManager = AFHTTPSessionManager()
        sessionManager.requestSerializer = AFJSONRequestSerializer()
        sessionManager.responseSerializer = AFJSONResponseSerializer()
        let policy = AFSecurityPolicy.init(pinningMode:.none)
        policy.allowInvalidCertificates = true
        policy.validatesDomainName = false
        sessionManager.securityPolicy = policy
        super.init()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - 公开函数
    func download(URLs:[String],checkCodes:[String]?,_ closure: @escaping (_ index: Int, _ progress: Float) -> Void) {
        var resources = [CRResource]()
        for i in 0..<URLs.count {
            let res = CRResource()
            let url = URLs[i]
            res.url = url
            if let codes = checkCodes{
                if i<codes.count{
                    res.checkCode = codes[i]
                }else{
                    res.checkCode = url
                }
            }else{
                res.checkCode = url
            }
            resources.append(res)
        }
        self.download(resources: resources, closure)
    }
    func download(resources:[CRResource], _ closure: @escaping (_ index: Int, _ progress: Float) -> Void) {
        for i in 0..<resources.count{
            let res = resources[i]
            let down = takeDownloader(resource: res)
            down.subscribe(observer: self) { (status, pro, nil) in
                closure(i,pro)
            }
            if i<3{
                down.insideDownloadTask?.resume()
            }
        }
    }
    /// 获取一个下载器   - resource: 下载资源Model - Returns: 下载器
    func takeDownloader(resource:CRResource)->ResourceDownloader{
        var downloader : ResourceDownloader? = nil
        runingDownloadersQueue.sync { [unowned self] () in
            downloader = self.runingDownloaders[resource.checkCode]
        }
        if downloader == nil {
            downloader = ResourceDownloader(resource: resource, sessionManager)
            downloader?.insideDownloadTask = downloader?.buildDownloadTask(resumeData: resource.resumeData as Data?)
            addRuningDownloader(downloader!)
        }
        return downloader!
    }
    // 只查询已完成的任务
    func fetchDownloadResources() -> [CRResource] {
        let predicate = NSPredicate.init(format: "status=%d", ResourceStatus.finish.rawValue)
        return []
    }
    func fetchResource(checkCode:String)->CRResource?{
        let pre = NSPredicate.init(format: "checkCode=%@", checkCode)
        return nil
    }
    func deleteDownloadResource(checkCode:String) {
        if let record = self.fetchResource(checkCode: checkCode){
            do {
                let pah = record.path
                try FileManager.default.removeItem(at:URL(fileURLWithPath:pah))
            }catch {
                print(error)
            }
        }
    }
    // MARK: - 私有函数
    fileprivate func addRuningDownloader(_ downloader: ResourceDownloader) {
        runingDownloadersQueue.async { [unowned self] () in
            self.runingDownloaders[downloader.resource.checkCode] = downloader
        }
    }
    fileprivate func removeRuningDownloader(with checkCode:String) {
        runingDownloadersQueue.async { [unowned self] () in
            self.runingDownloaders.removeValue(forKey: checkCode)
            if self.completedClosure != nil && self.runingDownloaders.count <= 0{
                DispatchQueue.main.async {
                    self.completedClosure!()
                }
            }
            for (_,value) in self.runingDownloaders{
                if let task = value.insideDownloadTask{
                    if task.state == .suspended{
                        task.resume()
                        break;
//                    return;
                    }
                }
            }
        }
    }
}
