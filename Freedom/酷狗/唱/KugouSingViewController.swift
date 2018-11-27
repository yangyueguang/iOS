//
//  SingViewController.swift
//  Freedom
import UIKit
class KugouSingViewController: KugouBaseViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(KugouSingViewController.swipe(_:)))
        leftSwipe.direction = .left
        leftSwipe.numberOfTouchesRequired = 1
        view.addGestureRecognizer(leftSwipe)
        
        let banner = UIImageView(frame: CGRect(x: 0, y: 64, width: APPW, height: 150))
        banner.image = UIImage(named: "bj")
        let fujin = UIButton(frame: CGRect(x: 0, y: banner.frameY + banner.frameHeight + 20, width: APPW / 2, height: 80))
        fujin.addTarget(self, action: #selector(self.fujin), for: .touchUpInside)
        fujin.setTitle("附近", for: .normal)
        let paihang = UIButton(frame: CGRect(x: fujin.frame.size.width, y: fujin.frameY, width: fujin.frame.size.width, height: fujin.frameHeight))
        paihang.addTarget(self, action: #selector(self.paihang), for: .touchUpInside)
        paihang.setTitle("排行", for: .normal)
        let guanzhu = UIButton(frame: CGRect(x: fujin.frameX, y: fujin.frameY + fujin.frameHeight, width: fujin.frame.size.width, height: fujin.frameHeight))
        guanzhu.addTarget(self, action: #selector(self.guanzhu), for: .touchUpInside)
        guanzhu.setTitle("关注", for: .normal)
        let wode = UIButton(frame: CGRect(x: guanzhu.frame.size.width, y: guanzhu.frameY, width: fujin.frame.size.width, height: fujin.frameHeight))
        wode.addTarget(self, action: #selector(self.wode), for: .touchUpInside)
        wode.setTitle("我的", for: .normal)
        let woyaochang = UIButton(frame: CGRect(x: (APPW - 100) / 2, y: guanzhu.frameY - 50, width: 100, height: 100))
        woyaochang.layer.cornerRadius = 50
        woyaochang.backgroundColor = UIColor.red
        woyaochang.setTitle("我要唱", for: .normal)
        woyaochang.addTarget(self, action: #selector(self.woyaochang), for: .touchUpInside)
        let cell = UIView(frame: CGRect(x: 0, y: guanzhu.frameY + guanzhu.frameHeight, width: APPW, height: 60))
        let icon = UIImageView(frame: CGRect(x: 20, y: 10, width: 40, height: 40))
        icon.image = UIImage(named: "")
        let textLabel = UILabel(frame: CGRect(x: icon.frameX + icon.frame.size.width, y: icon.frameY, width: 100, height: 40))
        textLabel.text = "大赛"
        let accessoryText = UILabel(frame: CGRect(x: APPW - 200, y: icon.frameY, width: 200, height: 40))
        accessoryText.text = "参与K歌大赛，赢取丰厚好礼"
        let cellBtn = UIButton(frame: cell.frame)
        cellBtn.addTarget(self, action: #selector(self.cell), for: .touchUpInside)
        cell.addSubview(icon)
        cell.addSubview(textLabel)
        cell.addSubview(accessoryText)
        cell.addSubview(cellBtn)
        view.addSubview(banner)
        view.addSubview(fujin)
        view.addSubview(guanzhu)
        view.addSubview(paihang)
        view.addSubview(wode)
        view.addSubview(woyaochang)
        view.addSubview(cell)
        view.backgroundColor = UIColor.gray
    }
    @objc func swipe(_ sender: UISwipeGestureRecognizer?) {
        //        sideMenuViewController.presentRightMenuViewController()
    }
    func fujin() {
    }
    
    func paihang() {
    }
    
    func guanzhu() {
    }
    
    func wode() {
    }
    
    func woyaochang() {
    }
    
    func cell() {
    }
}
