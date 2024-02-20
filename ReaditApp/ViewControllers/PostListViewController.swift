//
//  PostListViewController.swift
//  ReaditApp
//
//  Created by Mariana Piz on 19.02.2024.
//

import UIKit

class PostListViewController: UIViewController {
    
    // MARK: - Const
    struct Const {
        static let cellReuseIdentifier = "post"
        static let goToPostViewSegueID = "go_to_post_view"
    }
    
    // MARK: - Properties & data
    var posts: [RedditPost] = []
    var selectedPost: RedditPost?

    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 300;
        setPostValues()
    }
    
    // MARK: - Navigation
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        switch segue.identifier {
        case Const.goToPostViewSegueID:
            let postVC = segue.destination as! PostDetailsViewController
            postVC.redditPost = self.selectedPost!
        default:
            break
        }
    }
    
    private func setPostValues() {
        let apiService = APIService()
        Task {
            do {
                let redditResponse = try await apiService.fetchPosts(subreddit: "capybara", limit: 10, after: nil)
                DispatchQueue.main.async { [weak self] in
                    self?.posts = redditResponse.data.children.map { $0 }
                    self?.tableView.reloadData()
                }
            } catch {
                print("Failed with error: \(error)")
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension PostListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    // returns a filled cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Const.cellReuseIdentifier,
            for: indexPath
        ) as! PostTableViewCell
        
        let post = posts[indexPath.row]
        cell.configure(post: post)
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension PostListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPost = self.posts[indexPath.row]
        self.performSegue(
            withIdentifier: Const.goToPostViewSegueID,
            sender: indexPath
        )
    }
}
