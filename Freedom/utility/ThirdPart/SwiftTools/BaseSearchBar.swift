//
//  BaseSearchBar.swift
//  Freedom
//
//  Created by Super on 7/4/18.
//  Copyright © 2018 薛超. All rights reserved.
//
import UIKit
class BaseSearchBar: UISearchBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        for v: UIView in subviews {
            for vv: UIView in v.subviews {
                if (vv is UIImageView) {
                    vv.removeFromSuperview()
                }
                if let searchBarTextField:UITextField = v as? UITextField {
                    searchBarTextField.textColor = .gray
                    searchBarTextField.tintColor = UIColor.red
                    searchBarTextField.font = UIFont.systemFont(ofSize: 13)
                    searchBarTextField.backgroundColor = UIColor.yellow
                    searchBarTextField.layer.cornerRadius = 18
                    searchBarTextField.clipsToBounds = true
                }
            }
        }
        backgroundColor = UIColor.clear
        placeholder = "搜索"
        barStyle = .default
        searchBarStyle = .prominent
        showsCancelButton = false
        sizeToFit()
        barTintColor = UIColor.white
        backgroundImage = nil
        searchFieldBackgroundPositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
