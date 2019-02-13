
import UIKit
import RxSwift
@objcMembers
open class BaseCollectionViewCell<T> : UICollectionViewCell {
    var model: T!
    let disposeBag = DisposeBag()
    let viewModel = PublishSubject<T>()
    open var icon: UIImageView!
    open var line: UIView!
    open var title: UILabel!
    open var script: UILabel!
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        loadBaseTableCellSubviews()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadBaseTableCellSubviews()
    }
    func loadBaseTableCellSubviews() {
        initUI()
        isExclusiveTouch = true
        isUserInteractionEnabled = true
        contentView.isUserInteractionEnabled = true
    }
    //MARK: 以下子类重写
    open func initUI() {
        icon = UIImageView()
        icon.contentMode = .scaleToFill
        title = UILabel()
        title.font = UIFont.systemFont(ofSize: 15)
        title.numberOfLines = 0
        script = UILabel()
        script.font = UIFont.systemFont(ofSize: 13)
        title.textColor = UIColor(red: 33, green: 34, blue: 35, alpha: 1)
        script.textColor = title.textColor
        line = UIView()
    }
    override open func prepareForReuse() {
        super.prepareForReuse()
    }
    deinit {
    }
}


