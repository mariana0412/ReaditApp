//
//  PostViewController.swift
//  ReaditApp
//
//  Created by Mariana Piz on 13.02.2024.
//

import UIKit
import Kingfisher

class PostDetailsViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var postView: PostView!
    
    // MARK: - Properties & data
    var redditPost: RedditPost?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        if let redditPost = redditPost {
            postView.configure(with: redditPost)
            postView.sharingDelegate = self
        }
    }

}

extension PostDetailsViewController: PostViewSharingDelegate {
    
    func postViewDidRequestShare(withURL url: String) {
        share(url: url)
    }
    
}

extension PostDetailsViewController: PostViewSaveStatusDelegate {
    
    func postViewDidRequestChangeSaveStatus(for post: RedditPost, isSaved: Bool) {
        updatePostSaveStatus(for: post, isSaved: isSaved)
        NotificationCenter.default.post(name: .postSavedStatusChanged, object: nil, userInfo: ["url": post.data.url, "isSaved": isSaved])
    }
    
}
