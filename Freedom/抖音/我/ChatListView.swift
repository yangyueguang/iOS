//
//  ChatTextView.swift
//  Douyin
//
//  Created by Qiao Shi on 2018/8/9.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

import Foundation
import Photos
extension NSTextAttachment {
    static var _emotionKey = "emotionKey"
    var emotionKey:String? {
        get{
            return objc_getAssociatedObject(self, &NSTextAttachment._emotionKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &NSTextAttachment._emotionKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
class EmotionHelper:NSObject {

    static let EmotionFont = UIFont.big

    //获取emotion.json中的以表情图片文件名作为key值、表情对应的文本作为value值的字典dic
    static let emotionDic:[String:String] = {
        return FileManager.readJson2Dict(fileName: "emotion")["dict"]
        }() as! [String : String]

    //获取emotion.json中包含了表情选择器中每一页的表情图片文件名的二维数组array
    static let emotionArray:[[String]] = {
        return FileManager.readJson2Dict(fileName: "emotion")["array"]
        }() as! [[String]]

    //通过正则表达式匹配文本，表情文本转换为NSTextAttachment图片文本，例：[飞吻]→😘
    static func stringToEmotion(str:NSAttributedString) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString.init(attributedString: str)
        let pattern = "\\[.*?\\]"
        var regex:NSRegularExpression?
        do {
            regex = try NSRegularExpression.init(pattern: pattern, options: NSRegularExpression.Options(rawValue: 0))
        } catch {
            print("stringToEmotion error:" + error.localizedDescription)
        }
        let matches:[NSTextCheckingResult] = regex?.matches(in: str.string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange.init(location: 0, length: str.length)) ?? [NSTextCheckingResult]()
        var lengthOffset = 0
        for match in matches {
            let range = match.range
            let emotionValue = str.string.substring(range: range)
            let emotinoKey = EmotionHelper.emotionKeyFromValue(value: emotionValue)
            let attachment:NSTextAttachment = NSTextAttachment()
            let emotionPath = EmotionHelper.emotionIconPath(emotionKey: emotinoKey)

            attachment.image = UIImage.init(contentsOfFile: emotionPath)
            attachment.bounds = CGRect.init(x: 0, y: EmotionFont.descender, width: EmotionFont.lineHeight, height: EmotionFont.lineHeight/((attachment.image?.size.width)!/(attachment.image?.size.height)!))
            let matchStr = NSAttributedString.init(attachment: attachment)
            let emotionStr = NSMutableAttributedString.init(attributedString: matchStr)
            emotionStr.addAttribute(NSAttributedString.Key.font, value: EmotionFont, range: NSRange.init(location: 0, length: 1))
            attributedString.replaceCharacters(in: NSRange.init(location: range.location - lengthOffset, length: range.length), with: emotionStr)
            lengthOffset += (range.length - 1)
        }
        return attributedString
    }

    //NSTextAttachment图片文本转换为表情文本，例：😘→[飞吻]
    static func emotionToString(str:NSMutableAttributedString) -> NSAttributedString {
        str.enumerateAttribute(.attachment, in: NSRange.init(location: 0, length: str.length), options: .longestEffectiveRangeNotRequired) { (value, range, stop) in
            if let attachment = value as? NSTextAttachment {
                if let emotionKey = attachment.emotionKey {
                    let emotionValue = EmotionHelper.emotionValueFromKey(key: emotionKey)
                    str.replaceCharacters(in: range, with: emotionValue)
                }
            }
        }
        return str
    }

    //通过表情文本value值获取表情图片文件名key值
    static func emotionKeyFromValue(value:String) -> String {
        let emotionDic:[String:String] = EmotionHelper.emotionDic
        for key in emotionDic.keys {
            if emotionDic[key] == value {
                return key
            }
        }
        return ""
    }

    //通过表情图片文件名key值获取表情文本value值
    static func emotionValueFromKey(key:String) -> String {
        let emotionDic:[String:String] = EmotionHelper.emotionDic
        return emotionDic[key] ?? ""
    }

    static func insertEmotion(str:NSAttributedString, index:Int, key:String) -> NSAttributedString {

        let attachment:NSTextAttachment = NSTextAttachment()
        attachment.emotionKey = key
        let emotionPath = EmotionHelper.emotionIconPath(emotionKey:key)
        attachment.image = UIImage.init(contentsOfFile: emotionPath)
        attachment.bounds = CGRect.init(x: 0, y: EmotionFont.descender, width: EmotionFont.lineHeight, height: EmotionFont.lineHeight/((attachment.image?.size.width)!/(attachment.image?.size.height)!))
        let matchStr = NSAttributedString.init(attachment: attachment)
        let emotionStr = NSMutableAttributedString.init(attributedString: matchStr)
        emotionStr.addAttribute(NSAttributedString.Key.font, value: EmotionFont, range: NSRange.init(location: 0, length: emotionStr.length))
        let attrStr = NSMutableAttributedString.init(attributedString: str)

        attrStr.replaceCharacters(in: NSRange.init(location: index, length: 0), with: emotionStr)
        return attrStr
    }

    static func emotionIconPath(emotionKey:String) -> String {
        let emotionsPath = Bundle.main.path(forResource: "Emoticons", ofType: "bundle") ?? ""
        let emotionPath = emotionsPath + "/" + emotionKey
        return emotionPath
    }
}

let EMOTION_TAG:Int = 1000
let PHOTO_TAG:Int = 2000

let LEFT_INSET:CGFloat = 15
let RIGHT_INSET:CGFloat = 85
let TOP_BOTTOM_INSET:CGFloat = 15

protocol ChatTextViewDelegate:NSObjectProtocol {
    func onSendText(text:String)
    func onSendImages(images:[UIImage])
    func onEditBoardHeightChange(height:CGFloat)
}
class ChatTextView:UIView {
    var container = UIView.init()
    var textView = UITextView.init()
    var editMessageType:ChatEditMessageType = .EditNoneMessage
    var delegate:ChatTextViewDelegate?
    var textHeight:CGFloat = 0
    @objc dynamic var containerBoardHeight:CGFloat = 0
    var placeHolderLabel = UILabel.init()
    var emotionBtn = UIButton.init()
    var photoBtn = UIButton.init()
    var visualEffectView = UIVisualEffectView.init()
    lazy var emotionSelector:EmotionSelector = {
        let emotionSelector = EmotionSelector.init()
        emotionSelector.delegate = self
        emotionSelector.addTextViewObserver(textView: textView)
        emotionSelector.isHidden = true
        container.addSubview(emotionSelector)
        return emotionSelector
    }()
    
    lazy var photoSelector:PhotoSelector = {
        let photoSelector = PhotoSelector.init()
        photoSelector.delegate = self
        photoSelector.isHidden = true
        container.addSubview(photoSelector)
        return photoSelector
    }()
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        initSubView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }
    
    func initSubView() {
        self.backgroundColor = UIColor.clear
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleGuesture(sender:)))
        tapGestureRecognizer.delegate = self
        self.addGestureRecognizer(tapGestureRecognizer)
        
        container.frame = CGRect.init(x: 0, y: APPH, width: APPW, height: 0)
        container.backgroundColor = .grayx
        self.addSubview(container)
        
        containerBoardHeight = safeAreaBottomHeight
        
        textView.frame = CGRect.init(x: 0, y: APPH, width: APPW, height: 0)
        textView.backgroundColor = UIColor.clear
        textView.clipsToBounds = true
        textView.textColor = UIColor.whitex
        textView.font = .big
        textView.returnKeyType = .send
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.textContainerInset = UIEdgeInsets.init(top: TOP_BOTTOM_INSET, left: LEFT_INSET, bottom: TOP_BOTTOM_INSET, right: RIGHT_INSET)
        textView.textContainer.lineFragmentPadding = 0
        textHeight = textView.font?.lineHeight ?? 0
        
        placeHolderLabel.frame = CGRect.init(x:LEFT_INSET, y:0, width:APPW - LEFT_INSET - RIGHT_INSET, height:50)
        placeHolderLabel.text = "发送消息..."
        placeHolderLabel.textColor = UIColor.grayx
        placeHolderLabel.font = .big
        textView.addSubview(placeHolderLabel)
//        textView.setValue(placeHolderLabel, forKey: "_placeholderLabel")
        
        textView.delegate = self
        container.addSubview(textView)
        
        emotionBtn.tag = EMOTION_TAG
        emotionBtn.setImage(UIImage.init(named: "baseline_emotion_white"), for: .normal)
        emotionBtn.setImage(UIImage.init(named: "outline_keyboard_grey"), for: .selected)
        emotionBtn.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGuesture(sender:))))
        textView.addSubview(emotionBtn)
        
        photoBtn.tag = PHOTO_TAG;
        photoBtn.setImage(UIImage.init(named: "outline_photo_white"), for: .normal)
        photoBtn.setImage(UIImage.init(named: "outline_photo_red"), for: .selected)
        photoBtn.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGuesture(sender:))))
        textView.addSubview(photoBtn)
        
        self.addObserver(self, forKeyPath: "containerBoardHeight", options: [.initial,.new], context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "containerBoardHeight" {
            if containerBoardHeight == safeAreaBottomHeight {
                container.backgroundColor = .grayx
                textView.textColor = UIColor.whitex
                
                emotionBtn.setImage(UIImage.init(named: "baseline_emotion_white"), for: .normal)
                photoBtn.setImage(UIImage.init(named: "outline_photo_white"), for: .normal)
            } else {
                container.backgroundColor = UIColor.whitex
                textView.textColor = UIColor.blackx
                
                emotionBtn.setImage(UIImage.init(named: "baseline_emotion_grey"), for: .normal)
                photoBtn.setImage(UIImage.init(named: "outline_photo_grey"), for: .normal)
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateContainerFrame()
        
        photoBtn.frame = CGRect.init(x: APPW - 50, y: 0, width: 50, height: 50)
        emotionBtn.frame = CGRect.init(x: APPW - 85, y: 0, width: 50, height: 50)
        
        let rounded = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize.init(width: 10.0, height: 10.0))
        let shape = CAShapeLayer.init()
        shape.path = rounded.cgPath
        container.layer.mask = shape
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
            if editMessageType == .EditNoneMessage {
                return nil
            }
        }
        return hitView
    }
    
    func updateContainerFrame() {
        let textViewHeight = containerBoardHeight > safeAreaBottomHeight ? textHeight + 2*TOP_BOTTOM_INSET : UIFont.big.lineHeight + 2*TOP_BOTTOM_INSET
        textView.frame = CGRect.init(x: 0, y: 0, width: APPW, height: textViewHeight)
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.container.frame = CGRect.init(x: 0, y: APPH - self.containerBoardHeight - textViewHeight, width: APPW, height: self.containerBoardHeight + textViewHeight)
            self.delegate?.onEditBoardHeightChange(height: self.container.frame.height)
        }) { finished in
        }
    }
    
    func updateSelectorFrame(animated:Bool) {
        let textViewHeight = containerBoardHeight > 0 ? textHeight + 2*TOP_BOTTOM_INSET : UIFont.big.lineHeight + 2*TOP_BOTTOM_INSET;
        if animated {
            switch (self.editMessageType) {
            case .EditEmotionMessage:
                self.emotionSelector.isHidden = false
                self.emotionSelector.frame = CGRect.init(x: 0, y: textViewHeight + self.containerBoardHeight, width: APPW, height: self.containerBoardHeight)
                break
            case .EditPhotoMessage:
                self.photoSelector.isHidden = false
                self.photoSelector.frame = CGRect.init(x: 0, y: textViewHeight + self.containerBoardHeight, width: APPW, height: self.containerBoardHeight)
                break
            default:
                break
            }
        }
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            switch (self.editMessageType) {
            case .EditEmotionMessage:
                self.emotionSelector.frame = CGRect.init(x:0, y:textViewHeight, width:APPW, height:self.containerBoardHeight)
                self.photoSelector.frame = CGRect.init(x:0, y:textViewHeight + self.containerBoardHeight, width:APPW,  height:self.containerBoardHeight)
                break
            case .EditPhotoMessage:
                self.photoSelector.frame = CGRect.init(x:0, y:textViewHeight,width:APPW, height:self.containerBoardHeight);
                self.emotionSelector.frame = CGRect.init(x:0, y:textViewHeight + self.containerBoardHeight, width:APPW, height:self.containerBoardHeight)
                break
            default:
                self.photoSelector.frame = CGRect.init(x:0, y:textViewHeight + self.containerBoardHeight, width:APPW,  height:self.containerBoardHeight)
                self.emotionSelector.frame = CGRect.init(x:0, y:textViewHeight + self.containerBoardHeight, width:APPW,  height:self.containerBoardHeight)
                break
            }
        }) { finished in
            switch (self.editMessageType) {
            case .EditEmotionMessage:
                self.photoSelector.isHidden = true
                break;
            case .EditPhotoMessage:
                self.emotionSelector.isHidden = true
                break;
            default:
                self.photoSelector.isHidden = true
                self.emotionSelector.isHidden = true
                break;
            }
        }
    }
    
    func hideContainerBoard() {
        editMessageType = .EditNoneMessage;
        containerBoardHeight = safeAreaBottomHeight
        updateContainerFrame()
        updateSelectorFrame(animated: true)
        textView.resignFirstResponder()
        emotionBtn.isSelected = false
        photoBtn.isSelected = false
    }
    
    func show() {
        let window = UIApplication.shared.delegate?.window as? UIWindow
        window?.addSubview(self)
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
    
    deinit {
        emotionSelector.removeTextViewObserver(textView:textView)
        self.removeObserver(self, forKeyPath: "containerBoardHeight")
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatTextView {
    @objc func keyboardWillShow(notification:Notification) {
        editMessageType = .EditTextMessage
        emotionBtn.isSelected = false
        photoBtn.isSelected = false
        containerBoardHeight = notification.keyBoardHeight()
        updateContainerFrame()
        updateSelectorFrame(animated: true)
    }
}

extension ChatTextView:UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let attributedString = NSMutableAttributedString.init(attributedString: textView.attributedText)
        if !textView.hasText {
            placeHolderLabel.isHidden = false
            textHeight = textView.font?.lineHeight ?? 0
        } else {
            placeHolderLabel.isHidden = true
            textHeight = attributedString.boundingRect(with: CGSize(width: APPW - LEFT_INSET - RIGHT_INSET, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size.height
        }
        updateContainerFrame()
        updateSelectorFrame(animated: false)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            onSend()
            return false
        }
        return true
    }
}

extension ChatTextView:UIGestureRecognizerDelegate {    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if NSStringFromClass((touch.view?.superview?.classForCoder)!).contains("EmotionCell") || NSStringFromClass((touch.view?.superview?.classForCoder)!).contains("PhotoCell") {
            return false
        } else {
            return true
        }
    }
    
    @objc func handleGuesture(sender:UITapGestureRecognizer) {
        let point = sender.location(in: container)
        if !(container.layer.contains(point)) {
            hideContainerBoard()
        } else {
            switch sender.view?.tag {
            case EMOTION_TAG:
                emotionBtn.isSelected = !emotionBtn.isSelected
                photoBtn.isSelected = false
                if emotionBtn.isSelected {
                    editMessageType = .EditEmotionMessage
                    containerBoardHeight = EMOTION_SELECTOR_HEIGHT
                    updateContainerFrame()
                    updateSelectorFrame(animated: true)
                    textView.resignFirstResponder()
                } else {
                    editMessageType = .EditTextMessage
                    textView.becomeFirstResponder()
                }
                break
            case PHOTO_TAG:
                let status = PHPhotoLibrary.authorizationStatus()
                if status == .authorized {
                    DispatchQueue.main.async {[weak self] in
                        self?.photoBtn.isSelected = !(self?.photoBtn.isSelected)!
                        self?.emotionBtn.isSelected = false
                        if (self?.photoBtn.isSelected)! {
                            self?.editMessageType = .EditPhotoMessage
                            self?.containerBoardHeight = PHOTO_SELECTOR_HEIGHT
                            self?.updateContainerFrame()
                            self?.updateSelectorFrame(animated: true)
                            self?.textView.resignFirstResponder()
                        } else {
                            self?.hideContainerBoard()
                        }
                    }
                } else {
                    noticeInfo("请在设置中开启图库读取权限")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: {
                        UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString)!)
                    })
                }
                break
            default:
                break
            }
        }
    }
}

