//
//  XURLNavigator.swift
import UIKit
import Foundation

public enum XNavigationMode : Int {
    case push = 0
    case present
    case share
    case presentNotInNav
}

@objcMembers
public class XURLInfo: NSObject {
    var url = ""
    var sbID = ""
    var sbName = ""
    var nibName = ""
    var className = ""
    var bundlePath = ""
    var navigationMode = XNavigationMode.push
}

protocol XURLProtocol: NSObjectProtocol {
//    func doWithUrlInfo(_ vc:Self, urlInfo: XURLInfo) -> UIViewController
    func doWithUrlInfo(_ vc:UIViewController, urlInfo: XURLInfo) -> UIViewController
}

private var urlDic: [String : XURLInfo] = [:]

@objcMembers
public class XURLNavigator: NSObject {
    public static let shared = XURLNavigator()

    /// 当前控制器
    func currentViewController() -> UIViewController {
        let viewController = UIApplication.shared.keyWindow?.rootViewController
        return self.findBestViewController(viewController)
    }

    /// 注册控制器地址
    func registerURLObject(_ urlInfo: XURLInfo) {
        urlDic[urlInfo.url] = urlInfo
    }

    /// 跳转控制器
    func openURL(_ url: String, parameters: [String : Any] = [:], completion: @escaping (Bool) -> Void) {
        guard let urlInfo = urlInfoForURL(url),
            let vc = self.viewController(for: urlInfo) else {
            completion(false)
            return
        }
        if let url = URL(string: url) {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            let queryItems = components?.queryItems
            queryItems?.forEach({ (item) in
                vc.setValue(item.value, forKey: item.name)
            })
        }
        vc.setValuesForKeys(parameters)
        self.showVC(vc, routeMode: urlInfo.navigationMode)
        completion(true)
    }

    /// 根据url查找urlInfo对象
    func urlInfoForURL(_ urlString: String) -> XURLInfo? {
        guard let url = URL(string: urlString) else { return nil }
        let allURL = urlDic.keys
        for sourceURL in allURL {
            guard let storedURL = URL(string: sourceURL) else { return nil }
            if (storedURL.scheme == url.scheme) {
                let pattern = (storedURL.host ?? "") + storedURL.path
                let matcher = try? NSRegularExpression(pattern: pattern, options: [])
                let matchResult = matcher?.matches(in: urlString, range: NSRange(location: 0, length: urlString.count)) ?? []
                if matchResult.count > 0 {
                    return urlDic[sourceURL]
                }
            }
        }
        return nil
    }

    /// 根据urlInfo对象找对应的控制器
    func viewController(for urlInfo: XURLInfo) -> UIViewController? {
        guard let cls = self.getControllerWithBundle(urlInfo.bundlePath, name: urlInfo.className) else { return nil }
        var vc: UIViewController?
        if !urlInfo.sbID.isEmpty, !urlInfo.sbName.isEmpty {
            // 从Stroyboard创建
            let bundle = Bundle(path: urlInfo.bundlePath)
            let story = UIStoryboard(name: urlInfo.sbName, bundle: bundle)
            vc = story.instantiateViewController(withIdentifier: urlInfo.sbID)
        } else if !urlInfo.nibName.isEmpty {
            // 从NIB创建
            vc = cls.init(nibName: urlInfo.nibName, bundle: Bundle(path: urlInfo.bundlePath))
        } else if !urlInfo.className.isEmpty {
            // 从代码创建
            vc = cls.init()
        }
        if vc is XURLProtocol {
            // 从协议中创建
            if let vcc = vc as? XURLProtocol {
                vc = vcc.doWithUrlInfo(vc!, urlInfo: urlInfo)
            }
        }
        return vc
    }

    /// 正式推出控制器
    private func showVC(_ vc: UIViewController, routeMode: XNavigationMode) {
        switch routeMode {
        case .push:
            let currentVC = self.currentViewController()
            if let nav = currentVC.navigationController {
                nav.pushViewController(vc, animated: true)
            } else {
                self.showVC(vc, routeMode: .present)
            }
        case .present:
            if let nav = vc as? UINavigationController {
                self.currentViewController().present(nav, animated: true, completion: nil)
            } else {
                let nav = UINavigationController(rootViewController: vc)
                nav.navigationBar.isTranslucent = false
                self.currentViewController().present(nav, animated: true, completion: nil)
            }
        case .share:
            if let rootViewContoller = UIApplication.shared.delegate?.window??.rootViewController {
                rootViewContoller.present(vc, animated: true) {}
            }
        case .presentNotInNav:
            self.currentViewController().present(vc, animated: true)
        }
    }

    //FIXME: 私有方法
    private func getControllerWithBundle(_ bundle: String, name: String) -> UIViewController.Type?{
        let bundleClassName = bundle + "." + name
        return (NSClassFromString(bundleClassName) as? UIViewController.Type)
    }
    
    private func findBestViewController(_ vc: UIViewController?) -> UIViewController {
        if let pre = vc?.presentedViewController {
            return self.findBestViewController(pre)
        } else if (vc is UISplitViewController) {
            let svc = vc as? UISplitViewController
            if (svc?.viewControllers.count ?? 0) > 0 {
                return self.findBestViewController(svc?.viewControllers.last)
            } else {
                return vc!
            }
        } else if (vc is UINavigationController) {
            let svc = vc as? UINavigationController
            if (svc?.viewControllers.count ?? 0) > 0 {
                return self.findBestViewController(svc?.topViewController)
            } else {
                return vc!
            }
        } else if (vc is UITabBarController) {
            let svc = vc as? UITabBarController
            if (svc?.viewControllers?.count ?? 0) > 0 {
                return self.findBestViewController(svc?.selectedViewController)
            } else {
                return vc!
            }
        } else {
            return vc ?? currentViewController()
        }
    }
}
