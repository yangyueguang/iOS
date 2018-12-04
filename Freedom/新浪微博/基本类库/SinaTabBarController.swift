//
//  SinaTabBarController.swift
//  Freedom
//
//  Created by Super on 6/28/18.
//  Copyright © 2018 薛超. All rights reserved.
import UIKit
import XExtension
import XCarryOn
class SinaTabBar: UITabBar {
    var centerButton = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        centerButton.setBackgroundImage(UIImage(named: "tabbar_compose_button"), for: .normal)
        centerButton.setImage(UIImage(named: "tabbar_compose_icon_add"), for: .normal)
        let size = (centerButton.currentBackgroundImage?.size)!
        centerButton.frame = CGRect(x: centerButton.frameX, y: centerButton.frameY, width: size.width, height: size.height)
        centerButton.center = CGPoint(x: APPW * 0.5, y: 50 * 0.5)
        addSubview(centerButton)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        centerButton.center = CGPoint(x: bounds.size.width * 0.5, y: 25)
        let tabbarButtonW: CGFloat = bounds.size.width / 5
        var buttonIndex: CGFloat = 0
        for view in subviews {
            if view.isKind(of: NSClassFromString("UITabBarButton")! ) {
                view.frame = CGRect(x: buttonIndex * tabbarButtonW,y:view.frame.origin.y, width: tabbarButtonW, height:view.bounds.size.height)
                buttonIndex += 1
                if buttonIndex == 2 {
                    buttonIndex += 1
                }
            }
        }
    }
}
//按钮出来动画
class SinaTabBarController: BaseTabBarViewController {
    var plus: UIButton = UIButton(frame: CGRect(x: (APPW - 25) * 0.5, y: 8, width: 25, height: 25))
    var blurView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH))
    var text: UIImageView = UIImageView(frame: CGRect(x: 31, y: 500, width: 71, height: 100))
    var ablum: UIImageView = UIImageView(frame: CGRect(x: 152, y: 500, width: 71, height: 100))
    var camera: UIImageView = UIImageView(frame: CGRect(x: 273, y: 500, width: 71, height: 100))
    var sign: UIImageView = UIImageView(frame: CGRect(x: 31, y: 700, width: 71, height: 100))
    var comment: UIImageView = UIImageView(frame: CGRect(x: 152, y: 700, width: 71, height: 100))
    var more: UIImageView = UIImageView(frame: CGRect(x: 273, y: 700, width: 71, height: 100))
    override func viewDidLoad() {
        super.viewDidLoad()
        var i=0
        for vc in self.children{
            vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)], for: .selected)
            vc.tabBarItem.image = vc.tabBarItem.image?.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.selectedImage = vc.tabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.tag = i;
            i += 1
        }
        let tabbar = SinaTabBar()
        self.setValue(tabbar, forKeyPath: "tabBar")
        tabbar.centerButton.addTarget(self, action:#selector(self.centerClicked), for: .touchUpInside)
        initUI()
        configAccount()
    }
    private func initUI(){
        func configBtn(_ img:UIImageView,imageName:String,text:String,tag:Int){
            let image = UIImageView(image: UIImage(named: imageName ))
            let word = UILabel(frame: CGRect(x: 0, y: 75, width: 71, height: 25))
            word.text = text
            word.textAlignment = .center
            word.font = UIFont.systemFont(ofSize: 15)
            word.textColor = UIColor.gray
            img.addSubview(image)
            img.addSubview(word)
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.compose(gesture:)))
            img.isUserInteractionEnabled = true
            img.addGestureRecognizer(gesture)
            img.tag = tag
            blurView.addSubview(img)
        }
        configBtn(text, imageName: "tabbar_compose_idea", text: "文字",tag:1)
        configBtn(ablum, imageName: "tabbar_compose_photo", text: "相册",tag:2)
        configBtn(camera, imageName: "tabbar_compose_camera", text: "摄影",tag:3)
        configBtn(sign, imageName: "tabbar_compose_lbs", text: "签到",tag:4)
        configBtn(comment, imageName: "tabbar_compose_review", text: "评论",tag:5)
        configBtn(more, imageName: "tabbar_compose_more", text: "更多",tag:6)
        blurView.tintColor = UIColor.clear
        let compose = UIImageView(frame: CGRect(x: 0, y: 100, width: view.frame.size.width, height: 48))
        compose.image = UIImage(named: "compose_slogan")
        plus.setImage(UIImage(named: "tabbar_compose_background_icon_add"), for: .normal)
        plus.addTarget(self, action: #selector(self.closeClick), for: .touchUpInside)
        let bottom = UIView(frame: CGRect(x: 0, y: view.bounds.size.height - 44, width: view.bounds.size.height, height: 44))
        bottom.backgroundColor = UIColor.white
        bottom.addSubview(plus)
        blurView.addSubview(compose)
        blurView.addSubview(bottom)
        blurView.isHidden = true
        view.addSubview(blurView)
    }
    private func configAccount(){
        var account = SinaAccount.account()
        //设置根控制器
        if account != nil {
            //第三方登录状态
            let key = "version"
            let lastVersion = UserDefaults.standard.object(forKey: key) as? String
            let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
            if (currentVersion == lastVersion) {
                // 版本号相同：这次打开和上次打开的是同一个版本
                return
            } else {
                // 这次打开的版本和上一次不一样，显示新特性
                print("推出新特性的控制器")
                UserDefaults.standard.set(currentVersion, forKey: key)
                UserDefaults.standard.synchronize()
            }
        } else {
            let acont = ["access_token": "2.00IjAFKG0H7CVc7e020836340bdlSS", "expires_in": "2636676", "remind_in": "2636676", "uid": "5645754790"]
            account = SinaAccount(dict: acont)
            //储存账号信息
            SinaAccount.save(account)
            present(SinaAuthController(), animated: true) {
            }
        }
    }
    //发文字微博
    @objc private func compose(gesture:UITapGestureRecognizer) {
        closeClick()
        var vc:SinaBaseViewController?
        let view = gesture.view!
        switch view.tag {
        case 1:vc = SinaComposeViewController()
        case 2:vc = SinaComposeViewController()
        case 3:vc = SinaComposeViewController()
        case 4:vc = SinaComposeViewController()
        case 5:vc = SinaComposeViewController()
        default:vc = SinaComposeViewController()
        }
        let nav = SinaNavigationController(rootViewController: vc!)
        present(nav, animated: true)
    }
    //打开按钮
    @objc private func centerClicked(){
        func btnOpenAnimate(withFrame rect: CGRect,delay: CGFloat, btnView: UIImageView){
            UIView.animate(withDuration: 0.5, delay: TimeInterval(delay), usingSpringWithDamping: 0.6, initialSpringVelocity: 0.05, options: .allowUserInteraction, animations: {
                btnView.frame = rect
            }) { finished in
            }
        }
        btnOpenAnimate(withFrame: CGRect(x: 31, y: 280, width: 71, height: 100), delay: 0.0, btnView: text)
        btnOpenAnimate(withFrame: CGRect(x: 152, y: 280, width: 71, height: 100), delay: 0.1, btnView: ablum)
        btnOpenAnimate(withFrame: CGRect(x: 273, y: 280, width: 71, height: 100), delay: 0.15, btnView: camera)
        btnOpenAnimate(withFrame: CGRect(x: 31, y: 410, width: 71, height: 100), delay: 0.2, btnView: sign)
        btnOpenAnimate(withFrame: CGRect(x: 152, y: 410, width: 71, height: 100), delay: 0.25, btnView: comment)
        btnOpenAnimate(withFrame: CGRect(x: 273, y: 410, width: 71, height: 100), delay: 0.3, btnView: more)
        UIView.animate(withDuration: 0.2, animations: {
            self.plus.transform = CGAffineTransform(rotationAngle: .pi/4)
        })
        blurView.isHidden = false
    }
    //关闭按钮
    @objc private func closeClick() {
        //关闭动画
        func btnCloseAnimate(withFrame rect: CGRect, delay: CGFloat, btnView: UIImageView?) {
            UIView.animate(withDuration: 0.3, delay: TimeInterval(delay), usingSpringWithDamping: 0.6, initialSpringVelocity: 0.05, options: .allowUserInteraction, animations: {
                btnView?.frame = rect
            }) { finished in
            }
        }
        UIView.animate(withDuration: 0.6, animations: {
            self.plus.transform = CGAffineTransform(rotationAngle: -.pi/2)
            btnCloseAnimate(withFrame: CGRect(x: 273, y: 700, width: 71, height: 100), delay: 0.1, btnView: self.more)
            btnCloseAnimate(withFrame: CGRect(x: 152, y: 700, width: 71, height: 100), delay: 0.15, btnView: self.comment)
            btnCloseAnimate(withFrame: CGRect(x: 31, y: 700, width: 71, height: 100), delay: 0.2, btnView: self.sign)
            btnCloseAnimate(withFrame: CGRect(x: 273, y: 700, width: 71, height: 100), delay: 0.25, btnView: self.camera)
            btnCloseAnimate(withFrame: CGRect(x: 152, y: 700, width: 71, height: 100), delay: 0.3, btnView: self.ablum)
            btnCloseAnimate(withFrame: CGRect(x: 31, y: 700, width: 71, height: 100), delay: 0.35, btnView: self.text)
        }) { finished in
            self.blurView.isHidden = true
        }
    }
}
