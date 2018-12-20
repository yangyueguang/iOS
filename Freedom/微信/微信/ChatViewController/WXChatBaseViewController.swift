//
//  WXChatBaseViewController.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/20.
//  Copyright © 2018 薛超. All rights reserved.
//

import Foundation
//  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
class WXTextDisplayView: UIView {
    var attrString: NSAttributedString?

    func show(in view: UIView?, withAttrText attrText: NSAttributedString?, animation: Bool) {
    }

    var textView: UITextView?

    override init(frame: CGRect) {
        //if super.init(frame: frame)

        backgroundColor = UIColor.white
        if let aView = textView {
            addSubview(aView)
        }
        textView?.mas_makeConstraints({ make in
            make?.center.mas_equalTo(self)
        })

        let tapGR = UITapGestureRecognizer(target: self, action: #selector(WXTextDisplayView.dismiss))
        addGestureRecognizer(tapGR)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func show(in view: UIView?, withAttrText attrText: NSAttributedString?, animation: Bool) {
        view?.addSubview(self)
        self.frame = view?.bounds
        self.attrString = attrText
        self.alpha = 0
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 1.0
        }) { finished in
            //        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        }
    }
    func setAttrString(_ attrString: NSAttributedString?) {
        self.attrString = attrString
        var mutableAttrString: NSMutableAttributedString? = nil
        if let aString = attrString {
            mutableAttrString = NSMutableAttributedString(attributedString: aString)
        }
        mutableAttrString?.addAttribute(.font, value: UIFont.systemFont(ofSize: 25.0), range: NSRange(location: 0, length: attrString?.length ?? 0))
        if let aString = mutableAttrString {
            textView.attributedText = aString
        }
        var size = textView.sizeThatFits(CGSize(width: frame.size.width * 0.94, height: MAXFLOAT))
        size.height = size.height > APPH ? APPH : size.height
        textView.mas_updateConstraints({ make in
            make?.size.mas_equalTo(size)
        })
    }
    func dismiss() {
        //    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { finished in
            self.removeFromSuperview()
        }
    }

    // MARK: - Getter -
    var textView: UITextView! {
        if textView == nil {
            textView = UITextView()
            textView.backgroundColor = UIColor.clear
            textView.textAlignment = .center
            textView.editable = false
        }
        return textView
    }





    
}

class WXEmojiDisplayView: UIImageView {
    var emoji: TLEmoji?
    var rect = CGRect.zero
    private var imageView: UIImageView?
    private var imageLabel: UILabel?
    private var titleLabel: UILabel?

    init(frame: CGRect) {
        //if super.init(frame: CGRect(x: 0, y: 0, width: CGSize(width: 55, height: 100).width, height: CGSize(width: 55, height: 100).height))

        setImage(UIImage(named: "emojiKB_tips"))
        if let aLabel = imageLabel {
            addSubview(aLabel)
        }
        if let aView = imageView {
            addSubview(aView)
        }
        if let aLabel = titleLabel {
            addSubview(aLabel)
        }
        p_addMasonry()

    }
    func display(_ emoji: TLEmoji?, at rect: CGRect) {
        self.rect = rect
        setEmoji(emoji)
    }

    func setEmoji(_ emoji: TLEmoji?) {
        self.emoji = emoji
        if emoji?.type == TLEmojiTypeEmoji {
            imageLabel.hidden = false
            imageView?.isHidden = true
            titleLabel?.isHidden = true
            imageLabel.text = emoji?.emojiName
        } else if emoji?.type == TLEmojiTypeFace {
            imageLabel.hidden = true
            imageView?.isHidden = false
            titleLabel?.isHidden = false
            imageView?.image = UIImage(named: emoji?.emojiName ?? "")
            titleLabel?.text = emoji?.emojiName.substring(with: NSRange(location: 1, length: emoji?.emojiName.length ?? 0 - 2))
        }
    }
    func p_addMasonry() {
        imageView?.mas_makeConstraints({ make in
            make?.top.mas_equalTo(self).mas_offset(10)
            make?.left.mas_equalTo(self).mas_offset(12)
            make?.right.mas_equalTo(self).mas_equalTo(-12)
            make?.height.mas_equalTo(self.imageView?.mas_width)
        })
        titleLabel?.mas_makeConstraints({ make in
            make?.top.mas_equalTo(self.imageView?.mas_bottom).mas_offset(5)
            make?.centerX.mas_equalTo(self)
            make?.width.mas_lessThanOrEqualTo(self)
        })
        imageLabel.mas_makeConstraints({ make in
            make?.width.and().height().and().centerX.mas_equalTo(self.imageView)
            make?.top.mas_equalTo(self).mas_offset(12)
        })
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func setRect(_ rect: CGRect) {
        center = CGPoint(x: rect.origin.x + rect.size.width / 2, y: rect.origin.y + rect.size.height - frame.size.height + 15.0 + frame.size.height / 2)
    }

    // MARK: - Private Methods -

    // MARK: - Getter -
    var imageView: UIImageView? {
        if imageView == nil {
            imageView = UIImageView()
        }
        return imageView
    }

    var titleLabel: UILabel? {
        if titleLabel == nil {
            titleLabel = UILabel()
            titleLabel.font = UIFont.systemFont(ofSize: 12.0)
            titleLabel.textColor = UIColor.gray
        }
        return titleLabel
    }

    func imageLabel() -> UILabel? {
        if imageLabel == nil {
            imageLabel = UILabel()
            imageLabel.textAlignment = .center
            imageLabel.hidden = true
            imageLabel.font = UIFont.systemFont(ofSize: 30.0)
        }
        return imageLabel
    }


    
}
extension UIButton {
    func setImage(_ image: UIImage?, imageHL: UIImage?) {
        setImage(image, for: .normal)
        setImage(imageHL, for: .highlighted)
    }

