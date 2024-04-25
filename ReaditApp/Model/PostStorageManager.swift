//
//  PostStorageManager.swift
//  ReaditApp
//
//  Created by Mariana Piz on 25.02.2024.
//

import Foundation

class PostStorageManager {
    
    struct Const {
        static let fileName = "savedPosts.json"
    }
    
    static let shared = PostStorageManager()
    private var savedPosts: [Post] = []
    private var fileNeedsChanging = false
    
    init() {
        print("Document directory url: \(fileUrl.path)")
        savedPosts = loadPostsFromFile()
    }
    
    func getSavedPosts() -> [Post] {
        return savedPosts
    }
    
    func save(post: Post) {
        if !savedPosts.contains(post) {
            savedPosts.insert(post, at: 0)
            fileNeedsChanging = true
        }
    }
    
    func unsave(post: Post) {
        if savedPosts.contains(post) {
            savedPosts.removeAll { $0 == post }
            fileNeedsChanging = true
        }
    }
    
    func saveChanges() {
        if fileNeedsChanging {
            do {
                let data = try JSONEncoder().encode(savedPosts)
                try data.write(to: fileUrl, options: .atomic)
                fileNeedsChanging = false
            } catch {
                print("Error occured while saving posts: \(error)")
            }
        }
    }
    
    private func loadPostsFromFile() -> [Post] {
        do {
            let data = try Data(contentsOf: fileUrl)
            return try JSONDecoder().decode([Post].self, from: data)
        } catch {
            print("Error occured while loading posts: \(error)")
            return []
        }
    }
    
    private let fileUrl: URL = {
        let documentDirectoryUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectoryUrl = documentDirectoryUrls[0]
        return documentDirectoryUrls[0].appendingPathComponent(Const.fileName)
    }()

}
