//
//  XExcellView.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/5.
//  Copyright © 2018 薛超. All rights reserved.
//

import UIKit
import QuartzCore
import SnapKit
import MJRefresh
private let Color6 = UIColor(white: 0.25, alpha: 1)
private let Color9 = UIColor(white: 0.375, alpha: 1)
private var UIButtonHandlerKey = 0
extension UIControl {
    typealias ActionBlock = (Any?) -> Void
    func removeAllTargets() {
        for target: Any? in allTargets {
            removeTarget(target, action: nil, for: .allEvents)
        }
    }
    func addEventHandler(_ handler: ActionBlock, forControlEvents controlEvents: UIControl.Event) {
//        objc_setAssociatedObject(self, &UIButtonHandlerKey, handler, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        addTarget(self, action: #selector(UIControl.callActionHandler), for: controlEvents)
    }
    @objc func callActionHandler() {
        let handler = objc_getAssociatedObject(self, &UIButtonHandlerKey) as? ActionBlock
        if handler != nil {
            handler?(self)
        }
    }
}

enum TableColumnSortType : Int {
    case none = 0 //默认
    case asc
    case desc
}
protocol XExcellViewDataSource: NSObjectProtocol {
    func arrayDataForTopHeader(inTableView tableView: XExcellView) -> [ExcelTitleModel]
    func arrayDataForLeftHeader(inTableView tableView: XExcellView, inSection section: Int) -> [ExcelLeftModel]
    func arrayDataForContent(inTableView tableView: XExcellView, inSection section: Int) -> [[[Any]]]
    func arrayDataForSectionHeader(inTableView tableView: XExcellView, inSection section: Int) -> [ExcelTitleModel]
    ///返回label对象的前景色、背景色、宽和高。参数头部标题：section=-1 左边标题 column=-1 分区标题 row=-1
    func tableView(_ tableView: XExcellView, propertyInSection section: Int, row: Int, column: Int) -> ItemProperty
    func tableView(_ tableView: XExcellView, didSelectSection section: Int, inRow row: Int, inColumn column: Int, item mode: NSObject?, key: String?, sortType type: TableColumnSortType)
    func refresh(_ refresh: Bool, loadMorePage page: Int, completion: @escaping () -> Void) //需要重写
}
class SortItem: NSObject {
    var section: Int = 0
    var column: Int = 0
    var sortType: TableColumnSortType = .none
    var key = ""
    func changeSort(withSection section: Int, column: Int, sortType: TableColumnSortType) {
        self.section = section
        self.column = column
        self.sortType = sortType
    }
}
class ItemProperty: NSObject {
    var bgColor: UIColor = UIColor.clear
    var textColor: UIColor = UIColor(white: 0.6, alpha: 1)
    var xwidth: CGFloat = 100.0
    var xheight: CGFloat = 50.0
    var xstart: CGFloat = 0.0
    convenience init(bgColor: UIColor, textColor: UIColor, width: CGFloat, height: CGFloat = 50.0) {
        self.init()
        self.bgColor = bgColor
        self.textColor = textColor
        xwidth = width
        xheight = height
    }
}

class BaseExcelCell: UITableViewCell {
    var icon = UIImageView()
    lazy var title: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 13)
        title.adjustsFontSizeToFitWidth = true
        title.textAlignment = .center
        title.numberOfLines = 0
        return title
    }()
    lazy var script: UILabel = {
        let script = UILabel()
        script.font = UIFont.systemFont(ofSize: 11)
        script.textAlignment = .center
        script.textColor = Color6
        return script
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(white: 0.95, alpha: 1).cgColor
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        isUserInteractionEnabled = true
        contentView.isUserInteractionEnabled = true
        selectionStyle = UITableViewCell.SelectionStyle.none
        initUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func initUI() {
    }
}

class ExcelLeftModel: NSObject {
    var item: NSObject?
    var name = ""
    var key = ""
    var subName = ""
    convenience init(item: NSObject?, name: String, key: String = "", subName: String = "") {
        self.init()
        self.item = item
        self.name = name
        self.key = key
        self.subName = subName
    }
}

