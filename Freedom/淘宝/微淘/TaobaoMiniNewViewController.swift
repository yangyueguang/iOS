//
//  TaobaoMiniNewViewController.swift
//  Freedom
import UIKit
import XExtension
class TaobaoMiniNewViewCell:BaseTableViewCell{
    override func initUI() {
        super.initUI()
        icon.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        let name = UILabel(frame: CGRect(x: XW(icon) + 10, y: Y(icon) - 5, width: APPW - XW(icon) - 20, height: 20), font: fontSmallTitle, color: RGBAColor(0, 111, 255), text: nil)
        let times = UILabel(frame: CGRect(x: X(name), y: YH(name), width: W(name), height: 15), font: fontnomal, color: graycolor, text: nil)
        let picV = UIImageView(frame: CGRect(x: X(icon), y: YH(icon) + 10, width: APPW - 20, height: 130))
        let cellContentView = UIView(frame: CGRect(x: X(picV), y: YH(picV), width: W(picV), height: 60))
        cellContentView.backgroundColor = gradcolor
        title.removeFromSuperview()
        script.removeFromSuperview()
        title.frame = CGRect(x: 0, y: 0, width: W(cellContentView), height: 20)
        script.frame = CGRect(x: X(title), y: YH(title), width: W(title), height: 40)
        script.numberOfLines = 0
        cellContentView.addSubviews([title, script])
        let sees = UILabel(frame: CGRect(x: 10, y: YH(cellContentView) + 10, width: 100, height: 15), font: fontnomal, color: graycolor, text: nil)
        let zan = UIButton(frame: CGRect(x: APPW - 130, y: Y(sees!) - 2, width: 55, height: 19))
        let pinglun = UIButton(frame: CGRect(x: XW(zan) + 10, y: Y(zan), width: W(zan), height: H(zan)))
        zan.layer.cornerRadius = 7.5
        zan.layer.borderWidth = 0.5
        zan.clipsToBounds = true
        pinglun.layer.cornerRadius = 7.5
        pinglun.layer.borderWidth = 0.5
        pinglun.clipsToBounds = true
        sees?.font = Font(12)
        zan.titleLabel?.font = Font(12)
        pinglun.titleLabel?.font = Font(12)
        line.frame = CGRect(x: 0, y: 280 - 1, width: APPW, height: 1)
        addSubviews([name!, times!, picV, cellContentView, sees!, zan, pinglun])
        icon.image = UIImage(named: "xin")
        name?.text = "微淘发现"
        times?.text = "1-7"
        picV.image = UIImage(named: "image4.jpg")
        title.text = "初心品质 不忘初心，惊喜大发现，原来。。。"
        script.text = "与爱齐名，为有初心不变，小编为大家收集了超多好文好店，从手工匠人到原型设计，他们并没有忘记"
        sees?.text = " 145"
        zan.setTitle("3031", for: .normal)
        pinglun.setTitle("评论", for: .normal)
    }
}
class TaobaoMiniNewViewController: TaobaoBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: view.frameHeight - 20), style: .plain)
        tableView.dataArray = ["b", "a", "v", "f", "d", "a", "w", "u", "n", "o", "2"]
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
}
