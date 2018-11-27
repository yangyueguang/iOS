//
//  MainViewController.swift
//  Freedom
import UIKit
import XExtension
import MediaPlayer
import AVFoundation
class KugouTitleScrollView: UIScrollView {
    typealias SelectBlock = (Int) -> Void
    var line: UILabel = UILabel()
    var selectedButt: UIButton?
    var block : SelectBlock?
    var buttonArray = [UIButton]()
    init(frame: CGRect, titleArray: [String], selectedIndex selected_index: Int, scrollEnable: Bool, lineEqualWidth isEqual: Bool, color: UIColor?, select selectColor: UIColor?, selectBlock: @escaping SelectBlock) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        showsHorizontalScrollIndicator = false
        var orign_x: CGFloat = 0
        let height: CGFloat = self.frame.size.height
        let space: CGFloat = scrollEnable ? 20 : 200
        block = selectBlock
        for i in 0..<titleArray.count {
            let title = titleArray[i]
            let size: CGSize = CGSize(width: 200, height: 20)
            let titleButton: UIButton! = UIButton(type: .custom)
            titleButton.frame = CGRect(x: orign_x, y: 0, width: size.width + space, height: height)
            titleButton.setTitle(title, for: .normal)
            titleButton.setTitleColor(color, for: .normal)
            titleButton.setTitleColor(selectColor, for: .selected)
            titleButton.addTarget(self, action: #selector(self.headButtonClick(_:)), for: .touchUpInside)
            titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            titleButton.tag = i
            orign_x = orign_x + space + size.width
            contentSize = CGSize(width: orign_x, height: height)
            if i == selected_index {
                titleButton.isSelected = true
                selectedButt = titleButton
                line.backgroundColor = selectColor
                addSubview(line)
            }
            buttonArray.append(titleButton)
            addSubview(titleButton)
        }
        buttonOffset(selectedButt!)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //按钮点击
    @objc func headButtonClick(_ butt: UIButton) {
        buttonOffset(butt, animated: true)
        for button: UIButton in buttonArray {
            if button.tag == butt.tag{
                button.isSelected = true
            }else{
                button.isSelected = false
            }
        }
        block!(butt.tag)
    }
    //点击控制滚动视图的偏移量
    func buttonOffset(_ butt: UIButton, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.buttonOffset(butt)
            })
        } else {
            buttonOffset(butt)
        }
    }
    /*修改选中标题*  @param selectedIndex 选中标题的索引*/
    var selectedIndex: Int {
        for butt: UIButton in buttonArray {
            if butt.tag == self.selectedIndex {
                buttonOffset(butt, animated: true)
                break
            }
        }
        return 0
    }
    func buttonOffset(_ butt: UIButton) {
        let size: CGSize = CGSize(width: 100, height: 20)
        let width: CGFloat = size.width
        line.bounds = CGRect(x: 0, y: 0, width: width, height: 3)
        line.center = CGPoint(x: butt.center.x, y: butt.frame.size.height - 0.75)
        for button: UIButton in buttonArray {
            if button.tag == butt.tag{
                button.isSelected = true
            }else{
                button.isSelected = false
            }
        }
        if butt.center.x <= center.x {
            contentOffset = CGPoint(x: 0, y: 0)
        } else if (butt.center.x > center.x) && ((contentSize.width - butt.center.x) > (frame.size.width / 2.0)) {
            contentOffset = CGPoint(x: butt.center.x - center.x, y: 0)
        } else {
            contentOffset = CGPoint(x: contentSize.width - frame.size.width, y: 0)
        }
    }
}
class KugouMainViewController: KugouBaseViewController {
    let contentView: UIScrollView = UIScrollView()
    var titleSView: KugouTitleScrollView!
    var coustomTabBar: TabBarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleSView = KugouTitleScrollView(frame: CGRect(x: 100, y: 34, width: APPW - 200, height: 30), titleArray: ["听", "看", "唱"], selectedIndex: 0, scrollEnable: false, lineEqualWidth: false, color: UIColor.white, select: UIColor.orange, selectBlock: { index in
            self.titleClick(index)
        })
        navBar.addSubview(titleSView)
        leftItem.image = UIImage(named: "placeHoder-128")
        leftItem.frame = CGRect(x: 15, y: 34, width: 25, height: 25)
        rightItem.image = UIImage(named: "main_search")
        rightItem.frame = CGRect(x: APPW - 40, y: 34, width: 20, height: 20)
        navBar.backgroundColor = UIColor(white: 1, alpha: 0)
        let linsenVc = KugouLinsenViewController()
        let lookVc = KugouLookViewController()
        let singVc = KugouSingViewController()
        addChild(linsenVc)
        addChild(lookVc)
        addChild(singVc)
        // 不要自动调整inset
        automaticallyAdjustsScrollViewInsets = false
        contentView.frame = view.bounds
        contentView.delegate = self
        contentView.bounces = false
        contentView.isPagingEnabled = true
        view.insertSubview(contentView, at: 0)
        contentView.contentSize = CGSize(width: contentView.frame.size.width * CGFloat(children.count), height: 0)
        coustomTabBar = TabBarView(frame:CGRect(x: 0, y: CGFloat(APPH - TabBarH), width: APPW, height: CGFloat(TabBarH)))
        view.addSubview(coustomTabBar)
        scrollViewDidEndScrollingAnimation(contentView)
        NotificationCenter.default.addObserver(self, selector: #selector(KugouMainViewController.getMessage), name:NSNotification.Name("ChangeMainVCContentEnable"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        edgesForExtendedLayout = [.left, .right, .bottom]
    }
    func getMessage() {
        contentView.isUserInteractionEnabled = true
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func titleClick(_ index: Int) {
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        let vc = children[index]
        vc.view.frame = CGRect(x: scrollView.contentOffset.x, y: 0, width: APPW, height: scrollView.frame.size.height)
        scrollView.addSubview((vc.view)!)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
        let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        titleClick(index)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let alphe: CGFloat = scrollView.contentOffset.x / scrollView.frame.size.width
        navBar.backgroundColor = UIColor(red: 51 / 255.0, green: 124 / 255.0, blue: 200 / 255.0, alpha: alphe)
    }
    // MARK: - 抽屉效果
    override func leftItemTouched(_ sender: Any?) {
        // 如果是已经跳转了，点击后没有反应
        sideMenuViewController.presentLeftMenuViewController()
    }
}
