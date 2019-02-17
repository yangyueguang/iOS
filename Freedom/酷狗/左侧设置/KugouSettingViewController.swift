//
//  SettingViewController.swift
//  Freedom
import UIKit
import XExtension
import XCarryOn
class KugouSettingViewCell:BaseTableViewCell<Any> {
    override func initUI() {
        self.icon = UIImageView(frame: CGRect(x:0, y:0, width:0, height:120))
        self.title = UILabel(frame: CGRect(x:0, y:0, width:0, height: 20))
        self.addSubviews([self.title,self.icon])
        self.title.text = "name"
        self.icon.image = UIImage(named:"taobaomini2")
    }
}
final class KugouSettingViewController: KugouBaseViewController {
    var mainVC: KugouMainViewController?
    var topView: UIView?
    var bottomView: UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        let topImage = UIImageView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH))
        topImage.image = UIImage(named: "bj.jpg")
        topImage.isUserInteractionEnabled = true
        view.addSubview(topImage)
        bottomView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH))
        view.addSubview(bottomView!)
        bottomView?.addSubview(setupTopView()!)
        bottomView?.addSubview(setupBottomView()!)
        setupTableView()
        setupLeftGesture()
        setupMainVCTapGesture()
    }
    func setupTopView() -> UIView? {
        topView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 100))
        view.addSubview(topView!)
        let img = UIImageView(frame: CGRect(x: 15, y: 0, width: 40, height: 40))
        img.image = UIImage(named: "placeHoder-128")
        img.center = CGPoint(x: img.center.x, y: (topView?.center.y)!)
        img.layer.cornerRadius = img.frame.size.width * 0.5
        img.layer.masksToBounds = true
        topView?.addSubview(img)
        let img2 = UIImageView(frame: CGRect(x: APPW - 80, y: 0, width: 40, height: 40))
        img2.image = UIImage(named: "placeHoder-128")
        img2.center = CGPoint(x: img2.center.x, y: (topView?.center.y)!)
        img2.layer.cornerRadius = img.frame.size.width * 0.5
        img2.layer.masksToBounds = true
        topView?.addSubview(img2)
        let lineView = UIView(frame: CGRect(x: 10, y: 99, width: APPW - 70, height: 0.5))
        lineView.backgroundColor = UIColor.whitex
        lineView.alpha = 0.3
        topView?.addSubview(lineView)
        return topView
    }
    func setupBottomView() -> UIView? {
        let foot = UIView(frame: CGRect(x: 0, y: APPH - 110, width: APPW, height: 110))
        let lineView = UIView(frame: CGRect(x: 10, y: 0, width: APPW - 70, height: 0.5))
        lineView.backgroundColor = UIColor.whitex
        lineView.alpha = 0.3
        foot.addSubview(lineView)
        let btn = UIButton(frame: CGRect(x: 20, y: 40, width: 80, height: 40))
        btn.setTitle("设置", for: .normal)
        btn.titleLabel?.font = UIFont.normal
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        btn.setImage(UIImage(named: "setting"), for: .normal)
        foot.addSubview(btn)
        return foot
    }
    func setupTableView() {
        tableView = BaseTableView(frame: CGRect(x: 0, y: (topView?.height)!, width: APPW, height: APPH - 210), style: .plain)
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        bottomView?.addSubview(tableView)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueCell(BaseTableViewCell<Any>.self)
        cell.imageView?.image = UIImage(named: "music")
        cell.textLabel?.text = "手机专享"
        cell.textLabel?.textColor = UIColor.whitex
        cell.backgroundColor = UIColor.blackx
        cell.selectionStyle = .none
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func setupLeftGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(KugouSettingViewController.clickPan(_:)))
        view.addGestureRecognizer(panGesture)
    }
    func clickPan(_ pan: UIPanGestureRecognizer?) {
//        let point: CGPoint? = pan?.translation(in: view)
//        if (point?.x ?? 0.0) > 0 {
//            return
//        }
//        let deltaX = Double(fabs(Float(point?.x ?? 0.0)))
//        let scare = CGFloat(1 - deltaX / 1000.0)
//        let tranX = CGFloat(-fabs(Float(deltaX)) / 200.0)
//        let tranY = CGFloat(fabs(Float(deltaX)) / 1000.0)
//        Dlog(scare)
//        if 0.5 < scare < 1 {
//            bottomView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
//        } else {
//            bottomView.transform = view.transform.scaledBy(x: scare, y: scare)
//            if ((APPW - 50) / APPW + tranX) >= 0 {
//                presentingViewController.view.x = ((APPW - 50) / APPW + tranX) * APPW
//                presentingViewController.view.y = (100 / APPH - tranY) * APPH
//                presentingViewController.view.height = APPH - 2 * presentingViewController.view.y
//            }
//            if pan?.state == .ended {
//                if ((APPW - 50) / APPW + tranX) <= 0.2 {
//                    UIView.animate(withDuration: 0.1, animations: {() -> Void in
//                        self.presentingViewController.view.x = 0
//                        self.presentingViewController.view.y = 0
//                        self.presentingViewController.view.height = APPH
//                        self.bottomView.transform = CGAffineTransform(scaleX: 1, y: 1)
//                    }, completion: {(_ finished: Bool) -> Void in
//                        self.dismiss(animated: true) {() -> Void in }
//                    })
//                } else {
//                    UIView.animate(withDuration: 0.3, animations: {() -> Void in
//                        self.presentingViewController.view.x = APPW - 50
//                        self.presentingViewController.view.y = 100
//                        self.presentingViewController.view.height = APPH - 200
//                        self.bottomView.transform = CGAffineTransform(scaleX: 1, y: 1)
//                    })
//                }
//            }
//        }
    }
    func setupMainVCTapGesture() {
//        presentingViewController.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickMainVC)))
    }
    
    @objc func clickMainVC() {
        dismiss(animated: true, completion: {() -> Void in
            
        })
    }
}
