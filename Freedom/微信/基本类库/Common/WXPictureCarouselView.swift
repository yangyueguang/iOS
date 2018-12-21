//
//  WXPictureCarouselView.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/19.
//  Copyright © 2018 薛超. All rights reserved.
//

import Foundation
protocol WXPictureCarouselProtocol: NSObjectProtocol {
    func pictureURL() -> String
}

protocol WXPictureCarouselDelegate: NSObjectProtocol {
    func pictureCarouselView(_ pictureCarouselView: WXPictureCarouselView, didSelectItem model: WXPictureCarouselProtocol)
}

class WXPictureCarouselViewCell: UICollectionViewCell {
    private var _model: WXPictureCarouselProtocol
    var model: WXPictureCarouselProtocol {
        get {
            return _model
        }
        set(model) {
            imageView.sd_setImage(with: URL(string: model.pictureURL()))
        }
    }
    private var imageView: UIImageView

    override init(frame: CGRect) {
        super.init(frame: frame)

        if let aView = imageView {
            contentView.addSubview(aView)
        }

        p_addMasonry()

    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func p_addMasonry() {
        imageView.mas_makeConstraints({ make in
            make.edges.mas_equalTo(self.contentView)
        })
    }

    // MARK: -
    var imageView: UIImageView {
        if imageView == nil {
            imageView = UIImageView()
        }
        return imageView
    }

}
class WXPictureCarouselView:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var timer: Timer
    private var collectionView: UICollectionView
    var data: [Any] = []
    weak var delegate: WXPictureCarouselDelegate
    var timeInterval: TimeInterval = 0.0
    
    init(frame: CGRect) {
        super.init(frame: frame)

        timeInterval = 5
        addSubview(collectionView)

        p_addMasonry()

        collectionView.register(WXPictureCarouselViewCell.self, forCellWithReuseIdentifier: "TLPictureCarouselViewCell")

    }

    func setData(_ data: [Any]) {
        self.data = data
        collectionView.reloadData()
        DispatchQueue.main.async(execute: {

            let offset = CGPoint(x: self.collectionView.frame.size.width * 1, y: self.collectionView.contentOffset.y)
            self.collectionView.setContentOffset(offset, animated: false)

            if self.timer == nil && self.data.count > 1 {
                weak var weakSelf = self
                self.timer = Timer.bk_scheduledTimer(withTimeInterval: 2.0, block: { tm in
                    weakSelf.scrollToNextPage()
                }, repeats: true)
            }
        })
    }
    deinit {
        timer.invalidate()
        timer = nil
    }

    // MARK: -
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count == 0 ? 0 : data.count + 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row: Int = indexPath.row == 0  data.count - 1 : (indexPath.row == data.count + 1 ? 0 : indexPath.row - 1)
        let model: WXPictureCarouselProtocol = data[row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TLPictureCarouselViewCell", for: indexPath) as WXPictureCarouselViewCell
        cell.model = model
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row: Int = indexPath.row == 0  data.count - 1 : (indexPath.row == data.count - 1 ? 0 : indexPath.row - 1)
        let model: WXPictureCarouselProtocol = data[row]
        if delegate && delegate.responds(to: #selector(self.pictureCarouselView(_:didSelectItem:))) {
            delegate.pictureCarouselView(self, didSelectItem: model)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }

    //MARK: UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer.invalidate()
        timer = nil
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if timer == nil && data.count > 1 {
            weak var weakSelf = self
            timer = Timer.bk_scheduledTimer(withTimeInterval: 2.0, block: { tm in
                weakSelf.scrollToNextPage()
            }, repeats: true)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 轮播实现

        if scrollView.contentOffset.x / scrollView.frame.size.width == 0 {
            let offset = CGPoint(x: collectionView.frame.size.width * data.count, y: collectionView.contentOffset.y)
            scrollView.setContentOffset(offset, animated: false)
        } else if scrollView.contentOffset.x / scrollView.frame.size.width == data.count + 1 {
            let offset = CGPoint(x: collectionView.frame.size.width * 1, y: collectionView.contentOffset.y)
            scrollView.setContentOffset(offset, animated: false)
        }
    }
    func scrollToNextPage() {
        var nextPage: Int
        if collectionView.contentOffset.x / collectionView.frame.size.width == data.count {
            let offset = CGPoint(x: collectionView.frame.size.width * 0, y: collectionView.contentOffset.y)
            collectionView.setContentOffset(offset, animated: false)
            nextPage = 1
        } else {
            nextPage = Int(collectionView.contentOffset.x / collectionView.frame.size.width + 1)
        }
        let offset = CGPoint(x: collectionView.frame.size.width * CGFloat(nextPage), y: collectionView.contentOffset.y)
        collectionView.setContentOffset(offset, animated: true)
    }

    // MARK: -
    func p_addMasonry() {
        collectionView.mas_makeConstraints({ make in
            make.edges.mas_equalTo(self)
        })
    }
    var collectionView: UICollectionView! {
        if collectionView == nil {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = .zero
            collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            collectionView.backgroundColor = UIColor.white
            collectionView.showsVerticalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.isPagingEnabled = true
            collectionView.scrollsToTop = false
            collectionView.delegate = self
            collectionView.dataSource = self
        }
        return collectionView
    }

}
