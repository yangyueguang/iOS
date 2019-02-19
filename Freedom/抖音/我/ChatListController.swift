//
//  ChatListController.swift
//  Douyin
//
//  Created by Qiao Shi on 2018/8/4.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
let SYS_MSG_CORNER_RADIUS:CGFloat = 10
let MAX_SYS_MSG_WIDTH:CGFloat = APPW - 110
let COMMON_MSG_PADDING:CGFloat = 8
let USER_MSG_CORNER_RADIUS:CGFloat = 10
let MAX_USER_MSG_WIDTH:CGFloat = APPW - 160
let MSG_IMAGE_CORNOR_RADIUS:CGFloat = 10
let MAX_MSG_IMAGE_WIDTH:CGFloat = 200
let MAX_MSG_IMAGE_HEIGHT:CGFloat = 200

typealias OnRefresh = () -> Void
//enum
enum LoadingType: Int {
    case LoadStateIdle
    case LoadStateLoading
    case LoadStateAll
    case LoadStateFailed
}

enum RefreshingType: Int {
    case RefreshHeaderStateIdle
    case RefreshHeaderStatePulling
    case RefreshHeaderStateRefreshing
    case RefreshHeaderStateAll
}

class RefreshControl: UIControl {
    var indicator: UIImageView = UIImageView.init(image: UIImage.init(named: "icon60LoadingMiddle"))
    var superView: UIScrollView?

    var refreshingType: RefreshingType = .RefreshHeaderStateIdle
    var onRefresh: OnRefresh?

