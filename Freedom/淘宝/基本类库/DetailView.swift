//
//  DetailView.swift
//  Freedom
//
//  Created by Super on 6/14/18.
//  Copyright © 2018 Super. All rights reserved.
import UIKit
import XExtension
import XCarryOn
class DetailView: UIView {
    var sectionView: UIView!
    var sectionLineView: UIView!
    var isTriggerd = false
    var topScrollView: UIScrollView!//最重要的视图，用于作各种效果
    var tipView: UIView!//中间的提示视图
    var topScrollPageView: UIView!
    //banner视图，包含滚动视图和页面控件
    var topView: UIView!//顶部视图的容器
    var bottomView: UIView!
    private var middleHeight: CGFloat = 44.0
    private var currentIndex: Int = -1
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        topScrollPageView = UIView(frame: CGRect(x: 0, y: -370, width: width, height: 370))
        topScrollPageView.layer.masksToBounds = false
        tipView = UIView(frame: CGRect(x: 0, y: height, width: width, height: 44))
        topView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        bottomView = UIView(frame: CGRect(x: 0, y: height, width: width, height: height - 0))
        sectionView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: middleHeight))
        sectionView.backgroundColor = UIColor.white
        sectionLineView = UIView(frame: CGRect(x: width, y: middleHeight - 2, width: width, height: 2))
        sectionLineView.backgroundColor = UIColor.red
        topScrollView.addObserver(self, forKeyPath: "contentOffset", options: [.old, .new], context: nil)
        topScrollView.addObserver(self, forKeyPath: "contentSize", options: [.old, .new], context: nil)
        topScrollView.addSubview(tipView)
        topScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        addSubview(topView)
        addSubview(bottomView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func reloadData() {
        isTriggerd = false
        for v in bottomView.subviews{
            v.removeFromSuperview()
        }
        for v in sectionView.subviews{
            v.removeFromSuperview()
        }
        let titleTotal: Int = 3
        let itemWidth = CGFloat(width / CGFloat(titleTotal))
        var rect: CGRect = sectionView.frame
        middleHeight = 44.0
        rect.origin.y = 0
        rect.size.height = middleHeight
        sectionView.frame = rect
        bottomView.addSubview(sectionView)
        rect = sectionLineView.frame
        rect.size.width = itemWidth
        sectionLineView.frame = rect
        for i in 0..<titleTotal {
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: itemWidth * CGFloat(i), y: 0, width:width / CGFloat(titleTotal), height: middleHeight)
            button.backgroundColor = UIColor.white
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
            button.setTitleColor(UIColor.gray, for: .normal)
            button.setTitleColor(UIColor.red, for: .selected)
            button.tag = 20140830 + i
            button.addTarget(self, action: #selector(self.sectionButtonAction(_:)), for: .touchUpInside)
            sectionView.addSubview(button)
        }
        if middleHeight > 1.0 {
            let lineView = UIView(frame: CGRect(x: 0, y: middleHeight - 1, width: width, height: 1))
            lineView.backgroundColor = UIColor.lightGray
            lineView.alpha = 0.5
            sectionView.addSubview(lineView)
        }
        rect = bottomView.frame
        var sectionHeight: CGFloat = 0
        if (sectionView.superview != nil) {
            sectionHeight = sectionView.frame.origin.y + sectionView.frame.size.height
        }
        print(sectionHeight)
        topScrollView.contentInset = UIEdgeInsets(top: 370 - 20, left: 0, bottom: 44, right: 0)
        topScrollView.addSubview(topScrollPageView)
        sendSubviewToBack(topScrollPageView)
        topScrollView.contentOffset = CGPoint(x: 0, y: 20 - 370)
    }
    func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [String : Any]?, context: UnsafeMutableRawPointer?) {
        if ("contentSize" == keyPath) {
            if topScrollView.contentSize.height + topScrollView.contentInset.top + topScrollView.contentInset.bottom < height {
                var size: CGSize = topScrollView.contentSize
                size.height = height - (topScrollView.contentInset.top + topScrollView.contentInset.bottom)
                topScrollView.contentSize = size
                return
            }
            tipView.frame = CGRect(x: 0, y: topScrollView.contentSize.height, width: width, height: 44)
        } else if ("contentOffset" == keyPath) {
            let scrollView: UIScrollView = topScrollView
            if scrollView == topScrollView && !(topScrollView.contentSize.height + topScrollView.contentInset.top + topScrollView.contentInset.bottom < height) {
                let contentSize: CGSize = scrollView.contentSize
                let contentOffset: CGPoint = scrollView.contentOffset
                let contentInsets: UIEdgeInsets = scrollView.contentInset
                if !isTriggerd {
                    let startY: CGFloat = (contentSize.height + contentInsets.bottom - contentOffset.y  + height)
                    bottomView.frame = CGRect(x: 0, y: startY + height, width: width, height: height)
                }
                if scrollView.isDragging && !isTriggerd {
                    let value = Float(topScrollView.contentOffset.y + height - topScrollView.contentSize.height)
                    if value > 60 {
                        isTriggerd = true
                        if sectionLineView.superview == nil{
                            sectionView.addSubview(sectionLineView)
                        }
                        if -1 == currentIndex {
                            sectionButtonAction(sectionView.viewWithTag(20140830) as? UIButton)
                        }
                        weak var blockSelf = self
                        UIView.animate(withDuration: 0.25, animations: {
                            blockSelf?.bottomView.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
                            blockSelf?.topView.frame = CGRect(x: 0, y: -self.height, width: self.width, height: self.height)
                            var contentStartY: CGFloat = 0
                            if fabsf(Float(contentStartY)) < 1 {
                                return
                            }
                            if (self.sectionView.superview != nil) {
                                contentStartY = CGFloat(self.sectionView.frame.origin.y + self.sectionView.frame.size.height)
                            }
                            if !self.isTriggerd {
                                contentStartY -= 0
                            }
                            var i = 0, total = 3
                            while i < total {
                                let view = self.bottomView.viewWithTag(20150830 + i)
                                let rect = CGRect(x: 0, y: contentStartY, width: self.width, height: self.height - contentStartY)
                                view?.frame = rect
                                i += 1
                            }
                        })
                    }
                }
            }
        }
    }
    deinit {
        topScrollView.removeObserver(self, forKeyPath: "contentOffset")
        topScrollView.removeObserver(self, forKeyPath: "contentSize")
    }
    @objc func sectionButtonAction(_ sender: UIButton?) {
        if let button = sender{
        weak var blockSelf = self
            let index: Int = (button.tag ) - 20140830
            if button.isSelected {
                var rect: CGRect = sectionLineView.frame
                rect.origin.x = (button.frame.size.width ) * CGFloat(index)
            UIView.animate(withDuration: 0.25, animations: {
                blockSelf?.sectionLineView.frame = rect
            })
        }
        currentIndex = index
        }
    }
}
