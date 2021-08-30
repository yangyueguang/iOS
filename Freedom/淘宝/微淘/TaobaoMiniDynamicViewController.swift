//
//  TaobaoMiniDynamicViewController.swift
//  Freedom
import UIKit
//import XExtension
class TaobaoMiniDynamicViewCell:BaseTableViewCell<Any> {
    override func initUI() {
        super.initUI()
        icon.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        let name = UILabel(frame: CGRect(x: icon.right + 10, y: icon.y - 5, width: APPW - icon.right - 20, height: 20), font: .middle, color: UIColor.redx, text: nil)
        let times = UILabel(frame: CGRect(x: name.x, y: name.bottom, width: name.width, height: 15), font: .small, color: .gray, text: nil)
        let picV = UIImageView(frame: CGRect(x: icon.x, y: icon.bottom + 10, width: APPW - 20, height: 130))
        let cellContentView = UIView(frame: CGRect(x: picV.x, y: picV.bottom, width: picV.width, height: 60))
        cellContentView.backgroundColor = .lightGray
        title.removeFromSuperview()
        script.removeFromSuperview()
        title.frame = CGRect(x: 0, y: 0, width: cellContentView.width, height: 20)
        script.frame = CGRect(x: title.x, y: title.bottom, width: title.width, height: 40)
        script.numberOfLines = 0
        cellContentView.addSubviews([title, script])
        let sees = UILabel(frame: CGRect(x: 10, y: cellContentView.bottom + 10, width: 100, height: 15), font: .small, color: .gray, text: nil)
        let zan = UIButton(frame: CGRect(x: APPW - 130, y: sees.y - 2, width: 55, height: 19))
        let pinglun = UIButton(frame: CGRect(x: zan.right + 10, y: zan.y, width: zan.width, height: zan.height))
        zan.layer.cornerRadius = 7.5
        zan.layer.borderWidth = 0.5
        zan.clipsToBounds = true
        pinglun.layer.cornerRadius = 7.5
        pinglun.layer.borderWidth = 0.5
        pinglun.clipsToBounds = true
        sees.font = FFont(12)
        zan.titleLabel?.font = FFont(12)
        pinglun.titleLabel?.font = FFont(12)
        addSubviews([name, times, picV, cellContentView, sees, zan, pinglun])
        icon.image = TBImage.xin.image
        name.text = "微淘发现"
        times.text = "1-7"
        picV.image = TBImage.im4.image
        title.text = "初心品质 不忘初心，惊喜大发现，原来。。。"
        script.text = "与爱齐名，为有初心不变，小编为大家收集了超多好文好店，从手工匠人到原型设计，他们并没有忘记"
        sees.text = " 145"
        zan.setTitle("3031", for: .normal)
        pinglun.setTitle("评论", for: .normal)
    }
}
class TaobaoMiniDynamicViewController: TaobaoBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: view.height - 20), style: .plain)
        tableView.dataArray = ["b", "a", "v", "f", "d", "a", "w", "u", "n", "o", "2"]
//        tableView.dataSource = self
//        tableView.delegate = self
        view.addSubview(tableView)
    }
}
