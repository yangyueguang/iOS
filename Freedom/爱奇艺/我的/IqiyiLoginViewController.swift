//
//  JFLoginViewController.swift
//  Freedom
import UIKit
import XExtension
class IqiyiLoginBtnCell:BaseTableViewCell{
}
class IqiyiLoginViewController: IqiyiBaseViewController {
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = false
        title = "登陆"
//        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"cellLeft"), style: .done, target: self, action: self.navigationController?.popViewController(animated: true))
//        navigationItem.leftBarButtonItem = leftBarButtonItem
        tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        view.backgroundColor = UIColor(249, 249, 249,1)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70
        } else {
            return 180
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let ID = "JFLoginBtnCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID) as? IqiyiLoginBtnCell
            if cell == nil {
                // 从xib中加载cell
                cell = IqiyiLoginBtnCell(style: .default, reuseIdentifier: ID)
                cell?.backgroundColor = UIColor.red
            }
            cell?.selectionStyle = .none
        return cell!
    }
}
