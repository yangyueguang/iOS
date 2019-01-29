//
//  SDServiceTableViewController.swift
//  Freedom
import UIKit
import XExtension
import MJRefresh
class AlipayServiceTableViewCellModel: NSObject {
    var title = ""
    var detailString = ""
    var iconImageURLString = ""
}
class AlipayServiceTableViewCell:BaseTableViewCell<Any> {
    override func initUI() {
        icon = UIImageView(frame: CGRect(x: 10, y: 10, width: 100, height: 80))
        title = UILabel(frame: CGRect(x: 120, y: 10, width: 200, height: 20))
        script = UILabel(frame: CGRect(x: 120, y: 40, width: 200, height: 20))
        icon.layer.cornerRadius = 4
        icon.clipsToBounds = true
        title.font = Font(16)
        script.font = Font(14)
        script.textColor = UIColor.gray
        addSubviews([icon, title, script])
    }
    func setModel(_ model: NSObject?) {
        let cellModel = model as? AlipayServiceTableViewCellModel
        title.text = cellModel?.title
        script.text = cellModel?.detailString
        icon.sd_setImage(with: URL(string: cellModel?.iconImageURLString ?? ""), placeholderImage: nil)
    }
}
class AlipayServiceTableViewHeader : UIView,UITextFieldDelegate{
    var textField = UITextField()
    var textFieldSearchIcon = UIImageView()
    let textFieldPlaceholderLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        let textField = UITextField()
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        textField.backgroundColor = UIColor.white
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.addTarget(self, action: Selector(("textFieldValueChanged:")), for: .editingChanged)
        textField.clearButtonMode = .always
        textField.delegate = self as UITextFieldDelegate
        addSubview(textField)
        self.textField = textField
        let searchIcon = UIImageView(image: UIImage(named: "search"))
        searchIcon.contentMode = .scaleAspectFill
        self.textField.addSubview(searchIcon)
        textFieldSearchIcon = searchIcon
        textFieldPlaceholderLabel.font = self.textField.font
        textFieldPlaceholderLabel.textColor = UIColor.lightGray
        textField.addSubview(textFieldPlaceholderLabel)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setPlaceholderText(_ placeholderText: String?) {
        textFieldPlaceholderLabel.text = placeholderText
    }
    
    override func layoutSubviews() {
        let _: CGFloat = 8
        layoutTextFieldSubviews()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: textFieldSearchIcon.height * 1.4, height: textFieldSearchIcon.height))
        textField.leftViewMode = .always
    }
    func layoutTextFieldSubviews() {
        let rect: CGRect = CGRect(x: 0, y: 0, width: APPW, height: 200)
        textFieldPlaceholderLabel.bounds = CGRect(x: 0, y: 0, width: rect.size.width, height: textField.height)
        textFieldPlaceholderLabel.center = CGPoint(x: textField.frame.size.width * 0.5, y: textField.height * 0.5)
        textFieldSearchIcon.bounds = CGRect(x: 0, y: 0, width: textField.height * 0.6, height: textField.height * 0.6)
        textFieldSearchIcon.center = CGPoint(x: textFieldPlaceholderLabel.x - textFieldSearchIcon.frame.size.width * 0.5, y: textFieldPlaceholderLabel.center.y)
    }
    
    func textFieldValueChanged(_ field: UITextField?) {
        textFieldPlaceholderLabel.isHidden = (field?.text?.count ?? 0) != 0
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textField.becomeFirstResponder()
        let deltaX: CGFloat = textFieldSearchIcon.x - 5
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.textFieldSearchIcon.transform = CGAffineTransform(translationX: -deltaX, y: 0)
            self.textFieldPlaceholderLabel.transform = CGAffineTransform(translationX: -deltaX, y: 0)
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.textFieldSearchIcon.transform = .identity
            self.textFieldPlaceholderLabel.transform = .identity
        })
        self.textField.text = ""
        textFieldPlaceholderLabel.isHidden = false
    }
        
}
final class AlipayServiceTableViewController: AlipayBaseViewController {
    let cellClass = AlipayServiceTableViewCell.self
    var dataArray = [AlipayServiceTableViewCellModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH - TopHeight))
//        tableView.delegate = self
//        tableView.dataSource = self
        navigationItem.title = "朋友"
        tableView.rowHeight = 70
        let header = AlipayServiceTableViewHeader(frame: CGRect.zero)
        header.height = 44
        header.setPlaceholderText("搜索朋友")
        tableView.tableHeaderView = header
        var temp = [AnyHashable]()
        for i in 0..<12 {
            let model = AlipayServiceTableViewCellModel()
            model.title = "服务提醒 -- \(i)"
            model.detailString = "服务提醒摘要 -- \(i)"
            model.iconImageURLString = "http://f.vip.duba.net/data/avatar//201309/9/328/137871226483UB.jpg"
            temp.append(model)
        }
        dataArray = temp as! [AlipayServiceTableViewCellModel]
        view.addSubview(tableView)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArray[indexPath.row]
        var cell = tableView.dequeueCell(AlipayServiceTableViewCell.self)
        cell.setModel(model)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _: AlipayServiceTableViewCellModel? = dataArray[indexPath.row]
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        tableView.endEditing(true)
    }
    // MARK: - pull down refresh
    func pullDownRefreshOperation() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(2.0 * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {() -> Void in
//            self.refreshControl?.endRefreshing()
        })
    }
    
}