    class func initBtn(withFrame frame: CGRect, target: Any?, method: Selector, title: String?, setimageName: String?, backImageName: String?) -> UIButton? {
        let btn = UIButton(type: .custom)
        btn.frame = frame
        btn.addTarget(target, action: method, for: .touchUpInside)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        btn.setImage(UIImage(named: setimageName ?? ""), for: .normal)
        btn.setBackgroundImage(UIImage(named: backImageName ?? ""), for: .normal)
        return btn
    }
}
protocol WXChatBarDelegate: NSObjectProtocol {
    //chatBar状态改变
    func chatBar(_ chatBar: WXChatBar?, changeStatusFrom fromStatus: TLChatBarStatus, to toStatus: TLChatBarStatus)
    //输入框高度改变
    func chatBar(_ chatBar: WXChatBar?, didChangeTextViewHeight height: CGFloat)
}

protocol WXChatBarDataDelegate: NSObjectProtocol {
    //发送文字
    func chatBar(_ chatBar: WXChatBar?, sendText text: String?)
    // 录音控制
    func chatBarRecording(_ chatBar: WXChatBar?)
    func chatBarWillCancelRecording(_ chatBar: WXChatBar?)
    func chatBarDidCancelRecording(_ chatBar: WXChatBar?)
    func chatBarFinishedRecoding(_ chatBar: WXChatBar?)
}
class WXChatBar: UIView ,UITextViewDelegate {
    private var kVoiceImage: UIImage?
    private var kVoiceImageHL: UIImage?
    private var kEmojiImage: UIImage?
    private var kEmojiImageHL: UIImage?
    private var kMoreImage: UIImage?
    private var kMoreImageHL: UIImage?
    private var kKeyboardImage: UIImage?
    private var kKeyboardImageHL: UIImage?

    private var modeButton: UIButton?
    private var voiceButton: UIButton?
    private var textView: UITextView?
    private var talkButton: UIButton?
    private var emojiButton: UIButton?
    private var moreButton: UIButton?

    weak var delegate: WXChatBarDelegate?
    weak var dataDelegate: WXChatBarDataDelegate?
    var status: TLChatBarStatus?
    private(set) var curText = ""
    var activity = false
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    init() {
        super.init()

        backgroundColor = UIColor(245.0, 245.0, 247.0, 1.0)
        p_initImage()

        addSubview(modeButton)
        addSubview(voiceButton)
        addSubview(textView)
        addSubview(talkButton)
        addSubview(emojiButton)
        addSubview(moreButton)

        p_addMasonry()

        status = TLChatBarStatusInit

    }

    func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }

    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func sendCurrentText() {
        if textView.text.count > 0 {
            // send Text
            if dataDelegate && dataDelegate.responds(to: #selector(self.chatBar(_:sendText:))) {
                dataDelegate.chatBar(self, sendText: textView.text)
            }
        }
        textView.text = ""
        textViewDidChange(textView)
    }

    func addEmojiString(_ emojiString: String?) {
        let str = "\(textView.text)\(emojiString ?? "")"
        textView.text = str
        textViewDidChange(textView)
    }

    func setActivity(_ activity: Bool) {
        self.activity = activity
        if activity {
            textView.textColor = UIColor.black
        } else {
            textView.textColor = UIColor.gray
        }
    }
    var isFirstResponder: Bool {
        if status == TLChatBarStatusEmoji || status == TLChatBarStatusKeyboard || status == TLChatBarStatusMore {
            return true
        }
        return false
    }

