//
//  DateUtils.swift
//  ReaditAppComments
//
//  Created by Mariana Piz on 25.03.2024.
//

import Foundation

struct DateUtils {
    
    static func convertTimePassed(from timeInterval: TimeInterval) -> String {
        let postDate = Date(timeIntervalSince1970: timeInterval)  // number of seconds passed from 00:00:00 UTC 1 Jan 1970
        let currentDate = Date()
        let components = Calendar.current.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year], from: postDate, to: currentDate)

        if let year = components.year, year > 0 {
            return "\(year)y"
        } else if let month = components.month, month > 0 {
            return "\(month)mo"
        } else if let week = components.weekOfYear, week > 0 {
            return "\(week)w"
        } else if let day = components.day, day > 0 {
            return "\(day)d"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)h"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute)m"
        } else {
            return "Just now"
        }
    }
}
