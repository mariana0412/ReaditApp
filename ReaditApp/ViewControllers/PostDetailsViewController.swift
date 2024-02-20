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
    
    // Call this function to configure the view with a RedditPost
    func configure() {
        if let redditPost = redditPost {
            postView.config(with: redditPost)
        }
    }

}
