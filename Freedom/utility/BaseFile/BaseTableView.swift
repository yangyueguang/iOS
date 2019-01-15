
import UIKit
@objcMembers
open class BaseTableView : UITableView {
    open var dataArray: [Any] = []
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public convenience init(frame: CGRect) {
        self.init(frame: frame, style: .plain)
    }
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    deinit {
    }
}


