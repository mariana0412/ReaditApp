//
//  PostView.swift
//  ReaditApp
//
//  Created by Mariana Piz on 20.02.2024.
//

import UIKit

class PostView: UIView {
    
    let kCONTENT_XIB_NAME = "PostView"
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timePassed: UILabel!
    @IBOutlet weak var domain: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var rating: UIButton!
    @IBOutlet weak var commentsNumber: UIButton!
    @IBOutlet weak var bookmark: UIButton!
    
    var isSaved = false
    private var redditPost: RedditPost?
    weak var sharingDelegate: PostViewDelegate?
    
    @IBAction func sharePost(_ sender: Any) {
        if let post = redditPost {
            sharingDelegate?.postViewDidRequestShare(withURL: post.data.url)
        }
    }
    
    @IBAction func toggleSave(_ sender: Any) {
        guard let post = redditPost else { return }
        
        sharingDelegate?.postViewDidRequestChangeSaveStatus(for: post, isSaved: !post.saved)
        redditPost?.saved = !post.saved
        
        updateBookmarkImage()
    }
    
    private func updateBookmarkImage() {
        let bookmarkImageName = redditPost?.saved ?? false ? "bookmark.fill" : "bookmark"
        let bookmarkImage = UIImage(systemName: bookmarkImageName)
        bookmark.setImage(bookmarkImage, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    func configure(with post: RedditPost) {
        self.redditPost = post
        
        username.text = "u/\(post.data.username)"
        postTitle.text = post.data.title
        timePassed.text = post.data.timePassed
        domain.text = post.data.domain
        rating.setTitle(String(post.data.rating), for: .normal)
        commentsNumber.setTitle(String(post.data.commentsNumber), for: .normal)
        
        postImage.image = UIImage(systemName: "photo.fill")
        if let url = URL(string: post.data.imageURL) {
            postImage.kf.setImage(with: url, placeholder: UIImage(systemName: "photo.fill"))
        }
        
        isSaved = post.saved
        updateBookmarkImage()
    }
    
    func prepareForReuse() {
        username.text = nil
        postTitle.text = nil
        timePassed.text = nil
        domain.text = nil
        postImage.image = UIImage(systemName: "photo.fill")
        rating.setTitle(nil, for: .normal)
        commentsNumber.setTitle(nil, for: .normal)
    }
}

extension UIView {
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