extension ChatTextView:EmotionSelectorDelegate {
    
    func onDelete() {
        textView.deleteBackward()
    }
    
    func onSend() {
        let attributedString = NSMutableAttributedString.init(attributedString: textView.attributedText)
        let text = EmotionHelper.emotionToString(str: attributedString)
        if delegate != nil {
            if textView.hasText {
                delegate?.onSendText(text: text.string)
                textView.text = ""
                textHeight = textView.font?.lineHeight ?? 0
                updateContainerFrame()
                updateSelectorFrame(animated: false)
            } else {
                hideContainerBoard()
                noticeInfo("请输入文字")
            }
        }
    }
    
    func onSelect(emotionKey: String) {
        placeHolderLabel.isHidden = true
        
        let location = textView.selectedRange.location
        textView.attributedText = EmotionHelper.insertEmotion(str: textView.attributedText, index: location, key: emotionKey)
        textView.selectedRange = NSRange.init(location: location + 1, length: 0)
        textHeight = textView.attributedText.boundingRect(with: CGSize(width: APPW - LEFT_INSET - RIGHT_INSET, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size.height
        updateContainerFrame()
        updateSelectorFrame(animated: false)
    }
    
}

extension ChatTextView:PhotoSelectorDelegate {
    
    func onSend(images: [UIImage]) {
        delegate?.onSendImages(images: images)
    }
    
}
//
//  PhotoSelector.swift
//  Douyin
//
//  Created by Qiao Shi on 2018/8/9.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

import Foundation
import Photos
//
//  EmotionSelector.swift
//  Douyin
//
//  Created by Qiao Shi on 2018/8/9.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

import Foundation

let EMOTION_SELECTOR_HEIGHT:CGFloat = 220 + safeAreaBottomHeight

protocol EmotionSelectorDelegate:NSObjectProtocol {
    func onDelete()
    func onSend()
    func onSelect(emotionKey:String);
}
class EmotionSelector:UIView,UICollectionViewDelegate,UICollectionViewDataSource, UIGestureRecognizerDelegate, UIScrollViewDelegate {

    var collectionView:UICollectionView?
    var delegate:EmotionSelectorDelegate?

    var itemWidth:CGFloat = 0
    var itemHeight:CGFloat = 0
    var data = [[String]]()
    var emotionDic = [String:String]()
    var pointViews = [UIView]()
    var currentIndex:Int = 0
    var bottomView = UIView.init()
    var send = UIButton.init()

    init() {
        super.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: APPW, height: EMOTION_SELECTOR_HEIGHT)))
        initSubView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }

    func initSubView() {
        self.backgroundColor = .grayx;
        self.clipsToBounds = false;
        emotionDic = EmotionHelper.emotionDic
        data = EmotionHelper.emotionArray

        itemWidth = APPW / 7.0
        itemHeight = 50

        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.init(top:0, left:0, bottom:0, right:0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize.init(width: itemWidth, height: itemHeight)
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: APPW, height: itemHeight * 3), collectionViewLayout: layout)
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.alwaysBounceHorizontal = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(EmotionCell.classForCoder(), forCellWithReuseIdentifier: EmotionCell.identifier)
        self.addSubview(collectionView!)

        currentIndex = 0
        let indicatorWith:CGFloat = 5
        let indicatorHeight:CGFloat = 5
        let indicatorSpacing:CGFloat = 8
        for index in 0..<data.count {
            let pointView = UIView.init(frame:CGRect.init(x:APPW/2 - (indicatorWith*CGFloat(data.count) + indicatorSpacing*CGFloat(data.count-1))/2 + (indicatorWith + indicatorSpacing)*CGFloat(index),y:(collectionView?.frame.height)!,width:indicatorWith,height:indicatorHeight))
            if currentIndex == index {
                pointView.backgroundColor = UIColor.redx;
            }else {
                pointView.backgroundColor = UIColor.grayx;
            }
            pointView.layer.cornerRadius = indicatorWith/2;
            pointViews.append(pointView)
            self.addSubview(pointView)

            bottomView = UIView.init(frame: CGRect.init(x: 0, y: (collectionView?.frame.height)! + 25, width: APPW, height: 45 + safeAreaBottomHeight))
            bottomView.backgroundColor = UIColor.whitex
            self.addSubview(bottomView)

            let leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: itemWidth, height: 45 + safeAreaBottomHeight))
            leftView.backgroundColor = .grayx
            bottomView.addSubview(leftView)

            let defaultEmotion = UIImageView.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: itemWidth, height: 45)))
            defaultEmotion.contentMode = .center
            defaultEmotion.image = UIImage.init(named: "default_emoticon_cover")
            leftView.addSubview(defaultEmotion)

            send = UIButton.init(frame: CGRect.init(x: APPW - 60 - 15, y: 10, width: 60, height: 25))

            send.isEnabled = false
            send.backgroundColor = .grayx
            send.layer.cornerRadius = 2
            send.titleLabel?.font = .middle
            send.setTitle("发送", for: .normal)
            send.tintColor = UIColor.whitex
            send.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
            bottomView.addSubview(send)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updatePoints() {
        for index in 0..<pointViews.count {
            let pointView = pointViews[index]
            if currentIndex == index {
                pointView.backgroundColor = UIColor.redx;
            }else {
                pointView.backgroundColor = UIColor.grayx;
            }
        }
    }

    @objc func sendMessage() {
        delegate?.onSend()
    }

    func addTextViewObserver(textView:UITextView) {
        textView.addObserver(self, forKeyPath: "attributedText", options: .new, context: nil)
    }

    func removeTextViewObserver(textView:UITextView) {
        textView.removeObserver(self, forKeyPath: "attributedText");
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "attributedText" {
            let attributedString = change![NSKeyValueChangeKey.newKey] as? NSAttributedString
            if(attributedString != nil && (attributedString?.length ?? 0) > 0) {
                send.backgroundColor = UIColor.redx
                send.isEnabled = true
            }else {
                send.backgroundColor = .grayx
                send.isEnabled = false
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 21
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(EmotionCell.self, for: indexPath)
        let array:[String] = data[indexPath.section]
        if(indexPath.section < data.count - 1) {
            if(indexPath.row < array.count) {
                cell.initData(key: array[indexPath.row])
            }
        }else {
            if(indexPath.row % 3 != 2) {
                cell.initData(key: array[indexPath.row - indexPath.row/3])
            }
        }
        if(indexPath.row == 20) {
            cell.setDelte()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 20 {
            delegate?.onDelete()
        } else {
            let emotionKey = data[indexPath.section][indexPath.row]
            delegate?.onSelect(emotionKey: emotionKey)
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translatedPoint = scrollView.panGestureRecognizer.translation(in: scrollView)
        scrollView.panGestureRecognizer.isEnabled = false
        DispatchQueue.main.async {[weak self] in
            if(translatedPoint.x < 0 && (self?.currentIndex)! < (self?.data.count ?? 0) - 1) {
                self?.currentIndex += 1
            }
            if(translatedPoint.x > 0 && (self?.currentIndex)! > 0) {
                self?.currentIndex -= 1
            }
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                self?.updatePoints()
                self?.collectionView?.scrollToItem(at: IndexPath.init(row: 0, section: self?.currentIndex ?? 0), at: .left, animated: false)
            }, completion: { finished in
                scrollView.panGestureRecognizer.isEnabled = true
            })
        }
    }

}

class EmotionCell:UICollectionViewCell {
    var emotion = UIImageView.init()

    var _isHighlighted:Bool = false
    override var isHighlighted: Bool {
        set {
            _isHighlighted = newValue
        }
        get {
            return false
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        emotion.frame = self.bounds
        emotion.contentMode = .center
        self.contentView.addSubview(emotion)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func setDelte() {
        emotion.image = UIImage.init(named: "iconLaststep")
    }

    func initData(key:String) {
        let emoticonsPath:String = Bundle.main.path(forResource: "Emoticons", ofType: "bundle") ?? ""
        let emotionPath = emoticonsPath + "/" + key
        emotion.image = UIImage.init(contentsOfFile: emotionPath)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

let PHOTO_SELECTOR_HEIGHT:CGFloat = 220 + safeAreaBottomHeight
let PHOTO_ITEM_HEIGHT:CGFloat = 170

protocol PhotoSelectorDelegate:NSObjectProtocol {
    func onSend(images:[UIImage])
}
class PhotoSelector:UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let ALBUM_TAG:Int = 1000
    let ORIGINAL_PHOTO_TAG:Int = 2000
    let SEND_TAG:Int = 3000


    var container = UIView.init()
    var collectionView:UICollectionView?
    var delegate:PhotoSelectorDelegate?
    var data = [PHAsset]()
    var selectedData = [PHAsset]()
    var bottomView = UIView.init()
    var album = UIButton.init()
    var originalPhoto = UIButton.init()
    var send = UIButton.init()

    init() {
        super.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: APPW, height: PHOTO_SELECTOR_HEIGHT)))
        initSubView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }

    func initSubView() {

        self.backgroundColor = .grayx;
        self.clipsToBounds = false;

        let options = PHFetchOptions.init()
        options.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]
        let result = PHAsset.fetchAssets(with: .image, options: options)
        result.enumerateObjects {[weak self] (asset, index, stop) in
            self?.data.append(asset)
            self?.collectionView?.reloadData()
        }

        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.init(top:0, left:0, bottom:0, right:0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 2.5
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 2.5, width: APPW, height: PHOTO_ITEM_HEIGHT), collectionViewLayout: layout)
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.alwaysBounceHorizontal = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(PhotoCell.classForCoder(), forCellWithReuseIdentifier: PhotoCell.identifier)
        self.addSubview(collectionView!)

        bottomView.frame = CGRect.init(x: 0, y: (collectionView?.frame.maxY)! + 2.5, width: APPW, height: 45 + safeAreaBottomHeight)
        bottomView.backgroundColor = UIColor.whitex
        self.addSubview(bottomView)

        album = UIButton.init(frame: CGRect.init(x: 15, y: 10, width: 40, height: 25))
        album.tag = ALBUM_TAG
        album.titleLabel?.font = .big
        album.setTitle("相册", for: .normal)
        album.setTitleColor(UIColor.redx, for: .normal)
        album.addTarget(self, action: #selector(onButtonClick(sender:)), for: .touchUpInside)
        bottomView.addSubview(album)

        originalPhoto = UIButton.init(frame: CGRect.init(x: album.frame.maxX + 10, y: 10, width: 60, height: 25))
        originalPhoto.tag = ORIGINAL_PHOTO_TAG;
        originalPhoto.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 2, bottom: 0, right: 0)
        originalPhoto.titleLabel?.font = .big;
        originalPhoto.setTitle("原图", for: .normal)
        originalPhoto.setTitleColor(UIColor.redx, for: .normal)
        originalPhoto.setImage(UIImage.init(named: "radio_button_unchecked_white"), for: .normal)
        originalPhoto.setImage(UIImage.init(named: "radio_button_checked_red"), for: .selected)
        originalPhoto.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -2, bottom: 0, right: 0)
        originalPhoto.addTarget(self, action: #selector(onButtonClick(sender:)), for: .touchUpInside)
        bottomView.addSubview(originalPhoto)

        send = UIButton.init(frame: CGRect.init(x: APPW - 60 - 15, y: 10, width: 60, height: 25))
        send.tag = SEND_TAG;
        send.isEnabled = false
        send.backgroundColor = .grayx
        send.layer.cornerRadius = 2
        send.titleLabel?.font = .middle
        send.setTitle("发送", for: .normal)
        send.setTitleColor(UIColor.whitex, for: .normal)
        send.addTarget(self, action: #selector(onButtonClick(sender:)), for: .touchUpInside)
        bottomView.addSubview(send)
    }

    @objc func onButtonClick(sender:UIButton) {
        switch (sender.tag) {
        case ALBUM_TAG:
            break
        case ORIGINAL_PHOTO_TAG:
            originalPhoto.isSelected = !originalPhoto.isSelected
            break
        case SEND_TAG:
            self.processAssets()
            break
        default:
            break
        }
    }

    func processAssets() {
        if selectedData.count > 9 {
            noticeInfo("最多选择9张图片")
            return
        }
        if delegate != nil {
            let manager = PHImageManager.default()
            let options = PHImageRequestOptions.init()
            options.isNetworkAccessAllowed = true
            options.isSynchronous = true
            var images = [UIImage]()
            for asset in selectedData {
                let imageHeight:CGFloat = originalPhoto.isSelected ? CGFloat(asset.pixelHeight) : CGFloat(asset.pixelHeight > 1000 ? 1000 : asset.pixelHeight)
                manager.requestImage(for: asset, targetSize: CGSize.init(width:imageHeight * (CGFloat(asset.pixelWidth)/CGFloat(asset.pixelHeight)), height:imageHeight), contentMode: PHImageContentMode.aspectFit, options: options, resultHandler: { (result, info) in
                    if let img = result {
                        images.append(img)
                    }
                    if images.count == self.selectedData.count {
                        self.delegate?.onSend(images: images)
                        self.selectedData.removeAll()
                        self.collectionView?.reloadData()
                    }
                })
            }
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count > 50 ? 50 : data.count;
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(PhotoCell.self, for: indexPath)
        let asset = data[indexPath.row];
        cell.initData(asset: asset, selected: selectedData.contains(asset))
        cell.onSelect = {[weak self] isSelected in
            if isSelected {
                self?.selectedData.append(asset)
            } else {
                if let index = self?.selectedData.index(of: asset) {
                    self?.selectedData.remove(at: index)
                }
            }
            if self?.selectedData.count ?? 0 > 0 {
                self?.send.isEnabled = true
                self?.send.backgroundColor = UIColor.redx
            } else {
                self?.send.isEnabled = false
                self?.send.backgroundColor = .grayx
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let asset = data[indexPath.row];
        return CGSize.init(width: PHOTO_ITEM_HEIGHT*(CGFloat(asset.pixelWidth)/CGFloat(asset.pixelHeight)), height: PHOTO_ITEM_HEIGHT)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

typealias OnSelect = (_ isSelected:Bool) -> Void
class PhotoCell:UICollectionViewCell {
    var photo = UIImageView.init()
    var checkbox = UIButton.init()
    var coverLayer = CALayer.init()
    var onSelect:OnSelect?

    var _isHighlighted:Bool = false
    override var isHighlighted: Bool {
        set {
            _isHighlighted = newValue
        }
        get {
            return false
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        photo.contentMode = .scaleAspectFill;
        self.contentView.addSubview(photo)

        coverLayer.backgroundColor = UIColor.blackAlpha(0.6).cgColor
        coverLayer.isHidden = true
        photo.layer.addSublayer(coverLayer)

        checkbox.setImage(UIImage.init(named: "radio_button_unchecked_white"), for: .normal)
        checkbox.setImage(UIImage.init(named: "check_circle_white"), for: .selected)
        checkbox.addTarget(self, action: #selector(selectCheckbox), for: .touchUpInside)
        self.contentView.addSubview(checkbox)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        photo.image = nil
        coverLayer.isHidden = true
        checkbox.isSelected = false
        photo.transform = CGAffineTransform.identity
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        photo.frame = self.bounds

        photo.transform = checkbox.isSelected ? CGAffineTransform.init(scaleX: 1.1, y: 1.1) : CGAffineTransform.identity
        checkbox.frame = CGRect.init(x:self.bounds.size.width - 30, y:0, width:30, height:30)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        coverLayer.frame = photo.bounds
        CATransaction.commit()
    }

    func initData(asset:PHAsset, selected:Bool) {
        let manager = PHImageManager.default()
        if (self.tag != 0) {
            manager.cancelImageRequest(PHImageRequestID(self.tag))
        }
        manager.requestImage(for: asset, targetSize: CGSize.init(width:PHOTO_ITEM_HEIGHT * (CGFloat(asset.pixelWidth)/CGFloat(asset.pixelHeight)), height:PHOTO_ITEM_HEIGHT), contentMode: PHImageContentMode.aspectFit, options: nil, resultHandler: { (result, info) in
            self.photo.image = result
        })
        checkbox.isSelected = selected
        coverLayer.isHidden = !checkbox.isSelected
    }

    @objc func selectCheckbox() {
        checkbox.isSelected = !checkbox.isSelected
        coverLayer.isHidden = !checkbox.isSelected;
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            self.photo.transform = self.checkbox.isSelected ? CGAffineTransform.init(scaleX: 1.1, y: 1.1) : CGAffineTransform.identity
        }) { finished in

        }
        onSelect?(checkbox.isSelected)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
