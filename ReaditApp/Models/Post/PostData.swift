//
//  PostData.swift
//  ReaditApp
//
//  Created by Mariana Piz on 12.02.2024.
//
import Foundation

struct PostData: Codable {
    let username: String
    private let originalTimePassed: TimeInterval
    let domain: String
    let title: String
    private let preview: ImagePreview?
    let ups: Int
    let downs: Int
    let commentsNumber: Int
    private let permalink: String
    
    var rating: Int {
        return ups + downs
    }
    
    var imageURL: String {
        if let imageSourceUrl = preview?.images.first?.source.url {
            return imageSourceUrl.replacingOccurrences(of: "&amp;", with: "&")
        } else {
            return ""
        }
    }
    
    var timePassed: String {
        return convertTimePassed(from: originalTimePassed)
    }
    
    var url: String {
        return "https://www.reddit.com\(permalink)"
    }
    
    enum CodingKeys: String, CodingKey {
        case username = "author_fullname"
        case originalTimePassed = "created_utc"
        case domain
        case title
        case preview
        case ups
        case downs
        case commentsNumber = "num_comments"
        case permalink
    }
    
    private func convertTimePassed(from timeInterval: TimeInterval) -> String {
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
