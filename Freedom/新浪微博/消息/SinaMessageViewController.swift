//
//  SinaMessageViewController.swift
//  Freedom
//
//  Created by Super on 6/28/18.
//  Copyright © 2018 薛超. All rights reserved.
import UIKit
import XExtension
class SinaMessageViewController: SinaBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH - TopHeight), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ID = "cell"
        if indexPath.row == 0 {
            let _searchBar = UISearchBar()
            _searchBar.frame = CGRect(x: _searchBar.frame.origin.x, y: _searchBar.frame.origin.y, width: APPW, height: 40)
            _searchBar.placeholder = "大家都在搜：男模遭趴光"
            let d = UITableViewCell(style: .default, reuseIdentifier: nil)
            d.contentView.addSubview(_searchBar)
            return d
        }
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: ID)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: ID)
        }
        cell?.textLabel?.text = "微博小秘书\(indexPath.row)"
        cell?.detailTextLabel?.text = "今晚我想去你那里，等着我。详情请点击查看！"
        cell?.imageView?.image = UIImage(named: "movie")
        return cell!
    }
}
