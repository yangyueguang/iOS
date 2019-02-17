//
//  JFMineViewController.swift
//  Freedom
import UIKit
import XExtension
final class IqiyiMineViewController: IqiyiBaseViewController {
    override func viewDidLoad() {
        setNav()
        initViews()
    }
    func setNav() {
        navigationController?.navigationBar.isHidden = true
        let backImage = UIImageView(frame: CGRect(x: 0, y: 0, width: APPW, height: 147))
        backImage.image = UIImage(named: "morentu")
        view.addSubview(backImage)
        //
        let backView = UIView(frame: CGRect(x: 0, y: 107, width: APPW, height: 40))
        if let aNamed = UIImage(named: "titlebar") {
            backView.backgroundColor = UIColor(patternImage: aNamed)
        }
        view.addSubview(backView)
        //
        //设置
        let settingBtn = UIButton(frame: CGRect(x: APPW - 30, y: 30, width: 22, height: 22))
        settingBtn.setImage(UIImage(named: "wsetting"), for: .normal)
        view.addSubview(settingBtn)
        //消息
        let msgBtn = UIButton(type: .custom)
        msgBtn.frame = CGRect(x: APPW - 60, y: 30, width: 22, height: 22)
        msgBtn.setImage(UIImage(named: "wbell"), for: .normal)
        view.addSubview(msgBtn)
        //头像
        let userImage = UIImageView(frame: CGRect(x: 10, y: 30, width: 50, height: 50))
        userImage.isUserInteractionEnabled = true
        userImage.layer.masksToBounds = true
        userImage.layer.cornerRadius = 25
        userImage.image = UIImage(named: "userLogo")
        view.addSubview(userImage)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.tapGROnIconClick))
        userImage.addGestureRecognizer(tapGR)
        //登陆
        let loginLable = UILabel(frame: CGRect(x: userImage.frame.maxX + 10, y: 30, width: 100, height: 30))
        loginLable.textColor = UIColor.whitex
        loginLable.font = UIFont.middle
        loginLable.text = "马上登陆"
        view.addSubview(loginLable)
        //
        let msgLabel = UILabel(frame: CGRect(x: userImage.frame.maxX + 10, y: 60, width: 100, height: 20))
        msgLabel.text = "登陆后更精彩"
        msgLabel.textColor = UIColor.whitex
        msgLabel.font = UIFont.small
        view.addSubview(msgLabel)
    }
    func initViews() {
        let backImage = UIImageView(frame: CGRect(x: 0, y: 150, width: APPW, height: APPH - 150 - 49))
        backImage.image = UIImage(named: "cache_no_data")
        backImage.contentMode = .scaleAspectFit
        view.addSubview(backImage)
        //
        let titleArrar = ["历史", "收藏", "上传", "特权"]
        let picArray = ["whistory", "wfavourite", "wcamera", "wvip"]
        for i in 0..<4 {
            let segmentBtn = UIButton(type: .custom)
            segmentBtn.tag = i
            segmentBtn.frame = CGRect(x: APPW / 4 * CGFloat(i), y: 107, width: APPW / 4, height: 40)
            segmentBtn.setImage(UIImage(named: picArray[i]), for: .normal)
            segmentBtn.setTitle(titleArrar[i], for: .normal)
            segmentBtn.addTarget(self, action: #selector(IqiyiMineViewController.segmentBtn(_:)), for: .touchUpInside)
            view.addSubview(segmentBtn)
        }
    }
    func segmentBtn(_ sender: UIButton?) {
        if sender?.tag == 0 {
            let watchRecordVC = IqiyiWatchRecordViewController(nibName: "JFWatchRecordViewController", bundle: nil)
            navigationController?.pushViewController(watchRecordVC, animated: true)
        }
    }
    
    func tapGROnIconClick() {
        let loginVC = IqiyiLoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
        
}
