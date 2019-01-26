//
//  WXExpanded.swift
//  Freedom
import Foundation
extension FileManager {
    class func url(for directory: FileManager.SearchPathDirectory) -> URL? {
        return self.default.urls(for: directory, in: .userDomainMask).last
    }

    class func path(for directory: FileManager.SearchPathDirectory) -> String {
        return NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true)[0]
    }

    class func documentsURL() -> URL? {
        return self.url(for: .documentDirectory)
    }

    class func documentsPath() -> String {
        return self.path(for: .documentDirectory)
    }

    class func libraryURL() -> URL? {
        return self.url(for: .libraryDirectory)
    }
    class func libraryPath() -> String? {
        return self.path(for: FileManager.SearchPathDirectory.libraryDirectory)
    }

    class func cachesURL() -> URL? {
        return self.url(for: FileManager.SearchPathDirectory.cachesDirectory)
    }

    class func cachesPath() -> String {
        return self.path(for: FileManager.SearchPathDirectory.cachesDirectory)
    }

    class func addSkipBackupAttribute(toFile path: String) -> Bool {
        try? NSURL(fileURLWithPath: path).setResourceValue(true, forKey: .isExcludedFromBackupKey)
        return true
    }

    class func availableDiskSpace() -> Double {
        let attributes = try? self.default.attributesOfFileSystem(forPath: self.documentsPath())
        return Double(UInt64(attributes![FileAttributeKey.systemFreeSize] as! UInt64)) / Double(0x100000)
    }
    class func pathUserSettingImage(_ imageName: String) -> String? {
        let path = "\(FileManager.documentsPath())/User/\("2829969299")/Setting/Images/"
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path + imageName
    }

    class func pathUserChatImage(_ imageName: String) -> String {
        let path = "\(FileManager.documentsPath())/User/\("2829969299")/Chat/Images/"
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path + imageName
    }
    class func pathUserChatBackgroundImage(_ imageName: String) -> String {
        let path = "\(FileManager.documentsPath())/User/\("2829969299")/Chat/Background/"
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path + imageName
    }
    class func pathUserAvatar(_ imageName: String) -> String {
        let path = "\(FileManager.documentsPath())/User/\("2829969299")/Chat/Avatar/"
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path + imageName
    }

    class func pathContactsAvatar(_ imageName: String) -> String {
        let path = "\(FileManager.documentsPath())/Contacts/Avatar/"
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path + imageName
    }
    class func pathExpression(forGroupID groupID: String) -> String {
        let path = "\(FileManager.documentsPath())/Expression/\(groupID)/"
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }
    class func pathContactsData() -> String {
        let path = "\(FileManager.documentsPath())/Contacts/"
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path + ("Contacts.dat")
    }
    class func pathScreenshotImage(_ imageName: String) -> String {
        let path = "\(FileManager.documentsPath())/Screenshot/"
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path + imageName
    }

    class func cache(forFile filename: String) -> String {
        return FileManager.cachesPath() + filename
    }

}
