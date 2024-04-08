//
//  APIService.swift
//  ReaditApp
//
//  Created by Mariana Piz on 12.02.2024.
//
import UIKit
import Foundation

class PostService {
    
    // Function to fetch top posts from a given subreddit
    // - subreddit: the name of the subreddit to fetch from
    // - limit: the max number of posts to fetch
    // - after: a pagination token to fetch posts after a specific post
    func fetchPosts(subreddit: String, limit: Int, after: String?) async throws -> RedditResponse {
        var components = URLComponents(string: "https://www.reddit.com/r/\(subreddit)/top.json")
        
        var queryItems: [URLQueryItem] = [URLQueryItem(name: "limit", value: "\(limit)")]
        if let afterId = after {
            queryItems.append(URLQueryItem(name: "after", value: afterId))
        }
        
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            throw APIServiceError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIServiceError.invalidResponse
        }
        
        guard !data.isEmpty else {
            throw APIServiceError.noData
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(RedditResponse.self, from: data)
            return decodedResponse
        } catch {
            throw APIServiceError.decodingError(error)
        }
    }
}
