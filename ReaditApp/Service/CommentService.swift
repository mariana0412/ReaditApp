//
//  APIService.swift
//  ReaditAppComments
//
//  Created by Mariana Piz on 23.03.2024.
//

import Foundation

class CommentService {
    
    struct Const {
        static let commentsLimit = 20
    }
    
    var moreCommentsIds: [String] = []
    
    func fetchComments(subreddit: String, postId: String, limit: Int = Const.commentsLimit) async throws -> [Comment] {
        let urlString = "https://www.reddit.com/r/\(subreddit)/comments/\(postId).json?limit=\(limit)"
        let data = try await performNetworkRequest(urlString: urlString)
        
        return try decodeComments(from: data, updatingMoreIds: true)
    }

    func fetchMoreComments(subreddit: String, postId: String, limit: Int = Const.commentsLimit) async throws -> [Comment] {
        let idsString = moreCommentsIds.prefix(limit).joined(separator: ",")
        let urlString = "https://www.reddit.com/api/morechildren.json?link_id=t3_\(postId)&children=\(idsString)&api_type=json&sort=top&depth=1"
        let data = try await performNetworkRequest(urlString: urlString)
        
        return try decodeComments(from: data)
    }
    
    private func performNetworkRequest(urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw APIServiceError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIServiceError.invalidResponse
        }
        
        return data
    }
    
    private func decodeComments(from data: Data, updatingMoreIds: Bool = false) throws -> [Comment] {
        do {
            let decoder = JSONDecoder()
            var comments: [Comment] = []
            
            if updatingMoreIds {
                let listings = try decoder.decode([CommentsResponse].self, from: data)
                guard listings.count > 1 else {
                    throw APIServiceError.noData
                }
                
                for commentData in listings[1].data.children {
                    switch commentData {
                    case .comment(let commentDTO):
                        if let comment = commentDTO.toComment() {
                            comments.append(comment)
                        }
                    case .post:
                        continue
                    case .more(let moreData):
                        moreCommentsIds.append(contentsOf: moreData.children)
                    }
                }
            } else {
                let moreChildrenResponse = try decoder.decode(MoreCommentsResponse.self, from: data)
                
                let commentsDTOs: [CommentDTO] = moreChildrenResponse.json.data.things.compactMap {
                    if case .comment(let commentDTO) = $0 { return commentDTO }
                    return nil
                }
                
                comments = commentsDTOs.compactMap { $0.toComment() }
                
                moreCommentsIds.removeFirst(min(Const.commentsLimit, moreCommentsIds.count))
            }
            return comments
        } catch {
            throw APIServiceError.decodingError(error)
        }
    }
}
