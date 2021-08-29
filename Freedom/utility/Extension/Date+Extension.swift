
//
//  Date+Extension.swift
import Foundation

private var moren :TimeInterval = Foundation.Date().timeIntervalSince1970
public extension Date {
    var timeInterval:TimeInterval {
        get {
            guard let isFinished = objc_getAssociatedObject(self, &moren) as? TimeInterval else {
                return Foundation.Date().timeIntervalSince1970
            }
             return isFinished
        }
        set {
            objc_setAssociatedObject(self, &moren, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }

    /// 获取当前时间戳
    var timeStamp: Int64 {
        return Int64(floor(Date().timeIntervalSince1970 * 1000))
    }

    /// 获取年月日时分秒对象
    var components: DateComponents {
        return Calendar.current.dateComponents([.year, .month, .weekday, .day, .hour, .minute, .second, .nanosecond], from: self)
    }
    mutating func addDay(_ day:Int) {
        timeInterval += Double(day) * 24 * 3600
    }
    mutating func addHour(_ hour:Int) {
        timeInterval += Double(hour) * 3600
    }
    mutating func addMinute(_ minute:Int) {
        timeInterval += Double(minute) * 60
    }
    mutating func addSecond(_ second:Int) {
        timeInterval += Double(second)
    }

    mutating func addMonth(month m:Int) {
        let (year, month, day) = getDay()
        let (hour, minute, second) = getTime()
        if let date = (Calendar.current as NSCalendar).date(era: year / 100, year: year, month: month + m, day: day, hour: hour, minute: minute, second: second, nanosecond: 0) {
            timeInterval = date.timeIntervalSince1970
        } else {
            timeInterval += Double(m) * 30 * 24 * 3600
        }
    }

    mutating func addYear(year y:Int) {
        let (year, month, day) = getDay()
        let (hour, minute, second) = getTime()
        if let date = (Calendar.current as NSCalendar).date(era: year / 100, year: year + y, month: month, day: day, hour: hour, minute: minute, second: second, nanosecond: 0) {
            timeInterval = date.timeIntervalSince1970
        } else {
            timeInterval += Double(y) * 365 * 24 * 3600
        }
    }

    /// 日期加减
    func adding(_ component: Calendar.Component, value: Int) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self)!
    }

    /// let (year, month, day) = date.getDay()
    func getDay() -> (year:Int, month:Int, day:Int) {
        var year:Int = 0, month:Int = 0, day:Int = 0
        let date = Foundation.Date(timeIntervalSince1970: timeInterval)
        (Calendar.current as NSCalendar).getEra(nil, year: &year, month: &month, day: &day, from: date)
        return (year, month, day)
    }

    /// let (hour, minute, second) = date.getTime()
    func getTime() -> (hour:Int, minute:Int, second:Int) {
        var hour:Int = 0, minute:Int = 0, second:Int = 0
        let date = Foundation.Date(timeIntervalSince1970: timeInterval)
        (Calendar.current as NSCalendar).getHour(&hour, minute: &minute, second: &second, nanosecond: nil, from: date)
        return (hour, minute, second)
    }

    /// 本月开始日期
    func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components)!
    }

    /// 本月结束日期
    func endOfMonth(returnEndTime:Bool = false) -> Date {
        let components = NSDateComponents()
        components.month = 1
        if returnEndTime {
            components.second = -1
        } else {
            components.day = -1
        }
        return Calendar.current.date(byAdding: components as DateComponents, to: startOfMonth())!
    }

    /// 这个月有多少天
    func numberOfDaysInMonth() -> Int {
        return (Calendar.current.range(of: .day, in: .month, for: self)?.count)!
    }

    /// NSString转NSDate
    func dateFrom(_ string: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }

    /// NSDate转NSString
    func stringFrom(_ date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }

    /// 日期之间的距离
    func distanceWithDate(_ date: Date) -> DateComponents {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: date)
    }

    /// 星期几
    func weekString() -> String {
        let week = components.weekday ?? 0
        var str_week: String
        switch week % 7 {
        case 1:str_week = "周日"
        case 2:str_week = "周一"
        case 3:str_week = "周二"
        case 4:str_week = "周三"
        case 5:str_week = "周四"
        case 6:str_week = "周五"
        default:str_week = "周六"
        }
        return str_week
    }
    
    func timeToNow() -> String {
        var timeString = ""
        let late = TimeInterval(timeIntervalSince1970 * 1)
        let dat = Date(timeIntervalSinceNow: 0)
        let now = TimeInterval(dat.timeIntervalSince1970 * 1)
        let cha = TimeInterval((now - late) > 0 ? (now - late) : 0)
        if Int(cha / 60) < 1 {
            timeString = "刚刚"
        } else if Int(cha / 3600) < 1 {
            timeString = "\(cha / 60)"
            timeString = (timeString as NSString).substring(to: timeString.count - 7) 
            timeString = "\(timeString) 分前"
        } else if Int(cha / 3600) > 1 && Int(cha / 3600) < 12 {
            timeString = "\(cha / 3600)"
            timeString = (timeString as NSString).substring(to: timeString.count - 7)
            timeString = "\(timeString) 小时前"
        } else if Int(cha / 3600) < 24 {
            timeString = "今天"
        } else if Int(cha / 3600) < 48 {
            timeString = "昨天"
        } else if cha / 3600 / 24 < 10 {
            timeString = String(format: "%.0f 天前", cha / 3600 / 24)
        } else if cha / 3600 / 24 < 365 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM月dd日"
            timeString = dateFormatter.string(from: self)
        } else {
            timeString = "\(Int(cha) / 3600 / 24 / 365)年前"
        }
        return timeString
    }
}

