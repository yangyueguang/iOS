//
//  DetailTableViewController.swift
//  Freedom
import UIKit
import XExtension
class DetailTableViewController: TaobaoBaseViewController {
    private var titles = ["图文详情", "商品评论", "店铺推荐"]
    private var urls = ["http://m.b5m.com/item.html?tid=2614676&mps=____&type=content", "http://m.b5m.com/item.html?tid=2614676&mps=____&type=comment", "http://m.baidu.com"]
    var detailView :DetailView!
    var data :[[String:Any]]!
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        data = [["title": "Wap商品详情", "author": "伯光", "class": "DetailWapViewController"],["title": "TableView商品详情", "author": "伯光", "class": "DetailTableViewController"],["title": "ScrollView商品详情", "author": "伯光", "class": "DetailScrollViewController"],["title": "Wap商品详情", "author": "伯光", "class": "DetailWapViewController"],["title": "TableView商品详情", "author": "伯光", "class": "DetailTableViewController"],["title": "ScrollView商品详情", "author": "伯光", "class": "DetailScrollViewController"]]
        
            detailView = DetailView(frame: CGRect(x: 0, y: 64, width: view.bounds.size.width, height: view.bounds.size.height - 64))
            tableView = BaseTableView(frame: detailView.bounds)
            tableView.delegate = self
            tableView.dataSource = self
        if let aView = detailView {
            view.addSubview(aView)
        }
        view.backgroundColor = UIColor.lightGray
        tableView.reloadData()
        detailView?.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeueReusableCellWithIdentifier = "dequeueReusableCellWithIdentifier"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: dequeueReusableCellWithIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: dequeueReusableCellWithIdentifier)
            cell?.accessoryType = .disclosureIndicator
        }
        cell?.textLabel?.text = data[indexPath.row]["title"] as? String
        cell?.detailTextLabel?.text = data[indexPath.row]["author"] as? String
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = data[indexPath.row]["class"]
navigationController?.pushViewController(UIViewController(), animated: true)
    }
}
