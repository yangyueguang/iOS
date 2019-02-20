//
//  TaobaoMiniViewController.swift
//  Freedom
import UIKit
import XExtension
final class TaobaoMiniViewController: TaobaoBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftI = UIBarButtonItem(image: TBImage.scanner.image, style: .done, target: nil, action: nil)
        let rightI = UIBarButtonItem(image: TBImage.scanner.image, style: .done, target: nil, action: nil)
        let rightII = UIBarButtonItem(image: TBImage.scanner.image, style: .done, target: nil, action: nil)
        navigationItem.leftBarButtonItem = leftI
        navigationItem.rightBarButtonItems = [rightI, rightII] as? [UIBarButtonItem]
        title = "微淘"
        let titles = ["动态", "上新", "视频", "热文", "话题榜"]
        let icons = ["taobaomini1", "taobaomini2", "taobaomini3", "taobaomini4", "taobaomini5"]
        let controllers = [TaobaoMiniDynamicViewController(), TaobaoMiniNewViewController(), TaobaoMiniVideoViewController(), TaobaoMiniArticleViewController(), TaobaoMiniTopicViewController()]
        let TaobaoMiniScrollV = BaseScrollView(contentIconView: CGRect(x: 0, y: 0, width: Int(APPW), height: Int(APPH - TabBarH) - 55), titles: titles, icons: icons, controllers: controllers, in: self)
        TaobaoMiniScrollV.selectBlock = {(_ index: Int, _ dict: [AnyHashable: Any]?) -> Void in
            Dlog("点击了\(String(describing: dict))")
        }
        TaobaoMiniScrollV.selectThePage(3)
    }
}
