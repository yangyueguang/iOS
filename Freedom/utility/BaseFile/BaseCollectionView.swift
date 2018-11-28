
import UIKit
@objcMembers
open class BaseCollectionView : UICollectionView {
    open var dataArray = NSMutableArray()
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public convenience init(frame: CGRect) {
        let lay = UICollectionViewFlowLayout()
        lay.itemSize = CGSize(width: 100, height: 100)
        lay.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        lay.minimumInteritemSpacing = 10
        lay.minimumLineSpacing = 10
        lay.scrollDirection = .vertical
        self.init(frame: frame, collectionViewLayout: lay)
    }
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        alwaysBounceVertical = true
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    deinit {
    }
}


