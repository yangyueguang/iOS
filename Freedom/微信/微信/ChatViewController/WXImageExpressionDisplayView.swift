//
//  WXImageExpressionDisplayView.swift
//  Freedom

import Foundation
class WXImageExpressionDisplayView: UIView {
    var emoji: TLEmoji
    var rect = CGRect.zero
    var bgLeftView: UIImageView
    var bgCenterView: UIImageView
    var bgRightView: UIImageView
    var imageView: UIImageView
    init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 150, height: 162))

        addSubview(bgLeftView)
        addSubview(bgCenterView)
        addSubview(bgRightView)
        if let aView = imageView {
            addSubview(aView)
        }
        p_addMasonry()

    }

    func display(_ emoji: TLEmoji, at rect: CGRect) {
        self.rect = rect
        self.emoji = emoji
    }

    private var curID = ""
    func setEmoji(_ emoji: TLEmoji) {
        if self.emoji == emoji {
            return
        }
        self.emoji = emoji
        curID = emoji.emojiID
        let data = NSData(contentsOfFile: emoji.emojiPath  "") as Data
        if data != nil {
            imageView.image = UIImage.sd_animatedGIF(with: data)
        } else {
            var urlString: String = nil
            if let anID = emoji.emojiID {
                urlString = "http://123.57.155.230:8080/ibiaoqing/admin/expre/download.dopId=\(anID)"
            }
            imageView.sd_setImage(with: URL(string: emoji.emojiURL  ""), completed: { image, error, cacheType, imageURL in
                if urlString.contains(curID)  false {
                    DispatchQueue.global(qos: .default).async(execute: {
                        var data: Data = nil
                        if let aString = URL(string: urlString  "") {
                            data = Data(contentsOf: aString)
                        }
                        if urlString.contains(curID) {
                            DispatchQueue.main.async(execute: {
                                self.imageView.image = UIImage.sd_animatedGIF(with: data)
                            })
                        }
                    })
                }
            })
        }
    }
    func setRect(_ rect: CGRect) {
        let frame: CGRect = self.frame
        frame.origin.y = rect.origin.y - self.frame.size.height + 13
        self.frame = frame
        let w: CGFloat = 150 - 25
        let centerX: CGFloat = rect.origin.x + rect.size.width / 2
        if rect.origin.x + rect.size.width < self.frame.size.width {
            // 箭头在左边
            center = CGPoint(x: centerX + (150 - w / 4 - 25) / 2 - 16, y: center.y)
            bgLeftView.mas_updateConstraints({ make in
                make.width.mas_equalTo(w / 4)
            })
        } else if APPW - rect.origin.x < self.frame.size.width {
            // 箭头在右边
            center = CGPoint(x: centerX - (150 - w / 4 - 25) / 2 + 16, y: center.y)
            bgLeftView.mas_updateConstraints({ make in
                make.width.mas_equalTo(w / 4 * 3)
            })
        } else {
            center = CGPoint(x: centerX, y: center.y)
            bgLeftView.mas_updateConstraints({ make in
                make.width.mas_equalTo(w / 2)
            })
        }
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func p_addMasonry() {
        bgLeftView.mas_makeConstraints({ make in
            make.top.and().left().and().bottom().mas_equalTo(self)
        })
        bgCenterView.mas_makeConstraints({ make in
            make.left.mas_equalTo(self.bgLeftView.mas_right)
            make.top.and().bottom().mas_equalTo(self.bgLeftView)
            make.width.mas_equalTo(25)
        })
        bgRightView.mas_makeConstraints({ make in
            make.left.mas_equalTo(self.bgCenterView.mas_right)
            make.top.and().bottom().mas_equalTo(self.bgLeftView)
            make.right.mas_equalTo(self)
        })
        imageView.mas_makeConstraints({ make in
            make.top.mas_equalTo(self).mas_offset(10)
            make.left.mas_equalTo(self).mas_offset(10)
            make.right.mas_equalTo(self).mas_offset(-10)
            make.height.mas_equalTo(self.imageView.mas_width)
        })
    }


    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    var imageView: UIImageView {
        if imageView == nil {
            imageView = UIImageView()
        }
        return imageView
    }

    func bgLeftView() -> UIImageView {
        if bgLeftView == nil {
            bgLeftView = UIImageView(image: UIImage(named: "emojiKB_bigTips_left"))
        }
        return bgLeftView
    }

    func bgCenterView() -> UIImageView {
        if bgCenterView == nil {
            bgCenterView = UIImageView(image: UIImage(named: "emojiKB_bigTips_middle"))
        }
        return bgCenterView
    }

    func bgRightView() -> UIImageView {
        if bgRightView == nil {
            bgRightView = UIImageView(image: UIImage(named: "emojiKB_bigTips_right"))
        }
        return bgRightView
    }


    
}
