//
//  PostViewController.swift
//  ReaditApp
//
//  Created by Mariana Piz on 13.02.2024.
//

import UIKit
import Kingfisher
import SwiftUI

class PostDetailsViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    // MARK: - IBOutlet
    @IBOutlet weak var postView: PostView!
    
    // MARK: - Properties & data
    var redditPost: RedditPost?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        // Embed SwiftUI view in UIHostingController
        let commentsListViewController: UIViewController = UIHostingController(rootView: CommentListView())

        // Get reference to the HostingController view (UIView)
        let сommentsListView: UIView = commentsListViewController.view

        // Put `сommentsListView` in `containerView`
        self.containerView.addSubview(сommentsListView)

        // Layout with constraints
        сommentsListView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            сommentsListView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            сommentsListView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            сommentsListView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            сommentsListView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor)
        ])

        // Notify child View Controller of being presented
        commentsListViewController.didMove(toParent: self)
    }
    
    func configure() {
        if let redditPost = redditPost {
            postView.configure(with: redditPost)
            postView.sharingDelegate = self
            postView.saveStatusDelegate = self
        }
    }

}

extension PostDetailsViewController: PostViewSharingDelegate {
    
    func postViewDidRequestShare(withURL url: String) {
        share(url: url)
    }
    
}

extension PostDetailsViewController: PostViewSaveStatusDelegate {
    
    func postViewDidRequestChangeSaveStatus(for post: RedditPost) {
        updatePostSaveStatus(for: post)
        NotificationCenter.default.post(name: .postSavedStatusChanged, object: nil, userInfo: ["url": post.data.url, "isSaved": post.saved])
    }
    
}
