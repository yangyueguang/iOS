//
//  Extensions.swift
//  Douyin
//
//  Created by Chao Xue 薛超 on 2018/11/26.
//  Copyright © 2018 Qiao Shi. All rights reserved.
//
extension String {

    func substring(location index:Int, length:Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(self.startIndex, offsetBy: index + length)
            let subString = self[startIndex..<endIndex]
            return String(subString)
        } else {
            return self
        }
    }

    func substring(range:NSRange) -> String {
        if self.count > range.location {
            let startIndex = self.index(self.startIndex, offsetBy: range.location)
            let endIndex = self.index(self.startIndex, offsetBy: range.location + range.length)
            let subString = self[startIndex..<endIndex]
            return String(subString)
        } else {
            return self
        }
    }

    func md5() -> String {
        let cStrl = cString(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue));
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16);
        CC_MD5(cStrl, CC_LONG(strlen(cStrl!)), buffer);
        var md5String = "";
        for idx in 0...15 {
            let obcStrl = String.init(format: "%02x", buffer[idx]);
            md5String.append(obcStrl);
        }
        free(buffer);
        return md5String;
    }

    func urlScheme(scheme:String) -> URL? {
        if let url = URL.init(string: self) {
            var components = URLComponents.init(url: url, resolvingAgainstBaseURL: false)
            components?.scheme = scheme
            return components?.url
        }
        return nil
    }

    static func format(decimal:Float, _ maximumDigits:Int = 1, _ minimumDigits:Int = 1) ->String? {
        let number = NSNumber(value: decimal)
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = maximumDigits //设置小数点后最多2位
        numberFormatter.minimumFractionDigits = minimumDigits //设置小数点后最少2位（不足补0）
        return numberFormatter.string(from: number)
    }

    static func formatCount(count:NSInteger) -> String {
        if count < 10000  {
            return String.init(count)
        } else {
            return (String.format(decimal: Float(count)/Float(10000)) ?? "0") + "w"
        }
    }



    func singleLineSizeWithText(font:UIFont) -> CGSize {
        return self.size(withAttributes: [NSAttributedString.Key.font : font])
    }

    func singleLineSizeWithAttributeText(font:UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font:font]
        let attString = NSAttributedString(string: self,attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attString)
        return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0,length: 0), nil, CGSize(width: Double.greatestFiniteMagnitude, height: Double.greatestFiniteMagnitude), nil)
    }
}

extension UIImage {

