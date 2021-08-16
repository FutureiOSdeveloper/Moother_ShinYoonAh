//
//  Date+.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/08/12.
//

import Foundation

class DateConverter {
    func convertingUTCtime(_ dt: String) -> Date {
        let timeInterval = TimeInterval(dt)!
        let utcTime = Date(timeIntervalSince1970: timeInterval)
        return utcTime
    }
}

extension Date {
    func toString( dateFormat format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }

    func toStringKST( dateFormat format: String ) -> String {
        return self.toString(dateFormat: format)
    }

    func toStringUTC(_ timezone: Int ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH시"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
        return dateFormatter.string(from: self)
    }
    
    func toStringSunUTC(_ timezone: Int ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:MM"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
        return dateFormatter.string(from: self)
    }
    
    func toStringCompareUTC(_ timezone: Int ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
        return dateFormatter.string(from: self)
    }
}
