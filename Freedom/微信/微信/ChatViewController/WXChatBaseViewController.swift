//
//  WXChatBaseViewController.swift
//  Freedom
import SnapKit
import Foundation
import XExtension
protocol WXChatViewControllerProxy: NSObjectProtocol {
    func didClickedUserAvatar(_ user: WXUser)
    func didClickedImageMessages(_ imageMessages: [Any], at index: Int)
}
protocol WXChatBarDelegate: NSObjectProtocol {
    func chatBar(_ chatBar: WXChatBar, changeStatusFrom fromStatus: TLChatBarStatus, to toStatus: TLChatBarStatus)
    func chatBar(_ chatBar: WXChatBar, didChangeTextViewHeight height: CGFloat)
}
protocol WXChatBarDataDelegate: NSObjectProtocol {
    func chatBar(_ chatBar: WXChatBar, sendText text: String)
    func chatBarRecording(_ chatBar: WXChatBar)
    func chatBarWillCancelRecording(_ chatBar: WXChatBar)
    func chatBarDidCancelRecording(_ chatBar: WXChatBar)
    func chatBarFinishedRecoding(_ chatBar: WXChatBar)
}
class WXTextDisplayView: UIView {
    var attrString: NSAttributedString {
        didSet {
            let mutableAttrString = NSMutableAttributedString(attributedString: attrString)
            mutableAttrString.addAttribute(.font, value: UIFont.systemFont(ofSize: 25.0), range: NSRange(location: 0, length: attrString.length))
            textView.attributedText = mutableAttrString
            var size = textView.sizeThatFits(CGSize(width: frame.size.width * 0.94, height: CGFloat(MAXFLOAT)))
            size.height = size.height > APPH ? APPH : size.height
            textView.snp.updateConstraints { (make) in
                make.size.equalTo(size)
            }
        }
    }
    var textView: UITextView =  {
        let textView = UITextView()
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .center
        textView.isEditable = false
        return textView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(WXTextDisplayView.dismiss))
        addGestureRecognizer(tapGR)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func show(in view: UIView, withAttrText attrText: NSAttributedString, animation: Bool) {
        view.addSubview(self)
        self.frame = view.bounds
        self.attrString = attrText
        self.alpha = 0
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 1.0
        }) { finished in
            UIApplication.shared.isStatusBarHidden = true
        }
    }
    @objc func dismiss() {
        UIApplication.shared.isStatusBarHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { finished in
            self.removeFromSuperview()
        }
    }
}

class WXEmojiDisplayView: UIImageView {
    var emoji: TLEmoji {
        didSet {
            if emoji.type == .emoji {
                imageLabel.isHidden = false
                imageView.isHidden = true
                titleLabel.isHidden = true
                imageLabel.text = emoji.emojiName
            } else if emoji.type == .face {
                imageLabel.isHidden = true
                imageView.isHidden = false
                titleLabel.isHidden = false
                imageView.image = UIImage(named: emoji.emojiName)
                titleLabel.text = (emoji.emojiName as NSString).substring(with: NSRange(location: 1, length: emoji.emojiName.count - 2))
            }
        }
    }
    var rect = CGRect.zero {
        didSet {
            center = CGPoint(x: rect.origin.x + rect.size.width / 2, y: rect.origin.y + rect.size.height - frame.size.height + 15.0 + frame.size.height / 2)
        }
    }
    private var imageView = UIImageView()
    private lazy var imageLabel: UILabel =  {
        let imageLabel = UILabel()
        imageLabel.textAlignment = .center
        imageLabel.isHidden = true
        imageLabel.font = UIFont.systemFont(ofSize: 30.0)
        return imageLabel
    }()
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 12.0)
        titleLabel.textColor = UIColor.gray
        return titleLabel
    }()
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: CGSize(width: 55, height: 100).width, height: CGSize(width: 55, height: 100).height))
        image = UIImage(named: "emojiKB_tips")
        addSubview(imageLabel)
        addSubview(imageView)
        addSubview(titleLabel)
