//
//  RLMRealm+extension.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2019/1/9.
//  Copyright © 2019 薛超. All rights reserved.
//
import Realm
import Foundation
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
