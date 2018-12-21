//
//  WXShakeViewController.swift
//  Freedom

import Foundation
enum TLShakeButtonType : Int {
    case people
    case song
    case tv
}

class WXShakeButton: UIButton {
    var title = ""
    var iconPath = ""
    var iconHLPath = ""
    var type: TLShakeButtonType
    var msgNumber: Int = 0
    var iconImageView: UIImageView
    var textLabel: UILabel
    init(type: TLShakeButtonType, title: String, iconPath: String, iconHLPath: String) {
        super.init()

        addSubview(iconImageView)
        if let aLabel = textLabel {
            addSubview(aLabel)
        }
        p_addMasonry()
        self.type = type
        self.title = title
        self.iconPath = iconPath
        self.iconHLPath = iconHLPath

    }
    func setTitle(_ title: String) {
        self.title = title
        textLabel.text = title
    }

    func setIconPath(_ iconPath: String) {
        self.iconPath = iconPath
        iconImageView.image = UIImage(named: iconPath)
    }

    func setIconHLPath(_ iconHLPath: String) {
        self.iconHLPath = iconHLPath
        iconImageView.highlightedImage = UIImage(named: iconHLPath)
    }

    func setSelected(_ selected: Bool) {
        super.setSelected(selected)
        iconImageView.highlighted = selected
        textLabel.isHighlighted = selected
    }
    func p_addMasonry() {
        iconImageView.mas_makeConstraints({ make in
            make.left.and().right().mas_equalTo(self)
            make.bottom.mas_equalTo(self.textLabel.mas_top).mas_offset(-8)
        })
        textLabel.mas_makeConstraints({ make in
            make.left.and().right().mas_equalTo(self)
            make.bottom.mas_equalTo(self)
        })

        mas_updateConstraints({ make in
            make.top.mas_equalTo(self.iconImageView.mas_top)
        })
    }
    func iconImageView() -> UIImageView {
        if iconImageView == nil {
            iconImageView = UIImageView()
        }
        return iconImageView
    }

    var textLabel: UILabel {
        if textLabel == nil {
            textLabel = UILabel()
            textLabel.font = UIFont.systemFont(ofSize: 12.0)
            textLabel.textAlignment = .center
            textLabel.textColor = UIColor.white
            textLabel.highlightedTextColor = UIColor.green
        }
        return textLabel
    }



    
}
class WXShakeViewController: WXBaseViewController {
    var curType: TLShakeButtonType
    var topLogoView: UIImageView
    var bottomLogoView: UIImageView
    var centerLogoView: UIImageView
    var topLineView: UIImageView
    var bottomLineView: UIImageView
    var peopleButton: WXShakeButton
    var songButton: WXShakeButton
    var tvButton: WXShakeButton
    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "摇一摇"
        view.backgroundColor = UIColor(46.0, 49.0, 50.0, 1.0)

