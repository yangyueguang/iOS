//
//  MenuPopView.swift
//  Douyin
//
//  Created by Qiao Shi on 2018/8/5.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

import Foundation
import UIKit
typealias OnAction = (_ index:Int) -> Void

class MenuPopView: UIView {
    
    var container = UIView.init()
    var cancel = UIButton.init()
    var onAction: OnAction?
    private var _titles = [String]()
    var titles: [String] {
        set {
            _titles = newValue.reversed()
            initSubView()
        }
        get {
            return _titles
        }
    }
    
    init(titles:[String]) {
        super.init(frame: UIScreen.main.bounds)
        self.titles = titles
    }
    
    func initSubView() {
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(cancel(sender:))))
        container.frame = CGRect.init(x: 0, y: APPH, width: APPW, height: CGFloat(titles.count + 1) * 70)
        container.backgroundColor = UIColor.clear
        self.addSubview(container)
        
        cancel.frame = CGRect.init(x: 8, y: container.frame.size.height - 63, width: APPW - 16, height: 55)
        cancel.setTitle("取消", for: .normal)
        cancel.setTitleColor(UIColor.bluex, for: .normal)
        cancel.titleLabel?.font = .large
        cancel.layer.cornerRadius = 10
        cancel.backgroundColor = UIColor.whitex
        container.addSubview(cancel)
        cancel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(cancel(sender:))))
        
        for index in 0..<titles.count {
            let button = UIButton.init(frame: CGRect.init(x: 8, y: container.frame.size.height - CGFloat(63 * (index + 2)), width: APPW - 16, height: 55))
            button.setTitle(titles[index], for: .normal)
            button.setTitleColor(UIColor.bluex, for: .normal)
            button.titleLabel?.font = .large
            button.layer.cornerRadius = 10
            button.backgroundColor = UIColor.whiteAlpha(0.8)
            button.tag = index
            button.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(action(sender:))))
            container.addSubview(button)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func action(sender:UITapGestureRecognizer) {
        onAction?(sender.view?.tag ?? 0)
        dismiss()
    }
    
    @objc func cancel(sender:UITapGestureRecognizer) {
        var point = sender.location(in: container)
        if !container.layer.contains(point) {
            dismiss()
            return
        }
        
        point = sender.location(in: cancel)
        if cancel.layer.contains(point) {
            dismiss()
        }
    }
    
    func show() {
        let window = UIApplication.shared.delegate?.window as? UIWindow
        window?.addSubview(self)
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
            var frame = self.container.frame
            frame.origin.y -= frame.size.height
            self.container.frame = frame
        }) { finished in
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
            var frame = self.container.frame
            frame.origin.y += frame.size.height
            self.container.frame = frame
        }) { finished in
            self.removeFromSuperview()
        }
    }
}
