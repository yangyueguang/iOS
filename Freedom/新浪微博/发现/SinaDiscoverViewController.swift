//
//  SinaDiscoverViewController.swift
//  Freedom
//
//  Created by Super on 6/28/18.
//  Copyright © 2018 薛超. All rights reserved.
//
import UIKit
class SinaDiscoverViewController: SinaBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 375, height: 30))
        searchBar.placeholder = "大家都在搜：男模遭趴光"
        navigationItem.titleView = searchBar
    }
}
