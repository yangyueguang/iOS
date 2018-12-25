//
//  SinaAuthController.swift
//  Freedom
//
//  Created by Super on 6/28/18.
//  Copyright © 2018 薛超. All rights reserved.
import UIKit
import AFNetworking
class SinaAccount: NSObject {
    var access_token = ""/**用于调用access_token，接口获取授权后的access token。*/
    var expires_in: NSNumber? /**access_token的生命周期，单位是秒数。*/
    var uid = ""/**当前授权用户的UID。*/
    var created_time: Date?/**access token的创建时间 */
    var name = ""/** 用户昵称  */
    /*存储账号信息@param account 账号模型*/
    class func save(_ account: SinaAccount?) {
        // 自定义对象的存储必须用NSKeyedArchiver
        let XFAccountPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? "").appendingPathComponent("account.data").absoluteString
        if let anAccount = account {
            NSKeyedArchiver.archiveRootObject(anAccount, toFile: XFAccountPath)
        }
    }
    /*返回账号信息@return 账号模型（如果账号过期，返回nil）*/
    class func account()->SinaAccount? {
        let XFAccountPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? "").appendingPathComponent("account.data").absoluteString
        let account = NSKeyedUnarchiver.unarchiveObject(withFile: XFAccountPath) as? SinaAccount
        let expires_in: Int64 = Int64(truncating: account?.expires_in ?? 0)
        let expiresTime = account?.created_time?.addingTimeInterval(TimeInterval(expires_in))
        let result: ComparisonResult? = expiresTime?.compare(Date())
        if result != .orderedDescending {// 过期
            return nil
        }
        return account!
    }
    convenience init(dict: [AnyHashable: Any]) {
        self.init()
        self.access_token = dict["access_token"] as! String
        self.uid = dict["uid"] as! String
        self.expires_in = dict["expires_in"] as? NSNumber
        self.created_time = Date()
    }
}
class SinaAuthController: SinaBaseViewController,UIWebViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isStatusBarHidden = true
        let webView = UIWebView()
        webView.delegate = self
        webView.frame = view.bounds
        view.addSubview(webView)
        let url = URL(string: "https://api.weibo.com/oauth2/authorize?client_id=568898243&redirect_uri=http://www.sharesdk.cn")
        var request: URLRequest? = nil
        if let anUrl = url {
            request = URLRequest(url: anUrl)
        }
        if let aRequest = request {
            webView.loadRequest(aRequest)
        }
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        XHud.show(.withDetail(message: "正在加载..."))
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        XHud.hide()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        XHud.hide()
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        let url = (request.url?.absoluteString)!
        let range: NSRange? = (url as NSString?)?.range(of: "code=")
        if Int(range?.length ?? 0) != 0 {
            let fromIndex = Int((range?.location)! + (range?.length)!)
            let code = (url as NSString).substring(from: fromIndex)
            accessToken(withCode: code)
            return false
        }
        return true
    }
    /*利用code（授权成功后的request token）换取一个accessToken @param code 授权成功后的request token*/
    func accessToken(withCode code: String?) {
        let url = "https://api.weibo.com/oauth2/access_token"
        //拼接请求参数
        var params = [String: Any]()
        params["client_id"] = "568898243"
        params["client_secret"] = "38a4f8204cc784f81f9f0daaf31e02e3"
        params["grant_type"] = "authorization_code"
        params["redirect_uri"] = "http://www.sharesdk.cn"
        params["code"] = code ?? ""
        AFHTTPSessionManager().post(url, parameters: params, progress: nil, success: { task, responseObject in
            XHud.hide()
            // 将返回的账号字典数据 --> 模型，存进沙盒
            let account = SinaAccount(dict: responseObject as! [AnyHashable : Any])
            //储存账号信息
            SinaAccount.save(account)
            // 切换窗口的根控制器
            //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
            //        [window switchRootViewController];
            self.dismiss(animated: true)
        }, failure: { task, error in
        })
    }
}
