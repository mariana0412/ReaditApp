//
//  PostTableViewCell.swift
//  ReaditApp
//
//  Created by Mariana Piz on 19.02.2024.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var postView: PostView!
    
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        postView.prepareForReuse()
    }
    
    // MARK: - Config
    func configure(post: RedditPost) {
        postView.configure(with: post)
    }

}

