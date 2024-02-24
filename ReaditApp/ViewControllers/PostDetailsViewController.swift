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
            postView.delegate = self
        }
    }

}

extension PostDetailsViewController: PostViewDelegate {
    func postViewDidRequestShare(_ postView: PostView, withURL url: String) {
        guard let shareURL = URL(string: url) else { return }

        let activityViewController = UIActivityViewController(activityItems: [shareURL], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        present(activityViewController, animated: true, completion: nil)
    }
    
}
