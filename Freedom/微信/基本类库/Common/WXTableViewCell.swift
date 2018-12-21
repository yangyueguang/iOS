//
//  WXTableViewCell.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/19.
//  Copyright © 2018 薛超. All rights reserved.
//

import Foundation
enum TLCellLineStyle : Int {
    case none
    case default
    case fill
}

class WXTableViewCell: UITableViewCell {
    //左边距
    var leftSeparatorSpace: CGFloat = 0.0
    //右边距，默认0，要修改只能直接指定
    var rightSeparatorSpace: CGFloat = 0.0
    var topLineStyle: TLCellLineStyle
    var bottomLineStyle: TLCellLineStyle
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        leftSeparatorSpace = 15.0
        topLineStyle = TLCellLineStyleNone
        bottomLineStyle = TLCellLineStyleDefault

    }

    func setTopLineStyle(_ topLineStyle: TLCellLineStyle) {
        self.topLineStyle = topLineStyle
        setNeedsDisplay()
    }

    func setBottomLineStyle(_ bottomLineStyle: TLCellLineStyle) {
        self.bottomLineStyle = bottomLineStyle
        setNeedsDisplay()
    }

    func setLeftSeparatorSpace(_ leftSeparatorSpace: CGFloat) {
        self.leftSeparatorSpace = leftSeparatorSpace
        setNeedsDisplay()
    }

    func setRightSeparatorSpace(_ rightSeparatorSpace: CGFloat) {
        self.rightSeparatorSpace = rightSeparatorSpace
        setNeedsDisplay()
    }
    func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        context.setLineWidth(1 * 2)
        context.setStrokeColor(UIColor.gray.cgColor)
        if topLineStyle != TLCellLineStyleNone {
            context.beginPath()
            let startX: CGFloat = topLineStyle == TLCellLineStyleFill ? 0 : leftSeparatorSpace
            let endX: CGFloat = frame.size.width - rightSeparatorSpace
            let y: CGFloat = 0
            context.move(to: CGPoint(x: startX, y: y))
            context.addLine(to: CGPoint(x: endX, y: y))
            context.strokePath()
        }
        if bottomLineStyle != TLCellLineStyleNone {
            context.beginPath()
            let startX: CGFloat = bottomLineStyle == TLCellLineStyleFill ? 0 : leftSeparatorSpace
            let endX: CGFloat = frame.size.width - rightSeparatorSpace
            let y = frame.size.height
            context.move(to: CGPoint(x: startX, y: y))
            context.addLine(to: CGPoint(x: endX, y: y))
            context.strokePath()
        }
    }


    
}
