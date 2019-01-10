//
//  RLMRealm+extension.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2019/1/9.
//  Copyright © 2019 薛超. All rights reserved.
//
import Realm
import Foundation
import RealmSwift
extension RLMArray {
   @objc func array() -> [AnyObject] {
        var items: [AnyObject] = []
        for index in 0..<count {
            items.append(object(at: index))
        }
        return items
    }
}
extension RLMResults {
    @objc func array() -> [AnyObject] {
        var items: [AnyObject] = []
        for index in 0..<count {
            items.append(object(at: index))
        }
        return items
    }
}
extension RealmCollection {
    func array() -> [Self.Element] {
        var items: [Self.Element] = []
        for item in self {
            items.append(item)
        }
        return items
    }
}
extension List {
//    func reset(_ array: [AnyObject]) {
//        self.removeAll()
//        self.append(objectsIn: array)
//    }
//    convenience init(normalArray: [RealmCollectionValue]) {
//        self.init()
//        for ele in normalArray {
//            self.append(ele)
//        }
//    }
}
extension ListBase {
//    func remove(_ obj: AnyObject) {
//        let index = self.index(ofAccessibilityElement: obj)
//    }
//    convenience public init(normalArray: [AnyObject]) {
//        self.init()
//    }
}
extension RLMObject {
    func tes() {
        let re = CRResource()
        let realm = RLMRealm.default()
        let predicate = NSPredicate.init(format: "status=%d", ResourceStatus.finish.rawValue)
        let result = CRResource.objects(with: predicate)
        realm.addOrUpdate(re)
    }

//    override static func ignoredProperties() -> [String] {
//        return ["extensionFrame"]
//    }

}