//        p_addMasonry()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func display(_ emoji: TLEmoji, at rect: CGRect) {
        self.rect = rect
        self.emoji = emoji
    }
//    func p_addMasonry() {
//        imageView.mas_makeConstraints({ make in
//            make.top.mas_equalTo(self).mas_offset(10)
//            make.left.mas_equalTo(self).mas_offset(12)
//            make.right.mas_equalTo(self).mas_equalTo(-12)
//            make.height.mas_equalTo(self.imageView.mas_width)
//        })
//        titleLabel.mas_makeConstraints({ make in
//            make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(5)
//            make.centerX.mas_equalTo(self)
//            make.width.mas_lessThanOrEqualTo(self)
//        })
//        imageLabel.mas_makeConstraints({ make in
//            make.width.and().height().and().centerX.mas_equalTo(self.imageView)
    //            make.top.mas_equalTo(self)?.mas_offset(12)
//        })
//    }
}
extension UIButton {
    func setImage(_ image: UIImage?, imageHL: UIImage?) {
        setImage(image, for: .normal)
        setImage(imageHL, for: .highlighted)
    }
    class func initBtn(withFrame frame: CGRect, target: Any, method: Selector, title: String, setimageName: String, backImageName: String) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.frame = frame
        btn.addTarget(target, action: method, for: .touchUpInside)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        btn.setImage(UIImage(named: setimageName), for: .normal)
        btn.setBackgroundImage(UIImage(named: backImageName), for: .normal)
        return btn
    }
}

