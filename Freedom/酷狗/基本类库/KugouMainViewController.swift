//
//  MainViewController.swift
//  Freedom
import UIKit
//import XExtension
import MediaPlayer
import AVFoundation
class KugouMainViewController: KugouBaseViewController {
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var contentView: UIScrollView!
    @IBOutlet weak var tabBarView: KugouTabBarView?
    @IBOutlet var titleButtons: [UIButton]!
    let meVc = KugouMeViewController.storyVC(.kugou)
    let linsenVc = KugouLinsenViewController.storyVC(.kugou)
    let lookVc = KugouLookViewController.storyVC(.kugou)
    let singVc = KugouSingViewController.storyVC(.kugou)
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        tabBarController?.tabBar.isHidden = true
        edgesForExtendedLayout = [.left, .right, .bottom]
        addChild(meVc)
        addChild(linsenVc)
        addChild(lookVc)
        addChild(singVc)
        contentView.contentSize = CGSize(width: contentView.frame.size.width * CGFloat(children.count), height: 0)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        let vc = children[index]
        vc.view.frame = CGRect(x: scrollView.contentOffset.x, y: 0, width: APPW, height: scrollView.frame.size.height)
        scrollView.addSubview((vc.view)!)
        let btn = titleButtons[index]
        titleAction(btn)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    @IBAction func titleAction(_ sender: UIButton) {
        titleButtons.forEach(where: { (btn) -> Bool in
            return true
        }) { (btn) in
            btn.titleLabel?.font = UIFont.normal
        }
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.contentView.setContentOffset(CGPoint(x: self.contentView.width * CGFloat(sender.tag), y: 0), animated: true)
    }
    @IBAction func setAction(_ sender: Any) {
        sideMenuViewController.presentLeftMenuViewController()
    }
    @IBAction func addAction(_ sender: Any) {
    }
}
