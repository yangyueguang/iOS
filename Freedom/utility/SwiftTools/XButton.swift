//
import UIKit
@IBDesignable
class XButton: UIButton {
    private var titleSize = CGSize.zero
    private var imageSize = CGSize.zero
    @IBInspectable var direction: Int = 0
    @IBInspectable var interval: CGFloat  = 0
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        guard shouldLayout(contentRect) else {
            return super.titleRect(forContentRect: contentRect)
        }
        var targetRect:CGRect = CGRect.zero
        switch direction % 4 {
        case 0:
            targetRect = CGRect(x: (contentRect.width - titleSize.width)/2, y: (contentRect.height - titleSize.height - imageSize.height - interval)/2 + imageSize.height + interval, width: titleSize.width, height: titleSize.height)
        case 1:
            targetRect = CGRect(x: (contentRect.width - titleSize.width - imageSize.width - interval)/2, y: (contentRect.height - titleSize.height)/2, width: titleSize.width, height: titleSize.height)
        case 2:
            targetRect = CGRect(x: (contentRect.width - titleSize.width)/2, y: (contentRect.height - titleSize.height - imageSize.height - interval)/2, width: titleSize.width, height: titleSize.height)
        default:
            targetRect = CGRect(x: (contentRect.width - titleSize.width - imageSize.width - interval)/2 + imageSize.width + interval, y: (contentRect.height - titleSize.height)/2, width: titleSize.width, height: titleSize.height)
        }
        return targetRect
    }
  
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        guard shouldLayout(contentRect) else {
            return super.imageRect(forContentRect: contentRect)
        }
        var targetRect:CGRect = CGRect.zero
        switch direction % 4 {
        case 0:
            targetRect = CGRect.init(x: (contentRect.width - imageSize.width)/2, y: (contentRect.height - titleSize.height - imageSize.height - interval)/2, width: imageSize.width, height: imageSize.height)
        case 1:
            targetRect = CGRect.init(x: (contentRect.width - titleSize.width - imageSize.width - interval)/2 + titleSize.width + interval, y: (contentRect.height - imageSize.height)/2, width: imageSize.width, height: imageSize.height)
        case 2:
            targetRect = CGRect.init(x: (contentRect.width - imageSize.width)/2, y: (contentRect.height - titleSize.height - imageSize.height - interval)/2 + titleSize.height + interval, width: imageSize.width, height: imageSize.height)
        default:
            targetRect = CGRect.init(x: (contentRect.width - titleSize.width - imageSize.width - interval)/2, y: (contentRect.height - imageSize.height)/2, width: imageSize.width, height: imageSize.height)
        }
        return targetRect
    }

    private func shouldLayout(_ contentRect:CGRect) -> Bool {
        guard subviews.count > 1, let image = currentImage,let _ = currentTitle,let titleL = titleLabel,let _ = imageView else {
            return false
        }
        let titleFitSize = titleL.sizeThatFits(contentRect.size)
        titleL.numberOfLines = 0
        titleL.textAlignment = NSTextAlignment.center
        switch direction % 4 {
        case 1,3:
            imageSize.width = min(min(contentRect.height, contentRect.width - 20 - interval),image.size.width)
            imageSize.height = image.size.height * imageSize.width / image.size.width
            titleSize.width =  max(min(contentRect.width - imageSize.width - interval, titleFitSize.width), 20)
            titleSize.height = contentRect.height
        default:
            titleSize.height =  max(min(contentRect.height - image.size.height - interval, titleFitSize.height), 20)
            titleSize.width = min(contentRect.width, titleFitSize.width)
            imageSize.height = min(contentRect.height - titleFitSize.height, image.size.height)
            imageSize.width = image.size.width * imageSize.height / image.size.height
        }
        return true
    }
}
