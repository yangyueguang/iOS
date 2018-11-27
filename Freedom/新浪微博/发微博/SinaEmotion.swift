//
//  SinaEmotion.swift
//  Freedom
//
//  Created by Super on 6/28/18.
//  Copyright © 2018 薛超. All rights reserved.
import UIKit
import BaseFile
import XCategory
import MJExtension
class SinaEmotionButton: UIButton {
    var emotion: SinaEmotion?
}
class SinaEmotionAttachment: NSTextAttachment {
    var emotion: SinaEmotion?
}
class SinaComposePhotosView: UIView {
    var photos = [UIImage]()
    override func layoutSubviews() {
        super.layoutSubviews()
        let count: Int = subviews.count
        let maxCol: Int = 4
        let imageWH: CGFloat = 80
        let imageMargin: CGFloat = 10
        for i in 0..<count {
            let image = subviews[i] as? UIImageView
            let col: Int = i % maxCol
            let row: Int = i / maxCol
            image?.frame = CGRect(x: CGFloat(col) * (imageWH + imageMargin) + imageMargin, y: CGFloat(row) * (imageWH + imageMargin), width: imageWH, height: imageWH)
        }
    }
}
class SinaEmotion: NSObject {
    var chs = ""/** 表情的文字描述 */
    var png = ""/** 表情的png图片名 */
    var code = ""/** emoji表情的16进制编码 */
    class func addRecentEmotion(_ emotion: SinaEmotion?) {
        let XFRecentEmotionsPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? "").appendingPathComponent("emotions.archive").absoluteString
        var recentEmotions = NSKeyedUnarchiver.unarchiveObject(withFile: XFRecentEmotionsPath) as? [AnyHashable]
        if recentEmotions == nil {
            recentEmotions = [AnyHashable]()
        }
        if let anEmotion = emotion {
            while let elementIndex = recentEmotions?.index(of: anEmotion) { recentEmotions?.remove(at: elementIndex) }
        }
        if let anEmotion = emotion {
            recentEmotions?.insert(anEmotion, at: 0)
        }
        if let anEmotions = recentEmotions {
            NSKeyedArchiver.archiveRootObject(anEmotions, toFile: XFRecentEmotionsPath)
        }
    }
    /*返回装着XFEmotion模型的数组*/
    class func recentEmotions() -> [SinaEmotion] {
        let XFRecentEmotionsPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? "").appendingPathComponent("emotions.archive").absoluteString
        var recentEmotions = NSKeyedUnarchiver.unarchiveObject(withFile: XFRecentEmotionsPath) as? [SinaEmotion]
        if recentEmotions == nil {
            recentEmotions = [SinaEmotion]()
        }
        return recentEmotions!
    }
    func isEqual(_ other: SinaEmotion?) -> Bool {
        return (chs == other?.chs) || (code == other?.code)
    }
}
class SinaEmotionListView: UIView, UIScrollViewDelegate {
    /** 表情(里面存放的XFEmotion模型) */
    var emotions = [SinaEmotion]()
    var scrollView: UIScrollView = UIScrollView()
    var pageControl: UIPageControl = UIPageControl()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        addSubview(scrollView)
        pageControl.hidesForSinglePage = true
        pageControl.isUserInteractionEnabled = false
        //私有属性，使用KVC赋值
        pageControl.setValue(UIImage(named: "compose_keyboard_dot_normal"), forKeyPath: "_pageImage")
        pageControl.setValue(UIImage(named: "compose_keyboard_dot_selected"), forKeyPath: "_currentPageImage")
        addSubview(pageControl)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 根据emotions，创建对应个数的表情
    func setEmotions(_ emotions: [SinaEmotion]) {
        self.emotions = emotions
        for v in scrollView.subviews{
            v.removeFromSuperview()
        }
        let count: Int = (emotions.count + 20 - 1) / 20
        pageControl.numberOfPages = count
        for i in 0..<pageControl.numberOfPages {
            let pageView = SinaEmotionPageView(frame: CGRect.zero)
            let start = i * 20
            var len = emotions.count - start
            if len >= 20 {
                len = 20
            }
            var temp = [SinaEmotion]()
            for i in start..<start + len{
                temp.append(emotions[i])
            }
            pageView.emotions = temp
            scrollView.addSubview(pageView)
        }
        setNeedsLayout()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        pageControl.frame = CGRect(x: 0, y: frameHeight - pageControl.frameHeight, width: frame.size.width, height: 35)
        scrollView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: pageControl.frameY)
        let count: Int = scrollView.subviews.count
        for i in 0..<count {
            let pageView = scrollView.subviews[i] as? SinaEmotionPageView
            pageView?.frame = CGRect(x: CGFloat(i) * (pageView?.frame.size.width)!, y: 0, width: scrollView.frame.size.width, height: scrollView.frameHeight)
        }
        scrollView.contentSize = CGSize(width: CGFloat(count) * scrollView.frame.size.width, height: 0)
    }
    // MARK: - scrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNum = Double(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNum + 0.5)
    }
}
class SinaEmotionTextView: UITextView {
    var placeholder = ""
    var placeholderColor: UIColor = .red
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textDidChange), name: UITextView.textDidChangeNotification, object: self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func textDidChange() {
        setNeedsDisplay()
    }
    override func draw(_ rect: CGRect) {
        if hasText {
            return
        }
        let x: CGFloat = 5
        let w: CGFloat = rect.size.width - 2 * x
        let y: CGFloat = 8
        let h: CGFloat = rect.size.height - 2 * y
        let placeholderRect = CGRect(x: x, y: y, width: w, height: h)
        placeholder.draw(in: placeholderRect, withAttributes:[NSAttributedString.Key.foregroundColor:UIColor.red])
    }
    func insert(_ emotion: SinaEmotion) {
        if emotion.code != "" {
            insertText(emotion.code.emoji() ?? "")
        } else if emotion.png != "" {
            let attch = SinaEmotionAttachment()
            attch.emotion = emotion
            attch.image = UIImage(named: emotion.png )
            let attchWH: CGFloat = font!.lineHeight
            attch.bounds = CGRect(x: 0, y: -4, width: attchWH, height: attchWH)
            let imageStr = NSAttributedString(attachment: attch)
            let attributedText = NSMutableAttributedString()
            //拼接之前的文件
            if let aText = self.attributedText {
                attributedText.append(aText)
            }
            let loc = Int(selectedRange.location)
            //[attributedText insertAttributedString:text atIndex:loc];
            attributedText.replaceCharacters(in: selectedRange, with: imageStr)
            selectedRange = NSRange(location: loc + 1, length: 0)
        }
    }
    func fullText() -> String {
        var fullText = ""
        // 遍历所有的属性文字（图片、emoji、普通文字）
        attributedText?.enumerateAttributes(in: NSRange(location: 0, length: attributedText?.length ?? 0), options: [], using: { attrs, range, stop in
            let attch = attrs[NSAttributedString.Key.attachment] as? SinaEmotionAttachment
            if attch != nil {
                // 图片
                fullText += attch?.emotion?.chs ?? ""
            } else {
                let str: NSAttributedString? = self.attributedText?.attributedSubstring(from: range)
                fullText += str?.string ?? ""
            }
        })
        return fullText
    }
}
class SinaEmotionTabBar: UIView {
    var didSelectBlock: ((_ buttonType: Int) -> Void)?
    var selectedBtn: UIButton?
    override init(frame: CGRect) {
        super.init(frame: frame)
        _ = setupBtn("最近", buttonType: 0)
        _ = setupBtn("默认", buttonType: 1)
        _ = setupBtn("Emoji", buttonType: 2)
        _ = setupBtn("浪小花", buttonType: 3)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupBtn(_ title: String?, buttonType: Int) -> UIButton? {
        let btn = UIButton()
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .disabled)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(self.btnClick(_:)), for: .touchDown)
        btn.tag = buttonType
        btn.setTitle(title, for: .normal)
        addSubview(btn)
        if buttonType == 1 {
            btnClick(btn)
        }
        var image = "compose_emotion_table_mid_normal"
        var selectImage = "compose_emotion_table_mid_selected"
        if subviews.count == 1 {
            image = "compose_emotion_table_left_normal"
            selectImage = "compose_emotion_table_left_selected"
        } else if subviews.count == 4 {
            image = "compose_emotion_table_right_normal"
            selectImage = "compose_emotion_table_right_selected"
        }
        btn.setBackgroundImage(UIImage(named: image), for: .normal)
        btn.setBackgroundImage(UIImage(named: selectImage), for: .disabled)
        return btn
    }
    /*按钮点击*/
    @objc func btnClick(_ btn: UIButton?) {
        selectedBtn?.isEnabled = true
        btn?.isEnabled = false
        selectedBtn = btn
        if let block = didSelectBlock {
            block((btn?.tag)!)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let btnCount = subviews.count
        let btnW = frame.size.width / CGFloat(btnCount)
        for i in 0..<btnCount {
            let btn: UIButton? = subviews[i] as? UIButton
            btn?.frame = CGRect(x: CGFloat(i) * btnW, y: 0, width: btnW, height: frameHeight)
        }
    }
}
class SinaEmotionPageView: UIView {
    var emotions = [SinaEmotion]()
    var deleteButton: UIButton = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        deleteButton.setImage(UIImage(named: "compose_emotion_delete_highlighted"), for: .highlighted)
        deleteButton.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
        deleteButton.addTarget(self, action: #selector(self.deleteClick), for: .touchUpInside)
        addSubview(deleteButton)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setEmotions(_ emotions: [SinaEmotion]) {
        self.emotions = emotions
        let count: Int? = emotions.count
        for i in 0..<(count ?? 0) {
            let btn = SinaEmotionButton()
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            btn.adjustsImageWhenHighlighted = false
            addSubview(btn)
            btn.emotion = emotions[i]
            if btn.emotion!.png != ""{// 有图片
                btn.setImage(UIImage(named: (btn.emotion?.png)!), for: .normal)
            } else if btn.emotion!.code != "" {// 是emoji表情
                btn.setTitle(btn.emotion?.chs, for: .normal)
            }
            btn.addTarget(self, action: #selector(self.btnClick(_:)), for: .touchUpInside)
        }
    }
    //监听删除按钮点击
    @objc func deleteClick() {
        NotificationCenter.default.post(name: NSNotification.Name("EmotionDidDeleteNotification"), object: nil)
    }
    @objc func btnClick(_ btn: SinaEmotionButton?) {
        SinaEmotion.addRecentEmotion(btn?.emotion)
        var userInfo = [AnyHashable: Any]()
        if let anEmotion = btn?.emotion {
            userInfo["SelectEmotionKey"] = anEmotion
        }
        NotificationCenter.default.post(name: NSNotification.Name("EmotionDidSelectNotification"), object: nil, userInfo: userInfo)
    }
    override  func layoutSubviews() {
        super.layoutSubviews()
        let inset: CGFloat = 20
        let count = emotions.count
        let btnw: CGFloat = (frame.size.width - 2 * inset) / 7
        let btnH: CGFloat = (frameHeight - inset) / 3
        for i in 0..<count {
            let btn: UIButton? = subviews[i + 1] as? UIButton
            btn?.frame = CGRect(x: inset + CGFloat(i % 7) * btnw, y: inset + CGFloat(i / 7) * btnH, width: btnw, height: btnH)
        }
        deleteButton.frame = CGRect(x: frame.size.width - inset - btnw, y: frameHeight - btnH, width: btnw, height: btnH)
    }
}
class SinaComposeToolbar: UIView {
    var emotionButton: UIButton?
    var didClickBlock: ((_ buttonType: Int) -> Void)?
    /** 是否要显示键盘按钮  */
    var showKeyboardButton = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let aNamed = UIImage(named: "compose_toolbar_background") {
            backgroundColor = UIColor(patternImage: aNamed)
        }
        _ = setupBtn("compose_camerabutton_background", highImage: "emoticonkeyboardbutton_sd", type: 0)
        _ = setupBtn("u_album_gray", highImage: "u_album_y", type: 1)
        _ = setupBtn("compose_mentionbutton_background", highImage: "emoticonkeyboardbutton_sd", type: 2)
        _ = setupBtn("compose_trendbutton_background", highImage: "emoticonkeyboardbutton_sd", type: 3)
        _ = emotionButton = setupBtn("emoticonkeyboardbutton", highImage: "emoticonkeyboardbutton_sd", type: 4)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*创建一个按钮*/
    func setupBtn(_ image: String, highImage: String, type: Int) -> UIButton {
        let btn = UIButton()
        btn.setImage(UIImage(named: image ), for: .normal)
        btn.setImage(UIImage(named: highImage ), for: .highlighted)
        btn.addTarget(self, action: #selector(self.btnClick(_:)), for: .touchUpInside)
        btn.tag = type
        addSubview(btn)
        return btn
    }
    @objc func btnClick(_ btn: UIButton?) {
        if let block = didClickBlock {
            block((btn?.tag)!)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let count = subviews.count
        let btnW = CGFloat(frame.size.width / CGFloat(count))
        let btnH = frameHeight
        for i in 0..<count {
            let btn: UIButton? = subviews[i] as? UIButton
            btn?.frame = CGRect(x: CGFloat(i) * btnW, y: 0, width: btnW, height: btnH)
        }
    }
}
class SinaEmotionKeyboard: UIView {
    /** 保存正在显示listView */
    var showingListView: SinaEmotionListView = SinaEmotionListView()
    /** 表情内容 */
    var recentListView: SinaEmotionListView = SinaEmotionListView()
    var defaultListView: SinaEmotionListView = SinaEmotionListView()
    var emojiListView: SinaEmotionListView = SinaEmotionListView()
    var lxhListView: SinaEmotionListView = SinaEmotionListView()
    /** tabbar */
    var tabBar: SinaEmotionTabBar = SinaEmotionTabBar()
    override init(frame: CGRect) {
        super.init(frame: frame)
        //加载沙盒中的数据
        recentListView.emotions = SinaEmotion.recentEmotions()
        let path = Bundle.main.path(forResource: "defaltEmoji.plist", ofType: nil)
        defaultListView.emotions = SinaEmotion.mj_objectArray(withKeyValuesArray: NSArray(contentsOfFile: path ?? "")) as! [SinaEmotion]
        let path1 = Bundle.main.path(forResource: "SinaEmoji.plist", ofType: nil)
        emojiListView.emotions = SinaEmotion.mj_objectArray(withKeyValuesArray: NSArray(contentsOfFile: path1 ?? "")) as! [SinaEmotion]
        let path2 = Bundle.main.path(forResource: "lxhEmoji.plist", ofType: nil)
        lxhListView.emotions = SinaEmotion.mj_objectArray(withKeyValuesArray: NSArray(contentsOfFile: path2 ?? "")) as! [SinaEmotion]
        tabBar.didSelectBlock = { buttonType in
            self.showingListView.removeFromSuperview()
            switch buttonType {
            case 0:self.addSubview(self.defaultListView)
            case 1:self.addSubview(self.lxhListView)
            case 2:self.addSubview(self.emojiListView)
            case 3:self.addSubview(self.recentListView)
            default: break
            }
            self.showingListView = self.subviews.last as! SinaEmotionListView
            // 重新计算子控件的frame(setNeedsLayout内部会在恰当的时刻，重新调用layoutSubviews，重新布局子控件)
            self.setNeedsLayout()
        }
        tabBar.btnClick(tabBar.viewWithTag(1) as? UIButton)
        self.addSubview(tabBar)
        // 表情选中的通知
        NotificationCenter.default.addObserver(self, selector: #selector(self.emotionDidSelect), name: NSNotification.Name("EmotionDidSelectNotification"), object: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func emotionDidSelect() {
        recentListView.emotions = SinaEmotion.recentEmotions()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        tabBar.frame = CGRect(x: 0, y: frameHeight - tabBar.frameHeight, width: frame.size.width, height: 37)
        showingListView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: tabBar.frameY)
    }
}
