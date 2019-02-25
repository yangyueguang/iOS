//
//  SDHomeViewController.swift
//  Freedom
import UIKit
import RxSwift
import XExtension
class AlipayItemCell: BaseCollectionViewCell<BaseModel> {
    @IBOutlet weak var itemButton: XButton!
    override func initUI() {
        viewModel.subscribe(onNext: {[weak self] (model) in
            self?.itemButton.kf.setImage(with: model.icon.url, for: .normal)
            self?.itemButton.setTitle(model.title, for: .normal)
        }).disposed(by: disposeBag)
    }
}
class AlipayMiddleCell: BaseCollectionViewCell<BaseModel> {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    override func initUI() {
        viewModel.subscribe(onNext: {[weak self] (model) in
            self?.titleLabel.text = model.title
            self?.subTitleLabel.text = model.subTitle
            self?.iconImageView.kf.setImage(with: model.icon.url)
        }).disposed(by: disposeBag)
    }
}
class AlipayProductCell: BaseCollectionViewCell<BaseModel> {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    override func initUI() {
        viewModel.subscribe(onNext: {[weak self] (model) in
            self?.iconImageView.kf.setImage(with: model.icon.url)
            self?.titleLabel.text = model.title
            self?.subTitleLabel.text = model.subTitle
        }).disposed(by: disposeBag)
    }
}
final class AlipayHomeViewController: AlipayBaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel = PublishSubject<AlipayHomeModel>()
    var model: AlipayHomeModel = AlipayHomeModel()
    var searchVC = WXFriendSearchViewController()
    private lazy var searchController: WXSearchController =  {
        let searchController = WXSearchController(searchResultsController: searchVC)
        searchController.searchResultsUpdater = searchVC
        searchController.searchBar.placeholder = "搜索"
        searchController.searchBar.delegate = self
        searchController.showVoiceButton = true
        return searchController
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchController.searchBar
        collectionView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        viewModel.subscribe(onNext: {[weak self] (model) in
            guard let `self` = self else { return }
            self.model = model
            self.collectionView.reloadData()
        }).disposed(by: disposeBag)
        XNetKit.alipayHome([:], next: viewModel)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.pushViewController(AlipayScanViewController(), animated: true)
    }

}
extension AlipayHomeViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: APPW, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:return CGSize(width: APPW / 4, height: 80)
        case 1:return CGSize(width: APPW / 2, height: 80)
        default:return CGSize(width: APPW / 3, height: 100)
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:return model.items.count
        case 1:return model.middleItems.count
        default:return model.products.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueCell(AlipayItemCell.self, for: indexPath)
            cell.viewModel.onNext(model.items[indexPath.item])
            return cell
        case 1:
            let cell = collectionView.dequeueCell(AlipayMiddleCell.self, for: indexPath)
            cell.viewModel.onNext(model.middleItems[indexPath.item])
            return cell
        default:
            let cell = collectionView.dequeueCell(AlipayProductCell.self, for: indexPath)
            cell.viewModel.onNext(model.products[indexPath.item])
            return cell
        }
    }


}
extension AlipayHomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    }
}
