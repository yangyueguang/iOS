
//
//  ToutiaoViewController.swift
//  Freedom
import UIKit
import RxSwift
import XExtension
class ToutiaoViewController: ToutiaoBaseViewController {
    let titleScrollView = UIScrollView()//标题ScrollView
    let contentScrollView = UIScrollView()//内容scrollView
    var selTitlebutton = UIButton()//标题中的按钮
    let viewModel = PublishSubject<[BaseModel]>()
    var buttons: [UIButton] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        self.titleScrollView.backgroundColor = .orange
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleScrollView.frame = CGRect(x: 0, y: 0, width: APPW, height: 40)
        navigationItem.titleView = titleScrollView
        contentScrollView.frame = CGRect(x: 0, y: 0, width: APPW, height: APPH)
        titleScrollView.setContentOffset(CGPoint.zero, animated:false)
        titleScrollView.showsHorizontalScrollIndicator = false
        automaticallyAdjustsScrollViewInsets = false
        contentScrollView.isPagingEnabled = true
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.delegate = self
        view.addSubview(contentScrollView)
        viewModel.subscribe(onNext: {[weak self] (modes) in
            guard let `self` = self else { return }
            for i in 0..<modes.count{
                let model = modes[i]
                let vc = ToutiaoHomeSampleViewController()
                vc.topicModel = model
                self.addChild(vc)
                let button = UIButton(frame: CGRect(x: CGFloat(i)*80, y: 0, width: 80, height: 40))
                button.tag = i
                button.setTitle(model.title, for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                button.addTarget(self, action: #selector(self.clicked), for: .touchUpInside)
                self.titleScrollView.addSubview(button)
                self.buttons.append(button)
                if i==0{
                    self.clicked(button)
                }
            }
            self.titleScrollView.contentSize = CGSize(width: CGFloat(modes.count)*80, height: 0)
            self.contentScrollView.contentSize = CGSize(width: CGFloat(modes.count)*APPW, height: 0)
        }).disposed(by: disposeBag)
        XNetKit.topicList([:], next: viewModel)
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
        let rightColor = UIColor(250, 250, 250, 1)
        let leftColor = UIColor(230, 230, 230,  1)
        leftButton.setTitleColor(leftColor, for: .normal)
        rightButton?.setTitleColor(rightColor, for: .normal)
    }
}
