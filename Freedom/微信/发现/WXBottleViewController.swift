//
//  WXBottleViewController.swift
//  Freedom
import SnapKit
import XExtension
import Foundation
enum TLBottleButtonType : Int {
    case `throw`
    case pickUp
    case mine
}
class WXBottleButton: UIButton {
    var title = "" {
        didSet {
            textLabel.text = title
        }
    }
    var iconPath = "" {
        didSet {
            iconImageView.image = iconPath.image
        }
    }
    var type = TLBottleButtonType.throw
    var msgNumber: Int = 0
    var iconImageView = UIImageView()
    lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = UIFont.small
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.whitex
        return textLabel
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(type: TLBottleButtonType, title: String, iconPath: String) {
        self.init(frame: CGRect.zero)
        addSubview(iconImageView)
        addSubview(textLabel)
        self.type = type
        self.title = title
        self.iconPath = iconPath
        iconImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.textLabel.snp.top).offset(9)
        }
        textLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-3)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class WXBottleViewController: WXBaseViewController {
    var timer: Timer?
    var tapGes: UITapGestureRecognizer?
    lazy var backgroundView: UIImageView = {
        let backgroundView = UIImageView(frame: view.bounds)
        let hour = Date().components.hour ?? 0
        if hour >= 6 && hour <= 18 {
            backgroundView.image = WXImage.bottleDay.image
        } else {
            backgroundView.image = WXImage.bottleNight.image
        }
        return backgroundView
    }()
    var bottomBoard = UIImageView(image: WXImage.bottleBoard.image)
    var throwButton = WXBottleButton(type: .throw, title: "扔一个", iconPath: WXImage.bottleThrow.rawValue)
    var pickUpButton = WXBottleButton(type: .pickUp, title: "捡一个", iconPath: WXImage.bottlePickup.rawValue)
    var mineButton = WXBottleButton(type: .mine, title: "我的瓶子", iconPath: WXImage.bottleMine.rawValue)
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "漂流瓶"
        let rightBarButton = UIBarButtonItem(image: Image.setting.image, style: .plain, target: self, action: #selector(self.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
        view.addSubview(backgroundView)
        view.addSubview(bottomBoard)
        view.addSubview(throwButton)
        view.addSubview(pickUpButton)
        view.addSubview(mineButton)
        mineButton.addTarget(self, action: #selector(self.boardButtonDown(_:)), for: .touchUpInside)
        throwButton.addTarget(self, action: #selector(self.boardButtonDown(_:)), for: .touchUpInside)
        pickUpButton.addTarget(self, action: #selector(self.boardButtonDown(_:)), for: .touchUpInside)
        let widthButton: CGFloat = 75
        let space: CGFloat = (APPW - widthButton * 3) / 4
        bottomBoard.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
        }
        pickUpButton.snp.makeConstraints { (make) in
            make.centerX.bottom.equalTo(self.view)
            make.width.equalTo(widthButton)
        }
        throwButton.snp.makeConstraints { (make) in
            make.width.bottom.equalTo(self.pickUpButton)
            make.right.equalTo(self.pickUpButton.snp.left).offset(-space)
        }
        mineButton.snp.makeConstraints { (make) in
            make.width.bottom.equalTo(self.pickUpButton)
            make.left.equalTo(self.pickUpButton.snp.right).offset(space)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer?.invalidate()
        timer = Timer(timeInterval: 2.0, repeats: false, block: { (tm) in
            tm.invalidate()
            self.p_setNavBarHidden(true)
        })
        tapGes = UITapGestureRecognizer(target: self, action: #selector(self.didTapView))
        view.addGestureRecognizer(tapGes!)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        p_setNavBarHidden(false)
        timer?.invalidate()
        view.removeGestureRecognizer(tapGes!)
    }
    func boardButtonDown(_ sender: WXBottleButton) {
        noticeInfo(sender.title)
    }
    func didTapView() {
        timer?.invalidate()
        p_setNavBarHidden(!(navigationController?.navigationBar.isHidden ?? false))
    }
    func rightBarButtonDown(_ sender: UIBarButtonItem) {
    }
    private func p_setNavBarHidden(_ hidden: Bool) {
        if hidden {
            UIApplication.shared.setStatusBarHidden(true, with: .fade)
            UIView.animate(withDuration: 0.5, animations: {
                var rec: CGRect = self.navigationController?.navigationBar.frame ?? CGRect.zero
                rec.origin.y = -TopHeight - 20
                self.navigationController?.navigationBar.frame = rec
            }) { finished in
                self.navigationController?.navigationBar.isHidden = true
            }
        } else {
            navigationController?.navigationBar.isHidden = false
            UIApplication.shared.setStatusBarHidden(false, with: .fade)
            UIView.animate(withDuration: 0.2, animations: {
                var rec: CGRect = self.navigationController?.navigationBar.frame ?? CGRect.zero
                rec.origin.y = 20
                self.navigationController?.navigationBar.frame = rec
            })
        }
    }
}
