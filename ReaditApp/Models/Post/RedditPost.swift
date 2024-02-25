//
//  RedditPost.swift
//  ReaditApp
//
//  Created by Mariana Piz on 12.02.2024.
//

import Foundation

struct RedditPost: Codable {
    let data: PostData
    var saved: Bool = false
    
    private enum DecodingKeys: String, CodingKey {
        case data
    }

    private enum EncodingKeys: String, CodingKey {
        case data
        case saved
    }

    // Custom initializer for decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        data = try container.decode(PostData.self, forKey: .data)
        // `saved` is not decoded because it doesn't exist in the JSON; it's a local property
    }

    // Custom method for encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode(data, forKey: .data)
        try container.encode(saved, forKey: .saved)
        // Here, `saved` is encoded along with `data`, possibly for local storage or sending to a different API
    }
}

extension RedditPost: Equatable {
    static func ==(lhs: RedditPost, rhs: RedditPost) -> Bool {
        return lhs.data.url == rhs.data.url
    }
}
