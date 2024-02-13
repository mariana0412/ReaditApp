//
//  PostViewController.swift
//  ReaditApp
//
//  Created by Mariana Piz on 13.02.2024.
//

import UIKit
import Kingfisher

class PostViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timePassed: UILabel!
    @IBOutlet weak var domain: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var rating: UIButton!
    @IBOutlet weak var commentsNumber: UIButton!
    @IBOutlet weak var bookmark: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPostValues()
    }
    
    private func setPostValues() {
        let apiService = APIService()
        
        apiService.fetchPosts(subreddit: "ios", limit: 1, after: nil) { [weak self] result in
            switch result {
            case .success(let redditResponse):
                for post in redditResponse.data.children {
                    // DispatchQueue.main.async {
                    self?.username.text = post.data.username
                    self?.postTitle.text = post.data.title
                    self?.timePassed.text = post.data.timePassed
                    self?.domain.text = post.data.domain
                    
                    self?.rating.setTitle(String(post.data.rating), for: .normal)
                    self?.commentsNumber.setTitle(String(post.data.commentsNumber), for: .normal)
                    
                    if let url = URL(string: post.data.imageURL) {
                        let placeholder = UIImage(systemName: "photo.fill")
                        self?.image.kf.setImage(with: url, placeholder: placeholder)
                    }
                    
                    let bookmarkImageName = post.saved ? "bookmark.fill" : "bookmark"
                    let bookmarkImage = UIImage(systemName: bookmarkImageName)
                    self?.bookmark.setImage(bookmarkImage, for: .normal)
                }
            case .failure(let error):
                print("Failed with error: \(error)")
            }
        }
    }

}
