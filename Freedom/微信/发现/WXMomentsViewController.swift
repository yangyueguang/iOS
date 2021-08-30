//
//  WXMomentsViewController.swift
//  Freedom
import SnapKit
import MWPhotoBrowser
//import XExtension
import Foundation
class WXMomentImagesCell: BaseTableViewCell<WXMoment> {
    var momentView = WXMomentImageView.xibView()
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addSubview(momentView!)
        momentView!.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
}
class WXMomentsViewController: BaseTableViewController {
    var data: [WXMoment] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WXMomentImagesCell = tableView.dequeueCell(WXMomentImagesCell.self)
        cell.momentView?.moment.onNext(data[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let moment = data[indexPath.row - 1]
        return CGFloat(moment.extension.comments.count) * 37.0 + 100.0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moment = data[indexPath.row - 1]
        let detailVC = WXMomentDetailViewController()
        detailVC.moment = moment
        navigationController?.pushViewController(detailVC, animated: true)
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
