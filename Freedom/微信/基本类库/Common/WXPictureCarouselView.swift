//
//  WXPictureCarouselView.swift
//  Freedom
import SnapKit
import Foundation
protocol WXPictureCarouselDelegate: NSObjectProtocol {
    func pictureCarouselView(_ pictureCarouselView: WXPictureCarouselView, didSelectItem model: WXPictureCarouselProtocol)
}
class WXPictureCarouselViewCell: UICollectionViewCell {
    var model: WXPictureCarouselProtocol? {
        didSet {
            if let url = URL(string: model?.pictureURL() ?? "") {
                imageView.sd_setImage(with: url)
            }
        }
    }
    private var imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
class WXPictureCarouselView:UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var timer: Timer?
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    var data: [WXPictureCarouselProtocol] = [] {
        didSet {
            collectionView.reloadData()
            DispatchQueue.main.async(execute: {
                let offset = CGPoint(x: self.collectionView.frame.size.width * 1, y: self.collectionView.contentOffset.y)
                self.collectionView.setContentOffset(offset, animated: false)

                if self.timer == nil && self.data.count > 1 {
                    self.timer = Timer(fire: Date(), interval: 2, repeats: true, block: { (tm) in
                        self.scrollToNextPage()
                    })
                }
            })
        }
    }
    weak var delegate: WXPictureCarouselDelegate?
    var timeInterval: TimeInterval = 5
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.register(WXPictureCarouselViewCell.self, forCellWithReuseIdentifier: WXPictureCarouselViewCell.identifier)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        timer?.invalidate()
        timer = nil
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count == 0 ? 0 : data.count + 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row: Int = indexPath.row == 0 ? data.count - 1 : (indexPath.row == data.count + 1 ? 0 : indexPath.row - 1)
        let model: WXPictureCarouselProtocol = data[row]
        let cell = collectionView.dequeueCell(WXPictureCarouselViewCell.self, for: indexPath)
        cell.model = model
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row: Int = indexPath.row == 0 ? data.count - 1 : (indexPath.row == data.count - 1 ? 0 : indexPath.row - 1)
        let model: WXPictureCarouselProtocol = data[row]
        delegate?.pictureCarouselView(self, didSelectItem: model)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
        timer = nil
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if timer == nil && data.count > 1 {
            timer = Timer(fire: Date(), interval: 2.0, repeats: true, block: { (tm) in
                self.scrollToNextPage()
            })
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x / scrollView.frame.size.width == 0 {
            let offset = CGPoint(x: collectionView.frame.size.width * CGFloat(data.count), y: collectionView.contentOffset.y)
            scrollView.setContentOffset(offset, animated: false)
        } else if Int(scrollView.contentOffset.x / scrollView.frame.size.width) == data.count + 1 {
            let offset = CGPoint(x: collectionView.frame.size.width * 1, y: collectionView.contentOffset.y)
            scrollView.setContentOffset(offset, animated: false)
        }
    }
    func scrollToNextPage() {
        var nextPage: Int
        if Int(collectionView.contentOffset.x / collectionView.frame.size.width) == data.count {
            let offset = CGPoint(x: collectionView.frame.size.width * 0, y: collectionView.contentOffset.y)
            collectionView.setContentOffset(offset, animated: false)
            nextPage = 1
        } else {
            nextPage = Int(collectionView.contentOffset.x / collectionView.frame.size.width + 1)
        }
        let offset = CGPoint(x: collectionView.frame.size.width * CGFloat(nextPage), y: collectionView.contentOffset.y)
        collectionView.setContentOffset(offset, animated: true)
    }
}
