//
//  PostViewController.swift
//  ReaditApp
//
//  Created by Mariana Piz on 13.02.2024.
//

import UIKit
import Kingfisher

class PostViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timePassed: UILabel!
    @IBOutlet weak var domain: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var rating: UIButton!
    @IBOutlet weak var commentsNumber: UIButton!
    @IBOutlet weak var bookmark: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPostValues()
    }
    
    private func setPostValues() {
        let apiService = APIService()
        
        Task {
            do {
                let redditResponse = try await apiService.fetchPosts(subreddit: "ios", limit: 1, after: nil)
                if let post = redditResponse.data.children.first {
                    DispatchQueue.main.async { [weak self] in
                        self?.updateUI(with: post)
                    }
                }
            } catch {
                print("Failed with error: \(error)")
            }
        }
    }
    
    private func updateUI(with post: RedditPost) {
        username.text = post.data.username
        postTitle.text = post.data.title
        timePassed.text = post.data.timePassed
        domain.text = post.data.domain
        rating.setTitle(String(post.data.rating), for: .normal)
        commentsNumber.setTitle(String(post.data.commentsNumber), for: .normal)
        
        self.image.image = UIImage(systemName: "photo.fill")
        if let url = URL(string: post.data.imageURL) {
            image.kf.setImage(with: url, placeholder: UIImage(systemName: "photo.fill"))
        }
        
        let bookmarkImageName = post.saved ? "bookmark.fill" : "bookmark"
        let bookmarkImage = UIImage(systemName: bookmarkImageName)
        bookmark.setImage(bookmarkImage, for: .normal)
    }

}
