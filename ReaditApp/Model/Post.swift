//
//  RedditPost.swift
//  ReaditApp
//
//  Created by Mariana Piz on 12.02.2024.
//

import Foundation

struct Post: Codable {
    let id: String
    let username: String
    let domain: String
    let title: String
    let rating: Int
    let commentsNumber: Int
    let imageURL: String
    let timePassed: String
    let url: String
    var saved: Bool
}

extension Post: Equatable {
    static func ==(lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
}