class WXChatBar: UIView ,UITextViewDelegate {
    private let kVoiceImage = UIImage(named: "chat_toolbar_voice")
    private let kVoiceImageHL = UIImage(named: "chat_toolbar_voice_HL")
    private let kEmojiImage = UIImage(named: "chat_toolbar_emotion")
    private let kEmojiImageHL = UIImage(named: "chat_toolbar_emotion_HL")
    private let kMoreImage = UIImage(named: "chat_toolbar_more")
    private let kMoreImageHL = UIImage(named: "chat_toolbar_more_HL")
    private let kKeyboardImage = UIImage(named: "chat_toolbar_keyboard")
    private let kKeyboardImageHL = UIImage(named: "chat_toolbar_keyboard_HL")
    private let modeButton = UIButton()
    private let voiceButton = UIButton()
    private let emojiButton = UIButton()
    private let moreButton = UIButton()
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16.0)
        textView.returnKeyType = .send
        textView.layer.masksToBounds = true
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        textView.layer.cornerRadius = 4.0
        textView.delegate = self
        textView.scrollsToTop = false
        return textView
    }()
    private lazy var talkButton: UIButton = {
        let talkButton = UIButton()
        talkButton.setTitle("按住 说话", for: .normal)
        talkButton.setTitle("松开 结束", for: .highlighted)
        talkButton.setTitleColor(UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0), for: .normal)
        talkButton.setBackgroundImage(UIImage(color: UIColor(white: 0.0, alpha: 0.1)), for: .highlighted)
        talkButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        talkButton.layer.masksToBounds = true
        talkButton.layer.cornerRadius = 4.0
        talkButton.layer.borderWidth = 1
        talkButton.layer.borderColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        talkButton.isHidden = true
        talkButton.addTarget(self, action: #selector(self.talkButtonTouchDown(_:)), for: .touchDown)
        talkButton.addTarget(self, action: #selector(self.talkButtonTouchUp(inside:)), for: .touchUpInside)
        talkButton.addTarget(self, action: #selector(self.talkButtonTouchCancel(_:)), for: .touchUpOutside)
        talkButton.addTarget(self, action: #selector(self.talkButtonTouchCancel(_:)), for: .touchCancel)
        return talkButton
    }()
    weak var delegate: WXChatBarDelegate?
    weak var dataDelegate: WXChatBarDataDelegate?
    var status = TLChatBarStatus.init
    private var curText: String {
       return textView.text
    }
    var activity = false {
        didSet {
            if activity {
                textView.textColor = UIColor.black
            } else {
                textView.textColor = UIColor.gray
            }
        }
    }
    override init() {
        super.init()
        backgroundColor = UIColor(245.0, 245.0, 247.0, 1.0)
        addSubview(modeButton)
        addSubview(voiceButton)
        addSubview(textView)
        addSubview(talkButton)
        addSubview(emojiButton)
        addSubview(moreButton)
        modeButton.setImage(UIImage(named: "chat_toolbar_texttolist"), imageHL: UIImage(named: "chat_toolbar_texttolist_HL"))
        modeButton.addTarget(self, action: #selector(self.modeButtonDown), for: .touchUpInside)
        voiceButton.setImage(kVoiceImage, imageHL: kVoiceImageHL)
        voiceButton.addTarget(self, action: #selector(self.voiceButtonDown), for: .touchUpInside)
        emojiButton.setImage(kEmojiImage, imageHL: kEmojiImageHL)
        emojiButton.addTarget(self, action: #selector(self.emojiButtonDown), for: .touchUpInside)
        moreButton.setImage(kMoreImage, imageHL: kMoreImageHL)
        moreButton.addTarget(self, action: #selector(self.moreButtonDown), for: .touchUpInside)
//        p_addMasonry()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    func sendCurrentText() {
        if textView.text.count > 0 {
            dataDelegate?.chatBar(self, sendText: textView.text)
        }
        textView.text = ""
        textViewDidChange(textView)
    }

    func addEmojiString(_ emojiString: String) {
        let str = "\(String(describing: textView.text))\(emojiString)"
        textView.text = str
        textViewDidChange(textView)
    }
    override var isFirstResponder: Bool {
        if status == .emoji || status == .keyboard || status == .more {
            return true
        }
        return false
    }
    override func resignFirstResponder() -> Bool {
        if status == .emoji || status == .keyboard || status == .more {
            delegate?.chatBar(self, changeStatusFrom: status, to: .init)
            textView.resignFirstResponder()
            status = .init
            moreButton.setImage(kMoreImage, imageHL: kMoreImageHL)
            emojiButton.setImage(kEmojiImage, imageHL: kEmojiImageHL)
        }
        return super.resignFirstResponder()
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.activity = true
        if status != .keyboard {
            delegate?.chatBar(self, changeStatusFrom: status, to: .keyboard)
            if status == .emoji {
                emojiButton.setImage(kEmojiImage, imageHL: kEmojiImageHL)
            } else if status == .more {
                moreButton.setImage(kMoreImage, imageHL: kMoreImageHL)
            }
            status = .keyboard
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            sendCurrentText()
            return false
        } else if textView.text.count > 0 && (text == "") {
            // delete
            if textView.text[textView.text.index(textView.text.startIndex, offsetBy: range.location)] == "]" {
                var location = range.location
                var length = range.length
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
        var height: CGFloat = textView.sizeThatFits(CGSize(width: self.textView.frame.size.width, height: CGFloat(MAXFLOAT))).height
        height = height > 36 ? height : 36
        height = height <= 115 ? height : textView.frame.size.height
        if height != textView.frame.size.height {
            UIView.animate(withDuration: 0.2, animations: {
                textView.snp.updateConstraints({ (make) in
                    make.height.equalTo(height)
                })
                self.superview?.layoutIfNeeded()
                    delegate?.chatBar(self, didChangeTextViewHeight: textView.frame.size.height)
                }
            }) { finished in
                delegate?.chatBar(self, didChangeTextViewHeight: textView.frame.size.height)
            }
        }
    }
    @objc func modeButtonDown() {
        if status == .emoji {
            delegate?.chatBar(self, changeStatusFrom: status, to: TLChatBarStatusInit)
            emojiButton.setImage(kEmojiImage, imageHL: kEmojiImageHL)
            status = .init
        } else if status == .more {
            delegate?.chatBar(self, changeStatusFrom: status, to: TLChatBarStatusInit)
            moreButton.setImage(kMoreImage, imageHL: kMoreImageHL)
            status = .init
        }
    }
    @objc func voiceButtonDown() {
        textView.resignFirstResponder()
        if status == .voice {
            delegate?.chatBar(self, changeStatusFrom: status, to: .keyboard)
            voiceButton.setImage(kVoiceImage, imageHL: kVoiceImageHL)
            textView.becomeFirstResponder()
            textView.isHidden = false
            talkButton.isHidden = true
            status = .keyboard
        } else {// 开始语音
            delegate?.chatBar(self, changeStatusFrom: status, to: TLChatBarStatusVoice)
            if status == .keyboard {
                textView.resignFirstResponder()
            } else if status == .emoji {
                emojiButton.setImage(kEmojiImage, imageHL: kEmojiImageHL)
            } else if status == .more {
                moreButton.setImage(kMoreImage, imageHL: kMoreImageHL)
            }
            talkButton.isHidden = false
            textView.isHidden = true
            voiceButton.setImage(kKeyboardImage, imageHL: kKeyboardImageHL)
            status = .voice
        }
    }
    @objc func emojiButtonDown() {
        // 开始文字输入
        if status == .emoji {
            delegate?.chatBar(self, changeStatusFrom: status, to: TLChatBarStatusKeyboard)
            emojiButton.setImage(kEmojiImage, imageHL: kEmojiImageHL)
            textView.becomeFirstResponder()
            status = .keyboard
        } else {
            // 打开表情键盘
            delegate?.chatBar(self, changeStatusFrom: status, to: TLChatBarStatusEmoji)
            if status == .voice {
                voiceButton.setImage(kVoiceImage, imageHL: kVoiceImageHL)
                talkButton.hidden = true
                textView.isHidden = false
            } else if status == .more {
                moreButton.setImage(kMoreImage, imageHL: kMoreImageHL)
            }
            emojiButton.setImage(kKeyboardImage, imageHL: kKeyboardImageHL)
            textView.resignFirstResponder()
            status = .emoji
        }
    }
    @objc func moreButtonDown() {
        // 开始文字输入
        if status == .more {
            delegate?.chatBar(self, changeStatusFrom: status, to: TLChatBarStatusKeyboard)
            moreButton.setImage(kMoreImage, imageHL: kMoreImageHL)
            textView.becomeFirstResponder()
            status = .keyboard
        } else {
            // 打开更多键盘
            delegate?.chatBar(self, changeStatusFrom: status, to: .more)
            if status == TLChatBarStatusVoice {
                voiceButton.setImage(kVoiceImage, imageHL: kVoiceImageHL)
                talkButton.hidden = true
                textView.isHidden = false
            } else if status == TLChatBarStatusEmoji {
                emojiButton.setImage(kEmojiImage, imageHL: kEmojiImageHL)
            }
            moreButton.setImage(kKeyboardImage, imageHL: kKeyboardImageHL)
            textView.resignFirstResponder()
            status = .more
        }
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(0.5)
        context.setStrokeColor(UIColor.gray.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: 0, y: 0))
        context.addLine(to: CGPoint(x: APPW, y: 0))
        context.strokePath()
    }
    func talkButtonTouchDown(_ sender: UIButton) {
        dataDelegate?.chatBarRecording(self)
    }
    func talkButtonTouchUp(inside sender: UIButton){
        dataDelegate?.chatBarFinishedRecoding(self)
    }
    func talkButtonTouchCancel(_ sender: UIButton) {
        dataDelegate?.chatBarDidCancelRecording(self)
    }
//    func p_addMasonry() {
//        modeButton.mas_makeConstraints({ make in
//            make.left.mas_equalTo(self)
//            make.bottom.mas_equalTo(self).mas_offset(-4)
//            make.width.mas_equalTo(0)
//        })
//        voiceButton.mas_makeConstraints({ make in
//            make.bottom.mas_equalTo(self).mas_offset(-7)
//            make.left.mas_equalTo(self.modeButton.mas_right).mas_offset(1)
//            make.width.mas_equalTo(38)
//        })
//        textView.mas_makeConstraints({ make in
//            make.top.mas_equalTo(self).mas_offset(7)
//            make.bottom.mas_equalTo(self).mas_offset(-7)
//            make.left.mas_equalTo(self.voiceButton.mas_right).mas_offset(4)
//            make.right.mas_equalTo(self.emojiButton.mas_left).mas_offset(-4)
//            make.height.mas_equalTo(36)
//        })
//        talkButton.mas_makeConstraints({ make in
//            make.center.mas_equalTo(self.textView)
//            make.size.mas_equalTo(self.textView)
//        })
//        moreButton.mas_makeConstraints({ make in
//            make.top.and().width().mas_equalTo(self.voiceButton)
//            make.right.mas_equalTo(self).mas_offset(-1)
//        })
//        emojiButton.mas_makeConstraints({ make in
//            make.top.and().width().mas_equalTo(self.voiceButton)
//            make.right.mas_equalTo(self.moreButton.mas_left)
//        })
//    }
}


class WXChatBaseViewController: WXBaseViewController, WXChatViewControllerProxy, WXMoreKeyboardDelegate, WXChatBarDelegate, TLKeyboardDelegate, TLEmojiKeyboardDelegate, WXChatBarDataDelegate, WXChatTableViewControllerDelegate {
    var lastStatus = TLChatBarStatus.init
    var curStatus = TLChatBarStatus.init
    var user: WXChatUserProtocol
    var chatTableVC = WXChatTableViewController()
    var chatBar = WXChatBar()
    var moreKeyboard = TLMoreKeyboard()
    var emojiKeyboard = TLEmojiKeyboard()
    var emojiDisplayView = WXEmojiDisplayView()
    var imageExpressionDisplayView = WXImageExpressionDisplayView()
    private var lastDateInterval: TimeInterval = 0
    private var msgAccumulate: Intoverride  = 0
    var partner: WXChatUserProtocol {
        didSet {
            navigationItem.title = self.partner.chat_username
            resetChatVC()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableVC.delegate = self
        chatBar.delegate = self
        chatBar.dataDelegate = self
        moreKeyboard.keyboardDelegate = self
        moreKeyboard.delegate = self
        emojiKeyboard.keyboardDelegate = self
        emojiKeyboard.delegate = self
        view.addSubview(chatTableVC.tableView)
        addChild(chatTableVC)
        view.addSubview(chatBar)
//        chatTableVC().tableView.mas_makeConstraints({ make in
//            make.top.and().left().and().right().mas_equalTo(self.view)
//            make.bottom.mas_equalTo(self.chatBar.mas_top)
//        })
//        chatBar.mas_makeConstraints({ make in
//            make.left.and().right().and().bottom().mas_equalTo(self.view)
//        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardFrameWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    func resetChatVC() {
        var chatViewBGImage = UserDefaults.standard.object(forKey: "CHAT_BG_" + (partner.chat_userID())) as String
        if chatViewBGImage == nil {
            chatViewBGImage = UserDefaults.standard.object(forKey: "CHAT_BG_ALL") as String
            if chatViewBGImage.isEmpty {
                view.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
            } else {
                let imagePath = FileManager.pathUserChatBackgroundImage(chatViewBGImage)
                let image = UIImage(named: imagePath)
                view.backgroundColor = UIColor(patternImage: image)
            }
        } else {
            let imagePath = FileManager.pathUserChatBackgroundImage(chatViewBGImage)
            let image = UIImage(named: imagePath)
            view.backgroundColor = UIColor(patternImage: image)
        }
        resetChatTVC()
    }
    //发送图片消息
    func sendImageMessage(_ image: UIImage) {
        var imageData = UIImagePNGRepresentation(image) ? UIImagePNGRepresentation(image) : image.jpegData(compressionQuality: 0.5)
        let imageName = String(format: "%lf.jpg", Date().timeIntervalSince1970)
        let imagePath = FileManager.pathUserChatImage(imageName)
        FileManager.default.createFile(atPath: imagePath, contents: imageData, attributes: nil)
        let message = WXImageMessage()
        message.fromUser = user
        message.messageType = .image
        message.ownerTyper = .own
        message.content["path"] = imageName
        message.imageSize = image.size
        send(message)
        if partner.chat_user == .user {
            let message1 = WXImageMessage()
            message1.fromUser = partner
            message1.messageType = .image
            message1.ownerTyper = .friend
            message1.content["path"] = imageName
            message1.imageSize = image.size
            send(message1)
        } else {
            for user: WXChatUserProtocol in partner.groupMembers() {
                let message1 = WXImageMessage()
                message1.friendID = user.chat_userID
                message1.fromUser = user
                message1.messageType = .image
                message1.ownerTyper = .friend
                message1.content["path"] = imageName
                message1.imageSize = image.size
                send(message1)
            }
        }
    }
    func chatBar(_ chatBar: WXChatBar, sendText text: String) {
        let message = WXTextMessage()
        message.fromUser = user
        message.messageType = .text
        message.ownerTyper = .own
        message.content["text"] = text
        send(message)
        if partner.chat_user() == .user {
            let message1 = WXTextMessage()
            message1.fromUser = partner
            message1.messageType = .text
            message1.ownerTyper = .friend
            message1.content["text"] = text
            send(message1)
        } else {
            for user: WXChatUserProtocol in partner.groupMembers() {
                let message1 = WXTextMessage()
                message1.friendID = user.chat_userID
                message1.fromUser = user
                message1.messageType = .text
                message1.ownerTyper = .friend
                message1.content["text"] = text
                send(message1)
            }
        }
    }
    func chatBarRecording(_ chatBar: WXChatBar) {
        Dlog("rec...")
    }
    func chatBarWillCancelRecording(_ chatBar: WXChatBar) {
        Dlog("will cancel")
    }
    func chatBarDidCancelRecording(_ chatBar: WXChatBar) {
        Dlog("cancel")
    }
    func chatBarFinishedRecoding(_ chatBar: WXChatBar) {
        Dlog("finished")
    }
    func add(toShow message: WXMessage) {
        message.showTime = p_needShowTime(message.date)
        chatTableVC.add(message)
        chatTableVC.scrollToBottom(withAnimation: true)
    }
    func resetChatTVC() {
        chatTableVC.reloadData()
        lastDateInterval = 0
        msgAccumulate = 0
    }
    // chatView 获取历史记录
    func chatTableViewController(_ chatTVC: WXChatTableViewController, getRecordsFrom date: Date, count: Int, completed: @escaping (Date, [Any], Bool) -> Void) {
        var count = count
        WXMessageManager.shared.messageRecord(forPartner: partner.chat_userID, from: date, count: count, complete: { array, hasMore in
            if (array.count) > 0 {
                var count: Int = 0
                var tm: TimeInterval = 0
                for message: WXMessage in array as [WXMessage]  [] {
                    count += 1
                    if count > 10 || tm == 0 || (message.date.timeIntervalSince1970) - tm > 30 {
                        tm = message.date.timeIntervalSince1970
                        count = 0
                        message.showTime = true
                    }
                    if message.ownerTyper == TLMessageOwnerTypeSelf {
                        message.fromUser = self.user
                    } else {
                        if self.partner.chat_user() == TLChatUserTypeUser {
                            message.fromUser = self.partner
                        } else if self.partner.chat_user() == TLChatUserTypeGroup {
                            message.fromUser = self.partner?.groupMember(byID: message.friendID)
                        }
                    }
                }
            }
            completed(date, array, hasMore)
        })
    }
    // chatView 点击事件
    func chatTableViewControllerDidTouched(_ chatTVC: WXChatTableViewController) {
        if chatBar.isFirstResponder {
            chatBar.resignFirstResponder()
        }
    }
    func chatTableViewController(_ chatTVC: WXChatTableViewController, delete message: WXMessage) -> Bool {
        return WXMessageManager.sharedInstance().deleteMessage(byMsgID: message.messageID)
    }
    func chatTableViewController(_ chatTVC: WXChatTableViewController, didClickUserAvatar user: WXUser) {
        didClickedUserAvatar(user)
    }
    func chatTableViewController(_ chatTVC: WXChatTableViewController, didDoubleClick message: WXMessage) {
        if message.messageType == .text {
            let displayView = WXTextDisplayView()
            displayView.show(in: navigationController.view, withAttrText: (message as WXTextMessage).attrText(), animation: true)
        }
    }
    func chatTableViewController(_ chatTVC: WXChatTableViewController, didClick message: WXMessage) {
        if message.messageType == .image {
            WXMessageManager.shared.chatImagesAndVideos(forPartnerID: partner.chat_userID, completed: { imagesData in
                var index: Int = -1
                for i in 0..<imagesData.count {
                    if (message.messageID == imagesData[i].messageID) {
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
    func p_needShowTime(_ date: Date) -> Bool {
        msgAccumulate += 1
        if msgAccumulate > 10 || lastDateInterval == 0 || (date.timeIntervalSince1970) - lastDateInterval > 30 {
            lastDateInterval = date.timeIntervalSince1970
            msgAccumulate = 0
            return true
        }
        return false
    }
    func send(_ message: WXMessage) {
        message.userID = WXUserHelper.shared.user.userID
        if partner.chat_user() == .user {
            message.partnerType = .user
            message.friendID = partner.chat_userID
        } else if partner.chat_user() == .group {
            message.partnerType = .group
            message.groupID = partner.chat_userID
        }
        message.ownerTyper = .own;
        message.fromUser = WXUserHelper.shared.user
        message.date = Date()
        add(toShow: message) // 添加到列表
        WXMessageManager.shared.send(message, progress: { message, pregress in
        }, success: { message in
            Dlog("send success")
        }, failure: { message in
            Dlog("send failure")
        })
    }
    func emojiKeyboard(_ emojiKB: TLEmojiKeyboard, didSelectedEmojiItem emoji: TLEmoji) {
        if emoji.type == .emoji || emoji.type == .face {
            chatBar.addEmojiString(emoji.emojiName)
        } else {
            let message = WXExpressionMessage()
            message.fromUser = user
            message.messageType = .expression
            message.ownerTyper = .own
            message.emoji = emoji
            send(message)
            if partner.chat_user == .user {
                let message1 = WXExpressionMessage()
                message1.fromUser = partner
                message1.messageType = .expression
                message1.ownerTyper = .friend
                message1.emoji = emoji
                send(message1)
            } else {
                for user: WXChatUserProtocol in partner.groupMembers() {
                    let message1 = WXExpressionMessage()
                    message1.friendID = user.chat_userID
                    message1.fromUser = user
                    message1.messageType = .expression
                    message1.ownerTyper = .friend
                    message1.emoji = emoji
                    send(message1)
                }
            }
        }
    }
    func emojiKeyboardSendButtonDown() {
        chatBar.sendCurrentText()
    }

    func emojiKeyboard(_ emojiKB: TLEmojiKeyboard, didTouchEmojiItem emoji: TLEmoji, at rect: CGRect) {
        if emoji.type == .emoji || emoji.type == .face {
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
    func emojiKeyboardCancelTouchEmojiItem(_ emojiKB: TLEmojiKeyboard) {
        if emojiDisplayView.superview != nil {
            emojiDisplayView.removeFromSuperview()
        } else if imageExpressionDisplayView.superview != nil {
            imageExpressionDisplayView.removeFromSuperview()
        }
    }

    func emojiKeyboard(_ emojiKB: TLEmojiKeyboard, selectedEmojiGroupType type: TLEmojiType) {
        if type == .emoji || type == .face {
            chatBar.activity = true
        } else {
            chatBar.activity = false
        }
    }
    func chatInputViewHasText() -> Bool {
        return chatBar.curText.length == 0 ? false : true
    }
    func keyboardWillHide(_ notification: Notification) {
        if curStatus == .emoji || curStatus == .more {
            return
        }
        chatBar.mas_updateConstraints({ make in
            make.bottom.mas_equalTo(self.view)
        })
        view.layoutIfNeeded()
    }

    func keyboardFrameWillChange(_ notification: Notification) {
        let keyboardFrame: CGRect = notification.userInfo[UIResponder.keyboardFrameEndUserInfoKey].cgRectValue
        if lastStatus == .more || lastStatus == .emoji {
            if (keyboardFrame.size.height) <= 215.0 {
                return
            }
        } else if curStatus == TLChatBarStatusEmoji || curStatus == TLChatBarStatusMore {
            return
        }
        chatBar.mas_updateConstraints({ make in
            make.bottom.mas_equalTo(self.view).mas_offset(-(keyboardFrame.size.height))
        })
        view.layoutIfNeeded()
        chatTableVC.scrollToBottom(withAnimation: false)
    }
    
    func keyboardDidShow(_ notification: Notification) {
        if lastStatus == .more {
            moreKeyboard.dismiss(withAnimation: false)
        } else if lastStatus == .emoji {
            emojiKeyboard.dismiss(withAnimation: false)
        }
    }
    func chatKeyboard(_ keyboard: Any, didChangeHeight height: CGFloat) {
        chatBar.mas_updateConstraints({ make in
            make.bottom.mas_equalTo(self.view).mas_offset(-height)
        })
        view.layoutIfNeeded()
        chatTableVC.scrollToBottom(withAnimation: false)
    }

    func chatKeyboardDidShow(_ keyboard: Any) {
        if curStatus == .more && lastStatus == .emoji {
            emojiKeyboard.dismiss(withAnimation: false)
        } else if curStatus == .emoji && lastStatus == .more {
            moreKeyboard.dismiss(withAnimation: false)
        }
    }
    func chatBar(_ chatBar: WXChatBar, changeStatusFrom fromStatus: TLChatBarStatus, to toStatus: TLChatBarStatus) {
        if curStatus == toStatus {
            return
        }
        lastStatus = fromStatus
        curStatus = toStatus
        if toStatus == .init {
            if fromStatus == .more {
                moreKeyboard.dismiss(withAnimation: true)
            } else if fromStatus == .emoji {
                emojiKeyboard.dismiss(withAnimation: true)
            }
        } else if toStatus == .keyboard {
            if fromStatus == .more {
                moreKeyboard.mas_remakeConstraints({ make in
                    make.top.mas_equalTo(self.chatBar.mas_bottom)
                    make.left.and().right().mas_equalTo(self.view)
                    make.height.mas_equalTo(215.0)
                })
            } else if fromStatus == .emoji {
                emojiKeyboard.mas_remakeConstraints({ make in
                    make.top.mas_equalTo(self.chatBar.mas_bottom)
                    make.left.and().right().mas_equalTo(self.view)
                    make.height.mas_equalTo(215.0)
                })
            }
        } else if toStatus == .voice {
            if fromStatus == .more {
                moreKeyboard.dismiss(withAnimation: true)
            } else if fromStatus == .emoji {
                emojiKeyboard.dismiss(withAnimation: true)
            }
        } else if toStatus == .emoji {
            if fromStatus == .keyboard {
                emojiKeyboard.show(inView: view, withAnimation: true)
            } else {
                emojiKeyboard.show(inView: view, withAnimation: true)
            }
        } else if toStatus == .more {
            if fromStatus == .keyboard {
                moreKeyboard.show(inView: view, withAnimation: true)
            } else {
                moreKeyboard.show(inView: view, withAnimation: true)
            }
        }
    }
    func chatBar(_ chatBar: WXChatBar, didChangeTextViewHeight height: CGFloat) {
        chatTableVC.scrollToBottom(withAnimation: false)
    }
}
