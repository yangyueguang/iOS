//
//  EnergyHomeViewController.swift
//  Freedom
import UIKit
import XExtension
import XCarryOn
class EnergyHomeViewCell:BaseCollectionViewCell<Any> {
    override func initUI() {
        self.icon = UIImageView(frame: CGRect(x:0, y: 0, width: APPW/5, height:60))
        self.icon.layer.cornerRadius = 20
        self.icon.clipsToBounds = true
        self.title = UILabel(frame: CGRect(x: 0, y:  self.icon.bottom, width:self.icon.width, height: 20))
        self.title.textAlignment = .center
        self.contentMode = .center
        self.addSubviews([self.title,self.icon])
        self.title.text = "name"
        self.icon.image = UIImage(named:"taobaomini2")
    }
}
final class EnergyHomeViewController: EnergyBaseViewController,UICollectionViewDelegate,UICollectionViewDataSource{

    var collectionView: BaseCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
    self.view.backgroundColor = .white
        let more = UIBarButtonItem(image: UIImage(named:"u_add_y"), style: .plain, target: nil, action: nil)
    self.navigationItem.rightBarButtonItem = more;
        let searchBar = UISearchBar()
    searchBar.placeholder = "输入问题关键字";
    self.navigationItem.titleView = searchBar;
    let banner = BaseScrollView(banner: CGRect(x: 0, y: 0, width: APPW, height: 120), icons: ["",""])
        
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: APPW/5, height:80);
    layout.sectionInset = UIEdgeInsets(top: banner.bottom+10, left: 10, bottom: 0, right: 10);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
        self.collectionView = BaseCollectionView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH-110), collectionViewLayout: layout)
        self.collectionView.dataArray = NSMutableArray(array: ["微请柬","微渠道","微助手","分销版","微政务","微社区","微外卖","微配送",
"微挂号","微游戏","微OA","微名片","全景720","微贺卡","优惠券","微团购","微点菜","微小店","微彩票","问卷调查","微信打印机","微信wifi","客户备忘","微报名","订房易","抢元宝","微现场","超级加油","微网站","微商城","会员卡","微相册","微信支付","微喜帖","微测试","超级秒杀","全民经纪人","微投票","微签到","微预约"])
self.collectionView.register(EnergyHomeViewCell.self, forCellWithReuseIdentifier: EnergyHomeViewCell.identifier)
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
        self.collectionView.addSubview(banner)
        view.addSubview(self.collectionView)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionView.dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(EnergyHomeViewCell.self, for: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let value = self.collectionView.dataArray[indexPath.row]
        push(EnergyDetailViewController(), title: value as! String)
    }
}
