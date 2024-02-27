//
//  PostStorageManager.swift
//  ReaditApp
//
//  Created by Mariana Piz on 25.02.2024.
//

import Foundation

class PostStorageManager {
    
    static let shared = PostStorageManager()  // Singleton
    struct Const {
        static let fileName = "savedPosts.json"
    }
    
    init() {
        print("Document Directory URL: \(fileUrl.path)")
    }
    
    private let fileUrl: URL = {
        let documentDirectoryUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectoryUrl = documentDirectoryUrls[0]
        return documentDirectoryUrls[0].appendingPathComponent(Const.fileName)
    }()
    
    func save(post: RedditPost) {
        var savedPosts = loadPosts()
        
        if !savedPosts.contains(post) {
            savedPosts.append(post)
            savePosts(savedPosts)
        }
    }
    
    func unsave(post: RedditPost) {
        var savedPosts = loadPosts()
        savedPosts.removeAll { $0 == post }
        
        savePosts(savedPosts)
    }
    
    func savePosts(_ posts: [RedditPost]) {
        do {
            let data = try JSONEncoder().encode(posts)
            try data.write(to: fileUrl, options: .atomic)
        } catch {
            print("Error occured while saving posts: \(error)")
        }
    }
    
    func loadPosts() -> [RedditPost] {
        do {
            let data = try Data(contentsOf: fileUrl)
            return try JSONDecoder().decode([RedditPost].self, from: data)
        } catch {
            print("Error occured while loading posts: \(error)")
            return []
        }
    }

}
