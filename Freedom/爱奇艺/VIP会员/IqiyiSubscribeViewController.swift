//
//  Freedom
import UIKit
//import XExtension
import MJRefresh
protocol IqiyiSubScribeCardViewDelegate: NSObjectProtocol {
    func didSelectSubImageCard(_ subImageCard: IqiyiSubScribeCardView?, subItem: IqiyiSubItemModel?)
}
class IqiyiSubImageScrollView: UIView {
    weak var delegate: IqiyiSubScribeCardViewDelegate?
    var scrollView: UIScrollView?
    var dataArray = [Any]()
}
class IqiyiSubScribeCardView: UIView {
    var imageView: UIImageView?
    var titleLabel: UILabel?
    var cardImageView: UIImageView?
    var cardLabel: UILabel?
    var subItem: IqiyiSubItemModel?
    weak var delegate: IqiyiSubScribeCardViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cardImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        cardLabel = UILabel(frame: CGRect(x: 0, y: 100, width: 200, height: 20))
        addSubviews([cardImageView!, cardLabel!])
        imageView = UIImageView(frame: CGRect(x: 5, y: 0, width: frame.size.width - 5, height: frame.size.height - 30))
        if let aView = imageView {
            addSubview(aView)
        }
        //
        titleLabel = UILabel(frame: CGRect(x: 5, y: frame.size.height - 30, width: frame.size.width - 5, height: 30))
        titleLabel?.font = UIFont.middle
        titleLabel?.textColor = UIColor.blackx
        if let aLabel = titleLabel {
            addSubview(aLabel)
        }
        let tap = UITapGestureRecognizer(target: self, action:#selector(self.tapImageCard(_:)))
        print(tap);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setSubItem(_ subItem: IqiyiSubItemModel?) {
        self.subItem = subItem
        imageView?.sd_setImage(with: URL(string: subItem?.picurl ?? ""), placeholderImage: IQYImage.holder.image)
        titleLabel?.text = subItem?.title
    }
    @objc func tapImageCard(_ sender: UITapGestureRecognizer?) {
    }
}
class IqiyiSubscribeCell:BaseTableViewCell<IqiyiSubscribeModel> {
    override func initUI() {
        let scrollV = IqiyiSubImageScrollView(frame: CGRect(x: 0, y: 55, width: APPW, height: 155))
        addSubview(scrollV)
        viewModel.subscribe(onNext: {[weak self] (model) in
            guard let `self` = self else { return }
            self.imageView?.sd_setImage(with: URL(string: model.image))
            self.title.text = model.title
            self.script.text = "订阅 \(model.subed_count)"
        }).disposed(by: disposeBag)
    }
}
class IqiyiSubscribeScrollView: UIScrollView {
    var dataArray: [Any]?
    var scrollView:UIScrollView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        scrollView.contentSize = CGSize(width: 2 * APPW, height: frame.size.height)
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        //card
        let cardWidth: Float = Float((APPW * 2 - 15) / 3.0)
        for i in 0..<3 {
            let card = IqiyiSubScribeCardView(frame: CGRect(x: CGFloat(cardWidth * Float(i)), y: 0, width: CGFloat(cardWidth), height: frame.size.height))
            card.frame = CGRect(x: CGFloat((cardWidth + 5) * Float(i) + 5), y: 0, width: CGFloat(cardWidth), height: frame.size.height)
            card.tag = 20 + i
            scrollView.addSubview(card)
//            card.delegate = self
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setDataArray(_ dataArray: [Any]?) {
        self.dataArray = dataArray
        for i in 0..<3 {
            let item = dataArray![i] as! IqiyiSubItemModel
            let card = scrollView.viewWithTag(20 + i) as? IqiyiSubScribeCardView
            card?.subItem = item
        }
    }
    
    func didSelectSubImageCard(_ subImageCard: IqiyiSubScribeCardView?, subItem: IqiyiSubItemModel?) {
    }
}
final class IqiyiSubscribeViewController: IqiyiBaseViewController {
    var subscribeTableView : UITableView!
    var dataSource = [AnyHashable]()
    func setUpRefresh() {
        subscribeTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {() -> Void in
            self.initData()
        })
        subscribeTableView.mj_header.beginRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    func initNav() {
        title = "订阅推荐"
    }
    func initData() {
        
    }
    
    func initView() {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH - 64), style: .plain)
//        tableView.delegate = self
//        tableView.dataSource = self
        //将系统的Separator左边不留间隙
        tableView.separatorInset = UIEdgeInsets.zero
        subscribeTableView = tableView
        view.addSubview(subscribeTableView)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueCell(IqiyiSubscribeCell.self)
//        cell?.delegate = self
        let subM = dataSource[indexPath.row] as? IqiyiSubscribeModel
        print(String(describing:subM!))
        return cell
    }
    func didSelect(_ subCell: IqiyiSubscribeCell?, subItem: IqiyiSubItemModel?) {
        let videoDetailVC = IqiyiVideoDetailViewController()
        videoDetailVC.iid = (subItem?.code)!
        navigationController?.pushViewController(videoDetailVC, animated: true)
    }
    
}