    init() {
        super.init(frame: CGRect.init(x: 0, y: -50, width: APPW, height: 50))
        self.addSubview(indicator)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(indicator)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        indicator.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.equalTo(25)
        }
        if superView == nil {
            superView = self.superview as? UIScrollView
            superView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            if let superView = self.superview as? UIScrollView {
                if superView.isDragging && refreshingType == .RefreshHeaderStateIdle && superView.contentOffset.y < -80 {
                    refreshingType = .RefreshHeaderStatePulling
                }
                if !superView.isDragging && refreshingType == .RefreshHeaderStatePulling && superView.contentOffset.y >= -50 {
                    startRefresh()
                    onRefresh?()
                }
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    func startRefresh() {
        if refreshingType != .RefreshHeaderStateRefreshing {
            refreshingType = .RefreshHeaderStateRefreshing
            var edgeInsets = superView?.contentInset
            edgeInsets?.top += 50
            superView?.contentInset = edgeInsets ?? .zero
            startAnim()
        }
    }

    func endRefresh() {
        if refreshingType != .RefreshHeaderStateIdle {
            refreshingType = .RefreshHeaderStateIdle
            var edgeInsets = superView?.contentInset
            edgeInsets?.top -= 50
            superView?.contentInset = edgeInsets ?? .zero
            stopAnim()
        }
    }

    func loadAll() {
        refreshingType = .RefreshHeaderStateAll
        self.isHidden = true
    }


    //animation
    func startAnim() {
        let rotationAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber.init(value: .pi * 2.0)
        rotationAnimation.duration = 1.5
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = MAXFLOAT
        indicator.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }

    func stopAnim() {
        indicator.layer.removeAllAnimations()
    }

    deinit {
        superView?.removeObserver(self, forKeyPath: "contentOffset")
    }
}

class ChatListController: DouyinBaseViewController {
    let groupChatVM = PublishSubject<GroupChat>()
    var refreshControl = RefreshControl.init()
    var data = [GroupChat]()
    var textView = ChatTextView.init()
    let groupChatViewModel = PublishSubject<GroupChat>()
    let groupChatsViewModel = PublishSubject<[GroupChat]>()
    let baseVM = PublishSubject<BaseResponse>()
    var pageIndex = 0;
    let pageSize = 20
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarTitle(title: "QSHI")
        self.setNavigationBarTitleColor(color: UIColor.whitex)
        self.setNavigationBarBackgroundColor(color: .grayx)
        self.setStatusBarBackgroundColor(color: .grayx)
        self.setStatusBarStyle(style: .lightContent)
        self.setStatusBarHidden(hidden: false)
        textView.show()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData(page: pageIndex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textView.dismiss()
    }
    
    func setUpView() {
        tableView = BaseTableView.init(frame: CGRect.init(x: 0, y: safeAreaTopHeight, width: APPW, height: APPH - (self.navagationBarHeight() + statusBarHeight) - 10 - safeAreaBottomHeight))
        tableView.backgroundColor = UIColor.clear
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableView.register(TimeCell.classForCoder(), forCellReuseIdentifier: TimeCell.identifier)
        tableView.register(SystemMessageCell.classForCoder(), forCellReuseIdentifier: SystemMessageCell.identifier)
        tableView.register(ImageMessageCell.classForCoder(), forCellReuseIdentifier: ImageMessageCell.identifier)
        tableView.register(TextMessageCell.classForCoder(), forCellReuseIdentifier: TextMessageCell.identifier)
        self.view.addSubview(tableView)
        
        refreshControl.onRefresh = {[weak self] in
            self?.loadData(page: self?.pageIndex ?? 0)
        }
        tableView?.addSubview(refreshControl)
        textView.delegate = self

    }
    
    func loadData(page:Int, _ size:Int = 20) {
        XNetKit.douyinfindGroupChatsPaged(page: page, size: size, next: groupChatsViewModel)
        groupChatsViewModel.subscribe(onNext: {[weak self] (array) in
            let preCount = self?.data.count ?? 0
            UIView.setAnimationsEnabled(false)
            self?.processData(data: array)
            let curCount = self?.data.count ?? 0
            if (self?.pageIndex ?? 0) == 0 || preCount == 0 || (curCount - preCount) <= 0 {
                self?.scrollToBottom()
            } else {
                self?.tableView?.scrollToRow(at: IndexPath.init(row: curCount - preCount, section: 0), at: .top, animated: false)
            }
            self?.pageIndex += 1
            self?.refreshControl.endRefresh()
            UIView.setAnimationsEnabled(true)
        }).disposed(by: disposeBag)

    }
    
    func processData(data:[GroupChat]) {
        if data.count == 0 {
            return
        }
        var tempArray = [GroupChat]()
        for chat in data {
            if (!("system" == chat.msg_type ?? "") &&
                (tempArray.count == 0 || (tempArray.count > 0 && (labs((tempArray.last?.create_time ?? 0) - (chat.create_time ?? 0)) > 60*5)))) {
                let timeChat = chat.createTimeChat()
                tempArray.append(timeChat)
            }
            chat.cellHeight = ChatListController.cellHeight(chat: chat)
            tempArray.append(chat)
        }
        self.data.insert(contentsOf: tempArray, at: 0)
        tableView?.reloadData()
    }
    
    func deleteChat(cell:UITableViewCell?) {
        if cell == nil {
            return
        }
        if let indexPath = tableView?.indexPath(for: cell!) {
            let index = indexPath.row
            if index < data.count {
                let chat = data[index]
                var indexPaths = [IndexPath]()
                if index - 1 < data.count && data[index - 1].msg_type == "time" {
                    indexPaths.append(IndexPath.init(row: index - 1, section: 0))
                }
                if index < data.count {
                    indexPaths.append(IndexPath.init(row: index, section: 0))
                }
                if indexPaths.count == 0 {
                    return
                }
                XNetKit.douyinDeleteGroupChat(next: baseVM)
                baseVM.subscribe(onNext: {[weak self] (response) in
                    self?.tableView?.beginUpdates()
                    var indexs = [Int]()
                    for indexPath in indexPaths {
                        indexs.append(indexPath.row)
                    }
                    for index in indexs.sorted(by: >) {
                        self?.data.remove(at: index)
                    }
                    self?.tableView?.deleteRows(at: indexPaths, with: .right)
                    self?.tableView?.endUpdates()
                }).disposed(by: disposeBag)
            }
        }
    }
    
    func scrollToBottom() {
        if self.data.count > 0 {
            tableView?.scrollToRow(at: IndexPath.init(row: self.data.count-1, section: 0), at: .bottom, animated: false)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func receiveMessage(notification:Notification) {
        let json = notification.object as! NSDictionary
        let chat = GroupChat.parse(json)
        chat.cellHeight = ChatListController.cellHeight(chat: chat)
        var shouldScrollToBottom = false
        if (tableView?.visibleCells.count)! > 0 && (tableView?.indexPath(for: (tableView?.visibleCells.last)!)?.row ?? 0) == data.count - 1 {
            shouldScrollToBottom = true
        }
        UIView.setAnimationsEnabled(false)
        tableView?.beginUpdates()
        data.append(chat)
        tableView?.insertRows(at: [IndexPath.init(row: data.count - 1, section: 0)], with: .none)
        tableView?.endUpdates()
        UIView.setAnimationsEnabled(true)

        if shouldScrollToBottom {
            scrollToBottom()
        }
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let chat = data[indexPath.row]
        return chat.cellHeight
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = data[indexPath.row]
        if chat.msg_type == "system" {
            let cell = tableView.dequeueCell(SystemMessageCell.self)
            cell.initData(chat: chat)
            return cell
        } else if chat.msg_type == "text" {
            let cell = tableView.dequeueCell(TextMessageCell.self)
            cell.initData(chat: chat)
            cell.onMenuAction = {[weak self] actionType in
                if actionType == .DeleteAction {
                    self?.deleteChat(cell: cell)
                } else if actionType == .CopyAction {
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = chat.msg_content;
                }
            }
            return cell
        } else if chat.msg_type == "image" {
            let cell = tableView.dequeueCell(ImageMessageCell.self)
            cell.initData(chat: chat)
            cell.onMenuAction = {[weak self] actionType in
                if actionType == .DeleteAction {
                    self?.deleteChat(cell: cell)
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueCell(TimeCell.self)
            cell.initData(chat: chat)
            return cell
        }
    }

    static func cellHeight(chat:GroupChat) -> CGFloat {
        if chat.msg_type == "system" {
            return SystemMessageCell.cellHeight(chat:chat)
        } else if chat.msg_type == "text" {
            return TextMessageCell.cellHeight(chat:chat)
        } else if chat.msg_type == "image" {
            return ImageMessageCell.cellHeight(chat:chat)
        } else {
            return TimeCell.cellHeight(chat:chat)
        }
    }
}

extension ChatListController:ChatTextViewDelegate {
    func onSendText(text: String) {
        let chat = GroupChat.initTextChat(text:text)
        chat.visitor = Visitor.read()
        chat.cellHeight = ChatListController.cellHeight(chat: chat)
        
        UIView.setAnimationsEnabled(false)
        tableView?.beginUpdates()
        data.append(chat)
        tableView?.insertRows(at: [IndexPath.init(row: data.count - 1, section: 0)], with: .none)
        tableView?.endUpdates()
        UIView.setAnimationsEnabled(true)
        
        scrollToBottom()
        
        if let index = data.index(of: chat) {
            groupChatVM.subscribe(onNext: {[weak self] (chatG) in
                chat.updateTempTextChat(chat: chatG)
                self?.tableView?.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .none)
            }).disposed(by: disposeBag)
            XNetKit.douyinGroupChatText(text: text, next: groupChatVM)
        }
        
    }
    
    func onSendImages(images: [UIImage]) {
        for image in images {
            if let data:Data = image.jpegData(compressionQuality: 1.0) {
                let chat = GroupChat.initImageChat(image: image)
                chat.visitor = Visitor.read()
                chat.cellHeight = ChatListController.cellHeight(chat: chat)
                
                UIView.setAnimationsEnabled(false)
                tableView?.beginUpdates()
                self.data.append(chat)
                tableView?.insertRows(at: [IndexPath.init(row: self.data.count - 1, section: 0)], with: .none)
                tableView?.endUpdates()
                UIView.setAnimationsEnabled(true)
                
                if let index = self.data.index(of: chat) {
                    XNetKit.douyinGroupChatImage(next: groupChatVM)
                    groupChatVM.subscribe(onNext: {[weak self] (chat) in
                        chat.isCompleted = false
                        chat.isFailed = false
                        if let cell = self?.tableView?.cellForRow(at: IndexPath.init(row: index, section: 0)) as? ImageMessageCell {
                            cell.updateUploadStatus(chat:chat)
                        }


                            chat.updateTempImageChat(chat: chat)
                            self?.tableView?.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .none)

                    }).disposed(by: disposeBag)

                }
            }
        }
        scrollToBottom()
    }
    
    func onEditBoardHeightChange(height: CGFloat) {
        tableView?.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: height, right: 0)
        scrollToBottom()
    }
}


