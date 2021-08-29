//
//  ReusableView+Extension.swift
//  MyCocoaPods
//
//  Created by Chao Xue 薛超 on 2018/12/12.
//  Copyright © 2018 Super. All rights reserved.
//
import UIKit
import Foundation

public extension UICollectionViewCell {
}

public extension UICollectionReusableView {
    class var identifier: String {
        return self.nameOfClass
    }
    class var bundle: Bundle? {
        return Bundle(for: self)
    }
}

private var XCHView: UIView = UIView()
public extension UICollectionView {
    var headView: UIView {
        set {
            XCHView.removeFromSuperview()
            XCHView = newValue
            var headFrame = newValue.frame
            headFrame.origin.y = -headFrame.size.height
            XCHView.frame = headFrame
            contentInset = UIEdgeInsets(top: headFrame.size.height, left: 0, bottom: 0, right: 0)
            addSubview(XCHView)
        }
        get {
            return XCHView
        }
    }

    func dequeueCell<T: UICollectionViewCell>(_ cell: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: cell.identifier, for: indexPath) as! T
    }

    func dequeueHeadFoot<T: UICollectionReusableView>(_ className: T.Type, kind: String, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: className.identifier, for: indexPath) as! T
    }

    func register<T: UICollectionReusableView>(_ view: T.Type, isHeader: Bool = true, isNib: Bool = false) {
        if view is UICollectionViewCell.Type {
            if isNib {
                self.register(UINib(nibName: view.nameOfClass, bundle: Bundle(for: view.self)), forCellWithReuseIdentifier: view.identifier)
            }else{
                self.register(view.self, forCellWithReuseIdentifier: view.identifier)
            }
        } else {
            if isNib {
                self.register(UINib(nibName: view.nameOfClass, bundle: Bundle(for: view)), forSupplementaryViewOfKind: isHeader ? UICollectionView.elementKindSectionHeader : UICollectionView.elementKindSectionFooter, withReuseIdentifier: view.identifier)
            }else{
                self.register(view, forSupplementaryViewOfKind: isHeader ? UICollectionView.elementKindSectionHeader : UICollectionView.elementKindSectionFooter, withReuseIdentifier: view.identifier)
            }
        }
    }
}

public extension UITableViewCell {
    class var identifier: String {
        return self.nameOfClass
    }

    class var bundle: Bundle? {
        return Bundle(for: self)
    }
}

public extension UITableViewHeaderFooterView {
    class var identifier: String {
        return self.nameOfClass
    }

    class var bundle: Bundle? {
        return Bundle(for: self)
    }
}

public extension UITableView {
    func register<T: UIView>(_ view: T.Type, isNib: Bool = false) {
        if view is UITableViewCell.Type {
            if isNib {
                self.register(UINib(nibName: view.nameOfClass, bundle: Bundle.main), forCellReuseIdentifier: view.nameOfClass)
            }else{
                self.register(view, forCellReuseIdentifier: view.nameOfClass)
            }
        } else {
            if isNib {
                self.register(UINib(nibName: view.nameOfClass, bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: view.nameOfClass)
            }else{
                self.register(view, forHeaderFooterViewReuseIdentifier: view.nameOfClass)
            }
        }
    }

    func scrollToBottom(withAnimation animation: Bool) {
        let section = (dataSource?.numberOfSections!(in: self) ?? 1) - 1
        let row: Int = dataSource?.tableView(self, numberOfRowsInSection: section) ?? 0
        if (row) > 0 {
            scrollToRow(at: IndexPath(row: (row) - 1, section: section), at: .bottom, animated: animation)
        }
    }

    func dequeueHeadFootView<T: UITableViewHeaderFooterView>(view: T.Type) -> T? {
        let head = dequeueReusableHeaderFooterView(withIdentifier: view.identifier)
        return head as? T
    }

    func dequeueCell<T: UITableViewCell>(_ cell: T.Type) -> T {
        var ce = dequeueReusableCell(withIdentifier: cell.identifier)
        if ce == nil {
            ce = cell.init(style: .default, reuseIdentifier: cell.identifier)
        }
        return ce as! T
    }
}