class BaseLeftCell: BaseExcelCell {
    var model: ExcelLeftModel? {
        didSet {
            title.text = model?.name
            if model?.subName != nil {
                script.text = model?.subName
            }
            script.snp.makeConstraints { (make) in
                if model?.subName != nil {
                    make.height.equalTo(15)
                    make.bottom.equalToSuperview().offset(-5)
                } else {
                    make.height.equalTo(0)
                    make.bottom.equalToSuperview()
                }
            }
        }
    }
    var proper: ItemProperty! {
        didSet {
            backgroundColor = proper.bgColor
            title.textColor = proper.textColor
        }
    }
    lazy var indexL: UILabel = {
        let indexL = UILabel()
        indexL.layer.borderWidth = 0.5
        indexL.layer.borderColor = Color9.cgColor
        indexL.layer.masksToBounds = true
        indexL.layer.cornerRadius = 3
        indexL.layer.shouldRasterize = true
        indexL.layer.rasterizationScale = UIScreen.main.scale
        indexL.textAlignment = .center
        indexL.font = UIFont.systemFont(ofSize: 13)
        indexL.textColor = Color9
        return indexL
    }()
    override func initUI() {
        contentView.addSubview(title)
        contentView.addSubview(script)
        contentView.addSubview(indexL)
        indexL.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.height.equalTo(20)
            make.width.equalTo(25)
            make.centerY.equalToSuperview()
        }
        title.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview()
            make.left.equalTo(self.indexL.snp.right)
            make.bottom.equalTo(self.script.snp.top)
        }
        script.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.left.equalTo(self.indexL.snp.right)
            make.height.equalTo(0)
        }
    }

}

class BaseContentCell: BaseExcelCell {
    var proper: ItemProperty! {
        didSet {
            frame = CGRect(x: proper.xstart , y: 0, width: proper.xwidth, height: proper.xheight)
            backgroundColor = proper.bgColor
            title.textColor = proper.textColor
        }
    }
    var didSelectBlock: (() -> Void)?
    var value: Any? {
        didSet {
            if (value is Date) {
                let date = value as? Date
                let format = DateFormatter()
                format.dateFormat = "yyyy-MM-DD"
                if let aDate = date {
                    title.text = format.string(from: aDate)
                }
            } else if (value is NSNumber) {
                if value is Float {
                    let num = value as? NSNumber
                    let decemal = NSDecimalNumber(string: String(format: "%lf", num?.doubleValue ?? 0.0))
                    title.text = "\(decemal)"
                } else {
                    let num = value as? NSNumber
                    title.text = num?.stringValue
                }
            } else {
                if let aValue = value {
                    title.text = "\(aValue)"
                }
            }
        }
    }
    override func initUI() {
        title = UILabel(frame: CGRect(x: 3, y: 0, width: 100, height: 100 - 6))
        title.font = UIFont.systemFont(ofSize: 13)
        title.adjustsFontSizeToFitWidth = true
        title.textAlignment = .center
        title.numberOfLines = 0
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.cellDidSelct)))
    }
    @objc func cellDidSelct() {
        if (didSelectBlock != nil) {
            didSelectBlock?()
        } else {
            isUserInteractionEnabled = false
        }
    }
}

class ExcelTitleModel: NSObject {
    var name = ""
    var key = ""
    var sortable = false
    var sortType = TableColumnSortType.none
    convenience init(name: String, key: String, sortable: Bool = false, sorttype sortType: TableColumnSortType = .none) {
        self.init()
        self.name = name
        self.key = key
        self.sortable = sortable
        self.sortType = sortType
    }

