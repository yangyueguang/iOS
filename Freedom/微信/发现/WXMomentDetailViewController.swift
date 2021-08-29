//
//  WXMomentDetailViewController.swift
//  Freedom
import SnapKit
import MJRefresh
import MWPhotoBrowser
//import XExtension
import Foundation
class WXMomentDetailViewController: WXBaseViewController {
    private var scrollView = UIScrollView()
    private var momentView: WXMomentImageView!
    var moment: WXMoment = WXMoment() {
        didSet {
            momentView.moment.onNext(moment)
            momentView.snp.updateConstraints { (make) in
                make.height.equalTo(moment.extension.comments.count * 36 + 100)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        momentView = WXMomentImageView.xibView()!
        navigationItem.title = "详情"
        view.backgroundColor = UIColor.whitex
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        scrollView.addSubview(momentView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        momentView.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.width.equalTo(self.view)
        }
    }
    func momentViewClickImage(_ images: [String], at index: Int) {
        var data: [MWPhoto] = []
        for imageUrl: String in images {
            let photo = MWPhoto(url: URL(string: imageUrl))
            data.append(photo!)
        }
        let browser = MWPhotoBrowser(photos: data)
        browser?.displayNavArrows = true
        browser?.setCurrentPhotoIndex(UInt(index))
        let broserNavC = WXNavigationController(rootViewController: browser!)
        present(broserNavC, animated: false)
    }
}
