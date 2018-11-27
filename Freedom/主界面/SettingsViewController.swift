//
//  SettingsViewController.swift
//  Freedom
//
//  Created by Super on 6/15/18.
//  Copyright © 2018 Super. All rights reserved.
//
import UIKit
import ElasticTransitionObjC
import XExtension
import BaseFile
class SettingsViewController: XBaseViewController ,ElasticMenuTransitionDelegate{
    var contentLength:CGFloat = APPW * 0.8
    var dismissByBackgroundTouch = true
    var dismissByBackgroundDrag = true
    var dismissByForegroundDrag = true
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: APPW * 0.8, height: 200))
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        let ET = transitioningDelegate as? ElasticTransition
        print("\ntransition.edge = \(HelperFunctions.type(toStringOf: (ET?.edge)!))\ntransition.transformType = \(String(describing: ET?.transformTypeToString()))\ntransition.sticky = \(String(describing:  ET?.sticky))\ntransition.showShadow = \(String(describing: ET?.showShadow))")
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        }
        cell?.backgroundColor = UIColor.clear
        cell?.textLabel?.text = "\(indexPath.row)"
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
