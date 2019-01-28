//
//  EWPopMenu.swift
import UIKit
class XPopMenu<T>: UIView, UITableViewDelegate, UITableViewDataSource{
    public var actionClosure: ((T)->())?
    public var cellClosure: ((UITableView, T) -> (UITableViewCell))?
    private var items: [T] = []
    private var rowHeight: CGFloat = 0
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.showsHorizontalScrollIndicator = true
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.cornerRadius = 5
        tableView.layer.masksToBounds = true
        tableView.isScrollEnabled = true
        return tableView
    }()
    init(frame: CGRect, items:[T], cellHeight: CGFloat) {
        super.init(frame: UIScreen.main.bounds)
        rowHeight = cellHeight
        self.items = items
        let height = rowHeight * min(CGFloat(items.count), 5)
        let navHeight: CGFloat = UIScreen.main.bounds.size.height == 812 ? 88 : 64
        tableView.frame = CGRect(x: frame.origin.x, y: navHeight + frame.origin.y, width: frame.size.width, height: height)
        self.addSubview(tableView)
    }
    public func show() {
        let window = UIApplication.shared.windows.first
        window?.addSubview(self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellClosure?(tableView, items[indexPath.row])
        cell?.selectionStyle = .none
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        actionClosure?(items[indexPath.row])
        self.removeFromSuperview()
    }
}
