//
//  UILabel+TapAction.swift
//  SOKit
//
//  Created by Chao Xue 薛超 on 2018/10/30.
//  Copyright © 2018年 Xuechao. All rights reserved.
//  给UILabel添加字符串点击响应
import UIKit

private class AttributeModel {
    var range: NSRange?
    var str: String?
}

private var isTapAction: Bool?
private var attributeStrings: [AttributeModel]?
private var tapBlock: ((_ str: String, _ range: NSRange, _ index: Int) -> Void)?
private var effectDic: Dictionary<String, NSAttributedString>?
private var isTapEffect = true

public extension UILabel {
    /// 是否打开点击效果，默认是打开
    var isTapEffectEnabled: Bool {
        set { isTapEffect = newValue }
        get { return isTapEffect }
    }

    /// 给文本添加点击事件
    func addAttributeTapAction( _ strings: [String], tapAction: @escaping ((String, NSRange, Int) -> Void)) -> Void {
        tapBlock = tapAction
        if self.attributedText?.length == 0 { return }
        self.isUserInteractionEnabled = true
        isTapAction = true
        var totalString = self.attributedText?.string
        attributeStrings = []
        for str: String in strings {
            let range = totalString?.range(of: str)
            guard range?.lowerBound != nil else { return }

            var replacedString = ""
            for _ in 0..<str.count {
                replacedString = replacedString + " "
            }
            totalString = totalString?.replacingCharacters(in: range!, with: replacedString)
            let model = AttributeModel()
            let targetRange = { (string: String, range: Range<String.Index>?) -> NSRange in
                guard let from = range?.lowerBound.samePosition(in: string.utf16),
                    let to = range?.upperBound.samePosition(in: string.utf16) else { return NSRange() }
                let location = string.utf16.distance(from: string.utf16.startIndex, to: from)
                let lenth = string.utf16.distance(from: from, to: to)
                return NSRange(location: location, length: lenth)
            }
            model.range = targetRange(totalString!, range)
            model.str = str
            attributeStrings?.append(model)
        }
    }
    
    // MARK: - touchActions
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTapAction == false { return }
        let touch = touches.first
        let point = touch?.location(in: self)
        getTapFrame(point!) { (String, NSRange, Int) -> Void in
            if tapBlock != nil { tapBlock! (String, NSRange , Int) }
            if (isTapEffect && NSRange.location != NSNotFound) {
                effectDic = [:]
                let subAttribute = self.attributedText?.attributedSubstring(from: NSRange)
                _ = effectDic?.updateValue(subAttribute!, forKey: NSStringFromRange(NSRange))
                self.tapEffectWithStatus(true)
            }
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTapEffect {
            self.performSelector(onMainThread: #selector(self.tapEffectWithStatus(_:)), with: nil, waitUntilDone: false)
        }
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        if isTapEffect {
            self.performSelector(onMainThread: #selector(self.tapEffectWithStatus(_:)), with: nil, waitUntilDone: false)
        }
    }
    
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if isTapAction == true {
            let result = getTapFrame(point) { (String, NSRange, Int) -> Void in }
            if result == true { return self }
        }
        return super.hitTest(point, with: event)
    }

    @discardableResult
    private func getTapFrame(_ point: CGPoint , result: ((_ str: String ,_ range: NSRange, _ index: Int) -> Void)) -> Bool {
        let framesetter = CTFramesetterCreateWithAttributedString(self.attributedText!)
        var path = CGMutablePath()
        path.addRect(self.bounds, transform: CGAffineTransform.identity)
        var frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        let range = CTFrameGetVisibleStringRange(frame)
        if let lenth = self.attributedText?.length, lenth > range.length {
            var m_font : UIFont
            let n_font = self.attributedText?.attribute(NSAttributedString.Key.font, at: 0, effectiveRange: nil)
            if n_font != nil {
                m_font = n_font as! UIFont
            }else if (self.font != nil) {
                m_font = self.font
            }else {
                m_font = UIFont.systemFont(ofSize: 17)
            }
            path = CGMutablePath()
            path.addRect(CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height + m_font.lineHeight), transform: CGAffineTransform.identity)
            frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        }
        let lines = CTFrameGetLines(frame)
        if lines == [] as CFArray { return false }
        let count = CFArrayGetCount(lines)
        var origins = [CGPoint](repeating: CGPoint.zero, count: count)
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &origins)
        let transform = CGAffineTransform(translationX: 0, y: self.bounds.size.height).scaledBy(x: 1.0, y: -1.0);
        let verticalOffset = 0.0
        for i : CFIndex in 0..<count {
            let linePoint = origins[i]
            let line = CFArrayGetValueAtIndex(lines, i)
            let lineRef = unsafeBitCast(line,to: CTLine.self)

            var ascent: CGFloat = 0.0;
            var descent: CGFloat = 0.0;
            var leading: CGFloat = 0.0;
            let width = CTLineGetTypographicBounds(lineRef, &ascent, &descent, &leading)
            let height = ascent + abs(descent) + leading
            let flippedRect = CGRect(x: linePoint.x, y: linePoint.y , width: CGFloat(width), height: height)

            var rect = flippedRect.applying(transform)
            rect = rect.insetBy(dx: 0, dy: 0)
            rect = rect.offsetBy(dx: 0, dy: CGFloat(verticalOffset))
            let style = self.attributedText?.attribute(NSAttributedString.Key.paragraphStyle, at: 0, effectiveRange: nil)
            let lineSpace : CGFloat = style != nil ? (style as! NSParagraphStyle).lineSpacing: 0.0
            let lineOutSpace = (CGFloat(self.bounds.size.height) - CGFloat(lineSpace) * CGFloat(count - 1) - CGFloat(rect.size.height) * CGFloat(count)) / 2
            rect.origin.y = lineOutSpace + rect.size.height * CGFloat(i) + lineSpace * CGFloat(i)
            if rect.contains(point) {
                let relativePoint = CGPoint(x: point.x - rect.minX, y: point.y - rect.minY)
                var index = CTLineGetStringIndexForPosition(lineRef, relativePoint)
                var offset : CGFloat = 0.0
                CTLineGetOffsetForStringIndex(lineRef, index, &offset)
                if offset > relativePoint.x { index = index - 1 }
                let link_count = attributeStrings?.count
                for j in 0..<link_count! {
                    let model = attributeStrings![j]
                    let link_range = model.range
                    if NSLocationInRange(index, link_range!) {
                        result(model.str!,model.range!,j)
                        return true
                    }
                }
            }
        }
        return false
    }
    
    @objc private func tapEffectWithStatus(_ status: Bool) -> Void {
        if isTapEffect {
            let attStr = NSMutableAttributedString.init(attributedString: self.attributedText!)
            let subAtt = NSMutableAttributedString.init(attributedString: (effectDic?.values.first)!)
            let range = NSRangeFromString(effectDic!.keys.first!)
            if status {
                subAtt.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.lightGray, range: NSMakeRange(0, subAtt.length))
            }
            attStr.replaceCharacters(in: range, with: subAtt)
            self.attributedText = attStr
        }
    }
}
