//
//  AwemeListController.swift
//  Douyin
//
//  Created by Qiao Shi on 2018/8/4.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import MJRefresh
let AWEME_CELL:String = "AwemeListCell"

enum AwemeType {
    case AwemeWork
    case AwemeFavorite
}

class AwemeListController: DouyinBaseViewController {
    @objc dynamic var currentIndex:Int = 0
    let awemesVM = PublishSubject<[Aweme]>()
    let favoritesVM = PublishSubject<[Aweme]>()
    var isCurPlayerPause:Bool = false
    var pageIndex:Int = 0
    var pageSize:Int = 21
    var awemeType:AwemeType?
    var uid:String?
    
    var data = [Aweme]()
    var awemes = [Aweme]()

    
    init(data:[Aweme], currentIndex:Int, page:Int, size:Int, awemeType:AwemeType, uid:String) {
        super.init(nibName: nil, bundle: nil)
        
        self.currentIndex = currentIndex
        self.pageIndex = page
        self.pageSize = size
        self.awemeType = awemeType
        self.uid = uid
        
        self.awemes = data
        self.data.append(data[currentIndex])
        NotificationCenter.default.addObserver(self, selector: #selector(applicationBecomeActive), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImage(imageName: "img_video_loading")
        setUpView()
        setLeftButton(imageName: "icon_titlebar_whiteback")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView?.layer.removeAllAnimations()
        let cells = tableView?.visibleCells as! [AwemeListCell]
        for cell in cells {
            cell.playerView.cancelLoading()
        }
        NotificationCenter.default.removeObserver(self)
        self.removeObserver(self, forKeyPath: "currentIndex")
    }
    
    func setUpView() {
        tableView = BaseTableView.init(frame: CGRect.init(x: 0, y: -APPH, width: APPW, height: APPH * 5)) as! BaseTableView
        tableView.contentInset = UIEdgeInsets(top: APPH, left: 0, bottom: APPH * 3, right: 0);
        tableView.backgroundColor = UIColor.clear
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableView.register(AwemeListCell.classForCoder(), forCellReuseIdentifier: AWEME_CELL)
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {[weak self] in
            self?.loadData(page: self?.pageIndex ?? 0)
        })
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.view.addSubview(self.tableView!)
            self.data = self.awemes
            self.tableView?.reloadData()
            
            let curIndexPath = IndexPath.init(row: self.currentIndex, section: 0)
            self.tableView.scrollToRow(at: curIndexPath, at: UITableView.ScrollPosition.middle, animated: false)
            self.addObserver(self, forKeyPath: "currentIndex", options: [.initial, .new], context: nil)
        }
    }
    
    
    func loadData(page:Int, _ size:Int = 21) {
        if awemeType == AwemeType.AwemeWork {
            XNetKit.douyinfindPostAwemesPaged(uid ?? "", page: page, size: size, next: awemesVM)
            awemesVM.subscribe(onNext: { [weak self](array) in
                self?.pageIndex += 1

                self?.tableView?.beginUpdates()
                self?.data += array
                var indexPaths = [IndexPath]()
                for row in ((self?.data.count ?? 0) - array.count)..<(self?.data.count ?? 0) {
                    indexPaths.append(IndexPath.init(row: row, section: 0))
                }
                self?.tableView?.insertRows(at: indexPaths, with: .none)
                self?.tableView?.endUpdates()

                self?.tableView.mj_footer?.endRefreshing()

            }).disposed(by: disposeBag)

        } else {
            XNetKit.douyinfindFavoriteAwemesPaged(uid ?? "", page: page, next: favoritesVM)
            favoritesVM.subscribe(onNext: {[weak self] (array) in
                self?.pageIndex += 1

                self?.tableView?.beginUpdates()
                self?.data += array
                var indexPaths = [IndexPath]()
                for row in ((self?.data.count ?? 0) - array.count)..<(self?.data.count ?? 0) {
                    indexPaths.append(IndexPath.init(row: row, section: 0))
                }
                self?.tableView?.insertRows(at: indexPaths, with: .none)
                self?.tableView?.endUpdates()
                self?.tableView.mj_footer?.endRefreshing()

            }).disposed(by: disposeBag)
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return APPH
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(AwemeListCell.self)
        cell.initData(aweme: data[indexPath.row])
        return cell
    }
}

extension AwemeListController {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        DispatchQueue.main.async {
            let translatedPoint = scrollView.panGestureRecognizer.translation(in: scrollView)
            scrollView.panGestureRecognizer.isEnabled = false
            
            if translatedPoint.y < -50 && self.currentIndex < (self.data.count - 1) {
                self.currentIndex += 1
            }
            if translatedPoint.y > 50 && self.currentIndex > 0 {
                self.currentIndex -= 1
            }
            UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
                self.tableView?.scrollToRow(at: IndexPath.init(row: self.currentIndex, section: 0), at: UITableView.ScrollPosition.top, animated: false)
            }, completion: { finished in
                scrollView.panGestureRecognizer.isEnabled = true
            })
        }
    }
}

extension AwemeListController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "currentIndex") {
            isCurPlayerPause = false
            weak var cell = tableView?.cellForRow(at: IndexPath.init(row: currentIndex, section: 0)) as? AwemeListCell
            if cell?.isPlayerReady ?? false {
                cell?.replay()
            } else {
                AVPlayerManager.shared().pauseAll()
                cell?.onPlayerReady = {[weak self] in
                    if let indexPath = self?.tableView?.indexPath(for: cell!) {
                        if !(self?.isCurPlayerPause ?? true) && indexPath.row == self?.currentIndex {
                            cell?.play()
                        }
                    }
                }
            }
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    @objc func statusBarTouchBegin() {
        currentIndex = 0
    }
    
    @objc func applicationBecomeActive() {
        let cell = tableView?.cellForRow(at: IndexPath.init(row: currentIndex, section: 0)) as! AwemeListCell
        if !isCurPlayerPause {
            cell.playerView.play()
        }
    }
    
    @objc func applicationEnterBackground() {
        let cell = tableView?.cellForRow(at: IndexPath.init(row: currentIndex, section: 0)) as! AwemeListCell
        isCurPlayerPause = cell.playerView.rate() == 0 ? true :false
        cell.playerView.pause()
    }
}

