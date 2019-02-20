//
//  WXChatViewController.swift
//  Freedom
import XExtension
import SnapKit
import MWPhotoBrowser
import Foundation
extension UIImagePickerController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = UIColor.thin
        navigationBar.tintColor = UIColor.whitex
        view.backgroundColor = UIColor.light
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.whitex, NSAttributedString.Key.font: UIFont.large]
    }
}
protocol WXChatViewControllerProxy: NSObjectProtocol {
    func didClickedUserAvatar(_ user: WXUser)
    func didClickedImageMessages(_ imageMessages: [WXImageMessage], at index: Int)
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
    var attrString: NSAttributedString = NSAttributedString(string: "") {
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
        backgroundColor = UIColor.whitex
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
    var emoji: TLEmoji = TLEmoji() {
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
                imageView.image = emoji.emojiName.image
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
        titleLabel.font = UIFont.small
        titleLabel.textColor = UIColor.grayx
        return titleLabel
    }()
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: CGSize(width: 55, height: 100).width, height: CGSize(width: 55, height: 100).height))
        image = WXImage.emojiKB_tips.image
        addSubview(imageLabel)
        addSubview(imageView)
        addSubview(titleLabel)
        imageView.snp.makeConstraints { (make) in
            make.topMargin.equalTo(10)
            make.leftMargin.equalTo(12)
            make.rightMargin.equalTo(12)
            make.height.equalTo(self.imageView.snp.width)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.topMargin.equalTo(self.imageView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
        }
        imageLabel.snp.makeConstraints { (make) in
            make.width.height.centerX.equalTo(self.imageView)
            make.top.equalToSuperview().offset(12)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func display(_ emoji: TLEmoji, at rect: CGRect) {
        self.rect = rect
        self.emoji = emoji
    }
}

class WXImageExpressionDisplayView: UIView {
    var bgLeftView = UIImageView(image: WXImage.tipLeft.image)
    var bgCenterView = UIImageView(image: WXImage.tipMiddle.image)
    var bgRightView = UIImageView(image: WXImage.tipRight.image)
    var imageView = UIImageView()
    private var curID = ""
    var emoji: TLEmoji = TLEmoji() {
        didSet {
            curID = emoji.emojiID
            if let dda = try? Data(contentsOf: URL(fileURLWithPath: emoji.emojiPath)) {
                imageView.image = UIImage.sd_animatedGIF(with: dda)
            } else {
                let urlString = "http://123.57.155.230:8080/ibiaoqing/admin/expre/download.dopId=\(emoji.emojiID)"
                imageView.sd_setImage(with: URL(string: emoji.emojiURL), completed: { image, error, cacheType, imageURL in
                    if urlString.contains(self.curID) {
                        DispatchQueue.global(qos: .default).async(execute: {
                            var data = try Data(contentsOf: URL(string: urlString)!)
                            DispatchQueue.main.async(execute: {
                                self.imageView.image = UIImage.sd_animatedGIF(with: data)
                            })
                            } as! @convention(block) () -> Void)
                    }
                })
            }
        }
    }
    var rect = CGRect.zero {
        didSet {
            var frame: CGRect = self.frame
            frame.origin.y = rect.origin.y - self.frame.size.height + 13
            self.frame = frame
            let w: CGFloat = 150 - 25
            let centerX: CGFloat = rect.origin.x + rect.size.width / 2
            if rect.origin.x + rect.size.width < self.frame.size.width {
                // 箭头在左边
                center = CGPoint(x: centerX + (150 - w / 4 - 25) / 2 - 16, y: center.y)
                bgLeftView.snp.updateConstraints { (make) in
                    make.width.equalTo(w / 4)
                }
            } else if APPW - rect.origin.x < self.frame.size.width {
                // 箭头在右边
                center = CGPoint(x: centerX - (150 - w / 4 - 25) / 2 + 16, y: center.y)
                bgLeftView.snp.updateConstraints { (make) in
                    make.width.equalTo(w / 4 * 3)
                }
            } else {
                center = CGPoint(x: centerX, y: center.y)
                bgLeftView.snp.updateConstraints { (make) in
                    make.width.equalTo(w / 2)
                }
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 150, height: 162))
        addSubview(bgLeftView)
        addSubview(bgCenterView)
        addSubview(bgRightView)
        addSubview(imageView)
        bgLeftView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
        }
        bgCenterView.snp.makeConstraints { (make) in
            make.left.equalTo(self.bgLeftView.snp.right)
            make.top.bottom.equalTo(self.bgLeftView)
            make.width.equalTo(25)
        }
        bgRightView.snp.makeConstraints { (make) in
            make.left.equalTo(self.bgCenterView.snp.right)
            make.top.bottom.equalTo(self.bgLeftView)
            make.right.equalToSuperview()
        }
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leftMargin.equalTo(10)
            make.rightMargin.equalTo(-10)
            make.height.equalTo(self.imageView.snp.width)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func display(_ emoji: TLEmoji, at rect: CGRect) {
        self.rect = rect
        self.emoji = emoji
    }
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
        btn.setTitleColor(UIColor.whitex, for: .normal)
        btn.titleLabel?.font = UIFont.big
        btn.setImage(setimageName.image, for: .normal)
        btn.setBackgroundImage(backImageName.image, for: .normal)
        return btn
    }
}

