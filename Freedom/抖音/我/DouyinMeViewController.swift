//
//  UserHomePageController.swift
//  Douyin
//
//  Created by Qiao Shi on 2018/8/1.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

import Foundation
import UIKit
import XCarryOn
import MJRefresh
var USER_INFO_HEADER_HEIGHT:CGFloat = 340 + statusBarHeight
var SLIDE_TABBAR_FOOTER_HEIGHT:CGFloat = 40

final class DouyinMeViewController: DouyinBaseViewController {
    var collectionView: BaseCollectionView!
    var selectIndex:Int = 0
    
    let uid:String = "97795069353"
    var user:DouYinUser?
    
    var workAwemes = [Aweme]()
    var favoriteAwemes = [Aweme]()
    
    var pageIndex = 0;
    let pageSize = 21
    
    var tabIndex = 0
    var itemWidth:CGFloat = 0
    var itemHeight:CGFloat = 0
    
    let scalePresentAnimation = ScalePresentAnimation.init()
    let scaleDismissAnimation = ScaleDismissAnimation.init()
    let swipeLeftInteractiveTransition = SwipeLeftInteractiveTransition.init()
    
    var userInfoHeader:UserInfoHeader?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarTitleColor(color: UIColor.clear)
        self.setNavigationBarBackgroundColor(color: UIColor.clear)
        self.setStatusBarBackgroundColor(color: UIColor.clear)
        self.setStatusBarStyle(style: .lightContent)
        self.setStatusBarHidden(hidden: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onNetworkStatusChange(notification:)), name: Notification.Name(rawValue: NetworkStatesChangeNotification), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView()
    }
    
    func initCollectionView() {
        itemWidth = (APPW - CGFloat(Int(APPW) % 3)) / 3.0 - 1.0
        itemHeight =  itemWidth * 1.3
        
        let layout = HoverViewFlowLayout.init(navHeight: safeAreaTopHeight)
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 0;
        collectionView = BaseCollectionView.init(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UserInfoHeader.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UserInfoHeader.identifier)
        collectionView.register(SlideTabBarFooter.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SlideTabBarFooter.identifier)
        collectionView.register(AwemeCollectionCell.classForCoder(), forCellWithReuseIdentifier: AwemeCollectionCell.identifier)
        self.view.addSubview(collectionView)
        collectionView.mj_footer = MJRefreshAutoFooter(refreshingBlock: { [weak self] in
            self?.loadData(page: self?.pageIndex ?? 0)
        })
    }
    
    @objc func onNetworkStatusChange(notification:NSNotification) {
        if !NetworkManager.isNotReachableStatus(status: NetworkManager.networkStatus()) {
            if user == nil {
                loadUserData()
            }
            if favoriteAwemes.count == 0 && workAwemes.count == 0 {
                loadData(page: pageIndex)
            }
        }
    }
    
    func loadUserData() {
        UserRequest.findUser(uid: uid, success: {[weak self] data in
            self?.user = data as? DouYinUser
            self?.setNavigationBarTitle(title: self?.user?.nickname ?? "")
            self?.collectionView?.reloadSections(IndexSet.init(integer: 0))
        }, failure: { error in
            self.noticeError(error.localizedDescription)
        })
    }
    
    func loadData(page:Int, _ size:Int = 21) {
        if tabIndex == 0 {
            AwemeListRequest.findPostAwemesPaged(uid: uid, page: page, size, success: {[weak self] data in
                if let response = data as? AwemeListResponse {
                    if self?.tabIndex != 0 {
                        return
                    }
                    let array = response.data
                    self?.pageIndex += 1
                    
                    UIView.setAnimationsEnabled(false)
                    self?.collectionView?.performBatchUpdates({
                        self?.workAwemes += array
                        var indexPaths = [IndexPath]()
                        for row in ((self?.workAwemes.count ?? 0) - array.count)..<(self?.workAwemes.count ?? 0) {
                            indexPaths.append(IndexPath.init(row: row, section: 1))
                        }
                        self?.collectionView?.insertItems(at: indexPaths)
                    }, completion: { finished in
                        UIView.setAnimationsEnabled(true)

                        self?.collectionView.mj_footer.endRefreshing()
                    })
                }
            }, failure:{ error in

                self.collectionView.mj_footer.endRefreshing()
            })
        } else {
            AwemeListRequest.findFavoriteAwemesPaged(uid: uid, page: page, size, success: {[weak self] data in
                if let response = data as? AwemeListResponse {
                    if self?.tabIndex != 1 {
                        return
                    }
                    let array = response.data
                    self?.pageIndex += 1
                    
                    UIView.setAnimationsEnabled(false)
                    self?.collectionView?.performBatchUpdates({
                        self?.favoriteAwemes += array
                        var indexPaths = [IndexPath]()
                        for row in ((self?.favoriteAwemes.count ?? 0) - array.count)..<(self?.favoriteAwemes.count ?? 0) {
                            indexPaths.append(IndexPath.init(row: row, section: 1))
                        }
                        self?.collectionView?.insertItems(at: indexPaths)
                    }, completion: { finished in
                        UIView.setAnimationsEnabled(true)

                        self?.tableView.mj_footer.endRefreshing()
                    })
                }
            }, failure: { error in

                self.tableView.mj_footer.endRefreshing()
            })
        }
    }
}

