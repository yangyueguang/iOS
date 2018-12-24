//
//  WXImageExpressionDisplayView.swift
//  Freedom

import Foundation
import SnapKit
class WXImageExpressionDisplayView: UIView {
    var bgLeftView = UIImageView(image: UIImage(named: "emojiKB_bigTips_left"))
    var bgCenterView = UIImageView(image: UIImage(named: "emojiKB_bigTips_middle"))
    var bgRightView = UIImageView(image: UIImage(named: "emojiKB_bigTips_right"))
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
