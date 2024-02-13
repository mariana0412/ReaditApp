//
//  PostViewController.swift
//  ReaditApp
//
//  Created by Mariana Piz on 13.02.2024.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var timePassed: UILabel!
    
    @IBOutlet weak var domain: UILabel!
    
    @IBOutlet weak var postTitle: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var rating: UIButton!
    
    @IBOutlet weak var commentsNumber: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValues()
    }
    
    private func setValues() {
        let apiService = APIService()
        
        apiService.fetchPosts(subreddit: "ios", limit: 1, after: nil) { result in
            switch result {
            case .success(let redditResponse):
                print("Success! Received data:")
                for post in redditResponse.data.children {
                    print("Author: \(post.data.username)")
                    self.username.text = post.data.username
                    
                    print("Title: \(post.data.title)")
                    self.postTitle.text = post.data.title
                    
                    print("timePassed: \(post.data.timePassed)")
                    // TODO: convert time
                    
                    print("domain: \(post.data.domain)")
                    self.domain.text = post.data.domain
                    
                    print("imageURL: \(post.data.imageURL)")
                    // TODO: figure out what to do with images
                    
                    print("ups: \(post.data.ups)")
                    print("downs: \(post.data.downs)")
                    self.rating.setTitle(String(post.data.ups + post.data.downs), for: .normal)
                    
                    print("commentsNumber: \(post.data.commentsNumber)")
                    self.commentsNumber.setTitle(String(post.data.commentsNumber), for: .normal)
                }
            case .failure(let error):
                print("Failed with error: \(error)")
            }
        }
    }

}
