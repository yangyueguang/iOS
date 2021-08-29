//
//  Extension.swift
//  project
//
//  Created by Chao Xue 薛超 on 2019/7/31.
//  Copyright © 2019 Super. All rights reserved.
//
import UIKit
import Foundation
import RxSwift
import ObjectiveC
extension UITableView {

}
extension Collection {
    subscript (i index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
fileprivate var disposeBagContext: UInt8 = 0
extension Reactive where Base: AnyObject {
    func synchronizedBag<T>( _ action: () -> T) -> T {
        objc_sync_enter(self.base)
        let result = action()
        objc_sync_exit(self.base)
        return result
    }
}
public extension Reactive where Base: AnyObject {
    var disposeBag: DisposeBag {
        get {
            return synchronizedBag {
                if let disposeObject = objc_getAssociatedObject(base, &disposeBagContext) as? DisposeBag {
                    return disposeObject
                }
                let disposeObject = DisposeBag()
                objc_setAssociatedObject(base, &disposeBagContext, disposeObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return disposeObject
            }
        }
        set {
            synchronizedBag {
                objc_setAssociatedObject(base, &disposeBagContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}