    class func array(fromNames names: [String], keys: [String]?, sortableBlock sortable: @escaping (_ index: Int) -> Bool) -> [ExcelTitleModel] {
        var modes: [ExcelTitleModel] = []
        for i in 0..<names.count {
            let mode = ExcelTitleModel(name: names[i], key: keys?[i] ?? "", sortable: sortable(i))
            modes.append(mode)
        }
        return modes
    }
    func nextType() -> ExcelTitleModel {
        if sortType == .none {
            sortType = .asc
        } else if sortType == .asc {
            sortType = .desc
        } else {
            sortType = .none
        }
        return self
    }
    
}
class BaseTitleCell: BaseExcelCell {
    lazy var sortB: UIButton = {
        let sortB = UIButton()
        sortB.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        sortB.titleLabel?.textAlignment = .center
        sortB.setTitleColor(UIColor(white: 0.6, alpha: 1), for: .normal)
        sortB.titleLabel?.numberOfLines = 0
        sortB.clipsToBounds = true
        return sortB
    }()
    var model: ExcelTitleModel = ExcelTitleModel() {
        didSet {
            sortB.setTitle(model.name, for: .normal)
            if shouqi {
                sortB.setImage(UIImage(named: "下灰"), for: .selected)
                sortB.setImage(UIImage(named: "上灰"), for: .normal)
                sortB.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(sortB.imageView?.bounds.size.width ?? 0.0) - 2, bottom: 0, right: (sortB.imageView?.bounds.size.width ?? 0.0) + 2)
                sortB.imageEdgeInsets = UIEdgeInsets(top: 0, left: (sortB.titleLabel?.bounds.size.width ?? 0.0) + 2, bottom: 0, right: -(sortB.titleLabel?.bounds.size.width ?? 0.0) - 2)
                return
            }
            if !model.sortable {
                sortB.setImage(nil, for: .normal)
                sortB.setImage(nil, for: .selected)
                sortB.titleEdgeInsets = .zero
                return
            }
            if model.sortType == .asc {
                sortB.setImage(UIImage(named: "sort2"), for: .normal)
            } else if model.sortType == .desc {
                sortB.setImage(UIImage(named: "sort1"), for: .normal)
            } else {
                sortB.setImage(UIImage(named: "sort"), for: .normal)
            }
            sortB.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(sortB.imageView?.bounds.size.width ?? 0.0) - 2, bottom: 0, right: (sortB.imageView?.bounds.size.width ?? 0.0) + 2)
            sortB.imageEdgeInsets = UIEdgeInsets(top: 0, left: (sortB.titleLabel?.bounds.size.width ?? 0.0) + 2, bottom: 0, right: -(sortB.titleLabel?.bounds.size.width ?? 0.0) - 2)

        }
    }
    var proper: ItemProperty = ItemProperty() {
        didSet {
            sortB.setTitleColor(proper.textColor, for: .normal)
            //    [_sortB setTitleColor:proper.textColor forState:UIControlStateNormal];
            frame = CGRect(x: proper.xstart, y: 0, width: proper.xwidth, height: proper.xheight)
            backgroundColor = proper.bgColor
        }
    }
    var shouqi = false
    override func initUI() {
        clipsToBounds = true
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(white: 0.95, alpha: 1).cgColor
        contentView.addSubview(sortB)
        sortB.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        for target in sortB.allTargets {
            sortB.removeTarget(target, action: nil, for: .allEvents)
        }
    }
}

class BaseExcelHeadView: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class XExcellView: UIScrollView {
    @IBOutlet weak var titleScrollView: UIScrollView!
    @IBOutlet weak var leftTableView: UITableView!
    @IBOutlet weak var rightTableView: UITableView!
    @IBOutlet weak var rightScrollView: UIScrollView!

