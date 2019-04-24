//
//  AppUtils.swift
//  EZSportsRP
//
//  Created by admin_user on 3/1/18.
//  Copyright © 2018 admin_user. All rights reserved.
//

import Foundation

class DateUtils {
    static func isSameDate(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.component(.year, from: date1) == calendar.component(.year, from: date2) && calendar.component(.month, from: date1) == calendar.component(.month, from: date2) && calendar.component(.day, from: date1) == calendar.component(.day, from: date2)
    }
    
    static func convertDateToStr(date: Date, format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    static func convertStrToDate(string: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from:string)
    }
    
    static func getCurrentScheduleTime() -> Date? {
        let date = Date()
        let calendar = Calendar.current
        var components = calendar.dateComponents([.hour, .minute], from: date)
        components.minute = 0
        return calendar.date(from: components)
    }
    
    static func getTimeStamp() -> String {
        let time = Int64(TimeInterval(NSDate().timeIntervalSince1970))
        return String(time)
    }
}
