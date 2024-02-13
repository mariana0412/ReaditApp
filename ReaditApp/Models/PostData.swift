//
//  PostData.swift
//  ReaditApp
//
//  Created by Mariana Piz on 12.02.2024.
//

import Foundation

struct PostData: Codable {
    let username: String
    let timePassed: TimeInterval
    let domain: String
    let title: String
    let imageURL: String
    let ups: Int
    let downs: Int
    let commentsNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case username = "author_fullname"
        case timePassed = "created_utc"   // 1707724309.0
        case domain
        case title
        case imageURL = "url_overridden_by_dest"
        case ups
        case downs
        case commentsNumber = "num_comments"
    }
}
