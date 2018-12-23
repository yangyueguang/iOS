////
////  WXShakeViewController.swift
////  Freedom
//import SnapKit
//import Foundation
//enum TLShakeButtonType : Int {
//    case people
//    case song
//    case tv
//}
//class WXShakeButton: UIButton {
//    var title = "" {
//        didSet {
//            textLabel.text = title
//        }
//    }
//    var iconPath = "" {
//        didSet {
//            iconImageView.image = UIImage(named: iconPath)
//        }
//    }
//    var iconHLPath = "" {
//        didSet {
//            iconImageView.highlightedImage = UIImage(named: iconHLPath)
//        }
//    }
//    var type = TLShakeButtonType.people
//    var msgNumber: Int = 0
//    var iconImageView = UIImageView()
//    lazy var textLabel: UILabel = {
//        let textLabel = UILabel()
//        textLabel.font = UIFont.systemFont(ofSize: 12.0)
//        textLabel.textAlignment = .center
//        textLabel.textColor = UIColor.white
//        textLabel.highlightedTextColor = UIColor.green
//        return textLabel
//    }()
//    init(type: TLShakeButtonType, title: String, iconPath: String, iconHLPath: String) {
//        super.init()
//        addSubview(iconImageView)
//        addSubview(textLabel)
//        self.type = type
//        self.title = title
//        self.iconPath = iconPath
//        self.iconHLPath = iconHLPath
////        p_addMasonry()
//    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    override var isSelected: Bool {
//        didSet {
//            iconImageView.isHighlighted = isSelected
//            textLabel.isHighlighted = isSelected
//        }
//    }
////    func p_addMasonry() {
////        iconImageView.mas_makeConstraints({ make in
////            make.left.and().right().mas_equalTo(self)
////            make.bottom.mas_equalTo(self.textLabel.mas_top).mas_offset(-8)
////        })
////        textLabel.mas_makeConstraints({ make in
////            make.left.and().right().mas_equalTo(self)
////            make.bottom.mas_equalTo(self)
////        })
////        mas_updateConstraints({ make in
////            make.top.mas_equalTo(self.iconImageView.mas_top)
////        })
////    }
//}
//class WXShakeViewController: WXBaseViewController {
//    var curType = TLShakeButtonType.people
//    lazy var topLogoView: UIImageView = {
//        let topLogoView = UIImageView(image: UIImage(named: "shake_logo_top"))
//        topLogoView.backgroundColor = UIColor(46.0, 49.0, 50.0, 1.0)
//        topLogoView.contentMode = .bottom
//        return topLogoView
//    }()
//    lazy var bottomLogoView: UIImageView = {
//        let bottomLogoView = UIImageView(image: UIImage(named: "shake_logo_bottom"))
//        bottomLogoView.backgroundColor = UIColor(46.0, 49.0, 50.0, 1.0)
//        bottomLogoView.contentMode = .top
//        return bottomLogoView
//    }()
//    lazy var centerLogoView: UIImageView = {
//        let centerLogoView = UIImageView(image: UIImage(named: "shake_logo_center"))
//        centerLogoView.contentMode = .scaleAspectFill
//        centerLogoView.clipsToBounds = true
//        return centerLogoView
//    }()
//    var topLineView = UIImageView(image: UIImage(named: "shake_line_top"))
//    var bottomLineView = UIImageView(image: UIImage(named: "shake_line_bottom"))
//    lazy var peopleButton: WXShakeButton = {
//        let peopleButton = WXShakeButton(type: .people, title: "人", iconPath: "shake_button_people", iconHLPath: "shake_button_peopleHL")
//        peopleButton.isSelected = true
//        peopleButton.addTarget(self, action: #selector(self.controlButtonDown(_:)), for: .touchUpInside)
//        return peopleButton
//    }()
//    lazy var songButton: WXShakeButton = {
//        let songButton = WXShakeButton(type: .song, title: "歌曲", iconPath: "shake_button_music", iconHLPath: "shake_button_musicHL")
//        songButton.addTarget(self, action: #selector(self.controlButtonDown(_:)), for: .touchUpInside)
//        return songButton
//    }()
//    lazy var tvButton: WXShakeButton = {
//        let tvButton = WXShakeButton(type: .tv, title: "电视", iconPath: "shake_button_tv", iconHLPath: "shake_button_tvHL")
//        tvButton.addTarget(self, action: #selector(self.controlButtonDown(_:)), for: .touchUpInside)
//        return tvButton
//    }()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        topLineView.isHidden = true
//        bottomLineView.isHidden = true
//        navigationItem.title = "摇一摇"
//        view.backgroundColor = UIColor(46.0, 49.0, 50.0, 1.0)
//        let rightBarButton = UIBarButtonItem(image: UIImage(named: "nav_setting"), style: .plain, target: self, action: #selector(self.rightBarButtonDown(_:)))
//        navigationItem.rightBarButtonItem = rightBarButton
//        view.addSubview(centerLogoView)
//        view.addSubview(topLogoView)
//        view.addSubview(bottomLogoView)
//        view.addSubview(topLineView)
//        view.addSubview(bottomLineView)
//        view.addSubview(peopleButton)
//        view.addSubview(songButton)
//        view.addSubview(tvButton)
//        curType = .people
////        p_addMasonry()
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        let centreImageName = UserDefaults.standard.object(forKey: "Shake_Image_Path") as String
//        if centreImageName != nil {
//            let path = FileManager.pathUserSettingImage(centreImageName)
//            centerLogoView.image = UIImage(named: path)
//        } else {
//            centerLogoView.image = UIImage(named: "shake_logo_center")
//        }
//    }
//    func controlButtonDown(_ sender: WXShakeButton) {
//        if !sender.isSelected {
//            return
//        }
//        curType = sender.type
//        peopleButton.isSelected = peopleButton.type == sender.type
//        songButton.isSelected = songButton.type == sender.type
//        tvButton.isSelected = tvButton.type == sender.type
//    }
//    func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent) {
//        if topLineView.isHidden {
//            topLineView.isHidden = false
//            bottomLineView.isHidden = false
//            UIView.animate(withDuration: 0.5, animations: {
//                self.topLogoView.mas_updateConstraints({ make in
//                    make.bottom.mas_equalTo(self.view.mas_centerY).mas_offset(-10 - 90)
//                })
//                self.bottomLogoView.mas_updateConstraints({ make in
//                    make.top.mas_equalTo(self.view.mas_centerY).mas_offset(-10 + 90)
//                })
//                self.view.layoutIfNeeded()
//            }) { finished in
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.15 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
//                    UIView.animate(withDuration: 0.5, animations: {
//                        self.topLogoView.mas_updateConstraints({ make in
//                            make.bottom.mas_equalTo(self.view.mas_centerY).mas_offset(-10)
//                        })
//                        self.bottomLogoView.mas_updateConstraints({ make in
//                            make.top.mas_equalTo(self.view.mas_centerY).mas_offset(-10)
//                        })
//                        self.view.layoutIfNeeded()
//                    }) { finished in
//                        self.topLineView.isHidden = true
//                        self.bottomLineView.isHidden = true
//                    }
//                })
//            }
//        }
//    }
//    func rightBarButtonDown(_ sender: UIBarButtonItem) {
//        let shakeSettingVC = WXShakeSettingViewController()
//        hidesBottomBarWhenPushed = true
//        navigationController.pushViewController(shakeSettingVC, animated: true)
//    }
////    func p_addMasonry() {
////        centerLogoView.mas_makeConstraints({ make in
////            make.center.mas_equalTo(self.view)
////            make.width.mas_equalTo(self.view)
////            make.height.mas_equalTo(200)
////        })
////        topLogoView.mas_makeConstraints({ make in
////            make.bottom.mas_equalTo(self.view.mas_centerY).mas_offset(-10)
////            make.centerX.mas_equalTo(self.view)
////            make.width.mas_equalTo(self.view)
////            make.height.mas_equalTo(150)
////        })
////        bottomLogoView.mas_makeConstraints({ make in
////            make.top.mas_equalTo(self.view.mas_centerY).mas_offset(-10)
////            make.centerX.mas_equalTo(self.view)
////            make.width.mas_equalTo(self.view)
////            make.height.mas_equalTo(150)
////        })
////        topLineView.mas_makeConstraints({ make in
////            make.width.mas_equalTo(self.view)
////            make.top.mas_equalTo(self.topLogoView.mas_bottom)
////        })
////        bottomLineView.mas_makeConstraints({ make in
////            make.width.mas_equalTo(self.view)
////            make.bottom.mas_equalTo(self.bottomLogoView.mas_top)
////        })
////        let widthButton: CGFloat = 40
////        let space: CGFloat = (APPW - widthButton * 3) / 4 * 1.2
////        songButton.mas_makeConstraints({ make in
////            make.centerX.mas_equalTo(self.view)
////            make.bottom.mas_equalTo(self.view).mas_offset(-15)
////        })
////        peopleButton.mas_makeConstraints({ make in
////            make.centerY.mas_equalTo(self.songButton)
////            make.right.mas_equalTo(self.songButton.mas_left).mas_offset(-space)
////        })
////        tvButton.mas_makeConstraints({ make in
////            make.centerY.mas_equalTo(self.songButton)
////            make.left.mas_equalTo(self.songButton.mas_right).mas_offset(space)
////        })
////    }
//}
