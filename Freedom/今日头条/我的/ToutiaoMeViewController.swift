//
//  ToutiaoMeViewController.swift
//  Freedom
//
//  Created by Super on 2018/5/16.
//  Copyright © 2018年 Super. All rights reserved.
//
import UIKit
import XExtension
class ToutiaoMeViewController: ToutiaoBaseViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let ap = UINavigationBar.appearance()
        ap.setBackgroundImage(nil, for: .default)
        navigationController?.isNavigationBarHidden = true
        view.addSubview(self.createHeadView())
    }
    func createHeadView()->UIView{
        let head = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 120))
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 100))
        for i in 0..<3{
            let button = UIButton(frame: CGRect(x: 50+120*i, y: 20, width: 50, height: 50))
            button.layer.cornerRadius = 25;
            button.clipsToBounds = true
            button.setImage(UIImage(named:"userLogo"), for: .normal)
            topView.addSubview(button)
        }
        topView.backgroundColor = UIColor(10, 10, 10,  1)
        let label = UILabel(frame: CGRect(x: 10, y: view.bounds.size.height-30, width: APPW-20, height: 20))
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.text = "登录推荐更精准"
        label.textAlignment = .center
        topView.addSubview(label)
        head.addSubview(topView)
        let titles = ["收藏","历史","夜间"]
        for i in 0..<3{
            let buton = UIButton(frame: CGRect(x: CGFloat(i)*APPW/3, y: YH( view), width: APPW/3, height: 60))
            buton.setImage(UIImage(named:"wechart"), for: .normal)
            buton.setImage(UIImage(named:titles[i]), for: .normal)
            buton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 45, bottom: 20, right: 45)
            buton.titleEdgeInsets = UIEdgeInsets(top: 35, left: -APPW/3+10, bottom: 0, right: 0)
            buton.setTitleColor(.black, for: .normal)
            buton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            buton.backgroundColor = .white
            head.addSubview(buton)
        }
        return head;
    }
}
