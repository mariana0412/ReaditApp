//
//  APIService.swift
//  ReaditApp
//
//  Created by Mariana Piz on 12.02.2024.
//

import Foundation

class APIService {
    func fetchPosts(subreddit: String, limit: Int, after: String?, completion: @escaping (Result<RedditResponse, Error>) -> Void) {
        var components = URLComponents(string: "https://www.reddit.com/r/\(subreddit)/top.json")
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        
        if let afterId = after {
            queryItems.append(URLQueryItem(name: "after", value: afterId))
        }
        
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -2, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(RedditResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
