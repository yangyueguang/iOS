//
//  CarryOn.swift
//  MyCocoaPods
//
//  Created by htf on 2018/5/4.
//  Copyright © 2018年 Super. All rights reserved.
import UIKit
@objcMembers
public class APP:NSObject{
    public let region:String!
    public let name:String!
    public let bundle:String!
    public var icon=UIImage()
    public let identifier:String!
    public let infoVersion:String!
    public let bundleName:String!
    public let version:String!
    public let build:Int32
    public let platVersion:String!
    public let lessVersion:String!
    public var allowLoad=false
    public let launchName:String!
    public let mainName:String!
    public let deviceType:UIUserInterfaceIdiom!
    public let wechatAvalueble:Bool!
    public let systemVersion: Float!

    public override init() {
        let info = Bundle.main.infoDictionary
        region = info!["CFBundleDevelopmentRegion"] as? String
        name = info!["CFBundleDisplayName"] as? String
        bundle = info!["CFBundleExecutable"] as? String
        identifier = info!["CFBundleIdentifier"] as? String
        infoVersion = info!["CFBundleInfoDictionaryVersion"] as? String
        bundleName = info!["CFBundleName"] as? String
        version = info!["CFBundleShortVersionString"] as? String
        build = info!["CFBundleVersion"] as! Int32
        platVersion = info!["DTPlatformVersion"] as? String
        lessVersion = info!["MinimumOSVersion"] as? String
        launchName = info!["UILaunchStoryboardName"] as? String
        mainName = info!["UIMainStoryboardFile"] as? String
        deviceType = UIDevice.current.userInterfaceIdiom
        wechatAvalueble = UIApplication.shared.canOpenURL(URL(string: "weixin://")!)
        systemVersion = Float(UIDevice.current.systemVersion) ?? 8.0
        super.init()
        if let transport:[String:Any] = info!["NSAppTransportSecurity"] as? [String : Any]{
            self.allowLoad = transport["NSAllowsArbitraryLoads"] as! Bool
        }
        if let iconDict:[String:Any] = info!["CFBundleIcons"] as? [String : Any]{
            if let iconfiles:[String:Any] = iconDict["CFBundlePrimaryIcon"] as? [String : Any]{
                self.icon = UIImage(named:iconfiles["CFBundleIconName"] as! String)!
            }
        }
    }
}

@objcMembers
open class XPageControl: UIPageControl {
    public var imagePageStateNormal: UIImage?{
        didSet {
            updateDots()
        }
    }
    open var imagePageStateHighlighted: UIImage?{
        didSet {
            updateDots()
        }
    }
    override open var currentPage: Int{
        didSet {
            super.currentPage = currentPage
            updateDots()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        updateDots()
    }

    private func updateDots() {
        // 更新显示所有的点按钮
        if let highlightedImage = imagePageStateHighlighted{
            for v in self.subviews{
                var image = self.imagePageStateNormal
                if self.currentPage == self.subviews.index(of: v){
                    image = highlightedImage
                }
                if v.subviews.count==0{
                    let dot = UIImageView(frame: v.bounds)
                    v.addSubview(dot)
                    dot.contentMode = .center
                    dot.image = image!
                }else{
                    let temp = v.subviews.first as? UIImageView
                    temp?.image = image
                }
            }
        }
    }
}

///让键盘右上角加个完成按钮// 键盘完成按钮
@objcMembers
open class XTextField: UITextField {
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        let toolBar = UIToolbar(frame: CGRect(x:0, y:0,width:UIScreen.main.bounds.size.width, height:30))
        toolBar.barStyle = .default
        let btnFished = UIButton(frame: CGRect(x:0,y:0,width:50,height:25))
        btnFished.setTitleColor(UIColor.init(red: 4/256.0, green: 170/256.0, blue: 174/256.0, alpha: 1), for: .normal)
        btnFished.setTitleColor(.gray,for: .highlighted)
        btnFished.setTitle("完成", for: .normal)
        btnFished.addTarget(self, action: Selector(("finishTapped:")), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btnFished)
        let space = UIView(frame: CGRect(x:0,y:0, width:UIScreen.main.bounds.size.width - btnFished.frame.width - 30, height:25))
        let item = UIBarButtonItem(customView: space)
        toolBar.setItems([item,item2], animated: true)
        self.inputAccessoryView = toolBar
    }

    func finishTapped(sender:UIButton){
        self.resignFirstResponder()
    }
}

open class UnderLinTextField: UITextField {
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor(white: 0.8, alpha: 1).cgColor)
        context?.setLineWidth(1.0)
        context?.beginPath()
        context?.move(to: CGPoint(x: bounds.origin.x, y: frame.size.height - 1))
        context?.addLine(to: CGPoint(x: bounds.size.width, y: frame.size.height - 1))
        context?.closePath()
        context?.strokePath()
    }
}
