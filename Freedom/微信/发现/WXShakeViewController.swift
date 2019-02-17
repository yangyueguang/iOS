//
//  WXShakeViewController.swift
//  Freedom
import SnapKit
import Foundation
enum TLShakeButtonType : Int {
    case people
    case song
    case tv
}
class WXShakeButton: UIButton {
    var title = "" {
        didSet {
            textLabel.text = title
        }
    }
    var iconPath = "" {
        didSet {
            iconImageView.image = UIImage(named: iconPath)
        }
    }
    var iconHLPath = "" {
        didSet {
            iconImageView.highlightedImage = UIImage(named: iconHLPath)
        }
    }
    var type = TLShakeButtonType.people
    var msgNumber: Int = 0
    var iconImageView = UIImageView()
    lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = UIFont.small
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.whitex
        textLabel.highlightedTextColor = UIColor.greenx
        return textLabel
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(type: TLShakeButtonType, title: String, iconPath: String, iconHLPath: String) {
        self.init(frame: CGRect.zero)
        addSubview(iconImageView)
        addSubview(textLabel)
        self.type = type
        self.title = title
        self.iconPath = iconPath
        self.iconHLPath = iconHLPath
//        p_addMasonry()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var isSelected: Bool {
        didSet {
            iconImageView.isHighlighted = isSelected
            textLabel.isHighlighted = isSelected
        }
    }
//    func p_addMasonry() {
//        iconImageView.snp.makeConstraints { make in
//            make.left.and().right().equalTo(self)
//            make.bottom.equalTo(self.textLabel.mas_top).mas_offset(-8)
//        })
//        textLabel.snp.makeConstraints { make in
//            make.left.and().right().equalTo(self)
//            make.bottom.equalTo(self)
//        })
//        mas_updateConstraints({ make in
//            make.top.equalTo(self.iconImageView.mas_top)
//        })
//    }
}
class WXShakeViewController: WXBaseViewController {
    var curType = TLShakeButtonType.people
    lazy var topLogoView: UIImageView = {
        let topLogoView = UIImageView(image: UIImage(named: "shake_logo_top"))
        topLogoView.backgroundColor = UIColor.back
        topLogoView.contentMode = .bottom
        return topLogoView
    }()
    lazy var bottomLogoView: UIImageView = {
        let bottomLogoView = UIImageView(image: UIImage(named: "shake_logo_bottom"))
        bottomLogoView.backgroundColor = UIColor.back
        bottomLogoView.contentMode = .top
        return bottomLogoView
    }()
    lazy var centerLogoView: UIImageView = {
        let centerLogoView = UIImageView(image: UIImage(named: "shake_logo_center"))
        centerLogoView.contentMode = .scaleAspectFill
        centerLogoView.clipsToBounds = true
        return centerLogoView
    }()
    var topLineView = UIImageView(image: UIImage(named: "shake_line_top"))
    var bottomLineView = UIImageView(image: UIImage(named: "shake_line_bottom"))
    lazy var peopleButton: WXShakeButton = {
        let peopleButton = WXShakeButton(type: .people, title: "人", iconPath: "shake_button_people", iconHLPath: "shake_button_peopleHL")
        peopleButton.isSelected = true
        peopleButton.addTarget(self, action: #selector(self.controlButtonDown(_:)), for: .touchUpInside)
        return peopleButton
    }()
    lazy var songButton: WXShakeButton = {
        let songButton = WXShakeButton(type: .song, title: "歌曲", iconPath: "shake_button_music", iconHLPath: "shake_button_musicHL")
        songButton.addTarget(self, action: #selector(self.controlButtonDown(_:)), for: .touchUpInside)
        return songButton
    }()
    lazy var tvButton: WXShakeButton = {
        let tvButton = WXShakeButton(type: .tv, title: "电视", iconPath: "shake_button_tv", iconHLPath: "shake_button_tvHL")
        tvButton.addTarget(self, action: #selector(self.controlButtonDown(_:)), for: .touchUpInside)
        return tvButton
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        topLineView.isHidden = true
        bottomLineView.isHidden = true
        navigationItem.title = "摇一摇"
        view.backgroundColor = UIColor.back
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
        curType = .people
        p_addMasonry()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let centreImageName = UserDefaults.standard.value(forKey: "Shake_Image_Path") as? String
        if let centreImageName = centreImageName {
            let path = FileManager.pathUserSettingImage(centreImageName)
            centerLogoView.image = UIImage(named: path ?? "")
        } else {
            centerLogoView.image = UIImage(named: "shake_logo_center")
        }
    }
    func controlButtonDown(_ sender: WXShakeButton) {
        if !sender.isSelected {
            return
        }
        curType = sender.type
        peopleButton.isSelected = peopleButton.type == sender.type
        songButton.isSelected = songButton.type == sender.type
        tvButton.isSelected = tvButton.type == sender.type
    }
    func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent) {
        if topLineView.isHidden {
            topLineView.isHidden = false
            bottomLineView.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.topLogoView.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(self.view.snp.centerY).offset(-10)
                })
                self.bottomLogoView.snp.updateConstraints({ (make) in
                    make.top.equalTo(self.view.snp.centerY).offset(-10 + 90)
                })
                self.view.layoutIfNeeded()
            }) { finished in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.15 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.topLogoView.snp.updateConstraints({ (make) in
                            make.bottom.equalTo(self.view.snp.centerY).offset(-10)
                        })
                        self.bottomLogoView.snp.updateConstraints({ (make) in
                            make.top.equalTo(self.view.snp.centerY).offset(-10)
                        })
                        self.view.layoutIfNeeded()
                    }) { finished in
                        self.topLineView.isHidden = true
                        self.bottomLineView.isHidden = true
                    }
                })
            }
        }
    }
    func rightBarButtonDown(_ sender: UIBarButtonItem) {
        let shakeSettingVC = WXShakeSettingViewController()
        navigationController?.pushViewController(shakeSettingVC, animated: true)
    }
    func p_addMasonry() {
        centerLogoView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(self.view)
            make.height.equalTo(200)
        }
        topLogoView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.snp.centerY).offset(-10)
            make.centerX.equalTo(self.view)
            make.width.equalTo(self.view)
            make.height.equalTo(150)
        }
        bottomLogoView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.centerY).offset(-10)
            make.centerX.equalTo(self.view)
            make.width.equalTo(self.view)
            make.height.equalTo(150)
        }
        topLineView.snp.makeConstraints { make in
            make.width.equalTo(self.view)
            make.top.equalTo(self.topLogoView.snp.bottom)
        }
        bottomLineView.snp.makeConstraints { make in
            make.width.equalTo(self.view)
            make.bottom.equalTo(self.bottomLogoView.snp.top)
        }
        let widthButton: CGFloat = 40
        let space: CGFloat = (APPW - widthButton * 3) / 4 * 1.2
        songButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-15)
        }
        peopleButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.songButton)
            make.right.equalTo(self.songButton.snp.left).offset(-space)
        }
        tvButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.songButton)
            make.left.equalTo(self.songButton.snp.right).offset(space)
        }
    }
}
