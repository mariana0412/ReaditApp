//
//  CommentDTO.swift
//  ReaditAppComments
//
//  Created by Mariana Piz on 24.03.2024.
//

import Foundation

struct CommentDTO: Decodable {
    let username: String?
    let text: String?
    let ups: Int?
    let downs: Int?
    let createdAt: TimeInterval?
    let permalink: String?

    enum CodingKeys: String, CodingKey {
        case username = "author"
        case text = "body"
        case ups
        case downs
        case createdAt = "created_utc"
        case permalink
    }

    func toComment() -> Comment? {
        guard let username = username,
              let text = text,
              let createdAt = createdAt,
              let permalink = permalink,
              let url = URL(string: "https://www.reddit.com\(permalink)")
        else { return nil }

        let ratings = (ups ?? 0) - (downs ?? 0)
        
        return Comment(
            username: "/u/\(username)",
            text: text,
            ratings: ratings,
            timeAgo: DateUtils.convertTimePassed(from: createdAt),
            url: url
        )
    }
}

enum CommentData: Decodable {
    case comment(CommentDTO)
    case more(MoreData)
    case post

    private enum CodingKeys: String, CodingKey {
        case kind
        case data
        case post
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try container.decode(String.self, forKey: .kind)
        switch kind {
        case "t1":      // Regular comment
            let commentDTO = try container.decode(CommentDTO.self, forKey: .data)
            self = .comment(commentDTO)
        case "more":    // 'More' type data
            let moreData = try container.decode(MoreData.self, forKey: .data)
            self = .more(moreData)
        case "t3":      // Post itself (ignore)
            self = .post
        default:
            throw DecodingError.dataCorruptedError(forKey: .kind, in: container, debugDescription: "Unknown comment type")
        }
    }
}

struct MoreData: Decodable {
    let count: Int
    let children: [String]
}

// parsing comments
struct CommentsResponse: Decodable {
    let data: CommentsResponseData
}

struct CommentsResponseData: Decodable {
    let children: [CommentData]
}

// parsing more comments
struct MoreCommentsResponse: Decodable {
    let json: MoreCommentsData
}

struct MoreCommentsData: Decodable {
    let data: MoreCommentsThings
}

struct MoreCommentsThings: Decodable {
    let things: [CommentData]
}
