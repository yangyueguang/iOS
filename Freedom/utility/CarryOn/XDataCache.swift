//
//  XDataCache.swift
//  MyCocoaPods
//
//  Created by Chao Xue 薛超 on 2018/12/3.
//  Copyright © 2018 Super. All rights reserved.
//

import UIKit
import Foundation

open class XDataCache: NSObject {
    public static let shared = XDataCache()
    private var memCache: [String : Any] = [:]
    private var diskCachePath = ""
    private var cacheInQueue = OperationQueue()
    private var cacheMaxCacheAge: Int = 60 * 60 * 24 * 7 // 1 week

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override init() {
        super.init()
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        diskCachePath = URL(fileURLWithPath: paths[0]).appendingPathComponent("DataCache").absoluteString
        if !FileManager.default.fileExists(atPath: diskCachePath) {
            try? FileManager.default.createDirectory(atPath: diskCachePath, withIntermediateDirectories: true, attributes: nil)
        }
        cacheInQueue.maxConcurrentOperationCount = 1
        NotificationCenter.default.addObserver(self, selector: #selector(self.clearMemory), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.cleanDisk), name: UIApplication.willTerminateNotification, object: nil)
        let device = UIDevice.current
        if device.responds(to: #selector(getter: UIDevice.isMultitaskingSupported)) && device.isMultitaskingSupported {
            NotificationCenter.default.addObserver(self, selector: #selector(self.clearMemory), name: UIApplication.didEnterBackgroundNotification, object: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.cleanDisk), name: UIApplication.willResignActiveNotification, object: nil)

    }

    private func cachePath(forKey key: String) -> String {
        let filename = key
        return URL(fileURLWithPath: diskCachePath).appendingPathComponent(filename).absoluteString
    }

    public func store(_ data: Data, forKey key: String, toDisk: Bool) {
        memCache[key] = data
        if toDisk {
            cacheInQueue.addOperation {
                let fileManager = FileManager()
                fileManager.createFile(atPath: self.cachePath(forKey: key) , contents: data, attributes: nil)
            }
        }
    }

    public func data(_ key: String, fromDisk: Bool) -> Data? {
        var data = memCache[key] as? Data
        if data == nil && fromDisk {
            do {
                let path = cachePath(forKey: key)
                data = try Data(contentsOf: URL(fileURLWithPath: path))
                if data != nil {
                    memCache[key] = data
                }
            }catch{}
        }
        return data
    }

    public func removeData(forKey key: String) {
        memCache.removeValue(forKey: key)
        try? FileManager.default.removeItem(atPath: cachePath(forKey: key))
    }

    @objc public func clearMemory() {
        cacheInQueue.cancelAllOperations()
        memCache.removeAll()
    }

    public func clearDisk() {
        cacheInQueue.cancelAllOperations()
        try? FileManager.default.removeItem(atPath: diskCachePath)
        try? FileManager.default.createDirectory(atPath: diskCachePath, withIntermediateDirectories: true, attributes: nil)
    }
    
    @objc public func cleanDisk() {
        let expirationDate = Date(timeIntervalSinceNow: TimeInterval(-cacheMaxCacheAge))
        if let fileEnumerator = FileManager.default.enumerator(atPath: diskCachePath) {
        for file in fileEnumerator {
            let fileName = "\(file)"
            let filePath = URL(fileURLWithPath: diskCachePath).appendingPathComponent(fileName).absoluteString
            let attrs = try? FileManager.default.attributesOfItem(atPath: filePath)
            let modiData: Date = attrs?[FileAttributeKey.modificationDate] as! Date
            if modiData.compare(expirationDate) == .orderedAscending {
                try? FileManager.default.removeItem(atPath: filePath)
            }
        }
        }
    }
}
