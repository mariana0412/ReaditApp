//
//  PostTableViewCell.swift
//  ReaditApp
//
//  Created by Mariana Piz on 19.02.2024.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timePassed: UILabel!
    @IBOutlet weak var domain: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var redditPostImage: UIImageView!
    @IBOutlet weak var rating: UIButton!
    @IBOutlet weak var commentsNumber: UIButton!
    @IBOutlet weak var bookmark: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(post: RedditPost) {
        username.text = post.data.username
        postTitle.text = post.data.title
        timePassed.text = post.data.timePassed
        domain.text = post.data.domain
        rating.setTitle(String(post.data.rating), for: .normal)
        commentsNumber.setTitle(String(post.data.commentsNumber), for: .normal)
        
        redditPostImage.image = UIImage(systemName: "photo.fill")
        if let url = URL(string: post.data.imageURL) {
            redditPostImage.kf.setImage(with: url, placeholder: UIImage(systemName: "photo.fill"))
        }
        
        let bookmarkImageName = post.saved ? "bookmark.fill" : "bookmark"
        let bookmarkImage = UIImage(systemName: bookmarkImageName)
        bookmark.setImage(bookmarkImage, for: .normal)
    }

}

