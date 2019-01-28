
import UIKit
import RxSwift
@objcMembers
open class BaseTableViewCell : UITableViewCell {
    let disposeBag = DisposeBag()
    open var icon: UIImageView!
    open var title: UILabel!
    open var script: UILabel!
    ///单例初始化，兼容nib创建
    public static func getInstance() -> Self {
        let instance = self.init(style: .default, reuseIdentifier: self.identifier)
        return instance
    }
    public required override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadBaseTableCellSubviews()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadBaseTableCellSubviews()
    }
    func loadBaseTableCellSubviews() {
        initUI()
        isExclusiveTouch = true
        isUserInteractionEnabled = true
        contentView.isUserInteractionEnabled = true
        selectionStyle = .none
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