    func resignFirstResponder() -> Bool {
        if status == TLChatBarStatusEmoji || status == TLChatBarStatusKeyboard || status == TLChatBarStatusMore {
            if delegate && delegate.responds(to: #selector(self.chatBar(_:changeStatusFrom:to:))) {
                delegate.chatBar(self, changeStatusFrom: status, to: TLChatBarStatusInit)
            }
            textView.resignFirstResponder()
            status = TLChatBarStatusInit
            moreButton.setImage(kMoreImage, imageHL: kMoreImageHL)
            emojiButton.setImage(kEmojiImage, imageHL: kEmojiImageHL)
        }
        return super.resignFirstResponder()
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.activity = true
        if status != TLChatBarStatusKeyboard {
            if delegate && delegate.responds(to: #selector(self.chatBar(_:changeStatusFrom:to:))) {
                delegate.chatBar(self, changeStatusFrom: status, to: TLChatBarStatusKeyboard)
            }
            if status == TLChatBarStatusEmoji {
                emojiButton.setImage(kEmojiImage, imageHL: kEmojiImageHL)
            } else if status == TLChatBarStatusMore {
                moreButton.setImage(kMoreImage, imageHL: kMoreImageHL)
            }
            status = TLChatBarStatusKeyboard
        }
        return true
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            sendCurrentText()
            return false
        } else if textView.text.count > 0 && (text == "") {
            // delete
            if textView.text[textView.text.index(textView.text.startIndex, offsetBy: range.location)] == "]" {
                let location = Int(range.location)
                let length = Int(range.length)
                while location != 0 {
                    location -= 1
                    length += 1
                    let c = textView.text[textView.text.index(textView.text.startIndex, offsetBy: UInt(location))]
                    if c == "[" {
                        textView.text = (textView.text as NSString).replacingCharacters(in: NSRange(location: location, length: length), with: "")
                        return false
                    } else if c == "]" {
                        return true
                    }
                }
            }
        }

        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        var height: CGFloat = textView.sizeThatFits(CGSize(width: self.textView.frame.size.width, height: MAXFLOAT)).height
        height = height > 36 ? height : 36
        height = height <= 115 ? height : textView.frame.size.height
        if height != textView.frame.size.height {
            UIView.animate(withDuration: 0.2, animations: {
                textView.mas_updateConstraints({ make in
                    make?.height.mas_equalTo(height)
                })
                self.superview.layoutIfNeeded()
                if delegate && delegate.responds(to: #selector(self.chatBar(_:didChangeTextViewHeight:))) {
                    delegate.chatBar(self, didChangeTextViewHeight: textView.frame.size.height)
                }
            }) { finished in
                if delegate && delegate.responds(to: #selector(self.chatBar(_:didChangeTextViewHeight:))) {
                    delegate.chatBar(self, didChangeTextViewHeight: textView.frame.size.height)
                }
            }
        }
    }
    func modeButtonDown() {
        if status == TLChatBarStatusEmoji {
            if delegate && delegate.responds(to: #selector(self.chatBar(_:changeStatusFrom:to:))) {
                delegate.chatBar(self, changeStatusFrom: status, to: TLChatBarStatusInit)
            }
            emojiButton.setImage(kEmojiImage, imageHL: kEmojiImageHL)
            status = TLChatBarStatusInit
        } else if status == TLChatBarStatusMore {
            if delegate && delegate.responds(to: #selector(self.chatBar(_:changeStatusFrom:to:))) {
                delegate.chatBar(self, changeStatusFrom: status, to: TLChatBarStatusInit)
            }
            moreButton.setImage(kMoreImage, imageHL: kMoreImageHL)
            status = TLChatBarStatusInit
        }
    }
    func voiceButtonDown() {
        textView.resignFirstResponder()

        // 开始文字输入
        if status == TLChatBarStatusVoice {
            if delegate && delegate.responds(to: #selector(self.chatBar(_:changeStatusFrom:to:))) {
                delegate.chatBar(self, changeStatusFrom: status, to: TLChatBarStatusKeyboard)
            }
            voiceButton.setImage(kVoiceImage, imageHL: kVoiceImageHL)
            textView.becomeFirstResponder()
            textView.isHidden = false
            talkButton.hidden = true
            status = TLChatBarStatusKeyboard
        } else {
            // 开始语音
            if delegate && delegate.responds(to: #selector(self.chatBar(_:changeStatusFrom:to:))) {
                delegate.chatBar(self, changeStatusFrom: status, to: TLChatBarStatusVoice)
            }
            if status == TLChatBarStatusKeyboard {
                textView.resignFirstResponder()
            } else if status == TLChatBarStatusEmoji {
                emojiButton.setImage(kEmojiImage, imageHL: kEmojiImageHL)
            } else if status == TLChatBarStatusMore {
                moreButton.setImage(kMoreImage, imageHL: kMoreImageHL)
            }
            talkButton.hidden = false
            textView.isHidden = true
            voiceButton.setImage(kKeyboardImage, imageHL: kKeyboardImageHL)
            status = TLChatBarStatusVoice
        }
    }
    func emojiButtonDown() {
        // 开始文字输入
        if status == TLChatBarStatusEmoji {
            if delegate && delegate.responds(to: #selector(self.chatBar(_:changeStatusFrom:to:))) {
                delegate.chatBar(self, changeStatusFrom: status, to: TLChatBarStatusKeyboard)
            }
            emojiButton.setImage(kEmojiImage, imageHL: kEmojiImageHL)
            textView.becomeFirstResponder()
            status = TLChatBarStatusKeyboard
        } else {
            // 打开表情键盘
            if delegate && delegate.responds(to: #selector(self.chatBar(_:changeStatusFrom:to:))) {
                delegate.chatBar(self, changeStatusFrom: status, to: TLChatBarStatusEmoji)
            }
            if status == TLChatBarStatusVoice {
                voiceButton.setImage(kVoiceImage, imageHL: kVoiceImageHL)
                talkButton.hidden = true
                textView.isHidden = false
            } else if status == TLChatBarStatusMore {
                moreButton.setImage(kMoreImage, imageHL: kMoreImageHL)
            }
            emojiButton.setImage(kKeyboardImage, imageHL: kKeyboardImageHL)
            textView.resignFirstResponder()
            status = TLChatBarStatusEmoji
        }
    }
    func moreButtonDown() {
        // 开始文字输入
        if status == TLChatBarStatusMore {
            if delegate && delegate.responds(to: #selector(self.chatBar(_:changeStatusFrom:to:))) {
                delegate.chatBar(self, changeStatusFrom: status, to: TLChatBarStatusKeyboard)
            }
            moreButton.setImage(kMoreImage, imageHL: kMoreImageHL)
            textView.becomeFirstResponder()
            status = TLChatBarStatusKeyboard
        } else {
            // 打开更多键盘
            if delegate && delegate.responds(to: #selector(self.chatBar(_:changeStatusFrom:to:))) {
                delegate.chatBar(self, changeStatusFrom: status, to: TLChatBarStatusMore)
            }
            if status == TLChatBarStatusVoice {
                voiceButton.setImage(kVoiceImage, imageHL: kVoiceImageHL)
                talkButton.hidden = true
                textView.isHidden = false
            } else if status == TLChatBarStatusEmoji {
                emojiButton.setImage(kEmojiImage, imageHL: kEmojiImageHL)
            }
            moreButton.setImage(kKeyboardImage, imageHL: kKeyboardImageHL)
            textView.resignFirstResponder()
            status = TLChatBarStatusMore
        }
    }
    func talkButtonTouchDown(_ sender: UIButton?) {
        if dataDelegate && dataDelegate.responds(to: #selector(self.chatBarRecording(_:))) {
            dataDelegate.chatBarRecording(self)
        }
    }

    func talkButtonTouchUp(inside sender: UIButton?) {
        if dataDelegate && dataDelegate.responds(to: #selector(self.chatBarFinishedRecoding(_:))) {
            dataDelegate.chatBarFinishedRecoding(self)
        }
    }

    func talkButtonTouchCancel(_ sender: UIButton?) {
        if dataDelegate && dataDelegate.responds(to: #selector(self.chatBarDidCancelRecording(_:))) {
            dataDelegate.chatBarDidCancelRecording(self)
        }
    }
    func p_addMasonry() {
        modeButton.mas_makeConstraints({ make in
            make?.left.mas_equalTo(self)
            make?.bottom.mas_equalTo(self).mas_offset(-4)
            make?.width.mas_equalTo(0)
        })

        voiceButton.mas_makeConstraints({ make in
            make?.bottom.mas_equalTo(self).mas_offset(-7)
            make?.left.mas_equalTo(self.modeButton.mas_right).mas_offset(1)
            make?.width.mas_equalTo(38)
        })

        textView.mas_makeConstraints({ make in
            make?.top.mas_equalTo(self).mas_offset(7)
            make?.bottom.mas_equalTo(self).mas_offset(-7)
            make?.left.mas_equalTo(self.voiceButton.mas_right).mas_offset(4)
            make?.right.mas_equalTo(self.emojiButton.mas_left).mas_offset(-4)
            make?.height.mas_equalTo(36)
        })

        talkButton.mas_makeConstraints({ make in
            make?.center.mas_equalTo(self.textView)
            make?.size.mas_equalTo(self.textView)
        })

        moreButton.mas_makeConstraints({ make in
            make?.top.and().width().mas_equalTo(self.voiceButton)
            make?.right.mas_equalTo(self).mas_offset(-1)
        })

        emojiButton.mas_makeConstraints({ make in
            make?.top.and().width().mas_equalTo(self.voiceButton)
            make?.right.mas_equalTo(self.moreButton.mas_left)
        })
    }
    func p_initImage() {
        kVoiceImage = UIImage(named: "chat_toolbar_voice")
        kVoiceImageHL = UIImage(named: "chat_toolbar_voice_HL")
        kEmojiImage = UIImage(named: "chat_toolbar_emotion")
        kEmojiImageHL = UIImage(named: "chat_toolbar_emotion_HL")
        kMoreImage = UIImage(named: "chat_toolbar_more")
        kMoreImageHL = UIImage(named: "chat_toolbar_more_HL")
        kKeyboardImage = UIImage(named: "chat_toolbar_keyboard")
        kKeyboardImageHL = UIImage(named: "chat_toolbar_keyboard_HL")
    }

    func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(0.5)
        context?.setStrokeColor(UIColor.gray.cgColor)
        context?.beginPath()
        context?.move(to: CGPoint(x: 0, y: 0))
        context?.addLine(to: CGPoint(x: APPW, y: 0))
        context?.strokePath()
    }
    func modeButton() -> UIButton? {
        if modeButton == nil {
            modeButton = UIButton()
            modeButton.setImage(UIImage(named: "chat_toolbar_texttolist"), imageHL: UIImage(named: "chat_toolbar_texttolist_HL"))
            modeButton.addTarget(self, action: #selector(self.modeButtonDown), for: .touchUpInside)
        }
        return modeButton
    }

    func voiceButton() -> UIButton? {
        if voiceButton == nil {
            voiceButton = UIButton()
            voiceButton.setImage(kVoiceImage, imageHL: kVoiceImageHL)
            voiceButton.addTarget(self, action: #selector(self.voiceButtonDown), for: .touchUpInside)
        }
        return voiceButton
    }

    var textView: UITextView! {
        if textView == nil {
            textView = UITextView()
            textView.font = UIFont.systemFont(ofSize: 16.0)
            textView.returnKeyType = .send
            textView.layer.masksToBounds = true
            textView.layer.borderWidth = 1
            textView.layer.borderColor = UIColor(white: 0.0, alpha: 0.3).cgColor
            textView.layer.cornerRadius = 4.0
            textView.delegate = self
            textView.scrollsToTop = false
        }
        return textView
    }
    func talkButton() -> UIButton? {
        if talkButton == nil {
            talkButton = UIButton()
            talkButton.setTitle("按住 说话", for: .normal)
            talkButton.setTitle("松开 结束", for: .highlighted)
            talkButton.setTitleColor(UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0), for: .normal)
            talkButton.setBackgroundImage(FreedomTools(color: UIColor(white: 0.0, alpha: 0.1)), for: .highlighted)
            talkButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            talkButton.layer.masksToBounds = true
            talkButton.layer.cornerRadius = 4.0
            talkButton.layer.borderWidth = 1
            talkButton.layer.borderColor = UIColor(white: 0.0, alpha: 0.3).cgColor
            talkButton.hidden = true
            talkButton.addTarget(self, action: #selector(self.talkButtonTouchDown(_:)), for: .touchDown)
            talkButton.addTarget(self, action: #selector(self.talkButtonTouchUp(inside:)), for: .touchUpInside)
            talkButton.addTarget(self, action: #selector(self.talkButtonTouchCancel(_:)), for: .touchUpOutside)
            talkButton.addTarget(self, action: #selector(self.talkButtonTouchCancel(_:)), for: .touchCancel)
        }
        return talkButton
    }
    func emojiButton() -> UIButton? {
        if emojiButton == nil {
            emojiButton = UIButton()
            emojiButton.setImage(kEmojiImage, imageHL: kEmojiImageHL)
            emojiButton.addTarget(self, action: #selector(self.emojiButtonDown), for: .touchUpInside)
        }
        return emojiButton
    }

    func moreButton() -> UIButton? {
        if moreButton == nil {
            moreButton = UIButton()
            moreButton.setImage(kMoreImage, imageHL: kMoreImageHL)
            moreButton.addTarget(self, action: #selector(self.moreButtonDown), for: .touchUpInside)
        }
        return moreButton
    }

    func curText() -> String? {
        return textView.text
    }





}

protocol WXChatViewControllerProxy: NSObjectProtocol {
    func didClickedUserAvatar(_ user: WXUser?)
    func didClickedImageMessages(_ imageMessages: [Any]?, at index: Int)
}
//  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
//  FreedomBaseViewController.h

class WXChatBaseViewController: WXBaseViewController, WXChatViewControllerProxy, WXMoreKeyboardDelegate, WXChatBarDelegate, TLKeyboardDelegate, TLEmojiKeyboardDelegate, WXChatBarDataDelegate, WXChatTableViewControllerDelegate {
    var lastStatus: TLChatBarStatus?
    var curStatus: TLChatBarStatus?

    /// 用户信息
    var user: WXChatUserProtocol?
    /// 聊天对象
    var partner: WXChatUserProtocol?
    /// 消息展示页面
    var chatTableVC: WXChatTableViewController?
    /// 聊天输入栏
    var chatBar: WXChatBar?
    /// 更多键盘
    var moreKeyboard: TLMoreKeyboard?
    /// 表情键盘
    var emojiKeyboard: TLEmojiKeyboard?
    /// emoji展示view
    var emojiDisplayView: WXEmojiDisplayView?
    /// 图片表情展示view
    var imageExpressionDisplayView: WXImageExpressionDisplayView?
    private var lastDateInterval: TimeInterval = 0
    private var msgAccumulate: Int = 0
    func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(chatTableVC.tableView)
        addChild(chatTableVC)
        view.addSubview(chatBar)

        p_addMasonry()
    }

    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardFrameWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Public Methods -
    func setPartner(_ partner: WXChatUserProtocol?) {
        if self.partner && (self.partner.chat_userID() == partner?.chat_userID()) {
            return
        }
        self.partner = partner
        navigationItem?.title = self.partner.chat_username()
        resetChatVC()
    }

    func setChatMoreKeyboardData(_ moreKeyboardData: [AnyHashable]?) {
        var moreKeyboardData = moreKeyboardData
        moreKeyboard.setChatMoreKeyboardData(moreKeyboardData)
    }
    func setChatEmojiKeyboardData(_ emojiKeyboardData: [AnyHashable]?) {
        var emojiKeyboardData = emojiKeyboardData
        emojiKeyboard.emojiGroupData = emojiKeyboardData
    }

    func resetChatVC() {
        var chatViewBGImage = UserDefaults.standard.object(forKey: "CHAT_BG_" + (partner.chat_userID())) as? String
        if chatViewBGImage == nil {
            chatViewBGImage = UserDefaults.standard.object(forKey: "CHAT_BG_ALL") as? String
            if chatViewBGImage == nil {
                view.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
            } else {
                let imagePath = FileManager.pathUserChatBackgroundImage(chatViewBGImage)
                let image = UIImage(named: imagePath)
                if let anImage = image {
                    view.backgroundColor = UIColor(patternImage: anImage)
                }
            }
        } else {
            let imagePath = FileManager.pathUserChatBackgroundImage(chatViewBGImage)
            let image = UIImage(named: imagePath)
            if let anImage = image {
                view.backgroundColor = UIColor(patternImage: anImage)
            }
        }

        resetChatTVC()
    }
    //发送图片消息

    func sendImageMessage(_ image: UIImage?) {
        var imageData: Data? = nil
        if let anImage = image {
            imageData = UIImagePNGRepresentation(image) ? UIImagePNGRepresentation(image) : anImage.jpegData(compressionQuality: 0.5)
        }
        let imageName = String(format: "%lf.jpg", Date().timeIntervalSince1970)
        let imagePath = FileManager.pathUserChatImage(imageName)
        FileManager.default.createFile(atPath: imagePath, contents: imageData, attributes: nil)

        let message = WXImageMessage()
        message.fromUser = user
        message.messageType = TLMessageTypeImage
        message.ownerTyper = TLMessageOwnerTypeSelf
        message.content["path"] = imageName
        message.imageSize = image?.size
        send(message)
        if partner.chat_user() == TLChatUserTypeUser {
            let message1 = WXImageMessage()
            message1.fromUser = partner
            message1.messageType = TLMessageTypeImage
            message1.ownerTyper = TLMessageOwnerTypeFriend
            message1.content["path"] = imageName
            message1.imageSize = image?.size
            send(message1)
        } else {
            for user: WXChatUserProtocol? in partner.groupMembers() {
                let message1 = WXImageMessage()
                message1.friendID = user?.chat_userID()
                message1.fromUser = user
                message1.messageType = TLMessageTypeImage
                message1.ownerTyper = TLMessageOwnerTypeFriend
                message1.content["path"] = imageName
                message1.imageSize = image?.size
                send(message1)
            }
        }
    }
    func p_addMasonry() {
        chatTableVC()?.tableView.mas_makeConstraints({ make in
            make?.top.and().left().and().right().mas_equalTo(self.view)
            make?.bottom.mas_equalTo(self.chatBar.mas_top)
        })
        chatBar.mas_makeConstraints({ make in
            make?.left.and().right().and().bottom().mas_equalTo(self.view)
        })
    }

    // MARK: - Getter -
    func chatTableVC() -> WXChatTableViewController? {
        if chatTableVC == nil {
            chatTableVC = WXChatTableViewController()
            chatTableVC.delegate = self
        }
        return chatTableVC
    }
    func chatBar() -> WXChatBar? {
        if chatBar == nil {
            chatBar = WXChatBar()
            chatBar.delegate = self
            chatBar.dataDelegate = self
        }
        return chatBar
    }

    func emojiKeyboard() -> TLEmojiKeyboard? {
        if emojiKeyboard == nil {
            emojiKeyboard = TLEmojiKeyboard()
            emojiKeyboard.keyboardDelegate = self
            emojiKeyboard.delegate = self
        }
        return emojiKeyboard
    }

    func moreKeyboard() -> TLMoreKeyboard? {
        if moreKeyboard == nil {
            moreKeyboard = TLMoreKeyboard()
            moreKeyboard.keyboardDelegate = self
            moreKeyboard.delegate = self
        }
        return moreKeyboard
    }
    func emojiDisplayView() -> WXEmojiDisplayView? {
        if emojiDisplayView == nil {
            emojiDisplayView = WXEmojiDisplayView()
        }
        return emojiDisplayView
    }

    func imageExpressionDisplayView() -> WXImageExpressionDisplayView? {
        if imageExpressionDisplayView == nil {
            imageExpressionDisplayView = WXImageExpressionDisplayView()
        }
        return imageExpressionDisplayView
    }
    func chatBar(_ chatBar: WXChatBar?, sendText text: String?) {
        let message = WXTextMessage()
        message.fromUser = user
        message.messageType = TLMessageTypeText
        message.ownerTyper = TLMessageOwnerTypeSelf
        message.content["text"] = text
        send(message)
        if partner.chat_user() == TLChatUserTypeUser {
            let message1 = WXTextMessage()
            message1.fromUser = partner
            message1.messageType = TLMessageTypeText
            message1.ownerTyper = TLMessageOwnerTypeFriend
            message1.content["text"] = text
            send(message1)
        } else {
            for user: WXChatUserProtocol? in partner.groupMembers() {
                let message1 = WXTextMessage()
                message1.friendID = user?.chat_userID()
                message1.fromUser = user
                message1.messageType = TLMessageTypeText
                message1.ownerTyper = TLMessageOwnerTypeFriend
                message1.content["text"] = text
                send(message1)
            }
        }
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func chatBarRecording(_ chatBar: WXChatBar?) {
        DLog("rec...")
    }

    func chatBarWillCancelRecording(_ chatBar: WXChatBar?) {
        DLog("will cancel")
    }

    func chatBarDidCancelRecording(_ chatBar: WXChatBar?) {
        DLog("cancel")
    }

    func chatBarFinishedRecoding(_ chatBar: WXChatBar?) {
        DLog("finished")
    }

    // MARK: - Public Methods -
    func add(toShow message: WXMessage?) {
        message?.showTime = p_needShowTime(message?.date)
        chatTableVC.add(message)
        chatTableVC.scrollToBottom(withAnimation: true)
    }

    func resetChatTVC() {
        chatTableVC.reloadData()
        lastDateInterval = 0
        msgAccumulate = 0
    }
    // chatView 获取历史记录

    func chatTableViewController(_ chatTVC: WXChatTableViewController?, getRecordsFrom date: Date?, count: Int, completed: @escaping (Date?, [Any]?, Bool) -> Void) {
        var count = count
        WXMessageManager.sharedInstance().messageRecord(forPartner: partner.chat_userID(), from: date, count: count, complete: { array, hasMore in
            if (array?.count ?? 0) > 0 {
                var count: Int = 0
                var tm: TimeInterval = 0
                for message: WXMessage? in array as? [WXMessage?] ?? [] {
                    count += 1
                    if count > 10 || tm == 0 || (message?.date.timeIntervalSince1970 ?? 0.0) - tm > 30 {
                        tm = message?.date.timeIntervalSince1970 ?? 0.0
                        count = 0
                        message?.showTime = true
                    }
                    if message?.ownerTyper == TLMessageOwnerTypeSelf {
                        message?.fromUser = self.user
                    } else {
                        if self.partner.chat_user() == TLChatUserTypeUser {
                            message?.fromUser = self.partner
                        } else if self.partner.chat_user() == TLChatUserTypeGroup {
                            if self.partner.responds(to: #selector(self.groupMember(byID:))) {
                                message?.fromUser = self.partner.groupMember(byID: message?.friendID)
                            }
                        }
                    }
                }
            }
            completed(date, array, hasMore)
        })
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    // chatView 点击事件

    func chatTableViewControllerDidTouched(_ chatTVC: WXChatTableViewController?) {
        if chatBar.isFirstResponder {
            chatBar.resignFirstResponder()
        }
    }

    func chatTableViewController(_ chatTVC: WXChatTableViewController?, delete message: WXMessage?) -> Bool {
        return WXMessageManager.sharedInstance().deleteMessage(byMsgID: message?.messageID)
    }

    func chatTableViewController(_ chatTVC: WXChatTableViewController?, didClickUserAvatar user: WXUser?) {
        if responds(to: #selector(self.didClickedUserAvatar(_:))) {
            didClickedUserAvatar(user)
        }
    }

    func chatTableViewController(_ chatTVC: WXChatTableViewController?, didDoubleClick message: WXMessage?) {
        if message?.messageType == TLMessageTypeText {
            let displayView = WXTextDisplayView()
            displayView.show(in: navigationController?.view, withAttrText: (message as? WXTextMessage)?.attrText(), animation: true)
        }
    }
    func chatTableViewController(_ chatTVC: WXChatTableViewController?, didClick message: WXMessage?) {
        if message?.messageType == TLMessageTypeImage && responds(to: #selector(self.didClickedImageMessages(_:atIndex:))) {
            WXMessageManager.sharedInstance().chatImagesAndVideos(forPartnerID: partner.chat_userID(), completed: { imagesData in
                var index: Int = -1
                for i in 0..<(imagesData?.count ?? 0) {
                    if (message?.messageID == imagesData?[i].messageID) {
                        index = i
                        break
                    }
                }
                if index >= 0 {
                    self.didClickedImageMessages(imagesData, at: index)
                }
            })
        }
    }
    func p_needShowTime(_ date: Date?) -> Bool {
        msgAccumulate += 1
        if msgAccumulate > 10 || lastDateInterval == 0 || (date?.timeIntervalSince1970 ?? 0.0) - lastDateInterval > 30 {
            lastDateInterval = date?.timeIntervalSince1970
            msgAccumulate = 0
            return true
        }
        return false
    }
    func send(_ message: WXMessage?) {
        message?.userID = WXUserHelper.shared().user.userID
        if partner.chat_user() == TLChatUserTypeUser {
            message?.partnerType = TLPartnerTypeUser
            message?.friendID = partner.chat_userID()
        } else if partner.chat_user() == TLChatUserTypeGroup {
            message?.partnerType = TLPartnerTypeGroup
            message?.groupID = partner.chat_userID()
        }
        //    message.ownerTyper = TLMessageOwnerTypeSelf;
        //    message.fromUser = [WXUserHelper sharedHelper].user;
        message?.date = Date()

        add(toShow: message) // 添加到列表
        WXMessageManager.sharedInstance().send(message, progress: { message, pregress in

        }, success: { message in
            DLog("send success")
        }, failure: { message in
            DLog("send failure")
        })
    }
    func emojiKeyboard(_ emojiKB: TLEmojiKeyboard?, didSelectedEmojiItem emoji: TLEmoji?) {
        if emoji?.type == TLEmojiTypeEmoji || emoji?.type == TLEmojiTypeFace {
            chatBar.addEmojiString(emoji?.emojiName)
        } else {
            let message = WXExpressionMessage()
            message.fromUser = user
            message.messageType = TLMessageTypeExpression
            message.ownerTyper = TLMessageOwnerTypeSelf
            message.emoji = emoji
            send(message)
            if partner.chat_user() == TLChatUserTypeUser {
                let message1 = WXExpressionMessage()
                message1.fromUser = partner
                message1.messageType = TLMessageTypeExpression
                message1.ownerTyper = TLMessageOwnerTypeFriend
                message1.emoji = emoji
                send(message1)
            } else {
                for user: WXChatUserProtocol? in partner.groupMembers() {
                    let message1 = WXExpressionMessage()
                    message1.friendID = user?.chat_userID()
                    message1.fromUser = user
                    message1.messageType = TLMessageTypeExpression
                    message1.ownerTyper = TLMessageOwnerTypeFriend
                    message1.emoji = emoji
                    send(message1)
                }
            }
        }
    }
    func emojiKeyboardSendButtonDown() {
        chatBar.sendCurrentText()
    }

    func emojiKeyboard(_ emojiKB: TLEmojiKeyboard?, didTouchEmojiItem emoji: TLEmoji?, at rect: CGRect) {
        if emoji?.type == TLEmojiTypeEmoji || emoji?.type == TLEmojiTypeFace {
            if emojiDisplayView.superview == nil {
                emojiKeyboard.addSubview(emojiDisplayView)
            }
            emojiDisplayView.display(emoji, at: rect)
        } else {
            if imageExpressionDisplayView.superview == nil {
                emojiKeyboard.addSubview(imageExpressionDisplayView)
            }
            imageExpressionDisplayView.display(emoji, at: rect)
        }
    }
    func emojiKeyboardCancelTouchEmojiItem(_ emojiKB: TLEmojiKeyboard?) {
        if emojiDisplayView.superview != nil {
            emojiDisplayView.removeFromSuperview()
        } else if imageExpressionDisplayView.superview != nil {
            imageExpressionDisplayView.removeFromSuperview()
        }
    }

    func emojiKeyboard(_ emojiKB: TLEmojiKeyboard?, selectedEmojiGroupType type: TLEmojiType) {
        if type == TLEmojiTypeEmoji || type == TLEmojiTypeFace {
            chatBar.activity = true
        } else {
            chatBar.activity = false
        }
    }

    func chatInputViewHasText() -> Bool {
        return chatBar.curText.length == 0 ? false : true
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func keyboardWillHide(_ notification: Notification?) {
        if curStatus == TLChatBarStatusEmoji || curStatus == TLChatBarStatusMore {
            return
        }
        chatBar.mas_updateConstraints({ make in
            make?.bottom.mas_equalTo(self.view)
        })
        view.layoutIfNeeded()
    }

    func keyboardFrameWillChange(_ notification: Notification?) {
        let keyboardFrame: CGRect? = notification?.userInfo[UIResponder.keyboardFrameEndUserInfoKey]?.cgRectValue
        if lastStatus == TLChatBarStatusMore || lastStatus == TLChatBarStatusEmoji {
            if (keyboardFrame?.size.height ?? 0.0) <= 215.0 {
                return
            }
        } else if curStatus == TLChatBarStatusEmoji || curStatus == TLChatBarStatusMore {
            return
        }
        chatBar.mas_updateConstraints({ make in
            make?.bottom.mas_equalTo(self.view).mas_offset(-(keyboardFrame?.size.height ?? 0.0))
        })
        view.layoutIfNeeded()
        chatTableVC.scrollToBottom(withAnimation: false)
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func keyboardDidShow(_ notification: Notification?) {
        if lastStatus == TLChatBarStatusMore {
            moreKeyboard.dismiss(withAnimation: false)
        } else if lastStatus == TLChatBarStatusEmoji {
            emojiKeyboard.dismiss(withAnimation: false)
        }
    }

    // MARK: -
    //MARK: TLKeyboardDelegate
    func chatKeyboard(_ keyboard: Any?, didChangeHeight height: CGFloat) {
        chatBar.mas_updateConstraints({ make in
            make?.bottom.mas_equalTo(self.view).mas_offset(-height)
        })
        view.layoutIfNeeded()
        chatTableVC.scrollToBottom(withAnimation: false)
    }

    func chatKeyboardDidShow(_ keyboard: Any?) {
        if curStatus == TLChatBarStatusMore && lastStatus == TLChatBarStatusEmoji {
            emojiKeyboard.dismiss(withAnimation: false)
        } else if curStatus == TLChatBarStatusEmoji && lastStatus == TLChatBarStatusMore {
            moreKeyboard.dismiss(withAnimation: false)
        }
    }
    func chatBar(_ chatBar: WXChatBar?, changeStatusFrom fromStatus: TLChatBarStatus, to toStatus: TLChatBarStatus) {
        if curStatus == toStatus {
            return
        }
        lastStatus = fromStatus
        curStatus = toStatus
        if toStatus == TLChatBarStatusInit {
            if fromStatus == TLChatBarStatusMore {
                moreKeyboard.dismiss(withAnimation: true)
            } else if fromStatus == TLChatBarStatusEmoji {
                emojiKeyboard.dismiss(withAnimation: true)
            }
        } else if toStatus == TLChatBarStatusKeyboard {
            if fromStatus == TLChatBarStatusMore {
                moreKeyboard.mas_remakeConstraints({ make in
                    make?.top.mas_equalTo(self.chatBar.mas_bottom)
                    make?.left.and().right().mas_equalTo(self.view)
                    make?.height.mas_equalTo(215.0)
                })
            } else if fromStatus == TLChatBarStatusEmoji {
                emojiKeyboard.mas_remakeConstraints({ make in
                    make?.top.mas_equalTo(self.chatBar.mas_bottom)
                    make?.left.and().right().mas_equalTo(self.view)
                    make?.height.mas_equalTo(215.0)
                })
            }
        } else if toStatus == TLChatBarStatusVoice {
            if fromStatus == TLChatBarStatusMore {
                moreKeyboard.dismiss(withAnimation: true)
            } else if fromStatus == TLChatBarStatusEmoji {
                emojiKeyboard.dismiss(withAnimation: true)
            }
        } else if toStatus == TLChatBarStatusEmoji {
            if fromStatus == TLChatBarStatusKeyboard {
                emojiKeyboard.show(inView: view, withAnimation: true)
            } else {
                emojiKeyboard.show(inView: view, withAnimation: true)
            }
        } else if toStatus == TLChatBarStatusMore {
            if fromStatus == TLChatBarStatusKeyboard {
                moreKeyboard.show(inView: view, withAnimation: true)
            } else {
                moreKeyboard.show(inView: view, withAnimation: true)
            }
        }
    }
    func chatBar(_ chatBar: WXChatBar?, didChangeTextViewHeight height: CGFloat) {
        chatTableVC.scrollToBottom(withAnimation: false)
    }


    
}
