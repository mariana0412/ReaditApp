//
//  PostTableViewCell.swift
//  ReaditApp
//
//  Created by Mariana Piz on 19.02.2024.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timePassed: UILabel!
    @IBOutlet weak var domain: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var rating: UIButton!
    @IBOutlet weak var commentsNumber: UIButton!
    @IBOutlet weak var bookmark: UIButton!
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()

        username.text = nil
        postTitle.text = nil
        timePassed.text = nil
        domain.text = nil
        postImage.image = UIImage(systemName: "photo.fill")
        rating.setTitle(nil, for: .normal)
        commentsNumber.setTitle(nil, for: .normal)
        bookmark.setImage(UIImage(systemName: "bookmark"), for: .normal)
    }
    
    // MARK: - Config
    func configure(post: RedditPost) {
        username.text = post.data.username
        postTitle.text = post.data.title
        timePassed.text = post.data.timePassed
        domain.text = post.data.domain
        rating.setTitle(String(post.data.rating), for: .normal)
        commentsNumber.setTitle(String(post.data.commentsNumber), for: .normal)
        
        postImage.image = UIImage(systemName: "photo.fill")
        if let url = URL(string: post.data.imageURL) {
            postImage.kf.setImage(with: url, placeholder: UIImage(systemName: "photo.fill"))
        }
        
        let bookmarkImageName = post.saved ? "bookmark.fill" : "bookmark"
        let bookmarkImage = UIImage(systemName: bookmarkImageName)
        bookmark.setImage(bookmarkImage, for: .normal)
    }

}

