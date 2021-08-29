//
//  Collection+Extension.swift
//  MyCocoaPods
//
//  Created by Chao Xue 薛超 on 2018/12/12.
//  Copyright © 2018 Super. All rights reserved.
//

import Foundation

public extension Array{
    /// 返回对象数组对应的json数组 前提element一定是AnyObject类型
    func jsonArray() -> [[String: Any]] {
        var jsonObjects: [[String: Any]] = []
        for element in self {
            let model: AnyObject = element as AnyObject
            let jsonDict = model.dictionaryRepresentation()
            jsonObjects.append(jsonDict)
        }
        return jsonObjects
    }

    /// 安全的取值
    public func item(at index: Int) -> Element? {
        guard startIndex..<endIndex ~= index else { return nil }
        return self[index]
    }

    /// 交换
    public mutating func swap(from index: Int, to: Int) {
        guard index != to,
            startIndex..<endIndex ~= index,
            startIndex..<endIndex ~= to else { return }
        swapAt(index, to)
    }

    /// 找到的元素的地址列表
    public func indexs(where condition: (Element) throws -> Bool) rethrows -> [Int] {
        var indicies: [Int] = []
        for (index, value) in lazy.enumerated() {
            if try condition(value) { indicies.append(index) }
        }
        return indicies
    }

    /// 是否全是某种条件的对象
    public func isAll(Where condition: (Element) throws -> Bool) rethrows -> Bool {
        return try !contains { try !condition($0) }
    }

    /// 是否全不是某种条件对象
    public func isNone(Where condition: (Element) throws -> Bool) rethrows -> Bool {
        return try !contains { try condition($0) }
    }

    /// 对满足条件的每个对象采取行动
    public func forEach(where condition: (Element) throws -> Bool, body: (Element) throws -> Void) rethrows {
        for element in self where try condition(element) {
            try body(element)
        }
    }

    /// 数组筛选
    public func filtered<T>(_ isIncluded: (Element) throws -> Bool, map transform: (Element) throws -> T) rethrows ->  [T] {
        #if swift(>=4.1)
        return try compactMap({
            if try isIncluded($0) {
                return try transform($0)
            }
            return nil
        })
        #else
        return try flatMap({
        if try isIncluded($0) {
        return try transform($0)
        }
        return nil
        })
        #endif
    }

    /// 分组
    public func group(by size: Int) -> [[Element]] {
        guard size > 0, !isEmpty else { return [] }
        var value: Int = 0
        var slices: [[Element]] = []
        while value < count {
            slices.append(Array(self[Swift.max(value, startIndex)..<Swift.min(value + size, endIndex)]))
            value += size
        }
        return slices
    }

    /// 分为满足和不满足条件的两组
    public func divided(by condition: (Element) throws -> Bool) rethrows -> (matching: [Element], nonMatching: [Element]) {
        var matching = [Element]()
        var nonMatching = [Element]()
        for element in self {
            if try condition(element) {
                matching.append(element)
            } else {
                nonMatching.append(element)
            }
        }
        return (matching, nonMatching)
    }

    /// 排序
    public func sorted<T: Comparable>(by path: KeyPath<Element, T?>, ascending: Bool = true) -> [Element] {
        return sorted(by: { (lhs, rhs) -> Bool in
            guard let lhsValue = lhs[keyPath: path], let rhsValue = rhs[keyPath: path] else { return false }
            if ascending {
                return lhsValue < rhsValue
            }
            return lhsValue > rhsValue
        })
    }

}

public extension Array where Element: Equatable {
    /// 是否包含
    public func contains(_ elements: [Element]) -> Bool {
        guard !elements.isEmpty else { return true }
        var found = true
        for element in elements {
            if !contains(element) {
                found = false
            }
        }
        return found
    }

    /// 删除
    public mutating func removeAll(_ items: [Element]) {
        guard !items.isEmpty else { return }
        self = filter { !items.contains($0) }
    }

    /// 去重
    public mutating func removeDuplicates() {
        self = reduce(into: [Element]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
    }
    
    func index(_ e: Element) -> Int? {
        for (index, value) in lazy.enumerated() where value == e {
            return index
        }
        return nil
    }

}


public extension Dictionary{

    func jsonString(prettify: Bool = false) -> String {
        guard JSONSerialization.isValidJSONObject(self) else {
            return ""
        }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return "" }
        return String(data: jsonData, encoding: .utf8) ?? ""
    }

    ///    let result = dict + dict2
    public static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.forEach { result[$0] = $1 }
        return result
    }

    ///    dict += dict2
    public static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach { lhs[$0] = $1}
    }

    ///    let result = dict-["key1", "key2"]
    public static func - (lhs: [Key: Value], keys: [Key]) -> [Key: Value] {
        var result = lhs
        result.removeAll(keys: keys)
        return result
    }

    ///    dict-=["key1", "key2"]
    public static func -= (lhs: inout [Key: Value], keys: [Key]) {
        lhs.removeAll(keys: keys)
    }

    public mutating func removeAll(keys: [Key]) {
        keys.forEach({ removeValue(forKey: $0)})
    }
    
    public func count(where condition: @escaping ((key: Key, value: Value)) throws -> Bool) rethrows -> Int {
        var count: Int = 0
        try self.forEach {
            if try condition($0) {
                count += 1
            }
        }
        return count
    }

}
