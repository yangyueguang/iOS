//
//  SDHomeViewController.swift
//  Freedom
import UIKit
import XExtension
class AlipayItemCell: BaseCollectionViewCell<CellModelC<UIViewController>> {
    @IBOutlet weak var itemButton: XButton!
    override func initUI() {

    }
}
class AlipayMiddleCell: BaseCollectionViewCell<Any> {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    override func initUI() {

    }
}
class AlipayProductCell: BaseCollectionViewCell<Any> {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    override func initUI() {

    }
}
final class AlipayHomeViewController: AlipayBaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.pushViewController(AlipayScanViewController(), animated: true)
    }

}
