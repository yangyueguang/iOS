//
//  WXSearchController.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/19.
//  Copyright © 2018 薛超. All rights reserved.
//

import Foundation
class WXSearchController: UISearchController {
    var showVoiceButton = false

    override init(searchResultsController: UIViewController?) {
        //if super.init(searchResultsController: searchResultsController)

        searchBar.frame = CGRect(x: 0, y: 0, width: APPW, height: CGFloat(TopHeight))
        searchBar.backgroundImage = FreedomTools(color: UIColor.lightGray)
        searchBar.barTintColor = UIColor.lightGray
        searchBar.tintColor = UIColor.green
        let tf = searchBar.subviews.first?.subviews.last as? UITextField
        tf?.layer.masksToBounds = true
        tf?.layer.borderWidth = 1
        tf?.layer.borderColor = UIColor.gray.cgColor
        tf?.layer.cornerRadius = 5.0

        for view: UIView? in searchBar.subviews[0].subviews {
            if (view is NSClassFromString("UISearchBarBackground")) {
                let bg = UIView()
                bg.backgroundColor = UIColor.lightGray
                view?.addSubview(bg)
                bg.mas_makeConstraints({ make in
                    make?.edges.mas_equalTo(0)
                })

                let line = UIView()
                line.backgroundColor = UIColor.gray
                view?.addSubview(line)
                line.mas_makeConstraints({ make in
                    make?.left.and().right().and().bottom().mas_equalTo(0)
                    make?.height.mas_equalTo(1)
                })
                break
            }
        }

    }
    func setShowVoiceButton(_ showVoiceButton: Bool) {
        self.showVoiceButton = showVoiceButton
        if showVoiceButton {
            searchBar.showsBookmarkButton = true
            searchBar.setImage(UIImage(named: "searchBar_voice"), for: .bookmark, state: .normal)
            searchBar.setImage(UIImage(named: "searchBar_voice_HL"), for: .bookmark, state: .highlighted)
        } else {
            searchBar.showsBookmarkButton = false
        }
    }


}