    func drawRoundedRectImage(cornerRadius:CGFloat, width:CGFloat, height:CGFloat) -> UIImage? {
        let size = CGSize.init(width: width, height: height)
        let rect = CGRect.init(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()
        context?.addPath(UIBezierPath.init(roundedRect: rect, cornerRadius: cornerRadius).cgPath)
        context?.clip()
        self.draw(in: rect)
        context?.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output
    }

    func drawCircleImage() -> UIImage? {
        let side = min(self.size.width, self.size.height)
        let size = CGSize.init(width: side, height: side)
        let rect = CGRect.init(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()
        context?.addPath(UIBezierPath.init(roundedRect: rect, cornerRadius: side).cgPath)
        context?.clip()
        self.draw(in: rect)
        context?.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output
    }

}

extension UIWindow {
    static var tipsKey = "tipsKey"
    static var tips:UITextView? {
        get{
            return objc_getAssociatedObject(self, &UIWindow.tipsKey) as? UITextView
        }
        set {
            objc_setAssociatedObject(self, &UIWindow.tipsKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    static var tapKey = "tapKey"
    static var tap:UITapGestureRecognizer? {
        get{
            return objc_getAssociatedObject(self, &UIWindow.tapKey) as? UITapGestureRecognizer
        }
        set {
            objc_setAssociatedObject(self, &UIWindow.tapKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }


    static func showTips(text:String) {
        if tips != nil {
            dismiss()
        }
        Thread.sleep(forTimeInterval: 0.5)

        let window = UIApplication.shared.delegate?.window as? UIWindow
        let maxWidth:CGFloat = 200
        let maxHeight:CGFloat = window?.frame.size.height ?? 0 - 200
        let commonInset:CGFloat = 10

        let font = UIFont.systemFont(ofSize: 12)
        let string = NSMutableAttributedString.init(string: text)
        string.addAttributes([.font:font], range: NSRange.init(location: 0, length: string.length))

        let rect = string.boundingRect(with: CGSize.init(width: maxWidth, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        let size = CGSize.init(width: CGFloat(ceilf(Float(rect.size.width))), height: CGFloat(ceilf(rect.size.height < maxHeight ? Float(rect.size.height) : Float(maxHeight))))

        let textFrame = CGRect.init(x: (window?.frame.size.width ?? 0)/2 - size.width/2 - commonInset, y: (window?.frame.size.height ?? 0) - size.height/2 - commonInset - 100, width: size.width  + commonInset * 2, height: size.height + commonInset * 2)

        let textView = UITextView.init(frame: textFrame)
        textView.text = text
        textView.font = font
        textView.textColor = UIColor.white
        textView.backgroundColor = UIColor.black
        textView.layer.cornerRadius  = 5
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.contentInset = UIEdgeInsets.init(top: commonInset, left: commonInset, bottom: commonInset, right: commonInset)

        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(handlerGuesture(sender:)))
        window?.addGestureRecognizer(tapGesture)

        window?.addSubview(textView)

        tips = textView
        tap = tapGesture

        self.perform(#selector(dismiss), with: nil, afterDelay: 2.0)
    }

    @objc static func handlerGuesture(sender: UIGestureRecognizer) {
        dismiss()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(dismiss), object: nil)
    }

    @objc static func dismiss() {
        if let tapGesture = tap {
            let window = UIApplication.shared.delegate?.window as? UIWindow
            window?.removeGestureRecognizer(tapGesture)
        }
        UIView.animate(withDuration: 0.25, animations: {
            tips?.alpha = 0.0
        }) { finished in
            tips?.removeFromSuperview()
        }
    }
}

extension Data
{
    func subdata(in range: CountableClosedRange<Data.Index>) -> Data {
        return self.subdata(in: range.lowerBound..<range.upperBound + 1)
    }
}

extension NSAttributedString {
    func multiLineSize(width:CGFloat) -> CGSize {
        let rect = self.boundingRect(with: CGSize.init(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return CGSize.init(width: rect.size.width, height: rect.size.height)
    }
}

extension Notification {

    func keyBoardHeight() -> CGFloat {
        if let userInfo = self.userInfo {
            if let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let size = value.cgRectValue.size
                return UIInterfaceOrientation.portrait.isLandscape ? size.width : size.height
            }
        }
        return 0
    }

}

extension Date {
    static func formatTime(timeInterval:TimeInterval) -> String {
        let date = Date.init(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter.init()
        if date.isToday() {
            if date.isJustNow() {
                return "刚刚"
            } else {
                formatter.dateFormat = "HH:mm"
                return formatter.string(from: date)
            }
        } else {
            if date.isYestoday() {
                formatter.dateFormat = "昨天HH:mm"
                return formatter.string(from: date)
            } else if date.isCurrentWeek() {
                formatter.dateFormat = date.dateToWeekday() + "HH:mm"
                return formatter.string(from: date)
            } else {
                if date.isCurrentYear() {
                    formatter.dateFormat = "MM-dd  HH:mm"
                } else {
                    formatter.dateFormat = "yy-MM-dd  HH:mm"
                }
                return formatter.string(from: date)
            }
        }
    }

    func isJustNow() -> Bool {
        let now = Date.init().timeIntervalSince1970
        return fabs(now - self.timeIntervalSince1970) < 60 * 2 ? true : false
    }

    func isCurrentWeek() -> Bool {
        let nowDate = Date.init().dateFormatYMD()
        let selfDate = self.dateFormatYMD()
        let calendar = Calendar.current
        let cmps = calendar.dateComponents([.day], from: selfDate, to: nowDate)
        return cmps.day ?? 0 <= 7
    }

    func isCurrentYear() -> Bool {
        let calendar = Calendar.current
        let nowComponents = calendar.dateComponents([.year], from: Date.init())
        let selfComponents = calendar.dateComponents([.year], from: self)
        return selfComponents.year == nowComponents.year
    }

    func dateToWeekday() -> String {
        let weekdays = ["", "星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        var calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let timeZone = TimeZone.init(identifier: "Asia/Shanghai")
        calendar.timeZone = timeZone!
        let theComponents = calendar.dateComponents([.weekday], from: self)
        return weekdays[theComponents.weekday ?? 0]
    }

    func isToday() -> Bool {
        let calendar = Calendar.current
        let nowComponents = calendar.dateComponents([.day, .month, .year], from: Date.init())
        let selfComponents = calendar.dateComponents([.day, .month, .year], from: self)
        return nowComponents.year == selfComponents.year && nowComponents.month == selfComponents.month && nowComponents.day == selfComponents.day
    }

    func isYestoday() -> Bool {
        let nowDate = Date.init().dateFormatYMD()
        let selfDate = self.dateFormatYMD()
        let calendar = Calendar.current
        let cmps = calendar.dateComponents([.day], from: selfDate, to: nowDate)
        return cmps.day == 1
    }

    func dateFormatYMD() -> Date {
        let fmt = DateFormatter.init()
        fmt.dateFormat = "yyyy-MM-dd"
        let selfStr = fmt.string(from: self)
        return fmt.date(from: selfStr)!
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

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

typealias WebImageProgressBlock = (_ percent:Float) -> Void
typealias WebImageCompletedBlock = (_ image:UIImage?, _ error:Error?) -> Void
typealias WebImageCanceledBlock = () -> Void


extension UIImageView {
    static var operationKey = "operationKey"
    var operation:WebCombineOperation? {
        get{
            return objc_getAssociatedObject(self, &UIImageView.operationKey) as? WebCombineOperation
        }
        set {
            objc_setAssociatedObject(self, &UIImageView.operationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    func setImageWithURL(imageUrl:URL, completed: WebImageCompletedBlock?) {
        self.setImageWithURL(imageUrl: imageUrl, progress: nil, completed: completed, cancel: nil)
    }

    func setImageWithURL(imageUrl:URL, progress:WebImageProgressBlock?, completed: WebImageCompletedBlock?) {
        self.setImageWithURL(imageUrl: imageUrl, progress: progress, completed: completed, cancel: nil)
    }

    func setImageWithURL(imageUrl:URL, progress:WebImageProgressBlock?, completed: WebImageCompletedBlock?, cancel:WebImageCanceledBlock?) {
        self.cancelOperation()
        operation = WebDownloader.shared().dowload(url: imageUrl, progress: { (receivedSize, expectedSize) in
            DispatchQueue.main.async {
                progress?(Float(receivedSize)/Float(expectedSize))
            }
        }, completed: { (data, error, finished) in
            var image:UIImage?
            if finished && data != nil {
                image = UIImage.init(data: data!)
            }
            DispatchQueue.main.async {
                completed?(image, error)
            }
        }) {
            cancel?()
        }
    }

    func setWebPImageWithURL(imageUrl:URL, completed: WebImageCompletedBlock?) {
        self.setWebPImageWithURL(imageUrl: imageUrl, progress: nil, completed: completed, cancel: nil)
    }

    func setWebPImageWithURL(imageUrl:URL, progress:WebImageProgressBlock?, completed: WebImageCompletedBlock?) {
        self.setWebPImageWithURL(imageUrl: imageUrl, progress: progress, completed: completed, cancel: nil)
    }

    func setWebPImageWithURL(imageUrl:URL, progress:WebImageProgressBlock?, completed:WebImageCompletedBlock?, cancel:WebImageCanceledBlock?) {
        self.cancelOperation()
        operation = WebDownloader.shared().dowload(url: imageUrl, progress: { (receivedSize, expectedSize) in
            DispatchQueue.main.async {
                progress?(Float(receivedSize/expectedSize))
            }
        }, completed: { (data, error, finished) in
            var image:WebPImage?
            if finished && data != nil {
                image = WebPImage.init(data: data!)
            }
            DispatchQueue.main.async {
                completed?(image, error)
            }
        }) {
            cancel?()
        }
    }

    func cancelOperation() {
        operation?.cancel()
    }
}

extension Array {
    mutating func removeAtIndexes (indexs:[Int]) -> () {
        for index in indexs.sorted(by: >) {
            self.remove(at: index)
        }
    }
}
