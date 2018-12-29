//
//  FreedomLoginViewController.swift
//  Freedom
import UIKit
import XCarryOn
import XExtension
import AFNetworking
import RxSwift
import RxCocoa
//FIXME:登录下面的切换视图
private let disposeBag = DisposeBag()
class LoginBottomView:UIView{
    let leftBtn = UIButton()
    let rightBtn = UIButton()
    let tradeMarkL = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 100, height: frame.size.height)
        rightBtn.frame = CGRect(x: frame.size.width - 100, y: 0, width: 100, height: frame.size.height)
        leftBtn.setTitleColor(.white, for: .normal)
        rightBtn.setTitleColor(.white, for: .normal)
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        tradeMarkL.frame = CGRect(x: 100, y: 0, width: frame.size.width - 200, height: frame.size.height)
        tradeMarkL.font = UIFont.systemFont(ofSize: 14)
        tradeMarkL.textAlignment = .center
        tradeMarkL.textColor = .white
        tradeMarkL.text = "copy right by Super"
        addSubviews([leftBtn,tradeMarkL,rightBtn])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//FIXME:自定义输入框
class LoginTextField:UITextField{
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(UIColor(161, 168, 168,0.2).cgColor)
        context.setLineWidth(1.0)
        context.beginPath()
        context.move(to: CGPoint(x: bounds.origin.x, y: 45))
        context.addLine(to: CGPoint(x: bounds.size.width - 10, y: 45))
        context.closePath()
        context.strokePath()
    }
}
//FIXME:登录控制器
class FreedomBaseLoginViewController: BaseViewController,UITextFieldDelegate,RCIMConnectionStatusDelegate {
    var retryTime: Timer?
    var countTimer: Timer?
    var seconds = 0
    var loginUserName = ""
    var loginUserId = ""
    var loginToken = ""
    var loginPassword = ""
    var loginPhone = ""
    var loginMessageCode = ""
    let bottomV = LoginBottomView(frame: CGRect(x: 0, y: APPH - 40, width: APPW, height: 40))
    lazy var actionBtn : UIButton = {
        let btn = UIButton(frame: CGRect(x: APPW/2 - 100, y: 360, width: 200, height: 40))
        btn.backgroundColor = .red
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        return btn
    }()
    lazy var phoneT : LoginTextField = {
        let phone = LoginTextField(frame: CGRect(x: 20, y: 150, width: 300, height: 30))
        phone.delegate = self
        phone.textColor = .white
        phone.clearButtonMode = .whileEditing
        phone.adjustsFontSizeToFitWidth = true
        phone.keyboardType = UIKeyboardType.numberPad
        phone.attributedPlaceholder = NSAttributedString(string: "手机号", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:Font(14)])
        return phone
    }()
    lazy var userNameT : LoginTextField = {
        let userNT = LoginTextField(frame: CGRect(x: 20, y: 200, width: 300, height: 30))
        userNT.delegate = self
        userNT.textColor = .white
        userNT.clearButtonMode = .whileEditing
        userNT.adjustsFontSizeToFitWidth = true
        userNT.keyboardType = UIKeyboardType.numberPad
        userNT.attributedPlaceholder = NSAttributedString(string: "用户名", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:Font(14)])
      return userNT
    }()
    lazy var passWordT : LoginTextField = {
        let pass = LoginTextField(frame: CGRect(x: 20, y: 250, width: 300, height: 30))
        pass.delegate = self
        pass.textColor = .white
        pass.returnKeyType = UIReturnKeyType.done
        pass.isSecureTextEntry = true
        pass.clearButtonMode = .whileEditing
        pass.font = UIFont.systemFont(ofSize: 14)
        pass.adjustsFontSizeToFitWidth = true
        pass.keyboardType = UIKeyboardType.numberPad
        pass.attributedPlaceholder = NSAttributedString(string: "密码", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:Font(14)])
        return pass
    }()
    lazy var timeBtn : UIButton = {
        let btn = UIButton(frame:CGRect(x: APPW / 2, y: 300, width: 100, height: 30))
        btn.backgroundColor = .gray
        btn.setTitle("获取验证码", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    lazy var messageCodeT : LoginTextField = {
        let code = LoginTextField(frame: CGRect(x: 20, y: 300, width: APPW / 2 - 20, height: 30))
        code.delegate = self
        code.textColor = .white
        code.clearButtonMode = .whileEditing
        code.adjustsFontSizeToFitWidth = true
        code.keyboardType = UIKeyboardType.numberPad
        code.font = UIFont.systemFont(ofSize: 14)
        code.attributedPlaceholder = NSAttributedString(string: "验证码", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:Font(14)])
        return code
    }()
    //FIXME:程序开始
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        let backGroudIV = UIImageView(frame: view.bounds)
        backGroudIV.image = UIImage(named:"login_background")
        backGroudIV.contentMode = .scaleAspectFill
        view.addSubview(backGroudIV)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == userNameT{
            passWordT.text = nil
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        retryTime?.invalidate()
        retryTime = nil
    }
    //FIXME:用文件服务器配置登录,设置导航服务器和上传文件服务器信息
    func loginWithFileServer(_ appKey:String,_ demoServer:String,_ naviServer:String,_ fileServer:String) {
        RCDSettingUserDefaults.setRCAppKey(appKey)
        RCDSettingUserDefaults.setRCDemoServer(demoServer)
        RCDSettingUserDefaults.setRCNaviServer(naviServer)
        RCDSettingUserDefaults.setRCFileServer(fileServer)
        RCIM.shared().initWithAppKey(appKey)
        RCIM.shared().disconnect()
        RCIMClient.shared().setServerInfo(naviServer, fileServer: fileServer)
        navigationController?.pushViewController(FreedomLoginViewController(), animated: true)
    }

    //前往注册界面
    func gotoRegisterVC() {
        navigationController?.pushViewController(FreedomRegisterViewController(), animated: true)
    }
    //前往找回密码界面
    func gotoFindPswVC() {
        navigationController?.pushViewController(FreedomFindPswViewController(), animated: true)
    }
    //前往登录界面
    func gotoLoginVC(){
        let loginVC = FreedomLoginViewController()
        let transition = CATransition()
        transition.type = CATransitionType.push//可更改为其他方式
        transition.subtype = CATransitionSubtype.fromLeft//可更改为其他方式
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(loginVC, animated: false)
    }
    //FIXME:获取验证码按钮事件
    private func countSecondsDown(){
        seconds = 60
        timeBtn.isUserInteractionEnabled = false
        countTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timeFireMethod), userInfo: nil, repeats: true)
    }
    @objc func timeFireMethod() {
        seconds -= 1
        let btnTitle = "\(seconds)秒后发送"
        timeBtn.setTitle(btnTitle, for: .normal)
        if seconds == 0 {
            timeBtn.isUserInteractionEnabled = true
            countTimer?.invalidate()
            timeBtn.setTitle("获取验证码", for: .normal)
        }
    }
    //FIXME:验证登录信息
    private func checkContent()->Bool{
        let status: RCNetworkStatus = RCIMClient.shared().getCurrentNetworkStatus()
        var alertMessage: String? = nil
        if RCNetworkStatus.notReachable == status {
            alertMessage = "当前网络不可用，请检查！"
        }else if loginUserName.count == 0 {
            alertMessage = "用户名不能为空!"
        }else if(loginUserName.count != 11){
            alertMessage = "手机号不正确!"
        }else if loginPassword.count == 0 {
            passWordT.shakeAnimation()
            alertMessage = "密码不能为空!"
        }else if loginPassword.count < 6 || loginPassword.count > 11{
            passWordT.shakeAnimation()
            alertMessage = "请输入6-16位密码"
        }else if loginMessageCode.count == 0{
            alertMessage = "请输入验证码"
        }
        if alertMessage != nil {
            self.noticeError(alertMessage ?? "")
//            return false
            return true
        }
        return true
    }
    //FIXME:获取验证码
    func getVerficationCode(_ isRegister:Bool) {
        loginPhone = phoneT.text!
        AFHttpTool.checkPhoneNumberAvailable("86", phoneNumber: loginPhone, success: { responseDict in
//            let response = JSON(responseDict!)
//            if response["code"].intValue == 200 {
//                let resultStatus = response["result"].intValue
//                if  resultStatus == 0  && isRegister{
//                    print("手机号已被注册")
//                    return
//                }else if resultStatus != 0 && !isRegister {
//                    print("手机号未被注册")
//                    return
//                }
//                AFHttpTool.getVerificationCode("86", phoneNumber: self.loginPhone, success: { resDict in
//                    let res = JSON(resDict!)
//                    if res["code"].intValue == 200 {
//                        self.countSecondsDown()
//                    }
//                }, failure: { err in
//                    print("\(err!)")
//                })
//            }
        }, failure: { err in
            print("\(err!)")
        })
    }
    //FIXME:注册按钮的事件
    func registerAction() {
        loginPhone = phoneT.text!
        loginUserName = userNameT.text!
        loginPassword = passWordT.text!
        loginMessageCode = messageCodeT.text!
        if !checkContent() {
            return
        }
      //验证验证码是否有效
        AFHttpTool.verifyVerificationCode("86", phoneNumber: loginPhone, verificationCode: loginMessageCode, success: { response in
//            let code = response["code"].intValue
//            if code == 200 {
//                let verificationToken = response["result"]["verification_token"].stringValue
//                //注册用户
//                AFHttpTool.register(withNickname: self.loginUserName, password: self.loginPassword, verficationToken: verificationToken, success: { responseDict in
//                    let code = responseDict["code"].intValue
//                    if code == 200 {
//                        print("注册成功")
//                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5 * Double(NSEC_PER_MSEC) / Double(NSEC_PER_SEC), execute: {
//                            self.navigationController?.popViewController(animated: true)
//                        })
//                    }
//                }, failure: { err in
//                    print("注册失败")
//                })
//            }
//            if code == 1000 {
//                print("验证码错误")
//            }
//            if code == 2000 {
//                print("验证码过期")
//            }
        }, failure: { err in
            print("验证码无效")
        })
    }
    //FIXME:找回密码的按钮事件
    func findPwdBackAction(){
        let loginPhone = phoneT.text!
        let loginPassword = passWordT.text!
        let loginMessageCode = messageCodeT.text!
        if !checkContent() {
            return
        }
        AFHttpTool.verifyVerificationCode("86", phoneNumber: loginPhone, verificationCode: loginMessageCode, success: { responseDict in
//            let response = JSON(responseDict!)
//            if response["code"].intValue == 200 {
//                let vToken = response["result"]["verification_token"].stringValue
//                AFHttpTool.resetPassword(loginPassword, vToken: vToken, success: { resDict in
//                    let res = JSON(resDict!)
//                    if res["code"].intValue == 200 {
//                        print("修改成功!")
//                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5 * Double(NSEC_PER_MSEC) / Double(NSEC_PER_SEC), execute: {
//                            self.navigationController?.popViewController(animated: true)
//                        })
//                    }
//                }, failure: { err in
//                })
//            }
        }, failure: { err in
        })
    }
    //FIXME:登录按钮的事件
    func loginAction() {
        loginUserName = userNameT.text!
        loginPassword = passWordT.text!
        loginUserName = "18721064516"
        loginPassword = "123456"
        if !checkContent(){
            return
        }
        retryTime?.invalidate()
        retryTime = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.retryConnectionFailed), userInfo: nil, repeats: false)
        XHud.show(.withDetail(message: "登录中..."))
        UserDefaults.standard.removeObject(forKey: "UserCookies")
        AFHttpTool.login(withPhone:loginUserName, password: loginPassword, region: "86", success: { responseDict in
//            let response = JSON(responseDict!)
//            if response["code"].intValue == 200 {
//                let token = response["result"]["token"].stringValue
//                let userId = response["result"]["id"].stringValue
//                self.loginRongCloud(self.loginUserName, userId: userId, token: token, password: self.loginPassword)
//            } else {
//                //关闭HUD
//                let _errCode = response["code"].intValue
//                print("NSError is \(_errCode)")
//                if _errCode == 1000 {
//                    self.noticeError("手机号或密码错误！")
//                }
//                self.passWordT.shakeAnimation()
//            }
        }, failure: { err in
            self.noticeError("登录失败，请检查网络。")
        })
    }
    @objc func retryConnectionFailed() {
        RCIM.shared().disconnect()
        retryTime?.invalidate()
    }
    //FIXME: 登录融云服务器
    func loginRongCloud(_ userName: String, userId: String, token: String, password: String) {
        loginUserName = userName
        loginUserId = userId
        loginToken = token
        loginPassword = password
        //登录融云服务器
        RCIM.shared().connect(withToken: token, success: { userId in
            print("token is \(token)  userId is \(userId!)")
            self.loginUserId = userId!
            self.loginSuccess(self.loginUserName, userId: self.loginUserId, token: self.loginToken, password: self.loginPassword)
        }, error: { status in
            //关闭HUD
            print("RCConnectErrorCode is \(status.rawValue)")
            self.passWordT.shakeAnimation()
            DispatchQueue.main.async(execute: {
                print("RCConnectErrorCode is \(status.rawValue)")
                self.passWordT.shakeAnimation()
                //SDK会自动重连登录，这时候需要监听连接状态
                RCIM.shared().connectionStatusDelegate = self
            })
            //SDK会自动重连登陆，这时候需要监听连接状态
            RCIM.shared().connectionStatusDelegate = self
        }, tokenIncorrect: {
            print("IncorrectToken")
            AFHttpTool.getTokenSuccess({ responseDict in
//                let response = JSON(responseDict!)
//                let token = response["result"]["token"].stringValue
//                let userId = response["result"]["userId"].stringValue
//                self.loginRongCloud(userName, userId: userId, token: token, password: password)
            }, failure: { err in
                DispatchQueue.main.async(execute: {
                    print("Token无效")
                })
            })
        })
    }
    func loginSuccess(_ userName: String, userId: String, token: String, password: String) {
        retryTime?.invalidate()
        //保存默认用户
        let defaults = UserDefaults.standard
        defaults.set(userName, forKey: "userName")
        defaults.set(password, forKey: "userPwd")
        defaults.set(token, forKey: "userToken")
        defaults.set(userId, forKey: "userId")
        defaults.synchronize()
        //保存“发现”的信息
        RCDHttpTool.shareInstance().getSquareInfoCompletion({ result in
            defaults.set(result, forKey: "SquareInfoList")
            defaults.synchronize()
        })
        AFHttpTool.getUserInfo(userId, success: { response in
//            let jr = JSON(response!)
//            if Int(jr["code"].stringValue) == 200 {
//                let nickname = jr["result"]["nickname"].rawString()
//                let portraitUri = jr["result"]["portraitUri"].rawString()
//                let user = RCUserInfo(userId: userId, name: nickname, portrait: portraitUri)
//                if user!.portraitUri.count <= 0 {
//                    user?.portraitUri = FreedomTools.defaultUserPortrait(user)
//                }
//                RCDataBaseManager.shareInstance().insertUser(toDB: user)
//                RCIM.shared().refreshUserInfoCache(user, withUserId: userId)
//                RCIM.shared().currentUserInfo = user
//                defaults.set(user?.portraitUri, forKey:"userPortraitUri")
//                defaults.set(user?.name, forKey:"userNickName")
//                defaults.synchronize()
//            }
        }, failure: { err in
        })
        //同步群组
        RCDRCIMDataSource.shareInstance().syncGroups()
        RCDRCIMDataSource.shareInstance().syncFriendList(userId, complete: { friends in
        })
        DispatchQueue.main.async(execute: {
            let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc: UIViewController? = StoryBoard.instantiateViewController(withIdentifier: "FirstViewController")
            let window:UIWindow = ((UIApplication.shared.delegate?.window)!)!
            window.rootViewController = vc!
        })
    }
    func onRCIMConnectionStatusChanged(_ status: RCConnectionStatus) {
        DispatchQueue.main.async(execute: {
            if status == RCConnectionStatus.ConnectionStatus_UNKNOWN {
                RCIM.shared().connectionStatusDelegate = (UIApplication.shared.delegate as? RCIMConnectionStatusDelegate?)!
                self.loginSuccess(self.loginUserName, userId: self.loginUserId, token: self.loginToken, password: self.loginPassword)
            } else if status == RCConnectionStatus.ConnectionStatus_NETWORK_UNAVAILABLE {
                self.noticeError("当前网络不可用，请检查！")
            } else if status == .ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT {
                self.noticeError("您的帐号在别的设备上登录，您被迫下线！")
            } else if status == .ConnectionStatus_TOKEN_INCORRECT {
                print("Token无效")
                self.noticeError("无法连接到服务器！")
                AFHttpTool.getTokenSuccess({ responseDict in
//                    let response = JSON(responseDict!)
//                    self.loginToken = response["result"]["token"].stringValue
//                    self.loginUserId = response["result"]["userId"].stringValue
//                    self.loginRongCloud(self.loginUserName, userId: self.loginUserId, token: self.loginToken, password: self.loginPassword)
                }, failure: { (error) in
                    DispatchQueue.main.async(execute: {
                        print("Token无效")
                        self.noticeError("无法连接到服务器！")
                    })
                })
            } else {
                print(String(format: "RCConnectErrorCode is \(status)"))
            }
        })
    }
}
//FIXME:登录控制器
class FreedomLoginViewController:FreedomBaseLoginViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.actionBtn.setTitle("登录", for: .normal)
        bottomV.leftBtn.setTitle("新用户", for: .normal)
        bottomV.rightBtn.setTitle("找回密码", for: .normal)
        bottomV.leftBtn.rx.tap.subscribe(onNext: { (sender) in
            self.gotoRegisterVC()
        }).disposed(by: disposeBag)
        bottomV.rightBtn.rx.tap.subscribe(onNext: { (sender) in
            self.gotoFindPswVC()
        }).disposed(by: disposeBag)
        actionBtn.rx.tap.subscribe(onNext: { (sender) in
            self.loginAction()
        }).disposed(by: disposeBag)
        view.addSubviews([userNameT,passWordT,actionBtn,bottomV])
    }
}
//FIXME:注册控制器
class FreedomRegisterViewController:FreedomBaseLoginViewController {
    //FIXME:程序开始
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        passWordT.placeholder = "6-16位字符区分大小写"
        self.actionBtn.setTitle("注册", for: .normal)
        bottomV.leftBtn.setTitle("登录", for: .normal)
        bottomV.rightBtn.setTitle("找回密码", for: .normal)
        bottomV.leftBtn.rx.tap.subscribe(onNext: { (sender) in
            self.gotoLoginVC()
        }).disposed(by: disposeBag)
        bottomV.leftBtn.rx.tap.subscribe(onNext: { (sender) in
            self.gotoLoginVC()
        }).disposed(by: disposeBag)
        bottomV.rightBtn.rx.tap.subscribe(onNext: { (sender) in
            self.gotoFindPswVC()
        }).disposed(by: disposeBag)
        actionBtn.rx.tap.subscribe(onNext: { (sender) in
            self.registerAction()
        }).disposed(by: disposeBag)
        timeBtn.rx.tap.subscribe(onNext: { (sender) in
            self.getVerficationCode(true)
        }).disposed(by: disposeBag)
        view.addSubviews([phoneT,userNameT,passWordT,messageCodeT,timeBtn,actionBtn,bottomV])
    }

}
//FIXME:找回密码控制器
class FreedomFindPswViewController:FreedomBaseLoginViewController {
    //FIXME:程序开始
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        passWordT.placeholder = "6-16位字符区分大小写"
        self.actionBtn.setTitle("修改密码", for: .normal)
        bottomV.leftBtn.setTitle("登录", for: .normal)
        bottomV.rightBtn.setTitle("注册", for: .normal)
        bottomV.leftBtn.rx.tap.subscribe(onNext: { (sender) in
            self.gotoLoginVC()
        }).disposed(by: disposeBag)
        bottomV.rightBtn.rx.tap.subscribe(onNext: { (sender) in
            self.gotoRegisterVC()
        }).disposed(by: disposeBag)
        actionBtn.rx.tap.subscribe(onNext: { (sender) in
            self.findPwdBackAction()
        }).disposed(by: disposeBag)
        timeBtn.rx.tap.subscribe(onNext: { (sender) in
            self.getVerficationCode(false)
        }).disposed(by: disposeBag)
        view.addSubviews([phoneT,passWordT,messageCodeT,timeBtn,actionBtn,bottomV])
    }
}



