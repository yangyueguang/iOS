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
    case `default`
    case fill
}

class WXTableViewCell: UITableViewCell {
    var leftSeparatorSpace: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    var rightSeparatorSpace: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    var topLineStyle: TLCellLineStyle = .none {
        didSet {
             setNeedsDisplay()
        }
    }
    var bottomLineStyle: TLCellLineStyle = .none {
        didSet {
            setNeedsDisplay()
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        leftSeparatorSpace = 15.0
        topLineStyle = .none
        bottomLineStyle = .default
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(1 * 2)
        context.setStrokeColor(UIColor.gray.cgColor)
        if topLineStyle != .none {
            context.beginPath()
            let startX: CGFloat = topLineStyle == .fill ? 0 : leftSeparatorSpace
            let endX: CGFloat = frame.size.width - rightSeparatorSpace
            let y: CGFloat = 0
            context.move(to: CGPoint(x: startX, y: y))
            context.addLine(to: CGPoint(x: endX, y: y))
            context.strokePath()
        }
        if bottomLineStyle != .none {
            context.beginPath()
            let startX: CGFloat = bottomLineStyle == .fill ? 0 : leftSeparatorSpace
            let endX: CGFloat = frame.size.width - rightSeparatorSpace
            let y = frame.size.height
            context.move(to: CGPoint(x: startX, y: y))
            context.addLine(to: CGPoint(x: endX, y: y))
            context.strokePath()
        }
    }
}
