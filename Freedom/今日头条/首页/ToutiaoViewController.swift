
//
//  ToutiaoViewController.swift
//  Freedom
import UIKit
import XExtension
class ToutiaoViewController: ToutiaoBaseViewController {
let titleScrollView = UIScrollView()//标题ScrollView
let contentScrollView = UIScrollView()//内容scrollView
var selTitlebutton = UIButton()//标题中的按钮
var buttons = [UIButton]()
let titles = ["新能源","政策","新闻","国防","汽车","环保","核电","节能环保","动力"]
let tagids = ["12","13","14","17","19","21","22","24","25"]
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.navigationBar.setBackgroundImage(UIImage(named:"ToutiaoBackBar"), for: UIBarPosition.top, barMetrics: .default)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleScrollView.frame = CGRect(x: 0, y: 0, width: APPW, height: APPH)
        navigationItem.titleView = titleScrollView
        contentScrollView.frame = CGRect(x: 0, y: 0, width: APPW, height: APPH)
        view.addSubview(contentScrollView)
        for i in 0..<titles.count{
            let vc = ToutiaoHomeSampleViewController()
            addChild(vc)
            let button = UIButton(frame: CGRect(x: CGFloat(i)*80, y: 0, width: 80, height: 40))
            button.tag = i
            button.setTitle(titles[i], for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            button.addTarget(self, action: #selector(clicked), for: .touchUpInside)
            titleScrollView.addSubview(button)
            buttons.append(button)
            if i==0{
                self.clicked(button)
            }
        }
   titleScrollView.contentSize = CGSize(width: CGFloat(titles.count)*80, height: 0)
        titleScrollView.showsHorizontalScrollIndicator = false
        automaticallyAdjustsScrollViewInsets = false
        contentScrollView.contentSize = CGSize(width: CGFloat(titles.count)*APPW, height: 0)
        contentScrollView.isPagingEnabled = true
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.delegate = self
        titleScrollView.setContentOffset(CGPoint.zero, animated:false)
    }
    func clicked(_ button:UIButton){
    let x = CGFloat(button.tag)*APPW
    self.setTitleBtn(button)
        let vc = self.children[button.tag]
        if vc.view.superview != nil{
            contentScrollView.contentOffset = CGPoint(x: x, y: 0)
            return;
        }
        vc.view.frame = CGRect(x: x, y: 0, width: APPW, height: APPH)
        contentScrollView.addSubview(vc.view)
        contentScrollView.contentOffset = CGPoint(x: x, y: 0)
    }
    func setTitleBtn(_ button:UIButton){
    selTitlebutton.setTitleColor(.white, for: .normal)
        selTitlebutton.transform = CGAffineTransform.identity
        button.setTitleColor(.white, for: .normal)
        button.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        selTitlebutton = button
        var offset = button.center.x-APPW*0.5
        if offset<0{
            offset = 0
        }
        let maxOffset = titleScrollView.contentSize.width-APPW
        if offset>maxOffset{
            offset = maxOffset
        }
        titleScrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let i = self.contentScrollView.contentOffset.x / APPW;
        setTitleBtn(self.buttons[Int(i)] )
        let x = CGFloat(i)*APPW
        let vc = children[Int(i)]
        if vc.view.superview != nil{
            return;
        }
        vc.view.frame = CGRect(x: x, y: 0, width: APPW, height: APPH)
        contentScrollView.addSubview(vc.view)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x;
        let left:Int = Int(offset/APPW);
    let right = 1 + left;
        let leftButton:UIButton = self.buttons[left]
        var rightButton :UIButton?
    if right < self.buttons.count {
        rightButton = self.buttons[right]
        }
    let scaleR = offset/APPW - CGFloat(left);
    let scaleL = 1 - scaleR;
        let tranScale:CGFloat = 1.2 - 1 ;//左右按钮的缩放比例
    leftButton.transform = CGAffineTransform(scaleX: scaleL * tranScale+1, y: scaleR*tranScale+1)
        rightButton?.transform = CGAffineTransform(scaleX: scaleR * tranScale + 1, y: scaleR * tranScale + 1)
    let rightColor = RGBAColor(250, 250, 250, 1)
        let leftColor = RGBAColor(230, 230, 230,  1)
        leftButton.setTitleColor(leftColor, for: .normal)
        rightButton?.setTitleColor(rightColor, for: .normal)
    }
}
