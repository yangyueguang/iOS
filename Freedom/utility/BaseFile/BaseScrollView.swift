
import UIKit
import SDWebImage
func RGBACOLOR(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}
@objc
public enum MyScrolltype : Int {
    case scrollTypeSegment = 1 //分类平分展示视图
    case scrollTypeTitleScroll //标题滑动，自适应文字宽度
    case scrollTypeTitleIconScroll //标题滑动，有文字和图标的
    case scrollTypeBaseItem //内容小项目滑动，一般在主页
    case scrollTypeScrollItem //内容小项目滑动，一般在主页并且有分页的
    case scrollTypeContentView //内容视图滑动，如新闻类
    case scrollTypeContentTitleView //内容视图滑动，如新闻类，同时自带标题的滑动
    case scrollTypeContentIconView //内容视图滑动，如新闻类，同时自带标题拥有图标的滑动
    case scrollTypeBanner //横着的滚动视图一般见推荐或广告
    case scrollTypeVerticallyBanner //竖着动态播放的视图或广告
    case scrollTypeWelcom //欢迎界面
}
public typealias selectIndexBlock = (Int, [AnyHashable : Any]?) -> Swift.Void
public typealias viewOfIndexBlock = (Int) -> UIView?
@objcMembers
open class BaseScrollView : UIScrollView, UIScrollViewDelegate {
    open var time: Timer! //计时器
    open var icons: [Any]! //图片内容  由图片视图或视图组成的数组
    open var titles: [Any]! //标题    由文字组成的数组
    open var contentViews: [UIView]! = [] //用来盛放视图的
    open var selectBlock: selectIndexBlock! //内部反馈选择了第几个块
    open var viewBlock: viewOfIndexBlock! //外部协议告知第几个视图是什么样
    weak open var pushDelegateVC: UIViewController! //因为当前vc没有导航，所以交给此VCpush
    open var title: BaseScrollView! //组合视图中的标题视图
    open var content: BaseScrollView! //组合视图中的内容视图
    open var scrollType: MyScrolltype = MyScrolltype.scrollTypeSegment
    private var count: Int = 0
    private var index: Int = 0
    private var pagecontroller: UIPageControl?
    private var round = false
    //小项目滑动的图标要不要圆
//    private var size = CGSize.zero
    //小项目滑动的图标尺寸大小
    private var hang: Int = 0
    override init(frame: CGRect) {
        scrollType = MyScrolltype.scrollTypeSegment
        index = 0
        super.init(frame: frame)
        self.frame = frame
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) 没有实现")
    }
    //FIXME:分类平分展示视图
    public init(segment frame: CGRect, titles: [String]) {
        super.init(frame: frame)
        scrollType = MyScrolltype.scrollTypeSegment
        self.titles = titles
        var starx: CGFloat = 0.0
        for view: UIView in subviews {
            view.removeFromSuperview()
        }
        for i in 0..<titles.count {
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: starx, y: 0, width:self.frame.size.width / CGFloat(titles.count), height: self.frame.size.height)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.tag = 10 + i
            button.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
            button.setTitleColor(RGBACOLOR(r: 33, g: 34, b: 35, a: 1), for: .normal)
            button.setTitle(titles[i], for: .normal)
            button.backgroundColor = RGBACOLOR(r: 224, g: 225, b: 226, a: 1)
            addSubview(button)
            let line1 = UIImageView(frame: CGRect(x: button.frame.origin.x+button.frame.size.width, y: button.frame.origin.y, width: 1, height: button.frame.size.height))
            line1.backgroundColor = RGBACOLOR(r: 210, g: 210, b: 210, a: 1)
            addSubview(line1)
            starx = line1.frame.origin.x+line1.frame.size.width
            if i == titles.count - 1 {
                line1.backgroundColor = UIColor.clear
            }
            let line = UIView(frame: CGRect(x: 0, y: button.frame.size.height - 1, width: button.frame.size.width, height: 1))
            line.tag = button.tag + 20
            button.addSubview(line)
            if i == 0 {
                button.backgroundColor = UIColor.white
                line.backgroundColor = UIColor.red
            }
        }
        contentSize = CGSize(width: starx, height: 0)
        showsHorizontalScrollIndicator = false
        bounces = false
        bouncesZoom = false
    }
    //FIXME:标题滑动，自适应文字宽度
    public init(titleScroll frame:CGRect,titles:[String]){
        super.init(frame: frame)
        self.titles = titles
        scrollType = MyScrolltype.scrollTypeTitleScroll
        var starx: CGFloat = 0.0
        for view: UIView in subviews {
            view.removeFromSuperview()
        }
        for i in 0..<titles.count {
            let size = (titles[i] as AnyObject).boundingRect(with: CGSize(width: UIScreen.main.bounds.width, height: self.frame.size.height), options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.foregroundColor : UIColor.red ,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil).size
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: starx, y: 0, width: size.width + 30, height: self.frame.size.height)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.tag = 10 + i
            button.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
            button.setTitleColor(RGBACOLOR(r: 33, g: 34, b: 35, a: 1), for: .normal)
            button.setTitle(titles[i], for: .normal)
            button.backgroundColor = UIColor.gray
            addSubview(button)
            let line1 = UIImageView(frame: CGRect(x: button.frame.origin.x+button.frame.size.width, y: button.frame.origin.y, width: 1, height: button.frame.size.height))
            line1.backgroundColor = RGBACOLOR(r: 210, g: 210, b: 210, a: 1)
            addSubview(line1)
            starx = line1.frame.size.width+line1.frame.origin.x
            if i == self.titles.count - 1 {
                line1.backgroundColor = UIColor.clear
            }
            let line = UIView(frame: CGRect(x: 0, y: button.frame.size.height - 1, width: button.frame.size.width, height: 1))
            line.tag = button.tag + 20
            button.addSubview(line)
            if i == 0 {
                button.backgroundColor = UIColor.white
                line.backgroundColor = UIColor.red
            }
        }
        contentSize = CGSize(width: starx, height: 0)
        showsHorizontalScrollIndicator = false
        bounces = false
        bouncesZoom = false
    }
    //FIXME:标题滑动，有文字和图标的
    public init(titleIconScroll frame: CGRect, titles: [String], icons: [String]){
        super.init(frame: frame)
        self.titles = titles
        self.icons = icons
        scrollType = MyScrolltype.scrollTypeTitleIconScroll
        var starx: CGFloat = 0.0
        for view: UIView in subviews {
            view.removeFromSuperview()
        }
        for i in 0..<titles.count {
            let button = UIButton(frame: CGRect(x: starx, y: 0, width: self.frame.size.width / CGFloat(titles.count), height: self.frame.size.height))
            button.setTitle(titles[i], for: .normal)
            button.setImage(UIImage(named: icons[i]), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.titleLabel?.textAlignment = .center
            button.tag = 10 + i
            button.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
            button.setTitleColor(RGBACOLOR(r: 33, g: 34, b: 35, a: 1), for: .normal)
            button.backgroundColor = UIColor.lightGray
            button.contentHorizontalAlignment = .center
            let heightSpace: CGFloat = 10.0
            button.imageEdgeInsets = UIEdgeInsets(top: 1, left: 10, bottom: 30, right: 0)
            button.titleEdgeInsets = UIEdgeInsets(top: 30, left: -button.frame.size.width, bottom: 0, right: 0)
            button.imageEdgeInsets = UIEdgeInsets(top: heightSpace, left: 0.0, bottom: button.frame.size.height - button.imageView!.frame.size.height - heightSpace, right: -button.titleLabel!.frame.size.width)
            button.titleEdgeInsets = UIEdgeInsets(top: button.imageView!.frame.size.height + heightSpace, left: -button.imageView!.frame.size.width, bottom: 0.0, right: 0.0)
            addSubview(button)
            starx += button.frame.size.width
            if i == 0 {
                button.backgroundColor = UIColor.white
            }
        }
        contentSize = CGSize(width: starx, height: 0)
        showsHorizontalScrollIndicator = false
        bounces = false
        bouncesZoom = false
    }
    
    //FIXME:内容小项目滑动，一般在主页
    public init(baseItem frame: CGRect, icons: [String], titles: [String], size: CGSize, round: Bool){
        super.init(frame: frame)
        self.titles = titles
        self.icons = icons
        self.size = size
        self.round = round
        scrollType = .scrollTypeBaseItem
        var starx: CGFloat = 0
        var stary: CGFloat = 0
        for i in 0..<titles.count {
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: starx, y: stary, width: size.width, height: size.height)
            button.tag = 10 + i
            button.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
            starx = button.frame.size.width+button.frame.origin.x
            if starx > self.frame.size.width {
                //一行放不下的时候换行
                starx = 0
                stary = button.frame.size.height+button.frame.origin.y
                button.frame = CGRect(x: starx, y: stary, width: size.width, height: size.height)
                starx = button.frame.size.width+button.frame.origin.x
            }
            addSubview(button)
            let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width - 20, height: size.height - 30))
            imageview.center = CGPoint(x: button.frame.size.width / 2, y: button.frame.size.height / 2 - 15)
            imageview.contentMode = .scaleAspectFill
            if round {
                imageview.layer.cornerRadius = imageview.frame.size.width / 2
            }
            imageview.clipsToBounds = true
            imageview.image = icons[i].image
            button.addSubview(imageview)
            let namelable = UILabel(frame: CGRect(x: 0, y: imageview.frame.size.height+imageview.frame.origin.y + 8, width: button.frame.size.width, height: 20))
            namelable.font = UIFont.systemFont(ofSize: 13)
            namelable.textColor = RGBACOLOR(r: 33, g: 34, b: 35, a: 1)
            namelable.text = titles[i]
            namelable.textAlignment = .center
            button.addSubview(namelable)
        }
        self.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: stary + size.height)
        print("最终的y是：\(self.frame.size.height+self.frame.origin.y))")
    }

    //FIXME:内容小项目滑动，一般在主页并且有分页的
    public init(scrollItem frame: CGRect, icons: [String], titles: [String], size: CGSize, hang: Int, round: Bool){
        super.init(frame: frame)
        self.titles = titles
        self.icons = icons
        self.size = size
        self.round = round
        scrollType = MyScrolltype.scrollTypeScrollItem
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        let lie = Int(self.frame.size.width / size.width)
        let qnum = Int(hang) * lie
        var starx: CGFloat = 0
        var stary: CGFloat = 0
        for i in 0..<titles.count {
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: starx, y: stary, width: size.width, height: size.height)
            button.tag = 10 + i
            button.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
            starx = button.frame.origin.x+button.frame.size.width
            if (i + 1) % lie == 0 {
                //一行放不下的时候换行
                starx -= self.frame.size.width
                stary = button.frame.origin.y+button.frame.size.height
            }
            if stary / button.frame.size.height >= CGFloat(hang) {
                //行数够了，翻页显示
                starx = self.frame.size.width * CGFloat(i + 1)/CGFloat(qnum)
                stary = 0
            }
            let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: size.height - 30, height: size.height - 30))
            imageview.center = CGPoint(x: button.frame.size.width / 2, y: button.frame.size.height / 2 - 10)
            imageview.contentMode = .scaleAspectFill
            if round {
                imageview.layer.cornerRadius = imageview.frame.size.width / 2
            }
            imageview.clipsToBounds = true
            imageview.image = icons[i].image
            button.addSubview(imageview)
            let namelable = UILabel(frame: CGRect(x: 0, y: imageview.frame.size.height+imageview.frame.origin.y + 5, width: button.frame.size.width, height: 20))
            namelable.font = UIFont.systemFont(ofSize: 13)
            namelable.textColor = RGBACOLOR(r: 33, g: 34, b: 35, a: 1)
            namelable.text = titles[i]
            namelable.textAlignment = .center
            button.addSubview(namelable)
            addSubview(button)
        }
        self.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: size.height * CGFloat(hang))
        contentSize = CGSize(width: self.frame.size.width * CGFloat(titles.count / qnum + (titles.count % qnum>0 ? 1 : 0)), height: frame.size.height)
        print("最终的y是：\(self.frame.size.height))")
    }
    
    //FIXME:内容视图滑动，如新闻类
    public init(contentView frame: CGRect, controllers: [UIViewController], in NVC: UIViewController){
        super.init(frame: frame)
        delegate = self
        self.pushDelegateVC = NVC
        count = controllers.count
        contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(count), height: 0)
        scrollType = .scrollTypeContentView
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        for i in 0..<count {
            NVC.addChild(controllers[i])
        }
        let vc = NVC.children[0]
        vc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.size.height)
        addSubview((vc.view)!)
    }
    //FIXME:内容视图滑动，如新闻类，同时自带标题的滑动
    public init(contentTitleView frame: CGRect, titles: [String], controllers: [UIViewController], in NVC: UIViewController){
        super.init(frame: frame)
        self.scrollType = .scrollTypeContentTitleView
        self.title = BaseScrollView(segment:CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 40), titles: titles)
        self.content = BaseScrollView(contentView: CGRect(x:frame.origin.x, y: (self.title.frame.size.height)+(self.title.frame.origin.y), width:frame.size.width, height:frame.size.height - (self.title.frame.size.height)), controllers: controllers, in: NVC)
        self.pushDelegateVC = NVC
        self.title.selectBlock = {(index, dict) in
            self.selectBlock(index, dict)
            let vc = NVC.children[index]
            if vc.view.superview != nil {
                self.content.contentOffset = CGPoint(x: UIScreen.main.bounds.width * CGFloat(index), y: 0)
                return
            }
            vc.view.frame = CGRect(x: UIScreen.main.bounds.width * CGFloat(index), y: 0, width: UIScreen.main.bounds.width, height:frame.size.height - (self.title.frame.size.height)+(self.title.frame.origin.y))
            self.content.addSubview(vc.view)
            self.content.contentOffset = CGPoint(x: UIScreen.main.bounds.width * CGFloat(index), y: 0)
            }
        
        self.content.selectBlock = {(index, dict) in
            self.selectBlock(index, dict)
            var i = 0
            while i < (self.title.titles.count) {
                let button = self.title.viewWithTag(10 + i) as? UIButton
                button?.setTitleColor(RGBACOLOR(r: 33, g: 34, b: 35, a: 1), for: .normal)
                button?.backgroundColor = UIColor.lightGray
                button?.transform = CGAffineTransform(scaleX: 1, y: 1)
                let line = self.title.viewWithTag((button?.tag)! + 20)
                line?.backgroundColor = UIColor.clear
                i += 1
            }
            let button = self.title.viewWithTag(10 + index) as? UIButton
            button?.transform = CGAffineTransform.identity
            button?.setTitleColor(UIColor.red, for: .normal)
            //文字变红
            button?.backgroundColor = UIColor.white
            //        button.transform = CGAffineTransformMakeScale(1.5, 1.5);//放大的效果,放大1.5倍
            }
        NVC.view.addSubview((self.title)!)
        NVC.view.addSubview((self.content)!)
    }

    //FIXME:内容视图滑动，如新闻类，同时自带拥有图标的标题的滑动
    public init(contentIconView frame: CGRect, titles: [String], icons: [String], controllers: [UIViewController], in NVC: UIViewController){
        super.init(frame: frame)
        self.scrollType = .scrollTypeContentIconView
        self.title = BaseScrollView(titleIconScroll: CGRect(x: frame.origin.x, y: frame.origin.y, width: (self.frame.size.width), height: 60), titles: titles, icons: icons)
        self.content = BaseScrollView(contentView: CGRect(x:frame.origin.x, y: self.title.frame.size.height+self.title.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height - self.title.size.height), controllers: controllers, in: NVC)
        self.pushDelegateVC = NVC
        self.title.selectBlock = {(index,dict) in
            self.selectBlock(index, dict)
            let vc = NVC.children[index]
            if vc.view.superview != nil {
                self.content.contentOffset = CGPoint(x: UIScreen.main.bounds.width * CGFloat(index), y: 0)
                return
            }
            vc.view.frame = CGRect(x: UIScreen.main.bounds.width * CGFloat(index), y: 0, width: UIScreen.main.bounds.width, height:(self.frame.size.height) - (self.title.frame.size.height)+(self.title.frame.origin.y))
            self.content.addSubview(vc.view)
            self.content.contentOffset = CGPoint(x: UIScreen.main.bounds.width * CGFloat(index), y: 0)
            }
        self.content.selectBlock = {(index, dict) in
            self.selectBlock(index, dict)
            var i = 0
            while i < (self.title.titles.count) {
                let button = self.title.viewWithTag(10 + i) as? UIButton
                button?.backgroundColor = UIColor.lightGray
                i += 1
            }
            let button = self.title.viewWithTag(10 + index) as? UIButton
            button?.backgroundColor = UIColor.white
            }
        NVC.view.addSubview((self.title)!)
        NVC.view.addSubview((self.content)!)
    }
    //FIXME:横着的滚动视图一般见推荐或广告
    public init(banner frame: CGRect, icons: [String]){
        super.init(frame: frame)
        //仅支持网址访问图片//pagecontroll在右下角
        scrollType = .scrollTypeBanner
        delegate = self
        contentOffset = CGPoint(x: self.frame.size.width, y: 0)
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        pagecontroller = UIPageControl(frame: CGRect(x: self.frame.size.width - 110, y: self.frame.size.height - 20, width: 100, height: 20))
        pagecontroller?.backgroundColor = UIColor.clear
        pagecontroller?.currentPageIndicatorTintColor = UIColor.red
        pagecontroller?.pageIndicatorTintColor = UIColor.lightGray
        pagecontroller?.currentPage = index
        addSubview(pagecontroller!)
        count = icons.count + 2
        pagecontroller?.numberOfPages = icons.count
        contentSize = CGSize(width: self.frame.size.width * CGFloat(icons.count + 2), height: 0)
        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        imageview.sd_setImage(with: URL(string: (icons.last)!))
        imageview.contentMode = .scaleToFill
        imageview.clipsToBounds = true
        addSubview(imageview)
        for i in 0..<icons.count {
            let imgv = UIImageView(frame: CGRect(x: self.frame.size.width + CGFloat(i) * self.frame.size.width, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            imgv.sd_setImage(with: URL(string: icons[i]))
            imgv.contentMode = .scaleToFill
            imgv.clipsToBounds = true
            imgv.isUserInteractionEnabled = true
            imgv.tag = i
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.itemDidTaped(_:)))
            imgv.addGestureRecognizer(gesture)
            addSubview(imgv)
        }
        let lastimage = UIImageView(frame: CGRect(x: self.frame.size.width * CGFloat(icons.count + 1), y: 0, width: self.frame.size.width, height: self.frame.size.height))
        lastimage.sd_setImage(with: URL(string: (icons.first)!))
        lastimage.contentMode = .scaleToFill
        lastimage.clipsToBounds = true
        addSubview(lastimage)
        time = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.bannerTimeAction), userInfo: nil, repeats: true)
        time.fireDate = Date()
    }

    //FIXME:竖着动态播放的视图或广告
    public init(verticallyBanner frame: CGRect, icons: [String]){
        super.init(frame: frame)
        scrollType = .scrollTypeVerticallyBanner
        delegate = self
        contentOffset = CGPoint(x: 0, y: self.frame.size.height)
        isPagingEnabled = true
        showsVerticalScrollIndicator = false
        count = icons.count + 2
        contentSize = CGSize(width: 0, height: self.frame.size.height * CGFloat(icons.count + 2))
        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        imageview.sd_setImage(with: URL(string: (icons.last)!))
        imageview.contentMode = .scaleToFill
        imageview.clipsToBounds = true
        addSubview(imageview)
        for i in 0..<icons.count {
            let imgv = UIImageView(frame: CGRect(x: 0, y: self.frame.size.height + CGFloat(i) * self.frame.size.height, width: self.frame.size.width, height: self.frame.size.height))
            imgv.sd_setImage(with: URL(string: icons[i]))
            imgv.contentMode = .scaleToFill
            imgv.clipsToBounds = true
            imgv.isUserInteractionEnabled = true
            imgv.tag = i
            let gesture = UITapGestureRecognizer(target: self, action: #selector(itemDidTaped(_:)))
            imgv.addGestureRecognizer(gesture)
            addSubview(imgv)
        }
        let lastimage = UIImageView(frame: CGRect(x: 0, y: self.frame.size.height * CGFloat(icons.count + 1), width: self.frame.size.width, height: self.frame.size.height))
        lastimage.sd_setImage(with: URL(string: (icons.first)!))
        lastimage.contentMode = .scaleToFill
        lastimage.clipsToBounds = true
        addSubview(lastimage)
        time = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.bannerTimeAction), userInfo: nil, repeats: true)
        time.fireDate = Date()
    }

    //FIXME:欢迎界面
    public init(welcom frame: CGRect, icons: [String]){
        super.init(frame: frame)
        self.icons = icons
        scrollType = .scrollTypeWelcom
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        for i in 0..<icons.count {
            let imageV = UIImageView(frame: CGRect(x: CGFloat(i) * frame.size.width, y: frame.origin.y, width: frame.size.width, height: frame.size.height))
            imageV.image = icons[i].image
            imageV.contentMode = .scaleAspectFill
            imageV.clipsToBounds = true
            addSubview(imageV)
            if i == icons.count - 1 {
                let tap = UITapGestureRecognizer(target: self, action: #selector(getter: self.isHidden))
                imageV.isUserInteractionEnabled = true
                imageV.addGestureRecognizer(tap)
            }
        }
        contentSize = CGSize(width: self.frame.size.width * CGFloat(icons.count), height: self.frame.size.height)
    }

    //FIXME:分类展示的标题栏
    public init(viewSegment frame: CGRect, viewsNumber num: Int, viewOfIndex block: @escaping viewOfIndexBlock){
        super.init(frame: frame)
        self.viewBlock = block
        scrollType = .scrollTypeSegment
        var starx: CGFloat = 0.0
        for view: UIView in subviews {
            view.removeFromSuperview()
        }
        for i in 0..<num {
            let view: UIView? = block(i)
            view?.frame = CGRect(x: starx, y: (view?.frame.origin.y)!, width: (view?.frame.size.width)!, height: (view?.frame.size.height)!)
            addSubview(view!)
            starx += (view?.frame.size.width)!
            let gesture = UITapGestureRecognizer(target: self, action: #selector(itemDidTaped(_:)))
            view?.addGestureRecognizer(gesture)
        }
        contentSize = CGSize(width: starx, height: 0)
        showsHorizontalScrollIndicator = false
        bounces = false
        bouncesZoom = false
    }

    //FIXME:内容小项目视图
    public init(viewItem frame: CGRect, viewsNumber num: Int, viewOfIndex block: @escaping viewOfIndexBlock){
        super.init(frame: frame)
        self.viewBlock = block
        scrollType = .scrollTypeBaseItem
        var starx: CGFloat = 0
        var stary: CGFloat = 0
        for i in 0..<num {
            let view: UIView? = block(i)
            view?.frame = CGRect(x: starx, y: stary, width: (view?.frame.size.width)!, height: (view?.frame.size.height)!)
            starx = (view?.frame.size.width)!+(view?.frame.origin.x)!
            if starx > self.frame.size.width {
                //一行放不下的时候
                starx = 0
                stary = (view?.frame.size.height)!+(view?.frame.origin.y)!
                view?.frame = CGRect(x: starx, y: stary, width: (view?.frame.size.width)!, height: (view?.frame.size.height)!)
                starx = (view?.frame.size.width)!+(view?.frame.origin.x)!
            }
            addSubview(view!)
            let gesture = UITapGestureRecognizer(target: self, action: #selector(itemDidTaped(_:)))
            view?.addGestureRecognizer(gesture)
            if i == num - 1 {
                self.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frame.size.height > (view?.frame.size.height)!+(view?.frame.origin.y)! ? frame.size.height : (view?.frame.size.height)!+(view?.frame.origin.y)!)
            }
        }
    }
    
    //FIXME:视图banner兼容内容视图
    public init(viewBanner frame: CGRect, viewsNumber num: Int, viewOfIndex block: @escaping viewOfIndexBlock, vertically vertical: Bool, setFire fire: Bool){
        super.init(frame: frame)
        self.viewBlock = block
        isPagingEnabled = true
        count = num + 2
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        for i in 0..<num + 2 {
            var view: UIView?
            if i == 0 {
                view = block(num - 1)
            }else if i == num + 1 {
                view = block(0)
            }else {
                view = block(i - 1)
            }
            contentViews.append(view!)
        }
        var starx: CGFloat = 0
        var stary: CGFloat = 0
        let view1: UIView? = contentViews[num - 1]
        addSubview(view1!)
        for i in 0..<num + 2 {
            let view: UIView? = contentViews[i]
            view?.frame = CGRect(x: CGFloat(starx), y: CGFloat(stary), width: (view?.frame.size.width)!, height: (view?.frame.size.height)!)
            if vertical {
                stary += (view?.frame.size.height)!
            }else {
                starx += (view?.frame.size.width)!
            }
            let gesture = UITapGestureRecognizer(target: self, action: #selector(itemDidTaped(_:)))
            view?.addGestureRecognizer(gesture)
            addSubview(view!)
        }
        if vertical {
            scrollType = MyScrolltype.scrollTypeVerticallyBanner
            contentSize = CGSize(width: self.frame.size.width, height: self.frame.size.height * CGFloat(num + 2))
            contentOffset = CGPoint(x: 0, y: self.frame.size.height)
        }else {
            scrollType = MyScrolltype.scrollTypeBanner
            contentSize = CGSize(width: self.frame.size.width * CGFloat(num + 2), height: 0)
            contentOffset = CGPoint(x: self.frame.size.width, y: 0)
        }
        delegate = self
        if fire {
            time = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.bannerTimeAction), userInfo: nil, repeats: true)
            time.fireDate = Date()
        }
    }

    //FIXME: Actions===========================================
    //外界调用主动选择第几个块
    public func selectThePage(_ page: Int) {
        switch scrollType {
        case .scrollTypeSegment:
            let button = viewWithTag(page + 10) as? UIButton
            buttonAction(button!)
        case .scrollTypeTitleScroll:
            let button = viewWithTag(page + 10) as? UIButton
            buttonAction(button!)
        case .scrollTypeTitleIconScroll:
            let button = viewWithTag(page + 10) as? UIButton
            buttonAction(button!)
        case .scrollTypeBaseItem:
            let button = viewWithTag(page + 10) as? UIButton
            buttonAction(button!)
        case .scrollTypeScrollItem:
            let button = viewWithTag(page + 10) as? UIButton
            buttonAction(button!)
        case .scrollTypeContentView:
            setContentOffset(CGPoint(x: UIScreen.main.bounds.width * CGFloat(page), y: 0), animated: false)
            
        case .scrollTypeContentTitleView:
            self.selectBlock(page, nil)
        case .scrollTypeContentIconView:
            for i in 0..<self.titles.count {
                let button = title.viewWithTag(10 + i) as? UIButton
                button?.backgroundColor = UIColor.lightGray
                if i == page {
                    button?.backgroundColor = UIColor.white
                }
            }
            self.selectBlock(page, nil)
        case .scrollTypeBanner:
            pagecontroller?.currentPage = index
            contentOffset = CGPoint(x: self.frame.size.width * CGFloat(page), y: 0)
        case .scrollTypeVerticallyBanner:
            contentOffset = CGPoint(x: 0, y: self.frame.size.height * CGFloat(page))
        case .scrollTypeWelcom:
            contentOffset = CGPoint(x: self.frame.size.width * CGFloat(page), y: 0)
        default: break
            //不用做什么
        }
    }

    @objc public func buttonAction(_ btn: UIButton) {
        if selectBlock != nil {
            selectBlock(btn.tag - 10, nil)
        }
        switch scrollType {
        case .scrollTypeSegment:
            for i in 0..<titles.count {
                let button = viewWithTag(10 + i) as? UIButton
                button?.backgroundColor = UIColor.lightGray
                let line = viewWithTag((button?.tag)! + 20)
                line?.backgroundColor = UIColor.clear
            }
            btn.backgroundColor = UIColor.white
            let line = viewWithTag(btn.tag + 20)
            line?.backgroundColor = UIColor.red
        case .scrollTypeTitleScroll:
            var centx: CGFloat = btn.frame.origin.x - UIScreen.main.bounds.width / 2 + btn.frame.size.width / 2
            if contentSize.width < btn.frame.origin.x + (UIScreen.main.bounds.width + btn.frame.size.width) / 2 {
                centx = contentSize.width - UIScreen.main.bounds.width + 29
            }
            else if centx < 0 {
                centx = 0
            }
            setContentOffset(CGPoint(x: centx, y: 0), animated: true)
        case .scrollTypeTitleIconScroll:
            for i in 0..<titles.count {
                let button = viewWithTag(10 + i) as? UIButton
                button?.backgroundColor = UIColor.lightGray
            }
            btn.backgroundColor = UIColor.white
        case .scrollTypeBaseItem: break
        //不用做什么
        case .scrollTypeScrollItem: break
        //不用做什么
        case .scrollTypeContentView:
            var centx: CGFloat = btn.frame.origin.x - UIScreen.main.bounds.width / 2 + btn.frame.size.width / 2
            if contentSize.width < btn.frame.origin.x + (UIScreen.main.bounds.width + btn.frame.size.width) / 2 {
                centx = contentSize.width - UIScreen.main.bounds.width + 29
            }else if centx < 0 {
                centx = 0
            }
            setContentOffset(CGPoint(x: centx, y: 0), animated: true)
        case .scrollTypeContentTitleView: break
        //不用做什么
        case .scrollTypeContentIconView: break
        //不用做什么
        case .scrollTypeBanner: break
        //不用做什么
        case .scrollTypeVerticallyBanner: break
        //不用做什么
        case .scrollTypeWelcom: break
        //不用做什么
        default:break
        }
    }
    
    @objc public func bannerTimeAction() {
        pagecontroller?.currentPage = index
        index += 1
        if scrollType == .scrollTypeBanner {
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.contentOffset = CGPoint(x: self.frame.size.width * CGFloat(self.index), y: 0)
            }, completion: {(_ finished: Bool) -> Void in
                if self.contentOffset.x > self.frame.size.width * CGFloat(self.count - 2) {
                    self.contentOffset = CGPoint(x: self.frame.size.width, y: 0)
                    self.index = 0
                }
                if self.contentOffset.x < self.frame.size.width {
                    self.contentOffset = CGPoint(x: self.frame.size.width * CGFloat(self.count - 2), y: 0)
                    self.index = self.count - 2
                }
            })
        }else if scrollType == .scrollTypeVerticallyBanner {
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.contentOffset = CGPoint(x: 0, y: self.frame.size.height * CGFloat(self.index))
            }, completion: {(_ finished: Bool) -> Void in
                if self.contentOffset.y > self.frame.size.height * CGFloat(self.count - 2) {
                    self.contentOffset = CGPoint(x: 0, y: self.frame.size.height)
                    self.index = 0
                }
                if self.contentOffset.y < self.frame.size.height {
                    self.contentOffset = CGPoint(x: 0, y: self.frame.size.height * CGFloat(self.count - 2))
                    self.index = self.count - 2
                }
            })
        }
    }

    //FIXME: scrollviewdelegate
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        switch scrollType {
            case .scrollTypeSegment: break
            //不用做什么
            case .scrollTypeTitleScroll: break
            //不用做什么
            case .scrollTypeTitleIconScroll: break
            //不用做什么
            case .scrollTypeBaseItem: break
            //不用做什么
            case .scrollTypeScrollItem: break
            //不用做什么
            case .scrollTypeContentView:
                break
            case .scrollTypeContentTitleView:
                break
            case .scrollTypeContentIconView:
                break
            case .scrollTypeBanner: break
            //不用做什么
            case .scrollTypeVerticallyBanner: break
            //不用做什么
            case .scrollTypeWelcom: break
            //不用做什么
            default: break
                //不用做什么
        }
        //    [_time setFireDate:[NSDate dateWithTimeIntervalSinceNow:3]];
    }
    /// 实现字体颜色大小的渐变
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollType {
            case .scrollTypeSegment: break
            //不用做什么
            case .scrollTypeTitleScroll: break
            //不用做什么
            case .scrollTypeTitleIconScroll: break
            //不用做什么
            case .scrollTypeBaseItem: break
            //不用做什么
            case .scrollTypeScrollItem: break
            //不用做什么
            case .scrollTypeContentView: break
            case .scrollTypeContentTitleView:
                //这里是内容视图滚动过程中对标题栏的简便控制没有完成。
                let offset: CGFloat = scrollView.contentOffset.x
                //定义一个两个变量控制左右按钮的渐变
                let left = Int(offset / UIScreen.main.bounds.width)
                let right: Int = 1 + left
                let leftButton = viewWithTag(left + 10) as? UIButton
                var rightButton: UIButton? = nil
                if right < titles.count {
                    rightButton = viewWithTag(10 + right) as? UIButton
                }
                //切换左右按钮
                let scaleR: CGFloat = offset / UIScreen.main.bounds.width - CGFloat(left)
                let scaleL: CGFloat = 1 - scaleR
                //左右按钮的缩放比例
                let tranScale = CGFloat(1.2 - 1)
                //宽和高的缩放(渐变)
                leftButton?.transform = CGAffineTransform(scaleX: scaleL * tranScale + 1, y: scaleL * tranScale + 1)
                rightButton?.transform = CGAffineTransform(scaleX: scaleR * tranScale + 1, y: scaleR * tranScale + 1)
                //颜色的渐变
                let rightColor = UIColor(red: scaleR, green: 250, blue: 250, alpha: 1)
                let leftColor = UIColor(red: 230, green: 230, blue: 230, alpha: 1)
                //重新设置颜色
                leftButton?.setTitleColor(leftColor, for: .normal)
                rightButton?.setTitleColor(rightColor, for: .normal)
            case .scrollTypeContentIconView:
                let offset: CGFloat = scrollView.contentOffset.x
                //定义一个两个变量控制左右按钮的渐变
                let left = Int(offset / UIScreen.main.bounds.width)
                let right: Int = 1 + left
                let leftButton = viewWithTag(left + 10) as? UIButton
                var rightButton: UIButton? = nil
                if right < titles.count {
                    rightButton = viewWithTag(10 + right) as? UIButton
                }
                //切换左右按钮
                let scaleR: CGFloat = offset / UIScreen.main.bounds.width - CGFloat(left)
                let scaleL: CGFloat = 1 - scaleR
                //左右按钮的缩放比例
                let tranScale = CGFloat(1.2 - 1)
                    //宽和高的缩放(渐变)
                leftButton?.transform = CGAffineTransform(scaleX: scaleL * tranScale + 1, y: scaleL * tranScale + 1)
                rightButton?.transform = CGAffineTransform(scaleX: scaleR * tranScale + 1, y: scaleR * tranScale + 1)
                //颜色的渐变
                let rightColor = UIColor(red: scaleR, green: 250, blue: 250, alpha: 1)
                let leftColor = UIColor(red: 230, green: 230, blue: 230, alpha: 1)
                //重新设置颜色
                leftButton?.setTitleColor(leftColor, for: .normal)
                rightButton?.setTitleColor(rightColor, for: .normal)
            case .scrollTypeBanner: break
            //不用做什么
            case .scrollTypeVerticallyBanner: break
            //不用做什么
            case .scrollTypeWelcom: break
            //不用做什么
            default: break
                //不用做什么
        }
    }
    /// 滑动结束的时候
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch scrollType {
            case .scrollTypeSegment: break
            //不用做什么
            case .scrollTypeTitleScroll: break
            //不用做什么
            case .scrollTypeTitleIconScroll: break
            //不用做什么
            case .scrollTypeBaseItem: break
            //不用做什么
            case .scrollTypeScrollItem: break
            //不用做什么
            case .scrollTypeContentView:
                let i: Int = Int(contentOffset.x / UIScreen.main.bounds.width)
                let x = CGFloat(CGFloat(i) * UIScreen.main.bounds.width)
                if (selectBlock != nil) {
                    selectBlock(i, nil)
                }
                let vc = pushDelegateVC.children[i]
                if vc.view.superview != nil {
                    return
                }
                vc.view.frame = CGRect(x: x, y: 0, width: UIScreen.main.bounds.width, height: self.frame.size.height)
                addSubview((vc.view)!)
            case .scrollTypeContentTitleView:
                let i: Int = Int(contentOffset.x / UIScreen.main.bounds.width)
                let x = CGFloat(CGFloat(i) * UIScreen.main.bounds.width)
                if (selectBlock != nil) {
                    selectBlock(i, nil)
                }
                let vc = pushDelegateVC.children[i]
                if vc.view.superview != nil {
                    return
                }
                vc.view.frame = CGRect(x: x, y: 0, width: UIScreen.main.bounds.width, height:self.frame.size.height)
                addSubview((vc.view)!)
            case .scrollTypeContentIconView:
                let i: Int = Int(contentOffset.x / UIScreen.main.bounds.width)
                let x = CGFloat(i) * UIScreen.main.bounds.width
                if (selectBlock != nil) {
                    selectBlock(i, nil)
                }
                let vc = pushDelegateVC.children[i]
                if vc.view.superview != nil {
                    return
                }
                vc.view.frame = CGRect(x: x, y: 0, width: UIScreen.main.bounds.width, height: self.frame.size.height)
                addSubview((vc.view)!)
            case .scrollTypeBanner:
                if contentOffset.x > self.frame.size.width * CGFloat(count - 2) {
                    contentOffset = CGPoint(x: self.frame.size.width, y: 0)
                }
                if contentOffset.x < self.frame.size.width {
                    contentOffset = CGPoint(x: self.frame.size.width * CGFloat(count - 2), y: 0)
                }
                index = Int(contentOffset.x / self.frame.size.width)
                if index > count - 2 {
                    index = 0
                }
                if index < 0 {
                    index = count - 2
                }
                pagecontroller?.currentPage = index
            case .scrollTypeVerticallyBanner:
                if contentOffset.y > self.frame.size.height * CGFloat(count - 2) {
                    contentOffset = CGPoint(x: 0, y: self.frame.size.height)
                }
                if contentOffset.y < self.frame.size.height {
                    contentOffset = CGPoint(x: 0, y: self.frame.size.height * CGFloat(count - 2))
                }
                index = Int(contentOffset.y / self.frame.size.height)
                if index > count - 2 {
                    index = 0
                }
                if index < 0 {
                    index = count - 2
                }
                pagecontroller?.currentPage = index
            case .scrollTypeWelcom: break
            //不用做什么
            default: break
        }
    }
    public func show() {
        UIApplication.shared.windows[0].addSubview(self)
        isHidden = false
        alpha = 1.0
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {() -> Void in
            self.alpha = 1.0
        }, completion: {(_ finished: Bool) -> Void in
        })
    }
    public func hidden() {
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.alpha = 0.0
        }, completion: {(_ finished: Bool) -> Void in
            self.removeFromSuperview()
        })
    }
    public func itemDidTaped(_ tap:UITapGestureRecognizer){
        let i:Int = tap.view!.tag
        if self.selectBlock != nil {
                selectBlock(i, nil)
            }
    }
}
