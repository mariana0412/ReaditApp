//
//  PostView.swift
//  ReaditApp
//
//  Created by Mariana Piz on 20.02.2024.
//

import UIKit

class PostView: UIView {
    
    let kCONTENT_XIB_NAME = "PostView"
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var username: UILabel!
    @IBOutlet private weak var timePassed: UILabel!
    @IBOutlet private weak var domain: UILabel!
    @IBOutlet private weak var postTitle: UILabel!
    @IBOutlet private weak var postImage: UIImageView!
    @IBOutlet private weak var rating: UIButton!
    @IBOutlet private weak var commentsNumber: UIButton!
    @IBOutlet private weak var bookmark: UIButton!
    
    private var redditPost: RedditPost?
    private var bookmarkLayer: CAShapeLayer?
    
    weak var sharingDelegate: PostViewSharingDelegate?
    weak var saveStatusDelegate: PostViewSaveStatusDelegate?
    weak var commentsDelegate: PostViewCommentsDelegate?
    
    @IBAction private func sharePost(_ sender: Any) {
        if let post = redditPost {
            sharingDelegate?.postViewDidRequestShare(withURL: post.data.url)
        }
    }
    
    @IBAction private func toggleSave(_ sender: Any) {
        guard var post = redditPost else { return }
        post.saved.toggle()
        
        saveStatusDelegate?.postViewDidRequestChangeSaveStatus(for: post)
        redditPost?.saved = post.saved
        
        updateBookmarkImage()
    }
    
    @IBAction private func seeComments(_ sender: Any) {
        if let post = redditPost {
            commentsDelegate?.postViewDidRequestComments(for: post)
        }
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
        setupDoubleTapGesture()
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
        
        updateBookmarkImage()
    }
    
    func prepareForReuse() {
        username.text = nil
        postTitle.text = nil
        timePassed.text = nil
        domain.text = nil
        postImage.image = nil
        postImage.layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })
        rating.setTitle(nil, for: .normal)
        commentsNumber.setTitle(nil, for: .normal)
    }
    
    private func setupDoubleTapGesture() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        
        postImage.isUserInteractionEnabled = true
        postImage.addGestureRecognizer(doubleTapGesture)
    }

    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) { 
        guard var post = redditPost else { return }
        
        let shouldSave = !post.saved
        
        if shouldSave {
            post.saved = true
            saveStatusDelegate?.postViewDidRequestChangeSaveStatus(for: post)
        }
        redditPost?.saved = true
        
        updateBookmarkImage()
        animateBookmarkIcon()
    }
    
    func animateBookmarkIcon() {
        let bookmarkLayer = CAShapeLayer()
        
        bookmarkLayer.path = UIBezierPath(bookmarkIn: postImage.bounds).cgPath
        bookmarkLayer.fillColor = UIColor.systemGray.cgColor
        bookmarkLayer.opacity = 0
        
        postImage.layer.addSublayer(bookmarkLayer)
        
        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.fromValue = 0
        fadeIn.toValue = 1
        fadeIn.duration = 0.3
        
        let fadeOut = CABasicAnimation(keyPath: "opacity")
        fadeOut.fromValue = 1
        fadeOut.toValue = 0
        fadeOut.beginTime = CACurrentMediaTime() + 0.8   // delay
        fadeOut.duration = 0.3
        
        //sequential animation
        let group = CAAnimationGroup()
        group.animations = [fadeIn, fadeOut]
        group.duration = fadeOut.beginTime + fadeOut.duration
        
        bookmarkLayer.add(group, forKey: nil)
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

extension UIBezierPath {
    
    convenience init(bookmarkIn rect: CGRect) {
        self.init()
        
        // bookmark width and height
        let width = rect.width * 0.2
        let height = width * 1.5
        
        // bookmark starting position
        let start = CGPoint(x: rect.midX - width / 2, y: rect.midY - height / 2)
        
        self.move(to: start)
        
        self.addLine(to: CGPoint(x: start.x, y: start.y))
        self.addLine(to: CGPoint(x: start.x, y: start.y + height))
        self.addLine(to: CGPoint(x: start.x + width / 2, y: start.y + height / 1.5))
        self.addLine(to: CGPoint(x: start.x + width, y: start.y + height))
        self.addLine(to: CGPoint(x: start.x + width, y: start.y))

        self.close()
    }
}
