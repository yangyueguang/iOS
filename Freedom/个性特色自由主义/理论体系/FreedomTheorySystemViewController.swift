//
//  FreedomTheorySystemViewController.swift
//  Freedom
//
//  Created by Super on 2018/5/15.
//  Copyright © 2018年 Super. All rights reserved.
//
import UIKit
final class FreedomTheorySystemViewController: FreedomBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "理论体系"
        let items = ["经济建设","思想建设","人生追求","金钱","自由","爱情","事业","家庭","亲人","好友","健康","名誉","智慧","能力","快乐"]
        view.backgroundColor = UIColor.darkGray
        let starsView = Circular3DStarView(frame: CGRect(x: 0, y: 100, width: APPW, height: APPW))
        var stars: [UIView] = []
        for i in 0..<100 {
            let index = Int(arc4random() % 12)
            let text = items[index]
            let item = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30), font: UIFont.mini, color: UIColor.white, text: text)
            item.textAlignment = .center
            item.isTapEffectEnabled = false
            let pointView = UIButton(frame: CGRect(x: 45, y: 20, width: 10, height: 10))
            pointView.layer.cornerRadius = 5
            pointView.backgroundColor = UIColor.random
            pointView.tag = i
            item.addSubview(pointView)
            stars.append(item)
        }
        starsView.stars = stars
        view.addSubview(starsView)
    }
}
