//
//  WXSearchController.swift
//  Freedom

import Foundation
import SnapKit
//import XExtension
class WXSearchController: UISearchController {
    var showVoiceButton = false {
        didSet {
            if showVoiceButton {
                searchBar.showsBookmarkButton = true
                searchBar.setImage(WXImage.barVoice.image, for: .bookmark, state: .normal)
                searchBar.setImage(WXImage.barVoice.image, for: .bookmark, state: .highlighted)
            } else {
                searchBar.showsBookmarkButton = false
            }
        }
    }
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        searchBar.frame = CGRect(x: 0, y: 0, width: APPW, height: 44)
        searchBar.backgroundImage = UIImage.imageWithColor(.clear)
        searchBar.barTintColor = UIColor.light
        searchBar.tintColor = UIColor.greenx
        let tf = searchBar.subviews.first?.subviews.last as! UITextField
        tf.layer.masksToBounds = true
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.grayx.cgColor
        tf.layer.cornerRadius = 5.0
        for view: UIView in searchBar.subviews[0].subviews {
            if (NSStringFromClass(object_getClass(view) ?? UIView.self) == "UISearchBarBackground") {
                let bg = UIView()
                bg.backgroundColor = UIColor.light
                view.addSubview(bg)
                bg.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
                let line = UIView()
                line.backgroundColor = UIColor.grayx
                view.addSubview(line)
                line.snp.makeConstraints { (make) in
                    make.left.right.bottom.equalToSuperview()
                    make.height.equalTo(1)
                }
                break
            }
        }
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
