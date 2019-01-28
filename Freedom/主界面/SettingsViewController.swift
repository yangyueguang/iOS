//
//  SettingsViewController.swift
//  Freedom
//
//  Created by Super on 6/15/18.
//  Copyright © 2018 Super. All rights reserved.
//
import UIKit
import XExtension
import XCarryOn
class SettingsViewController: BaseViewController ,ElasticMenuTransitionDelegate{
    var contentLength:CGFloat = APPW * 0.8
    var dismissByBackgroundTouch = true
    var dismissByBackgroundDrag = true
    var dismissByForegroundDrag = true
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH))
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: APPW * 0.8, height: 200))
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        let tm = transitioningDelegate as! ElasticTransition
        print( "transition.edge = .\(tm.edge)\n" +
            "transition.transformType = .\(tm.transformType)\n" +
            "transition.sticky = \(tm.sticky)\n" +
            "transition.showShadow = \(tm.showShadow)")
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueCell(BaseTableViewCell.self)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
