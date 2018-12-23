//
//  WXSearchController.swift
//  Freedom

import Foundation
import SnapKit
import XExtension
class WXSearchController: UISearchController {
    var showVoiceButton = false {
        didSet {
            if showVoiceButton {
                searchBar.showsBookmarkButton = true
                searchBar.setImage(UIImage(named: "searchBar_voice"), for: .bookmark, state: .normal)
                searchBar.setImage(UIImage(named: "searchBar_voice_HL"), for: .bookmark, state: .highlighted)
            } else {
                searchBar.showsBookmarkButton = false
            }
        }
    }
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        searchBar.frame = CGRect(x: 0, y: 0, width: APPW, height: CGFloat(TopHeight))
        searchBar.backgroundImage = UIImage.imageWithColor(.lightGray)
        searchBar.barTintColor = UIColor.lightGray
        searchBar.tintColor = UIColor.green
        let tf = searchBar.subviews.first?.subviews.last as! UITextField
        tf.layer.masksToBounds = true
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.cornerRadius = 5.0
        for view: UIView in searchBar.subviews[0].subviews {
            if (NSStringFromClass(object_getClass(view) ?? UIView.self) == "UISearchBarBackground") {
                let bg = UIView()
                bg.backgroundColor = UIColor.lightGray
                view.addSubview(bg)
                bg.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
                let line = UIView()
                line.backgroundColor = UIColor.gray
                view.addSubview(line)
                line.snp.makeConstraints { (make) in
                    make.left.right.bottom.equalToSuperview()
                    make.height.equalTo(1)
                }
                break
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
