
import UIKit
@objcMembers
open class BaseTableViewCell : UITableViewCell {
    open var icon: UIImageView!
    open var line: UIView!
    open var title: UILabel!
    open var script: UILabel!
    ///单例初始化，兼容nib创建
    open class func getInstance() -> Any {
        var instance: BaseTableViewCell? = nil
        let nibFilePath: String = URL(fileURLWithPath: Bundle.main.bundlePath).appendingPathComponent("\(NSStringFromClass(self)).nib").absoluteString
        if FileManager.default.fileExists(atPath: nibFilePath) {
            let o = Bundle.main.loadNibNamed(NSStringFromClass(self), owner: nil, options: nil)?.last
            if (o is BaseTableViewCell) {
                instance = o as? BaseTableViewCell
            }else {
                instance = self.init(style: .default, reuseIdentifier: self.identifier())
            }
        }else {
            instance = self.init(style: .default, reuseIdentifier: self.identifier())
        }
        return instance!
    }
    public class func identifier() -> String {
        return "\(NSStringFromClass(self))Identifier"
    }
    required override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadBaseTableCellSubviews()
    }
    required public init?(coder aDecoder: NSCoder) {
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
        line = UIView()
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


