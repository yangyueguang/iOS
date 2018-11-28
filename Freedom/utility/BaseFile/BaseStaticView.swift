
import UIKit
@objcMembers
open class SWCommonItem : NSObject {
    open var icon: String! /** 图标 */
    open var title: String! /** 标题 */
    open var subtitle: String! /** 子标题 */
    open var badgeValue: String! /** 右边显示的数字标记 */
    open var text: String! /** 右边label显示的内容 */
    open var destVcClass: UIViewController! /** 点击这行cell，需要调转到哪个控制器 */
    open var operation: (() -> Swift.Void)! /** 封装点击这行cell想做的事情 */
    class func item(withTitle title: String)->SWCommonItem{
       return SWCommonItem(title: title, icon: "")
    }
    public init(title: String, icon: String) {
        super.init()
        self.title = title
        self.icon = icon
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
@objcMembers
open class SWCommonGroup : NSObject {
    open var header: String! /** 组头 */
    open var footer: String! /** 组尾 */
    open var items: [SWCommonItem]! /** 这组的所有行模型*/
    override init() {
        super.init()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
@objcMembers
open class SWCommonCell : UITableViewCell {
    var badgeValue = ""
    lazy var rightArrow: UIImageView = UIImageView(image: UIImage(named: "cell_right"))
    lazy var rightSwitch: UISwitch = UISwitch()
    lazy var rightLabel: UILabel = {//标签
        let rl = UILabel()
        rl.textColor = UIColor.lightGray
        rl.font = UIFont.systemFont(ofSize: 13)
        return rl
    }()
    lazy var bageView: UIButton = {//提醒数字
        let bv = UIButton()
        bv.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        bv.setBackgroundImage(UIImage(named: "main_badge"), for: .normal)
        return bv
    }()
    class func cellWith(tableView: UITableView) -> SWCommonCell{
        let ID = "common"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID) as? SWCommonCell
        if cell == nil {
            cell = SWCommonCell(style: .value1, reuseIdentifier: ID)
        }
        return cell!
    }
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 11)
        backgroundColor = UIColor.clear
        backgroundView = UIImageView()
        selectedBackgroundView = UIImageView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        detailTextLabel?.frame = CGRect(x: (textLabel?.frame.maxX)! + 5, y: (detailTextLabel?.frame.origin.y)!, width: (detailTextLabel?.frame.size.width)!, height: (detailTextLabel?.frame.size.height)!)
    }
    
    // MARK: - setter
    public func setIndexPath(_ indexPath: IndexPath, rowsInSection rows: Int) {
        // 1.取出背景view
        let bgView = backgroundView as? UIImageView
        let selectedBgView = selectedBackgroundView as? UIImageView
        bgView?.image = UIImage(named: "white")
        selectedBgView?.image = UIImage(named: "gray")
    }
    
    open var item: SWCommonItem{ /** cell对应的item数据 */
        get{
            return self.item
        }
        set{
            // 1.设置基本数据
            imageView?.image = UIImage(named: item.icon)
            textLabel?.text = item.title
            detailTextLabel?.text = item.subtitle
            // 2.设置右边的内容
            if item.badgeValue != nil {
                bageView.frame = CGRect(x: bageView.frame.origin.x, y: bageView.frame.origin.y, width: (bageView.currentBackgroundImage?.size.width)!, height: (bageView.currentBackgroundImage?.size.height)!)
                bageView.setTitle(item.badgeValue, for: .normal)
                accessoryView = bageView
            accessoryView = rightArrow
            }
        }
    }
}
@objcMembers
open class BaseStaticTableView : UITableView {
   var groups :[SWCommonGroup] = [SWCommonGroup]()
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .grouped)
        backgroundColor = UIColor.lightGray
        separatorStyle = .none
        sectionFooterHeight = 5
        sectionHeaderHeight = 0
        contentInset = UIEdgeInsets(top: 5 - 35, left: 0, bottom: 0, right: 0)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group: SWCommonGroup? = groups[section]
        return (group?.items.count)!
    }
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SWCommonCell.cellWith(tableView: tableView)
        let group: SWCommonGroup? = groups[indexPath.section]
        cell.item = (group?.items[indexPath.row])!
        cell.setIndexPath(indexPath, rowsInSection: (group?.items.count)!)
        return cell
    }
    open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let group: SWCommonGroup? = groups[section]
        return group?.footer
    }
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let group: SWCommonGroup? = groups[section]
        return group?.header
    }
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1.取出这行对应的item模型
        let group: SWCommonGroup? = groups[indexPath.section]
        let item: SWCommonItem? = (group?.items[indexPath.row])!
        // 2.判断有无需要跳转的控制器
        if item?.destVcClass != nil {
            let destVc: UIViewController? = item?.destVcClass!
            destVc?.title = item?.title
//        [self.navigationController pushViewController:destVc animated:YES];
        }
        // 3.判断有无想执行的操作
        if item?.operation != nil {
            item?.operation()
        }
    }
    func test() {
        // 1.创建组
        let group = SWCommonGroup()
        groups.append(group)
        // 2.设置组的所有行数据
        let readMdoe = SWCommonItem.item(withTitle: "阅读模式")
        readMdoe.text = "有图模式"
        let readMdoe1 = SWCommonItem.item(withTitle: "字号大小")
        readMdoe1.text = "中"
        let readMdoe2 = SWCommonItem.item(withTitle: "显示备注")
        readMdoe2.text = "是"
        group.items = [readMdoe, readMdoe1, readMdoe2]
    }
}




