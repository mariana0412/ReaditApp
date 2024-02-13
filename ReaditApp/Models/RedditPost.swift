//
//  RedditPost.swift
//  ReaditApp
//
//  Created by Mariana Piz on 12.02.2024.
//

import Foundation

struct RedditPost: Codable {
    let data: PostData
    var saved: Bool = Bool.random()
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}
