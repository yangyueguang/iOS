//
//  TipViewController.swift
//  iTour
//
//  Created by Super on 2017/10/31.
//  Copyright © 2017年 Croninfo. All rights reserved.
//
import UIKit
import QuartzCore

@objcMembers
public class TipView: UIView {
    var clipRect = CGRect.zero

    init(clipRect rect: CGRect, tip trect: CGRect, direction: Int, percent p: CGFloat, text: String) {
        super.init(frame: UIScreen.main.bounds)
        clipRect = rect
        backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
        let tipL = UILabel(frame: trect)
        tipL.layer.cornerRadius = 5
        tipL.clipsToBounds = true
        tipL.backgroundColor = UIColor.white
        tipL.font = UIFont.systemFont(ofSize: 18)
        tipL.textAlignment = .center
        tipL.textColor = UIColor(white: 0.25, alpha: 1)
        tipL.text = text
        var origin = CGPoint(x: 0, y: 0)
        switch direction {
        case 1:
            origin.x = trect.origin.x + trect.size.width * p - 6
            origin.y = trect.origin.y - 11
        case 2:
            origin.x = trect.origin.x + trect.size.width
            origin.y = trect.origin.y + trect.size.height * p - 9
        case 3:
            origin.x = trect.origin.x + trect.size.width * p - 6
            origin.y = trect.origin.y + trect.size.height - 8
        default:
            origin.x = trect.origin.x - 11
            origin.y = trect.origin.y + trect.size.height * p - 9
        }
        let arrow = UIImageView(frame: CGRect(x: origin.x, y: origin.y, width: 11, height: 18))
        arrow.contentMode = .center
        arrow.image = UIImage(named: "WhiteArroy")
        arrow.transform = CGAffineTransform(rotationAngle: CGFloat(.pi/2 * Double(direction)))
        addSubview(tipL)
        addSubview(arrow)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func draw(_ rect: CGRect) {
        let context: CGContext = UIGraphicsGetCurrentContext()!
        let backgroundimage: CGImage = context.makeImage()!
        context.clear(rect)
        let radius: CGFloat = 10
        let x1: CGFloat = clipRect.origin.x
        let y1: CGFloat = clipRect.origin.y
        let x2: CGFloat = x1 + clipRect.size.width
        let y3: CGFloat = y1 + clipRect.size.height
        context.move(to: CGPoint(x: x1, y: y1 + radius))
        context.addArc(tangent1End: CGPoint(x:x1, y:y1), tangent2End: CGPoint(x: x1 + radius, y:y1), radius: radius)
        context.addArc(tangent1End: CGPoint(x:x2, y:y1), tangent2End: CGPoint(x:x2, y: y1 + radius), radius: radius)
        context.addArc(tangent1End: CGPoint(x:x2, y:y3), tangent2End: CGPoint(x: x2 - radius, y:y3), radius: radius)
        context.addArc(tangent1End: CGPoint(x:x1, y:y3), tangent2End: CGPoint(x: x1, y: y3 - radius), radius: radius)
        context.closePath()
        context.addRect(context.boundingBoxOfClipPath)
        context.clip(using: .evenOdd)
        let maskImage: CGImage = context.makeImage()!
        let mask: CGImage = CGImage(maskWidth: maskImage.width, height:maskImage.height, bitsPerComponent: maskImage.bitsPerComponent, bitsPerPixel:maskImage.bitsPerPixel, bytesPerRow: maskImage.bytesPerRow, provider:maskImage.dataProvider!, decode: nil, shouldInterpolate: false)!
        let masked: CGImage = backgroundimage.masking(mask)!
        context.clear(rect)
        context.draw(masked, in: rect)
    }
}

@objcMembers
public class XTip: UIViewController {
    var index: Int = 0
    var didClickedOverBlock: ((_ index: Int) -> Bool)? = nil
    var tipViewBlock: ((_ index: Int) -> TipView)?
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        index = 0
        show()
    }

    func show() {
        let modalState: TipView = tipViewBlock!(index)
        view.addSubview(modalState)
        modalState.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:))))
    }
    
    func tapAction(_ sender:UITapGestureRecognizer){
        index += 1
        if self.didClickedOverBlock!(self.index) {
            self.dismiss(animated: false, completion: {() -> Void in
            })
        }else{
            sender.view?.removeFromSuperview()
            self.show()
        }
    }
}