        let rightBarButton = UIBarButtonItem(image: UIImage(named: "nav_setting"), style: .plain, target: self, action: #selector(self.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButton

        view.addSubview(centerLogoView)
        view.addSubview(topLogoView)
        view.addSubview(bottomLogoView)
        view.addSubview(topLineView)
        view.addSubview(bottomLineView)
        view.addSubview(peopleButton)
        view.addSubview(songButton)
        view.addSubview(tvButton)
        p_addMasonry()

        curType = TLShakeButtonTypePeople
    }
    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let centreImageName = UserDefaults.standard.object(forKey: "Shake_Image_Path") as String
        if centreImageName != nil {
            let path = FileManager.pathUserSettingImage(centreImageName)
            centerLogoView.image = UIImage(named: path)
        } else {
            centerLogoView.image = UIImage(named: "shake_logo_center")
        }
    }

    // MARK: - Event Response
    func controlButtonDown(_ sender: WXShakeButton) {
        if sender.isSelected != nil {
            return
        }
        curType = sender.type
        peopleButton.selected = peopleButton.type == sender.type
        songButton.selected = songButton.type == sender.type
        tvButton.selected = tvButton.type == sender.type
    }
    func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent) {
        if topLineView.isHidden() {
            topLineView.hidden = false
            bottomLineView.hidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.topLogoView.mas_updateConstraints({ make in
                    make.bottom.mas_equalTo(self.view.mas_centerY).mas_offset(-10 - 90)
                })
                self.bottomLogoView.mas_updateConstraints({ make in
                    make.top.mas_equalTo(self.view.mas_centerY).mas_offset(-10 + 90)
                })
                self.view.layoutIfNeeded()
            }) { finished in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.15 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.topLogoView.mas_updateConstraints({ make in
                            make.bottom.mas_equalTo(self.view.mas_centerY).mas_offset(-10)
                        })
                        self.bottomLogoView.mas_updateConstraints({ make in
                            make.top.mas_equalTo(self.view.mas_centerY).mas_offset(-10)
                        })
                        self.view.layoutIfNeeded()
                    }) { finished in
                        self.topLineView.hidden = true
                        self.bottomLineView.hidden = true
                    }
                })
            }
        }
    }
    func p_addMasonry() {
        centerLogoView.mas_makeConstraints({ make in
            make.center.mas_equalTo(self.view)
            make.width.mas_equalTo(self.view)
            make.height.mas_equalTo(200)
        })
        topLogoView.mas_makeConstraints({ make in
            make.bottom.mas_equalTo(self.view.mas_centerY).mas_offset(-10)
            make.centerX.mas_equalTo(self.view)
            make.width.mas_equalTo(self.view)
            make.height.mas_equalTo(150)
        })
        bottomLogoView.mas_makeConstraints({ make in
            make.top.mas_equalTo(self.view.mas_centerY).mas_offset(-10)
            make.centerX.mas_equalTo(self.view)
            make.width.mas_equalTo(self.view)
            make.height.mas_equalTo(150)
        })
        topLineView.mas_makeConstraints({ make in
            make.width.mas_equalTo(self.view)
            make.top.mas_equalTo(self.topLogoView.mas_bottom)
        })
        bottomLineView.mas_makeConstraints({ make in
            make.width.mas_equalTo(self.view)
            make.bottom.mas_equalTo(self.bottomLogoView.mas_top)
        })

        // bottom
        let widthButton: CGFloat = 40
        let space: CGFloat = (APPW - widthButton * 3) / 4 * 1.2
        songButton.mas_makeConstraints({ make in
            make.centerX.mas_equalTo(self.view)
            make.bottom.mas_equalTo(self.view).mas_offset(-15)
        })
        peopleButton.mas_makeConstraints({ make in
            make.centerY.mas_equalTo(self.songButton)
            make.right.mas_equalTo(self.songButton.mas_left).mas_offset(-space)
        })
        tvButton.mas_makeConstraints({ make in
            make.centerY.mas_equalTo(self.songButton)
            make.left.mas_equalTo(self.songButton.mas_right).mas_offset(space)
        })
    }
    func rightBarButtonDown(_ sender: UIBarButtonItem) {
        let shakeSettingVC = WXShakeSettingViewController()
        hidesBottomBarWhenPushed = true
        navigationController.pushViewController(shakeSettingVC, animated: true)
    }

    func topLogoView() -> UIImageView {
        if topLogoView == nil {
            topLogoView = UIImageView(image: UIImage(named: "shake_logo_top"))
            topLogoView.backgroundColor = UIColor(46.0, 49.0, 50.0, 1.0)
            topLogoView.contentMode = .bottom
        }
        return topLogoView
    }
    func bottomLogoView() -> UIImageView {
        if bottomLogoView == nil {
            bottomLogoView = UIImageView(image: UIImage(named: "shake_logo_bottom"))
            bottomLogoView.backgroundColor = UIColor(46.0, 49.0, 50.0, 1.0)
            bottomLogoView.contentMode = .top
        }
        return bottomLogoView
    }

    func centerLogoView() -> UIImageView {
        if centerLogoView == nil {
            centerLogoView = UIImageView(image: UIImage(named: "shake_logo_center"))
            centerLogoView.contentMode = .scaleAspectFill
            centerLogoView.clipsToBounds = true
        }
        return centerLogoView
    }
    func topLineView() -> UIImageView {
        if topLineView == nil {
            topLineView = UIImageView(image: UIImage(named: "shake_line_top"))
            topLineView.hidden = true
        }
        return topLineView
    }

    func bottomLineView() -> UIImageView {
        if bottomLineView == nil {
            bottomLineView = UIImageView(image: UIImage(named: "shake_line_bottom"))
            bottomLineView.hidden = true
        }
        return bottomLineView
    }
    func peopleButton() -> WXShakeButton {
        if peopleButton == nil {
            peopleButton = WXShakeButton(type: TLShakeButtonTypePeople, title: "人", iconPath: "shake_button_people", iconHLPath: "shake_button_peopleHL")
            peopleButton.selected = true
            peopleButton.addTarget(self, action: #selector(self.controlButtonDown(_:)), for: .touchUpInside)
        }
        return peopleButton
    }

    func songButton() -> WXShakeButton {
        if songButton == nil {
            songButton = WXShakeButton(type: TLShakeButtonTypeSong, title: "歌曲", iconPath: "shake_button_music", iconHLPath: "shake_button_musicHL")
            songButton.addTarget(self, action: #selector(self.controlButtonDown(_:)), for: .touchUpInside)
        }
        return songButton
    }

    func tvButton() -> WXShakeButton {
        if tvButton == nil {
            tvButton = WXShakeButton(type: TLShakeButtonTypeTV, title: "电视", iconPath: "shake_button_tv", iconHLPath: "shake_button_tvHL")
            tvButton.addTarget(self, action: #selector(self.controlButtonDown(_:)), for: .touchUpInside)
        }
        return tvButton
    }


    
}