class WXChatBar: UIView ,UITextViewDelegate {
    private let modeButton = UIButton()
    private let voiceButton = UIButton()
    private let emojiButton = UIButton()
    private let moreButton = UIButton()
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.big
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
        talkButton.setTitleColor(UIColor.subTitle, for: .normal)
        talkButton.setBackgroundImage(UIImage.imageWithColor(UIColor.blackx), for: .highlighted)
        talkButton.titleLabel?.font = UIFont.big
        talkButton.layer.masksToBounds = true
        talkButton.layer.cornerRadius = 4.0
        talkButton.layer.borderWidth = 1
        talkButton.layer.borderColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        talkButton.isHidden = true
        //        talkButton.addTarget(self, action: #selector(self.talkButtonTouchDown(_:)), for: .touchDown)
        //        talkButton.addTarget(self, action: #selector(self.talkButtonTouchUp(inside:)), for: .touchUpInside)
        //        talkButton.addTarget(self, action: #selector(self.talkButtonTouchCancel(_:)), for: .touchUpOutside)
        //        talkButton.addTarget(self, action: #selector(self.talkButtonTouchCancel(_:)), for: .touchCancel)
        return talkButton
    }()
    weak var delegate: WXChatBarDelegate?
    weak var dataDelegate: WXChatBarDataDelegate?
    var status = TLChatBarStatus.more
    var curText: String {
        return textView.text
    }
    var activity = false {
        didSet {
            if activity {
                textView.textColor = UIColor.blackx
            } else {
                textView.textColor = UIColor.grayx
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.back
        addSubview(modeButton)
        addSubview(voiceButton)
        addSubview(textView)
        addSubview(talkButton)
        addSubview(emojiButton)
        addSubview(moreButton)
        modeButton.setImage(WXImage.add.image, imageHL: WXImage.addHL.image)
        modeButton.addTarget(self, action: #selector(self.modeButtonDown), for: .touchUpInside)
        voiceButton.setImage(WXImage.voice.image, imageHL: WXImage.voiceHL.image)
        voiceButton.addTarget(self, action: #selector(self.voiceButtonDown), for: .touchUpInside)
        emojiButton.setImage(WXImage.face.image, imageHL: WXImage.faceHL.image)
        emojiButton.addTarget(self, action: #selector(self.emojiButtonDown), for: .touchUpInside)
        moreButton.setImage(WXImage.add.image, imageHL: WXImage.addHL.image)
        moreButton.addTarget(self, action: #selector(self.moreButtonDown), for: .touchUpInside)
        modeButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalTo(0)
            make.bottom.equalToSuperview().offset(-4)
        }
        voiceButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-7)
            make.left.equalTo(self.modeButton.snp.right).offset(1)
            make.width.equalTo(38)
        }
        textView.snp.makeConstraints { (make) in
            make.topMargin.equalTo(7)
            make.bottomMargin.equalTo(7)
            make.left.equalTo(self.voiceButton.snp.right).offset(4)
            make.right.equalTo(self.emojiButton.snp.left).offset(-4)
            make.height.equalTo(36)
        }
        talkButton.snp.makeConstraints { (make) in
            make.center.equalTo(self.textView)
            make.size.equalTo(self.textView)
        }
        moreButton.snp.makeConstraints { (make) in
            make.top.width.equalTo(self.voiceButton)
            make.right.equalToSuperview().offset(-1)
        }
        emojiButton.snp.makeConstraints { (make) in
            make.top.width.equalTo(self.voiceButton)
            make.right.equalTo(self.moreButton.snp.left)
        }
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
            delegate?.chatBar(self, changeStatusFrom: status, to: .default)
            textView.resignFirstResponder()
            status = .default
            moreButton.setImage(WXImage.add.image, imageHL: WXImage.addHL.image)
            emojiButton.setImage(WXImage.face.image, imageHL: WXImage.faceHL.image)
        }
        return super.resignFirstResponder()
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.activity = true
        if status != .keyboard {
            delegate?.chatBar(self, changeStatusFrom: status, to: .keyboard)
            if status == .emoji {
                emojiButton.setImage(WXImage.face.image, imageHL: WXImage.faceHL.image)
            } else if status == .more {
                moreButton.setImage(WXImage.add.image, imageHL: WXImage.addHL.image)
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
                self.delegate?.chatBar(self, didChangeTextViewHeight: textView.frame.size.height)
            }, completion: { (finished) in
                self.delegate?.chatBar(self, didChangeTextViewHeight: textView.frame.size.height)
            })
        }
    }
    @objc func modeButtonDown() {
        if status == .emoji {
            delegate?.chatBar(self, changeStatusFrom: status, to: .default)
            emojiButton.setImage(WXImage.face.image, imageHL: WXImage.faceHL.image)
            status = .default
        } else if status == .more {
            delegate?.chatBar(self, changeStatusFrom: status, to: .default)
            moreButton.setImage(WXImage.add.image, imageHL: WXImage.addHL.image)
            status = .default
        }
    }
    @objc func voiceButtonDown() {
        textView.resignFirstResponder()
        if status == .voice {
            delegate?.chatBar(self, changeStatusFrom: status, to: .keyboard)
            voiceButton.setImage(WXImage.voice.image, imageHL: WXImage.faceHL.image)
            textView.becomeFirstResponder()
            textView.isHidden = false
            talkButton.isHidden = true
            status = .keyboard
        } else {// 开始语音
            delegate?.chatBar(self, changeStatusFrom: status, to: .voice)
            if status == .keyboard {
                textView.resignFirstResponder()
            } else if status == .emoji {
                emojiButton.setImage(WXImage.face.image, imageHL: WXImage.faceHL.image)
            } else if status == .more {
                moreButton.setImage(WXImage.add.image, imageHL: WXImage.faceHL.image)
            }
            talkButton.isHidden = false
            textView.isHidden = true
            voiceButton.setImage(WXImage.keyboard.image, imageHL: WXImage.keyboardHL.image)
            status = .voice
        }
    }
    @objc func emojiButtonDown() {
        // 开始文字输入
        if status == .emoji {
            delegate?.chatBar(self, changeStatusFrom: status, to: .keyboard)
            emojiButton.setImage(WXImage.face.image, imageHL: WXImage.faceHL.image)
            textView.becomeFirstResponder()
            status = .keyboard
        } else {
            // 打开表情键盘
            delegate?.chatBar(self, changeStatusFrom: status, to: .emoji)
            if status == .voice {
                voiceButton.setImage(WXImage.voice.image, imageHL: WXImage.voiceHL.image)
                talkButton.isHidden = true
                textView.isHidden = false
            } else if status == .more {
                moreButton.setImage(WXImage.keyboard.image, imageHL: WXImage.keyboardHL.image)
            }
            emojiButton.setImage(WXImage.keyboard.image, imageHL: WXImage.keyboardHL.image)
            textView.resignFirstResponder()
            status = .emoji
        }
    }
    @objc func moreButtonDown() {
        // 开始文字输入
        if status == .more {
            delegate?.chatBar(self, changeStatusFrom: status, to: .keyboard)
            moreButton.setImage(WXImage.add.image, imageHL: WXImage.addHL.image)
            textView.becomeFirstResponder()
            status = .keyboard
        } else {
            // 打开更多键盘
            delegate?.chatBar(self, changeStatusFrom: status, to: .more)
            if status == .voice {
                voiceButton.setImage(WXImage.voice.image, imageHL: WXImage.voiceHL.image)
                talkButton.isHidden = true
                textView.isHidden = false
            } else if status == .emoji {
                emojiButton.setImage(WXImage.face.image, imageHL: WXImage.faceHL.image)
            }
            moreButton.setImage(WXImage.keyboard.image, imageHL: WXImage.keyboardHL.image)
            textView.resignFirstResponder()
            status = .more
        }
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(0.5)
        context.setStrokeColor(UIColor.grayx.cgColor)
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
}
//FIXME: 基本控制器
class WXChatViewController: WXBaseViewController {
    var lastStatus = TLChatBarStatus.default
    var curStatus = TLChatBarStatus.default
    var chatTableVC = WXChatTableViewController()
    var chatBar = WXChatBar()
    var moreKeyboard = TLMoreKeyboard.shared
    var emojiKeyboard = XEmojiKeyboard.shared
    var emojiDisplayView = WXEmojiDisplayView(frame: CGRect.zero)
    var imageExpressionDisplayView = WXImageExpressionDisplayView()
    private var lastDateInterval: TimeInterval = 0
    private var msgAccumulate: Int  = 0
    var user: WXChatUserProtocol?
    static let shared = WXChatViewController()
    private var emojiKBHelper = WXUserHelper.shared
    var partner: WXChatUserProtocol? {
        didSet {
            navigationItem.title = self.partner?.chat_username
            resetChatVC()
            if partner?.chat_userType == TLChatUserType.user.rawValue {
                rightBarButton.image = WXImage.default.image
            } else {
                rightBarButton.image = WXImage.default.image
            }
        }
    }
    private lazy var rightBarButton: UIBarButtonItem = {
        return UIBarButtonItem(image: WXImage.add.image, style: .plain, target: self, action: #selector(self.rightBarButtonDown(_:)))
    }()
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableVC.delegate = self
        chatBar.delegate = self
        chatBar.dataDelegate = self
        moreKeyboard.keyboardDelegate = self
        emojiKeyboard.keyboardDelegate = self
        emojiKeyboard.delegate = self
        addChild(chatTableVC)
        view.addSubview(chatTableVC.tableView)
        view.addSubview(chatBar)
        chatTableVC.tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(chatBar.snp.top)
        }
        chatBar.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        navigationItem.rightBarButtonItem = rightBarButton
        user = WXUserHelper.shared.user as WXChatUserProtocol
        emojiKBHelper.emojiGroupDataComplete({ emojiGroups in
            self.moreKeyboard.chatMoreKeyboardData = WXMoreKBHelper().chatMoreKeyboardData
        })
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
        var chatViewBGImage = UserDefaults.standard.object(forKey: "CHAT_BG_" + (partner?.chat_userID ?? "")) as? String
        if chatViewBGImage == nil {
            chatViewBGImage = UserDefaults.standard.object(forKey: "CHAT_BG_ALL") as? String
            if chatViewBGImage?.isEmpty ?? true {
                view.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
            } else {
                let imagePath = FileManager.pathUserChatBackgroundImage(chatViewBGImage ?? "")
                view.backgroundColor = UIColor(patternImage: imagePath.image)
            }
        } else {
            let imagePath = FileManager.pathUserChatBackgroundImage(chatViewBGImage ?? "")
            view.backgroundColor = UIColor(patternImage: imagePath.image)
        }
        resetChatTVC()
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
    //发送图片消息
    func sendImageMessage(_ image: UIImage) {
        let imageData = (image.pngData() != nil) ? image.pngData() : image.jpegData(compressionQuality: 0.5)
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
        if partner?.chat_userType == TLChatUserType.user.rawValue {
            let message1 = WXImageMessage()
            message1.fromUser = partner
            message1.messageType = .image
            message1.ownerTyper = .friend
            message1.content["path"] = imageName
            message1.imageSize = image.size
            send(message1)
        } else {
            for user: WXChatUserProtocol in partner?.groupMembers() ?? [] {
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
}
extension WXChatViewController: XKeyboardDelegate {

}
extension WXChatViewController: WXChatBarDataDelegate {
    func chatBar(_ chatBar: WXChatBar, sendText text: String) {
        let message = WXTextMessage()
        message.fromUser = user
        message.messageType = .text
        message.ownerTyper = .own
        message.content["text"] = text
        send(message)
        if partner?.chat_userType == TLChatUserType.user.rawValue {
            let message1 = WXTextMessage()
            message1.fromUser = partner
            message1.messageType = .text
            message1.ownerTyper = .friend
            message1.content["text"] = text
            send(message1)
        } else {
            for user: WXChatUserProtocol in partner?.groupMembers() ?? []{
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
}
extension WXChatViewController : WXChatTableViewControllerDelegate {
    // chatView 获取历史记录
    func chatTableViewController(_ chatTVC: WXChatTableViewController, getRecordsFrom date: Date, count: Int, completed: @escaping (Date, [WXMessage], Bool) -> Void) {
        WXMessageHelper.shared.messageRecord(forPartner: partner?.chat_userID ?? "", from: date, count: count, complete: { array, hasMore in
            if (array.count) > 0 {
                var count: Int = 0
                var tm: TimeInterval = 0
                for message: WXMessage in array {
                    count += 1
                    if count > 10 || tm == 0 || (message.date.timeIntervalSince1970) - tm > 30 {
                        tm = message.date.timeIntervalSince1970
                        count = 0
                        message.showTime = true
                    }
                    if message.ownerTyper == .own {
                        message.fromUser = self.user
                    } else {
                        if self.partner?.chat_userType == TLChatUserType.user.rawValue {
                            message.fromUser = self.partner
                        } else if self.partner?.chat_userType == TLChatUserType.group.rawValue {
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
            _ = chatBar.resignFirstResponder()
        }
    }
    func chatTableViewController(_ chatTVC: WXChatTableViewController, delete message: WXMessage) -> Bool {
        WXMessageHelper.shared.deleteMessage(byMsgID: message.messageID)
        return true
    }
    func chatTableViewController(_ chatTVC: WXChatTableViewController, didClickUserAvatar user: WXUser) {
        didClickedUserAvatar(user)
    }
    func chatTableViewController(_ chatTVC: WXChatTableViewController, didDoubleClick message: WXMessage) {
        if message.messageType == .text {
            let displayView = WXTextDisplayView()
            displayView.show(in: navigationController?.view ?? self.view, withAttrText: (message as! WXTextMessage).attrText, animation: true)
        }
    }
    func chatTableViewController(_ chatTVC: WXChatTableViewController, didClick message: WXMessage) {
        if message.messageType == .image {
            WXMessageHelper.shared.chatImagesAndVideos(forPartnerID: partner?.chat_userID ?? "", completed: { imagesData in
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
}
extension WXChatViewController: XEmojiKeyboardDelegate {
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
        message.groupID = message.userID
        if partner?.chat_userType == TLChatUserType.user.rawValue {
            message.partnerType = .user
            message.friendID = partner?.chat_userID ?? ""
        } else if partner?.chat_userType == TLChatUserType.group.rawValue {
            message.partnerType = .group
            message.groupID = partner?.chat_userID ?? ""
        }
        message.ownerTyper = .own;
        message.fromUser = WXUserHelper.shared.user
        message.date = Date()
        add(toShow: message) // 添加到列表
        WXMessageHelper.shared.send(message, progress: { message, pregress in
        }, success: { message in
            Dlog("send success")
        }, failure: { message in
            Dlog("send failure")
        })
    }
    func emojiKeyboard(_ emojiKB: XEmojiKeyboard, didSelectedEmojiItem emoji: TLEmoji) {
        if emoji.type == .emoji || emoji.type == .face {
            chatBar.addEmojiString(emoji.emojiName)
        } else {
            let message = WXExpressionMessage()
            message.fromUser = user
            message.messageType = .expression
            message.ownerTyper = .own
            message.emoji = emoji
            send(message)
            if partner?.chat_userType == TLChatUserType.user.rawValue {
                let message1 = WXExpressionMessage()
                message1.fromUser = partner
                message1.messageType = .expression
                message1.ownerTyper = .friend
                message1.emoji = emoji
                send(message1)
            } else {
                for user: WXChatUserProtocol in partner?.groupMembers() ?? []{
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

    func emojiKeyboard(_ emojiKB: XEmojiKeyboard, didTouchEmojiItem emoji: TLEmoji, at rect: CGRect) {
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
    func emojiKeyboardCancelTouchEmojiItem(_ emojiKB: XEmojiKeyboard) {
        if emojiDisplayView.superview != nil {
            emojiDisplayView.removeFromSuperview()
        } else if imageExpressionDisplayView.superview != nil {
            imageExpressionDisplayView.removeFromSuperview()
        }
    }
    func emojiKeyboard(_ emojiKB: XEmojiKeyboard, selectedEmojiGroupType type: TLEmojiType) {
        if type == .emoji || type == .face {
            chatBar.activity = true
        } else {
            chatBar.activity = false
        }
    }
    func chatInputViewHasText() -> Bool {
        return chatBar.curText.count == 0 ? false : true
    }
    func keyboardWillHide(_ notification: Notification) {
        if curStatus == .emoji || curStatus == .more {
            return
        }
        chatBar.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview()
        }
        view.layoutIfNeeded()
    }
    func keyboardFrameWillChange(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        if lastStatus == .more || lastStatus == .emoji {
            if (keyboardFrame.size.height) <= 215.0 {
                return
            }
        } else if curStatus == .emoji || curStatus == .more {
            return
        }
        chatBar.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(-keyboardFrame.size.height)
        }
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
        chatBar.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(-height)
        }
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
}
extension WXChatViewController: WXChatBarDelegate {
    func chatBar(_ chatBar: WXChatBar, changeStatusFrom fromStatus: TLChatBarStatus, to toStatus: TLChatBarStatus) {
        if curStatus == toStatus {
            return
        }
        lastStatus = fromStatus
        curStatus = toStatus
        if toStatus == .default {
            if fromStatus == .more {
                moreKeyboard.dismiss(withAnimation: true)
            } else if fromStatus == .emoji {
                emojiKeyboard.dismiss(withAnimation: true)
            }
        } else if toStatus == .keyboard {
            if fromStatus == .more {
                if moreKeyboard.superview != nil {
                    moreKeyboard.snp.remakeConstraints { (make) in
                        make.top.equalTo(self.chatBar.snp.bottom)
                        make.left.right.equalTo(self.view)
                        make.height.equalTo(215)
                    }
                }
            } else if fromStatus == .emoji {
                if emojiKeyboard.superview != nil {
                    emojiKeyboard.snp.remakeConstraints { (make) in
                        make.top.equalTo(self.chatBar.snp.bottom)
                        make.left.right.equalTo(self.view)
                        make.height.equalTo(215)
                    }
                }
            }
        } else if toStatus == .voice {
            if fromStatus == .more {
                moreKeyboard.dismiss(withAnimation: true)
            } else if fromStatus == .emoji {
                emojiKeyboard.dismiss(withAnimation: true)
            }
        } else if toStatus == .emoji {
            if fromStatus == .keyboard {
                emojiKeyboard.show(in: view, withAnimation: true)
            } else {
                emojiKeyboard.show(in: view, withAnimation: true)
            }
        } else if toStatus == .more {
            if fromStatus == .keyboard {
                moreKeyboard.show(in: view, withAnimation: true)
            } else {
                moreKeyboard.show(in: view, withAnimation: true)
            }
        }
    }
    func chatBar(_ chatBar: WXChatBar, didChangeTextViewHeight height: CGFloat) {
        chatTableVC.scrollToBottom(withAnimation: false)
    }
}
extension WXChatViewController: WXChatViewControllerProxy {
    func didClickedUserAvatar(_ user: WXUser) {
        let detailVC = WXFriendDetailViewController.storyVC(.wechat)
        detailVC.user = user
        navigationController?.pushViewController(detailVC, animated: true)
    }
    func didClickedImageMessages(_ imageMessages: [WXImageMessage], at index: Int) {
        var data: [MWPhoto] = []
        for message: WXImageMessage in imageMessages {
            var url: URL?
            let imagePath = message.content.path
            if !imagePath.isEmpty {
                let imagePatha = FileManager.pathUserChatImage(imagePath)
                url = URL(fileURLWithPath: imagePatha)
            } else {
                url = URL(string: message.content.url)
            }
            let photo = MWPhoto(url: url)
            data.append(photo!)
        }
        if let browser = MWPhotoBrowser(photos: data) {
            browser.displayNavArrows = true
            browser.setCurrentPhotoIndex(UInt(index))
            let broserNavC = WXNavigationController(rootViewController: browser)
            present(broserNavC, animated: false)
        }
    }
}

extension WXChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @objc func rightBarButtonDown(_ sender: UINavigationBar) {
        if partner?.chat_userType == TLChatUserType.user.rawValue {
            let chatDetailVC = WXChatDetailViewController()
            chatDetailVC.user = partner as! WXUser
            navigationController?.pushViewController(chatDetailVC, animated: true)
        } else {
            let chatGroupDetailVC = WXCGroupDetailViewController()
            chatGroupDetailVC.group = WXGroup()// partner as! WXGroup
            navigationController?.pushViewController(chatGroupDetailVC, animated: true)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPicking image: UIImage, editingInfo: [String : Any]) {
        picker.dismiss(animated: true) {
            self.sendImageMessage(image)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            let image = info[.originalImage] as! UIImage
            self.sendImageMessage(image)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func moreKeyboard(_ keyboard: Any, didSelectedFunctionItem funcItem: TLMoreKeyboardItem) {
        if funcItem.type == .camera || funcItem.type == .image {
            let imagePickerController = UIImagePickerController()
            if funcItem.type == .camera {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    imagePickerController.sourceType = .camera
                } else {
                    self.noticeError("相机初始化失败")
                    return
                }
            } else {
                imagePickerController.sourceType = .photoLibrary
            }
            imagePickerController.delegate = self
            present(imagePickerController, animated: true)
        } else {
            self.noticeInfo("选中”\(funcItem.title)“ 按钮")
        }
    }
    func emojiKeyboardEmojiEditButtonDown() {
        let expressionVC = WXExpressionViewController()
        let navC = WXNavigationController(rootViewController: expressionVC)
        present(navC, animated: true)
    }

    func emojiKeyboardMyEmojiEditButtonDown() {
        let myExpressionVC = WXMyExpressionViewController()
        let navC = WXNavigationController(rootViewController: myExpressionVC)
        present(navC, animated: true)
    }
}
