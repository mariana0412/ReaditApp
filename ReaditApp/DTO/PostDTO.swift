//
//  PostDTO.swift
//  ReaditApp
//
//  Created by Mariana Piz on 09.04.2024.
//
import Foundation

struct PostDTO: Decodable {
    let id: String?
    let username: String?
    private let originalTimePassed: TimeInterval?
    let domain: String?
    let title: String?
    private let preview: ImagePreview?
    let ups: Int?
    let downs: Int?
    let commentsNumber: Int?
    private let permalink: String?
    
    var rating: Int {
        (ups ?? 0) - (downs ?? 0)
    }
    
    var imageURL: String {
        if let imageSourceUrl = preview?.images.first?.source.url {
            return imageSourceUrl.replacingOccurrences(of: "&amp;", with: "&")
        } else {
            return ""
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case username = "author"
        case originalTimePassed = "created_utc"
        case domain
        case title
        case preview
        case ups
        case downs
        case commentsNumber = "num_comments"
        case permalink
    }
    
    func toPost() -> Post? {
        guard let id = id,
              let domain = domain,
              let title = title,
              let commentsNumber = commentsNumber,
              let originalTimePassed = originalTimePassed,
              let permalink = permalink
        else { return nil }
        
        return Post(
            id: id,
            username: username ?? "unknown",
            domain: domain,
            title: title,
            rating: (ups ?? 0) - (downs ?? 0),
            commentsNumber: commentsNumber,
            imageURL: imageURL,
            timePassed: DateUtils.convertTimePassed(from: originalTimePassed),
            url: "https://www.reddit.com\(permalink)",
            saved: false
        )
    }
    
}

struct RedditResponse: Decodable {
    let data: RedditData
}

struct RedditData: Decodable {
    let children: [RedditChild]
    let after: String?
}

struct RedditChild: Decodable {
    let data: PostDTO
}

// Image handling
struct ImageResolution: Decodable {
    let url: String
    let width: Int
    let height: Int
}

struct ImagePreview: Decodable {
    let images: [ImageDetail]
}

struct ImageDetail: Decodable {
    let source: ImageResolution
    let resolutions: [ImageResolution]
}