extension DouyinMeViewController:UICollectionViewDataSource,UICollectionViewDelegate {
    
    //UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return tabIndex == 0 ? workAwemes.count : favoriteAwemes.count
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(AwemeCollectionCell.self, for: indexPath)
        let aweme:Aweme = tabIndex == 0 ? workAwemes[indexPath.row] : favoriteAwemes[indexPath.row]
        cell.initData(aweme: aweme)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            if kind == UICollectionView.elementKindSectionHeader {
                let header = collectionView.dequeueHeadFoot(UserInfoHeader.self, kind: UICollectionView.elementKindSectionHeader, for: indexPath)
                userInfoHeader = header
                if let data = user {
                    header.initData(user: data)
                    header.delegate = self
                }
                return header
            } else {
                let footer = collectionView.dequeueHeadFoot(SlideTabBarFooter.self, kind: UICollectionView.elementKindSectionFooter, for: indexPath)
                footer.delegate = self
                footer.setLabel(titles: ["作品" + String(user?.aweme_count ?? 0),"喜欢" + String(user?.favoriting_count ?? 0)], tabIndex: tabIndex)
                return footer
            }
        }
        return UICollectionReusableView.init()
    }
    
    //UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        let controller = tabIndex == 0 ? AwemeListController.init(data: workAwemes, currentIndex: indexPath.row, page: pageIndex, size: pageSize, awemeType: .AwemeWork, uid: uid) : AwemeListController.init(data: favoriteAwemes, currentIndex: indexPath.row, page: pageIndex, size: pageSize, awemeType: .AwemeFavorite, uid: uid)
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .overCurrentContext
        self.modalPresentationStyle = .currentContext
        swipeLeftInteractiveTransition.wireToViewController(viewController: controller)
        self.present(controller, animated: true, completion: nil)
    }
    
    //UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 0 ? CGSize.init(width:APPW, height:USER_INFO_HEADER_HEIGHT) : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return section == 0 ? CGSize.init(width:APPW, height:SLIDE_TABBAR_FOOTER_HEIGHT) : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: itemWidth, height: itemHeight)
    }
    
}

extension DouyinMeViewController {
    //实现UIScrollViewDelegate中的scrollViewDidScroll方法
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //获取当前控件y方向的偏移量
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            userInfoHeader?.overScrollAction(offsetY: offsetY)
        } else {
            userInfoHeader?.scrollToTopAction(offsetY: offsetY)
            updateNavigationTitle(offsetY: offsetY)
        }
    }
    
    func updateNavigationTitle(offsetY:CGFloat) {
        if USER_INFO_HEADER_HEIGHT - self.navagationBarHeight()*2 > offsetY {
            setNavigationBarTitleColor(color: UIColor.clear)
        }
        
        if USER_INFO_HEADER_HEIGHT - self.navagationBarHeight()*2 < offsetY && offsetY < USER_INFO_HEADER_HEIGHT - self.navagationBarHeight() {
            let alphaRatio = 1.0 - (USER_INFO_HEADER_HEIGHT - self.navagationBarHeight() - offsetY)/self.navagationBarHeight()
            self.setNavigationBarTitleColor(color: UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: alphaRatio))
        }
        
        if offsetY > USER_INFO_HEADER_HEIGHT - self.navagationBarHeight() {
            self.setNavigationBarTitleColor(color: UIColor.whitex)
        }
    }
}

extension DouyinMeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return scalePresentAnimation
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return scaleDismissAnimation
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return swipeLeftInteractiveTransition.interacting ? swipeLeftInteractiveTransition : nil
    }
}

extension DouyinMeViewController: UserInfoDelegate, OnTabTapActionDelegate {
    
    func onUserActionTap(tag: Int) {
        switch tag {
        case AVATAE_TAG:
            PhotoView.init(user?.avatar_medium?.url_list.first).show()
            break
        case SEND_MESSAGE_TAG:
            self.navigationController?.pushViewController(ChatListController.init(), animated: true)
            break
        case FOCUS_CANCEL_TAG,FOCUS_TAG:
            userInfoHeader?.startFocusAnimation()
            break
        case SETTING_TAG:
            let sheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "清除缓存", style: .default) { (ac) in
                XDataCache.shared.clearMemory()
                XDataCache.shared.cleanDisk()
                self.noticeSuccess("清除缓存成功")
            }
            sheet.addAction(action)
            self.present(sheet, animated: true, completion: nil)
            break
        case GITHUB_TAG:
            UIApplication.shared.openURL(URL.init(string: "https://github.com/sshiqiao/douyin-ios-swift")!)
            break
        default:
            break
        }
    }
    
    func onTabTapAction(index: Int) {
        if tabIndex != index {
            tabIndex = index
            pageIndex = 0
            
            UIView.setAnimationsEnabled(false)
            collectionView?.performBatchUpdates({
                workAwemes.removeAll()
                favoriteAwemes.removeAll()
                collectionView?.reloadSections(IndexSet.init(integer: 1))
            }, completion: { finished in
                UIView.setAnimationsEnabled(true)
                

                self.tableView.mj_footer.endRefreshing()
                
                self.loadData(page: self.pageIndex)
            })        }
    }
}


