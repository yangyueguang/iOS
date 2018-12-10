//
//  BaseSearchBarView.swift
//  iTour
//
//  Created by Super on 2017/10/23.
//  Copyright © 2017年 Croninfo. All rights reserved.
//

import UIKit

class BaseSearchBarView: UISearchBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        placeholder = "搜索"
        let searchBarTextField = subviews.flatMap { $0.subviews }.filter { $0 is UITextField }.first as? UITextField
        if let searchBarTextField = searchBarTextField {
            searchBarTextField.textColor = .gray
            searchBarTextField.tintColor = UIColor.gray
            searchBarTextField.font = UIFont.systemFont(ofSize: 13)
            searchBarTextField.backgroundColor = .black
            searchBarTextField.layer.cornerRadius = 18// searchBarTextField.frame.size.width/2
            searchBarTextField.clipsToBounds = true
            searchBarTextField.height = 10
            searchBarTextField.defaultTextAttributes = [:]
        }
//        let sea = subviews.first?.subviews.last
//        sea?.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 10)
//        if #available(iOS 10.0, *) {
//            self.setPositionAdjustment(UIOffsetMake(kScreenW/2, 0), for: .search)
//        }
//        let searField = subviews.last as? UITextField
//        searField?.font = UIFont.systemFont(ofSize: 11)
        let miniSFont = UIFont.systemFont(ofSize: 13)
        for v in subviews {
            if v is UITextField{
                (v as! UITextField).font = miniSFont
            }
            if v is UILabel{
                (v as! UILabel).font = miniSFont
            }
            for mv in v.subviews{
                if mv is UITextField{
                    (mv as! UITextField).font = miniSFont
                    mv.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height:10)
                }
                if mv is UILabel{
                    (mv as! UILabel).font = miniSFont
                }
            }
        }
       
        barStyle = .default
        searchBarStyle = .minimal
        showsCancelButton = false
        sizeToFit()
        barTintColor = UIColor.red
        setImage(UIImage(named:"cancel"), for: .clear, state: .normal)
        setImage(UIImage(named:"搜索"), for: .search, state: .normal)
        searchFieldBackgroundPositionAdjustment = UIOffset(horizontal: 0, vertical: -5 )
//        setPositionAdjustment(UIOffsetMake(0, 0), for: .search)
//        setPositionAdjustment(UIOffsetMake(0, 0), for: .clear)
//        setSearchFieldBackgroundImage(UIImage(named:"搜索外框"), for: .normal)
//        backgroundColor = UIColor.white
//        showsBookmarkButton = true
//        setImage(UIImage(named:"cancel"), for: .bookmark, state: .normal)
//        backgroundImage = UIImage(named:"搜索外框")
//        setBackgroundImage(UIImage(named:"搜索外框"), for: .any, barMetrics: .default)
//        prompt = "prompt"
//        inputAccessoryView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 25))
//        inputAccessoryView?.backgroundColor = .red
//        showsSearchResultsButton = true
//        isSearchResultsButtonSelected = true
//        text = "text"
//        showsScopeBar = true
//        scopeBarBackgroundImage = UIImage(named:"search_home")
//        setScopeBarButtonBackgroundImage(UIImage(named:"search_home"), for: .normal)
//        setScopeBarButtonDividerImage(UIImage(named:"更新提醒"), forLeftSegmentState: .normal, rightSegmentState: .normal)
//        setScopeBarButtonTitleTextAttributes( ["foregroundColor" : UIColor.white ,"font" : UIFont.systemFont(ofSize: 16)], for: .normal)
//        scopeButtonTitles = ["aaa","bbb","ccc"]
//        selectedScopeButtonIndex = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
