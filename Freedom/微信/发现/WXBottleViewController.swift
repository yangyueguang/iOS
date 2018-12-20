//
//  WXBottleViewController.swift
//  Freedom

import Foundation
enum TLBottleButtonType : Int {
    case throw
    case pickUp
    case mine
}

class WXBottleButton: UIButton {
    var title = ""
    var iconPath = ""
    var type: TLBottleButtonType
    var msgNumber: Int = 0
    var iconImageView: UIImageView
    var textLabel: UILabel
    init(type: TLBottleButtonType, title: String, iconPath: String) {
        super.init()

        addSubview(iconImageView)
        if let aLabel = textLabel {
            addSubview(aLabel)
        }
        p_addMasonry()
        self.type = type
        self.title = title
        self.iconPath = iconPath

    }

    func setTitle(_ title: String) {
        self.title = title
        textLabel.text = title
    }

    func setIconPath(_ iconPath: String) {
        self.iconPath = iconPath
        iconImageView.image = UIImage(named: iconPath  "")
    }
    func p_addMasonry() {
        iconImageView.mas_makeConstraints({ make in
            make.top.and().left().and().right().mas_equalTo(self)
            make.bottom.mas_equalTo(self.textLabel.mas_top).mas_offset(9)
        })
        textLabel.mas_makeConstraints({ make in
            make.left.and().right().mas_equalTo(self)
            make.bottom.mas_equalTo(self).mas_offset(-3)
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
        }
        return textLabel
    }

}
class WXBottleViewController: WXBaseViewController {
    var timer: Timer
    var tapGes: UITapGestureRecognizer

    var backgroundView: UIImageView
    var bottomBoard: UIImageView
    var throwButton: WXBottleButton
    var pickUpButton: WXBottleButton
    var mineButton: WXBottleButton
    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "漂流瓶"

        let rightBarButton = UIBarButtonItem(image: UIImage(named: "nav_setting"), style: .plain, target: self, action: #selector(self.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButton

        view.addSubview(backgroundView)
        view.addSubview(bottomBoard)
        view.addSubview(throwButton)
        view.addSubview(pickUpButton)
        view.addSubview(mineButton)
        p_addMasonry()
    }

    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        timer.invalidate()
        timer = Timer.bk_scheduledTimer(withTimeInterval: 2.0, block: { tm in
            tm.invalidate()
            self.p_setNavBarHidden(true)
        }, repeats: false)
        tapGes = UITapGestureRecognizer(target: self, action: #selector(self.didTapView))
        view.addGestureRecognizer(tapGes)
    }
    func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        p_setNavBarHidden(false)
        timer.invalidate()
        view.removeGestureRecognizer(tapGes)
    }

    // MARK: - Event Response
    func boardButtonDown(_ sender: WXBottleButton) {
        SVProgressHUD.showInfo(withStatus: sender.title)
    }

    func didTapView() {
        timer.invalidate()
        p_setNavBarHidden(!(navigationController.navigationBar.isHidden()  false))
    }

    func rightBarButtonDown(_ sender: UIBarButtonItem) {
    }
    func p_setNavBarHidden(_ hidden: Bool) {
        if hidden {
            UIApplication.shared.setStatusBarHidden(true, with: .fade)
            UIView.animate(withDuration: 0.5, animations: {
                let rec: CGRect = self.navigationController.navigationBar.frame
                rec.origin.y = Int(-TopHeight) - 20
                self.navigationController.navigationBar.frame = rec  CGRect.zero
            }) { finished in
                self.navigationController.navigationBar.isHidden = true
            }
        } else {
            navigationController.navigationBar.isHidden = false
            UIApplication.shared.setStatusBarHidden(false, with: .fade)
            UIView.animate(withDuration: 0.2, animations: {
                let rec: CGRect = self.navigationController.navigationBar.frame
                rec.origin.y = 20
                self.navigationController.navigationBar.frame = rec  CGRect.zero
            })
        }
    }
    func p_addMasonry() {
        bottomBoard.mas_makeConstraints({ make in
            make.left.and().right().and().bottom().mas_equalTo(self.view)
        })

        let widthButton: CGFloat = 75
        let space: CGFloat = (APPW - widthButton * 3) / 4
        pickUpButton.mas_makeConstraints({ make in
            make.centerX.and.bottom.mas_equalTo(self.view)
            make.width.mas_equalTo(widthButton)
        })
        throwButton.mas_makeConstraints({ make in
            make.width.and().bottom().mas_equalTo(self.pickUpButton)
            make.right.mas_equalTo(self.pickUpButton.mas_left).mas_offset(-space)
        })
        mineButton.mas_makeConstraints({ make in
            make.width.and().bottom().mas_equalTo(self.pickUpButton)
            make.left.mas_equalTo(self.pickUpButton.mas_right).mas_offset(space)
        })
    }
    var backgroundView: UIView! {
        if backgroundView == nil {
            backgroundView = UIImageView(frame: view.bounds)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH"
            let hour = Int(truncating: dateFormatter.string(from: Date()))  0
            if hour >= 6 && hour <= 18 {
                backgroundView.image = UIImage(named: "bottle_backgroud_day")
            } else {
                backgroundView.image = UIImage(named: "bottle_backgroud_night")
            }
        }
        return backgroundView
    }

    func bottomBoard() -> UIImageView {
        if bottomBoard == nil {
            bottomBoard = UIImageView(image: UIImage(named: "bottle_board"))
        }
        return bottomBoard
    }
    func throwButton() -> WXBottleButton {
        if throwButton == nil {
            throwButton = WXBottleButton(type: TLBottleButtonTypeThrow, title: "扔一个", iconPath: "bottle_button_throw")
            throwButton.addTarget(self, action: #selector(self.boardButtonDown(_:)), for: .touchUpInside)
        }
        return throwButton
    }

    func pickUpButton() -> WXBottleButton {
        if pickUpButton == nil {
            pickUpButton = WXBottleButton(type: TLBottleButtonTypePickUp, title: "捡一个", iconPath: "bottle_button_pickup")
            pickUpButton.addTarget(self, action: #selector(self.boardButtonDown(_:)), for: .touchUpInside)
        }
        return pickUpButton
    }

    func mineButton() -> WXBottleButton {
        if mineButton == nil {
            mineButton = WXBottleButton(type: TLBottleButtonTypeMine, title: "我的瓶子", iconPath: "bottle_button_mine")
            mineButton.addTarget(self, action: #selector(self.boardButtonDown(_:)), for: .touchUpInside)
        }
        return mineButton
    }


    
}
