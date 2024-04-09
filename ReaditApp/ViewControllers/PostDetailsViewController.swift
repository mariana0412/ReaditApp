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

    @IBOutlet private weak var containerView: UIView!
    
    // MARK: - IBOutlet
    @IBOutlet private weak var postView: PostView!
    
    // MARK: - Properties & data
    var redditPost: RedditPost?
    var coordinator: CommentCoordinator?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        coordinator = CommentCoordinator(navigationController: self.navigationController)
        let commentListView = CommentListView(onCommentSelected: { [weak self] comment in
            self?.coordinator?.navigateToCommentDetails(comment)
        })
        
        let commentsListViewController: UIViewController = UIHostingController(rootView: commentListView)
        let сommentsListView: UIView = commentsListViewController.view
        self.containerView.addSubview(сommentsListView)

        сommentsListView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            сommentsListView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            сommentsListView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            сommentsListView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            сommentsListView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor)
        ])

        commentsListViewController.didMove(toParent: self)
    }
    
    func configure() {
        if let redditPost = redditPost {
            postView.configure(with: redditPost)
            postView.sharingDelegate = self
            postView.saveStatusDelegate = self
        }
    }
    
    class CommentCoordinator {
        private weak var navigationController: UINavigationController?
        
        init(navigationController: UINavigationController?) {
            self.navigationController = navigationController
        }
        
        func navigateToCommentDetails(_ comment: Comment) {
            let commentDetailsView = CommentDetailsView(comment: comment)
            let detailsViewController = UIHostingController(rootView: commentDetailsView)
            navigationController?.pushViewController(detailsViewController, animated: true)
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
