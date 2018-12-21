//
//  WXImageExpressionDisplayView.swift
//  Freedom

import Foundation
import SnapKit
class WXImageExpressionDisplayView: UIView {
    var emoji: TLEmoji {
        didSet {
            curID = emoji.emojiID
            if data = try Data(contentsOf: URL(fileURLWithPath: emoji.emojiPath)) {
                imageView.image = UIImage.sd_animatedGIF(with: data)
            } else {
                var urlString = "http://123.57.155.230:8080/ibiaoqing/admin/expre/download.dopId=\(emoji.emojiID)"
                imageView.sd_setImage(with: URL(string: emoji.emojiURL), completed: { image, error, cacheType, imageURL in
                    if urlString.contains(self.curID) {
                        DispatchQueue.global(qos: .default).async(execute: {
                            var data = try Data(contentsOf: URL(string: urlString))
                            DispatchQueue.main.async(execute: {
                                self.imageView.image = UIImage.sd_animatedGIF(with: data)
                            })
                        })
                    }
                })
            }
        }
    }
    var rect = CGRect.zero
    var bgLeftView = UIImageView(image: UIImage(named: "emojiKB_bigTips_left"))
    var bgCenterView = UIImageView(image: UIImage(named: "emojiKB_bigTips_middle"))
    var bgRightView = UIImageView(image: UIImage(named: "emojiKB_bigTips_right"))
    var imageView = UIImageView()
    private var curID = ""
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 150, height: 162))
        addSubview(bgLeftView)
        addSubview(bgCenterView)
        addSubview(bgRightView)
        addSubview(imageView)
//        p_addMasonry()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func display(_ emoji: TLEmoji, at rect: CGRect) {
        self.rect = rect
        self.emoji = emoji
    }
    func setRect(_ rect: CGRect) {
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
    
//    func p_addMasonry() {
//        bgLeftView.mas_makeConstraints({ make in
//            make.top.and().left().and().bottom().mas_equalTo(self)
//        })
//        bgCenterView.mas_makeConstraints({ make in
//            make.left.mas_equalTo(self.bgLeftView.mas_right)
//            make.top.and().bottom().mas_equalTo(self.bgLeftView)
//            make.width.mas_equalTo(25)
//        })
//        bgRightView.mas_makeConstraints({ make in
//            make.left.mas_equalTo(self.bgCenterView.mas_right)
//            make.top.and().bottom().mas_equalTo(self.bgLeftView)
//            make.right.mas_equalTo(self)
//        })
//        imageView.mas_makeConstraints({ make in
//            make.top.mas_equalTo(self).mas_offset(10)
//            make.left.mas_equalTo(self).mas_offset(10)
//            make.right.mas_equalTo(self).mas_offset(-10)
//            make.height.mas_equalTo(self.imageView.mas_width)
//        })
//    }
}
