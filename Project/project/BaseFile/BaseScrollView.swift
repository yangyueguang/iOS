
import UIKit

open class BaseTableViewCell: UITableViewCell {
    required override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override open func prepareForReuse() {
        super.prepareForReuse()
    }
    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    deinit {
    }
}

open class BaseTableView : UITableView {
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    convenience init(frame: CGRect) {
        self.init(frame: frame, style: .plain)
    }
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
    }

    deinit {

    }
}

open class BaseCollectionViewCell : UICollectionViewCell {
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
    }

    func initUI() {

    }

    override open func prepareForReuse() {
        super.prepareForReuse()
    }
    deinit {
    }

}

open class BaseCollectionView : UICollectionView {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    convenience init(frame: CGRect) {
        let lay = UICollectionViewFlowLayout()
        lay.itemSize = CGSize(width: 100, height: 100)
        lay.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        lay.minimumInteritemSpacing = 10
        lay.minimumLineSpacing = 10
        lay.scrollDirection = .vertical
        self.init(frame: frame, collectionViewLayout: lay)
    }
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        alwaysBounceVertical = true
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
}