    lazy var excelNameL: UILabel = {
        let excelNameL = UILabel(frame: CGRect.zero)
        excelNameL.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleWidth, .flexibleHeight]
        excelNameL.textColor = UIColor(white: 0.6, alpha: 1)
        excelNameL.textAlignment = .center
        excelNameL.layer.borderWidth = 0.5
        excelNameL.layer.borderColor = UIColor(white: 0.95, alpha: 1).cgColor
        excelNameL.font = UIFont.systemFont(ofSize: 12)
        return excelNameL
    }()
    var page: Int = 0
    var sectionCount: Int = 0
    var leftHeaderEnable = false
    var hidIndex = false
    var showSection = false
    weak var datasource: XExcellViewDataSource? {
        didSet {
            reset()
        }
    }

    /*是否保持顶部标题不更新 */
    var keepTopHead = false
    var scrollOffset: CGPoint {
        set {
            DispatchQueue.main.async(execute: {
                self.rightTableView.contentOffset = CGPoint(x: 0, y: newValue.y)
                self.leftTableView.contentOffset = CGPoint(x: 0, y: newValue.y)
                self.titleScrollView.contentOffset = CGPoint(x: newValue.x, y: 0)
                self.rightScrollView.contentOffset = CGPoint(x: newValue.x, y: 0)
            })
        }
        get {
            let thex: CGFloat = rightScrollView.contentOffset.x
            let they: CGFloat = leftTableView.contentOffset.y
            return CGPoint(x: thex, y: they)
        }
    }
    var headView: UIView? {
        didSet {
                headView?.frame = CGRect(x: headView?.frame.origin.x ?? 0.0, y: headView?.frame.origin.y ?? 0.0, width: headView?.bounds.size.width ?? 0.0, height: (headView?.bounds.size.height ?? 0.0) + topHeaderHeight)
                rightTableView.tableHeaderView = headView
        }
    }
    var footView: UIView? {
        didSet {
            rightTableView.tableFooterView = footView
        }
    }
    private var sectionFoldedStatus: [Int : Int] = [:]
    private var columnPointCollection: [CGFloat] = []
    private var leftHeaderDataArray: [[ExcelLeftModel]] = []
    private var sectionDataArray: [[ExcelTitleModel]] = []
    private var contentDataArray: [[[Any]]] = []
    private var boldSeperatorLineWidth: CGFloat = 0.0
    private var topHeaderHeight: CGFloat = 0.0
    private var leftHeaderWidth: CGFloat = 0.0
    private lazy var emptyView: UIView = {
        let emptyView = UIView(frame: CGRect(x: 0, y: APPH / 2 - 100, width: APPW, height: 100))
        let emptyL = UILabel(frame: CGRect(x: 0, y: 0, width: emptyView.bounds.size.width, height: emptyView.bounds.size.height))
        emptyL.font = UIFont.systemFont(ofSize: 20)
        emptyL.textColor = UIColor(red: 100 / 255.0, green: 100 / 255.0, blue: 100 / 255.0, alpha: 1)
        emptyL.textAlignment = .center
        emptyL.text = "暂无数据"
        emptyView.isHidden = true
        emptyView.addSubview(emptyL)
        return emptyView
    }()
    private var excelContentCellIdentifier = ""

    private var sortItem = SortItem()
    func privateRefresh() {
        mj_footer?.endRefreshing()
        leftTableView.mj_footer?.endRefreshing()
        rightTableView.mj_footer?.endRefreshing()
        page = 0
        datasource?.refresh(true, loadMorePage: page, completion: {
            self.mj_header?.endRefreshing()
            self.leftTableView.mj_header?.endRefreshing()
            self.rightTableView.mj_header?.endRefreshing()
        })
    }

    func privateLoadMore() {
        mj_header?.endRefreshing()
        leftTableView.mj_header?.endRefreshing()
        rightTableView.mj_header?.endRefreshing()
        page += 1
        datasource?.refresh(false, loadMorePage: page, completion: {
            self.mj_footer?.endRefreshing()
            self.leftTableView.mj_footer?.endRefreshing()
            self.rightTableView.mj_footer?.endRefreshing()
        })
    }

    func setLeftHeaderEnable(_ leftHeaderEnable: Bool) {
        self.leftHeaderEnable = leftHeaderEnable
        if leftHeaderEnable {
            leftTableView.mj_footer = rightTableView.mj_footer
        }
    }
    ///FIXME:初始化

    override init(frame: CGRect) {
        super.init(frame: frame)

        page = 0
        sectionCount = 1
        leftHeaderEnable = true
        layer.borderColor = UIColor(white: 0.9, alpha: 1).cgColor
        layer.cornerRadius = 1
        layer.borderWidth = 1
        clipsToBounds = true
        backgroundColor = UIColor.clear
        contentMode = .redraw
        autoresizingMask = [.flexibleHeight, .flexibleWidth]
        boldSeperatorLineWidth = 0.5
          addSubview(excelNameL)


        let header = MJRefreshNormalHeader(refreshingBlock: {
            self.privateRefresh()
        })
        mj_header = header
        leftTableView.mj_header = MJRefreshHeader(refreshingBlock: {
            self.leftTableView.mj_header?.endRefreshing()
            self.mj_header?.beginRefreshing()
        })
        rightTableView.mj_header = MJRefreshHeader(refreshingBlock: {
            self.rightTableView.mj_header?.endRefreshing()
            self.mj_header?.beginRefreshing()
        })
        let footer = MJRefreshAutoNormalFooter {
            self.privateLoadMore()
        }
        footer.mj_h = 5
//        footer.stateLabel.font = UIFont.systemFont(ofSize: 15)
//        footer.stateLabel.textColor = UIColor.clear
        footer.activityIndicatorViewStyle = UIActivityIndicatorView.Style.white
        footer.triggerAutomaticallyRefreshPercent = 2.0
        rightTableView.mj_footer = footer
        addSubview(emptyView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let superWidth = bounds.size.width
        let superHeight = bounds.size.height
        if leftHeaderEnable {
            excelNameL.frame = CGRect(x: 0, y: 0, width: leftHeaderWidth, height: topHeaderHeight)
            titleScrollView.frame = CGRect(x: leftHeaderWidth + boldSeperatorLineWidth, y: 0, width: superWidth - leftHeaderWidth - boldSeperatorLineWidth, height: topHeaderHeight)
            leftTableView.frame = CGRect(x: 0, y: topHeaderHeight + boldSeperatorLineWidth, width: leftHeaderWidth, height: superHeight - topHeaderHeight - boldSeperatorLineWidth)
            rightScrollView.frame = CGRect(x: leftHeaderWidth + boldSeperatorLineWidth, y: topHeaderHeight + boldSeperatorLineWidth, width: superWidth - leftHeaderWidth - boldSeperatorLineWidth, height: superHeight - topHeaderHeight - boldSeperatorLineWidth)
        } else {
            if let headView = headView {
                titleScrollView.removeFromSuperview()
                titleScrollView.frame = CGRect(x: 0, y: headView.bounds.size.height - topHeaderHeight, width: superWidth, height: topHeaderHeight)
                headView.addSubview(titleScrollView)
                rightScrollView.frame = CGRect(x: 0, y: 0, width: superWidth, height: superHeight)
                //        }else if(self.footView){
            } else {
                titleScrollView.frame = CGRect(x: 0, y: 0, width: superWidth, height: topHeaderHeight)
                rightScrollView.frame = CGRect(x: 0, y: topHeaderHeight + boldSeperatorLineWidth, width: superWidth, height: superHeight - topHeaderHeight - boldSeperatorLineWidth)
            }
        }
        adjustView()
    }
    func reloadData() {
        DispatchQueue.main.async(execute: {
            self.reset()
            self.emptyView.isHidden = true
            for temp in self.leftHeaderDataArray {
                if temp.count == 0 {
                    self.emptyView.isHidden = false
                }
            }
            self.leftTableView.reloadData()
            self.rightTableView.reloadData()
            self.performSelector(onMainThread: #selector(self.tongbu), with: nil, waitUntilDone: false)
//            if #available(iOS 11.0, *) {
//                leftTableView.performBatchUpdates({
//                }) { finished in
//                    rightTableView.performBatchUpdates({
//                    }) { finished in
//                        rightTableView.contentOffset = leftTableView.contentOffset
//                    }
//                }
//            } else {
//                self.performSelector(onMainThread: #selector(self.tongbu), with: nil, waitUntilDone: false)
//            }
        })
    }
    @objc func tongbu() {
        rightScrollView.contentOffset = CGPoint(x: rightScrollView.contentOffset.x, y: 0)
        rightTableView.contentOffset = leftTableView.contentOffset
    }

//    func draw(_ rect: CGRect) {
//        super.draw(rect)
//        let context = UIGraphicsGetCurrentContext()
//        context?.setLineWidth(boldSeperatorLineWidth)
//        context?.setAllowsAntialiasing(false)
//        context?.setStrokeColor(UIColor.red.cgColor)
//        let y: CGFloat = topHeaderHeight + boldSeperatorLineWidth / 2.0
//        context?.move(to: CGPoint(x: 0.0, y: y))
//        context?.addLine(to: CGPoint(x: bounds.size.width, y: y))
//        context?.strokePath()
//    }
    deinit {
        titleScrollView = nil
        rightScrollView = nil
        leftTableView = nil
        rightTableView = nil
    }

    ///FIXME:点击左侧收起

    @objc func leftHeaderTap(_ sender: UIButton) {
        let lockQueue = DispatchQueue(label: "self")
        lockQueue.sync {
            sender.isSelected = !sender.isSelected
            let section = sender.tag
            buildSectionFoledStatus(section)
            leftTableView.beginUpdates()
            rightTableView.beginUpdates()
            var indexPaths:[IndexPath] = []
            for i in 0..<rows(inSection: section) {
                indexPaths.append(IndexPath(row: i, section: section))
            }
            if folded(inSection: section) {
                leftTableView.deleteRows(at: indexPaths, with: .none)
                rightTableView.deleteRows(at: indexPaths, with: .none)
            } else {
                leftTableView.insertRows(at: indexPaths, with: .none)
                rightTableView.insertRows(at: indexPaths, with: .none)
            }
            leftTableView.endUpdates()
            rightTableView.endUpdates()
        }
    }

    ///FIXME: - private method

    func reset() {
        accessDataSourceData()
        accessColumnPointCollection()
        buildSectionFoledStatus(-1)
        setUptitleScrollView()
    }
    func accessDataSourceData() {
        leftHeaderDataArray.removeAll()
        contentDataArray.removeAll()
        sectionDataArray.removeAll()
        topHeaderHeight = itemProperty(withSection: -1, row: 0, column: 0).xheight
        leftHeaderWidth = itemProperty(withSection: 0, row: 0, column: -1).xwidth
        for i in 0..<sectionCount {
            guard let datasource = datasource else { return }
            let tempL = datasource.arrayDataForLeftHeader(inTableView: self, inSection: i)
            let tempC = datasource.arrayDataForContent(inTableView: self, inSection: i)

            let tempS = datasource.arrayDataForSectionHeader(inTableView: self, inSection: i)
            sectionDataArray.append(tempS)
            leftHeaderDataArray.append(tempL)
            contentDataArray.append(tempC)
        }
    }

    func accessColumnPointCollection() {
        let columns: Int = datasource?.arrayDataForTopHeader(inTableView: self).count ?? 0
        if columns == 0 {
            print("列数必须大于0")
        }
        var tmpAry: [CGFloat] = []
        var widthColumn: CGFloat = 0.0
        for i in 0..<columns {
            let proper = itemProperty(withSection: 0, row: 0, column: i)
            widthColumn += proper.xwidth
            tmpAry.append(widthColumn)
        }
        columnPointCollection = tmpAry
    }

    func adjustView() {
        var width: CGFloat = 0.0
        let count = datasource?.arrayDataForTopHeader(inTableView: self).count ?? 0
        for i in 0..<count {
            width += itemProperty(withSection: 0, row: 0, column: i).xwidth
        }
        DispatchQueue.main.async(execute: {
            self.titleScrollView.contentSize = CGSize(width: width, height: self.topHeaderHeight)
            self.rightScrollView.contentSize = CGSize(width: width, height: self.bounds.size.height - self.topHeaderHeight - self.boldSeperatorLineWidth)
            self.rightTableView.frame = CGRect(x: 0.0, y: 0.0, width: width, height: self.bounds.size.height - self.topHeaderHeight - self.boldSeperatorLineWidth)
        })
    }

    func buildSectionFoledStatus(_ section: Int) {
        for i in 0..<sectionCount {
            if section == -1 {
                if !showSection {
                    sectionFoldedStatus[i] = 0
                } else {
                    sectionFoldedStatus[i] = 1
                }
            } else if i == section {
                if folded(inSection: section) {
                    sectionFoldedStatus[i] = 0
                } else {
                    sectionFoldedStatus[i] = 1
                }
                break
            }
        }
    }
    // MARK:  --右侧的表头
    func setUptitleScrollView() {
        adjustView()
        excelNameL.backgroundColor = itemProperty(withSection: -1, row: 0, column: -1).bgColor
        if keepTopHead {
            return
        }
        keepTopHead = true
        titleScrollView.subviews.forEach({$0.removeFromSuperview()})
        let count = datasource?.arrayDataForTopHeader(inTableView: self).count ?? 0
        var forCellIdentifier = ""
        for i in 0..<count {
            let proper = itemProperty(withSection: -1, row: 0, column: i)
            proper.xstart = columnPointCollection[i]
            let cell:BaseTitleCell = leftTableView.dequeueReusableCell(withIdentifier: BaseTitleCell.identifier) as! BaseTitleCell
            cell.proper = proper
            cell.sortB.setTitleColor(UIColor(white: 0.6, alpha: 1), for: .normal)
            cell.sortB.tag = i
            let model = datasource?.arrayDataForTopHeader(inTableView: self)[i] ?? ExcelTitleModel()
            cell.model = model
            forCellIdentifier += model.name
            if model.sortable {
                cell.sortB.addEventHandler({ sender in
                    for v in titleScrollView.subviews where v is BaseTitleCell {
                        let vb = v as! BaseTitleCell
                        let vm = vb.model
                        if vb.sortB.tag == (sender as! UIButton).tag {
                           _ = vm.nextType()
                        } else if vm.sortable {
                            vm.sortType = .none
                        }
                        vb.model = vm
                    }
                    let confirm: Bool = true//self.datasource.responds(to: #selector(self.tableView(_:didSelectSection:inRow:inColumn:item:key:sortType:)))
                    if confirm {
                        self.leftTableView.contentOffset = CGPoint.zero
                        self.rightTableView.contentOffset = self.leftTableView.contentOffset
                        self.datasource?.tableView(self, didSelectSection: -1, inRow: 0, inColumn: i, item: nil, key: cell.model.key, sortType: cell.model.sortType)
                    } else {
                        self.sortItem.changeSort(withSection: -1, column: i, sortType: cell.model.sortType)
                        for j in 0..<self.sectionCount {
                            let iPath = IndexPath(row: i, section: j)
                            self.singleHeaderClick(iPath)
                        }
                        self.leftTableView.reloadData()
                        self.rightTableView.reloadData()
                    }
                }, forControlEvents: UIControl.Event.touchUpInside)
            }
            titleScrollView.addSubview(cell)
        }
        excelContentCellIdentifier = forCellIdentifier
    }
    func singleHeaderClick(_ indexPath: IndexPath) {
        let section = indexPath.section
        let column = indexPath.row
        let columnFlag = (sortItem.column == column) ? sortItem.sortType : .none
        let leftHeaderDataInSection = leftHeaderDataArray[section]
        let contentDataInSection = contentDataArray[section]
        var sortContentData = contentDataInSection.sorted { (obj1, obj2) -> Bool in
            let a: String = obj1[column] as! String
            let b: String = obj2[column] as! String
            return a.compare(b) == .orderedAscending
        }
        var sortIndexAry: [Int] = []
        for i in 0..<sortContentData.count {
            let objI: NSArray = sortContentData[i] as NSArray
            for j in 0..<contentDataInSection.count {
                let objJ: NSArray = contentDataInSection[j] as NSArray
                if objI == objJ {
                    sortIndexAry.append(j)
                    break
                }
            }
        }
        var sortLeftHeaderData: [ExcelLeftModel] = []
        for i in sortIndexAry {
            sortLeftHeaderData.append(leftHeaderDataInSection[i])
        }
        if columnFlag == .desc {
            let leftReverseEnumerator: NSEnumerator = (sortLeftHeaderData as NSArray).reverseObjectEnumerator()
            let contentReverseEvumerator: NSEnumerator = (sortContentData as NSArray).reverseObjectEnumerator()
            sortLeftHeaderData = leftReverseEnumerator.allObjects as! [ExcelLeftModel]
            sortContentData = contentReverseEvumerator.allObjects as! [[Any]]
        }
        leftHeaderDataArray[section] = sortLeftHeaderData
        contentDataArray[section] = sortContentData
    }
    ///FIXME: other method

    func itemProperty(withSection section: Int, row: Int, column: Int) -> ItemProperty {
        guard let datasource = datasource else {
            return ItemProperty()
        }
        return datasource.tableView(self, propertyInSection: section, row: row, column: column)
    }

    func rows(inSection section: Int) -> Int {
        if section >= leftHeaderDataArray.count {
            sectionCount = 1
            return 0
        }
        let temp = leftHeaderDataArray[section]
        return temp.count
    }

    func folded(inSection section: Int) -> Bool {
        return sectionFoldedStatus[section] != 0
    }


    
}
extension XExcellView: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !folded(inSection: section) {
            return rows(inSection: section)
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !showSection {
            return 0
        }
        return itemProperty(withSection: section, row: -1, column: 0).xheight
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return itemProperty(withSection: indexPath.section, row: indexPath.row, column: 0).xheight
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeadView = tableView.dequeueReusableHeaderFooterView(withIdentifier: BaseExcelHeadView.identifier) as! BaseExcelHeadView
        sectionHeadView.subviews.forEach({$0.removeFromSuperview()})
        sectionHeadView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.rectForHeader(inSection: section).size.height)
        let sectionArray = sectionDataArray[section]
        if tableView == leftTableView {
            let cell: BaseTitleCell = tableView.dequeueReusableCell(withIdentifier: BaseTitleCell.identifier) as! BaseTitleCell
            cell.frame = sectionHeadView.bounds
            let proper = itemProperty(withSection: section, row: -1, column: -1)
            cell.proper = proper
            let model = sectionArray[0]
            cell.shouqi = true
            cell.model = model
            cell.sortB.tag = section
            cell.sortB.isSelected = folded(inSection: section)
            cell.sortB.addTarget(self, action: #selector(self.leftHeaderTap(_:)), for: .touchUpInside)
            sectionHeadView.contentView.addSubview(cell)
        } else {
            let count = datasource?.arrayDataForTopHeader(inTableView: self).count ?? 0
            for i in 0..<count {
                let cell = tableView.dequeueReusableCell(withIdentifier: BaseTitleCell.identifier) as! BaseTitleCell
                let proper = itemProperty(withSection: section, row: -1, column: i)
                proper.xstart = columnPointCollection[i]
                cell.proper = proper
                let model = sectionArray[i + 1]
                if sortItem.section == section && sortItem.column == i {
                    model.sortType = sortItem.sortType
                }
                if model.sortable {
                    cell.sortB.addEventHandler({ sender in
                        let sender: UIButton = sender as! UIButton
                        sender.isSelected = !sender.isSelected
                        cell.model = cell.model.nextType()
                        self.sortItem.changeSort(withSection: section, column: i, sortType: cell.model.sortType)
                        self.singleHeaderClick(IndexPath(row: i, section: section))
                        self.leftTableView.reloadData()
                        self.rightTableView.reloadData()
                    }, forControlEvents: UIControl.Event.touchUpInside)
                }
                cell.model = model
                sectionHeadView.contentView.addSubview(cell)
            }
        }
        return sectionHeadView
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == leftTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: BaseLeftCell.identifier) as! BaseLeftCell
            if hidIndex {
                cell.indexL.snp.makeConstraints { (make) in
                    make.left.equalToSuperview().offset(-25)
                }
            }
            let mode = leftHeaderDataArray[indexPath.section][indexPath.row]
            let proper = itemProperty(withSection: indexPath.section, row: indexPath.row, column: -1)
            cell.model = mode
            cell.proper = proper
            cell.indexL.text = String(format: "%ld", indexPath.row + 1)
            return cell
        } else {
            let count = datasource?.arrayDataForTopHeader(inTableView: self).count ?? 0
            let identifier = String(format: "%@%ld%@Identifier", NSStringFromClass(BaseExcelCell.self.self), count, excelContentCellIdentifier)
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! BaseContentCell
                for i in 0..<count {
                    let miniCell = tableView.dequeueReusableCell(withIdentifier: BaseContentCell.identifier) as! BaseContentCell
                    let proper = itemProperty(withSection: indexPath.section, row: indexPath.row, column: i)
                    proper.xstart = i < columnPointCollection.count ? columnPointCollection[i] : 0.0
                    miniCell.proper = proper
                    miniCell.tag = i + 10
                    cell.contentView.addSubview(miniCell)
                }


            for i in 0..<count {
                let miniCell = cell.contentView.viewWithTag(i + 10) as! BaseContentCell
                miniCell.didSelectBlock = {
                    let mode: ExcelLeftModel? = self.leftHeaderDataArray[indexPath.section][indexPath.row]
                    self.datasource?.tableView(self, didSelectSection: indexPath.section, inRow: indexPath.row, inColumn: i, item: mode?.item, key: nil, sortType: .none)
                }
                let proper = itemProperty(withSection: indexPath.section, row: indexPath.row, column: i)
                proper.xstart = i < columnPointCollection.count ? columnPointCollection[i] : 0.0
                if showSection {
                    miniCell.proper = proper
                } else {
                    miniCell.title.textColor = proper.textColor
                }
                var ary = contentDataArray[indexPath.section][indexPath.row]
                if i < ary.count {
                    miniCell.value = ary[i]
                } else {
                    miniCell.value = nil
                }
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section: Int = indexPath.section
        let row: Int = indexPath.row
        let column: Int = -1
        var target: UITableView?
        if tableView == leftTableView {
            target = rightTableView
        } else if tableView == rightTableView {
            target = leftTableView
        } else {
            target = nil
        }
        target?.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        let mode: ExcelLeftModel? = leftHeaderDataArray[indexPath.section][indexPath.row]
        datasource?.tableView(self, didSelectSection: section, inRow: row, inColumn: column, item: mode?.item, key: nil, sortType: .none)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var target: UIScrollView?
        if scrollView == leftTableView {
            target = rightTableView
        } else if scrollView == rightTableView {
            target = leftTableView
        } else if scrollView == rightScrollView {
            target = titleScrollView
        } else if scrollView == titleScrollView {
            target = rightScrollView
        }
        target?.contentOffset = scrollView.contentOffset
    }
}
