//
//  RedditPost.swift
//  ReaditApp
//
//  Created by Mariana Piz on 12.02.2024.
//

import Foundation

struct RedditPost: Codable {
    let data: PostData
    var saved: Bool
    
    enum CodingKeys: String, CodingKey {
        case data
        case saved
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(PostData.self, forKey: .data)
        saved = try container.decodeIfPresent(Bool.self, forKey: .saved) ?? false
    }
}

extension RedditPost: Equatable {
    static func ==(lhs: RedditPost, rhs: RedditPost) -> Bool {
        return lhs.data.url == rhs.data.url
    }
}
