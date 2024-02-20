//
//  PostListViewController.swift
//  ReaditApp
//
//  Created by Mariana Piz on 19.02.2024.
//

import UIKit

class PostListViewController: UIViewController {
    
    let cellIdentifier = "post"
    var posts: [RedditPost] = []

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setPostValues()
    }


    // MARK: - Table view data source

    
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


extension PostListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    // повертає заповнену клітинку
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PostTableViewCell
        let post = posts[indexPath.row]
        cell.configure(post: post)
        return cell
    }
    
}
