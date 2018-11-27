//
//  DouyinBaseViewController.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/11/26.
//  Copyright © 2018 薛超. All rights reserved.
//

import UIKit

class DouyinBaseViewController: XBaseViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initNavigationBarTransparent()
    }

    func initNavigationBarTransparent() {
        setNavigationBarTitleColor(color: ColorWhite)
        setNavigationBarBackgroundImage(image: UIImage.init())
        setStatusBarStyle(style: .lightContent)
        setNavigationBarShadowImage(image: UIImage.init())
        initLeftBarButton(imageName: "icon_titlebar_whiteback")
        setBackgroundColor(color: ColorThemeBackground)
    }

    func setBackgroundColor(color: UIColor) {
        self.view.backgroundColor = color;
    }


    func initLeftBarButton(imageName: String) {
        let leftButton = UIBarButtonItem.init(image: UIImage.init(named: imageName), style: .plain, target: self, action: #selector(back))
        leftButton.tintColor = ColorWhite
        self.navigationItem.leftBarButtonItem = leftButton;
    }

    func setStatusBarHidden(hidden: Bool)  {
        UIApplication.shared.isStatusBarHidden = hidden;
    }

    func setNavigationBarTitle(title:String) {
        self.navigationItem.title = title;
    }

    func setNavigationBarTitleColor(color:UIColor) {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:color]
    }

    func setNavigationBarBackgroundColor(color:UIColor) {
        self.navigationController?.navigationBar.backgroundColor = color;
    }

    func setNavigationBarBackgroundImage(image:UIImage) {
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
    }

    func setStatusBarStyle(style:UIStatusBarStyle) {
        UIApplication.shared.statusBarStyle = style
    }

    func setStatusBarBackgroundColor(color: UIColor) {
        UIApplication.shared.statusBarView?.backgroundColor = color
    }

    func setNavigationBarShadowImage(image:UIImage) {
        self.navigationController?.navigationBar.shadowImage = image;
    }

    @objc func back() {
        self.navigationController?.popViewController(animated: true);
    }

    @objc func popself() {
        self.dismiss(animated: true, completion: nil)
    }

    func navagationBarHeight()->CGFloat {
        return self.navigationController?.navigationBar.frame.size.height ?? 0;
    }

    func setLeftButton(imageName:String) {
        let leftButton = UIButton.init(type: .custom);
        leftButton.frame = CGRect.init(x: 15.0, y: statusBarHeight + 11, width: 20.0, height: 20.0)
        leftButton.setBackgroundImage(UIImage.init(named: imageName), for: .normal)
        leftButton.addTarget(self, action: #selector(popself), for: .touchUpInside);
        self.view.addSubview(leftButton)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0 , execute: {
            self.view.bringSubviewToFront(leftButton)
        })
    }

    func setBackgroundImage(imageName:String) {
        let background = UIImageView.init(frame: screenFrame)
        background.clipsToBounds = true
        background.contentMode = .scaleAspectFill
        background.image = UIImage.init(named: imageName)
        self.view.addSubview(background)
    }

    

}
