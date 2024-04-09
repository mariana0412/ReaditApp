//
//  PostStorageManager.swift
//  ReaditApp
//
//  Created by Mariana Piz on 25.02.2024.
//

import Foundation

class PostStorageManager {
    
    static let shared = PostStorageManager()
    
    struct Const {
        static let fileName = "savedPosts.json"
    }
    
    private let fileUrl: URL = {
        let documentDirectoryUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectoryUrl = documentDirectoryUrls[0]
        return documentDirectoryUrls[0].appendingPathComponent(Const.fileName)
    }()
    
    func save(post: Post) {
        var savedPosts = loadPosts()
        
        if !savedPosts.contains(post) {
            savedPosts.insert(post, at: 0)
            savePosts(savedPosts)
        }
    }
    
    func unsave(post: Post) {
        var savedPosts = loadPosts()
        savedPosts.removeAll { $0 == post }
        
        savePosts(savedPosts)
    }
    
    func savePosts(_ posts: [Post]) {
        do {
            let data = try JSONEncoder().encode(posts)
            try data.write(to: fileUrl, options: .atomic)
        } catch {
            print("Error occured while saving posts: \(error)")
        }
    }
    
    func loadPosts() -> [Post] {
        do {
            let data = try Data(contentsOf: fileUrl)
            return try JSONDecoder().decode([Post].self, from: data)
        } catch {
            print("Error occured while loading posts: \(error)")
            return []
        }
    }

}
