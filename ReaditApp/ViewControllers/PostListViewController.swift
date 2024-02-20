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
        static let subredditTopic = "cats"
    }
    
    // MARK: - Properties & data
    var posts: [RedditPost] = []
    var selectedPost: RedditPost?
    var afterId: String?
    var isFetchingPosts = false
    var showOnlySaved = false

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subredditLabel: UILabel!
    @IBOutlet weak var saved: UIButton!
    
    // prototype, not fully implemented
    @IBAction func showSaved(_ sender: UIButton) {
        let iconName = showOnlySaved ? "bookmark.circle" : "bookmark.circle.fill"
        saved.setImage(UIImage(systemName: iconName), for: .normal)
        showOnlySaved = !showOnlySaved
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manageUI()
        fetchPosts()
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
    
    // MARK: - UI Management
    private func manageUI() {
        self.tableView.rowHeight = 300;
        self.subredditLabel.text = "/r/\(Const.subredditTopic)"
    }
    
    private func fetchPosts(loadMore: Bool = false) {
        guard !isFetchingPosts else { return }
        isFetchingPosts = true

        let apiService = APIService()
        Task {
            do {
                let redditResponse = try await apiService.fetchPosts(subreddit: Const.subredditTopic, limit: 20, after: loadMore ? afterId : nil)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    if loadMore && redditResponse.data.after == self.afterId {
                        // If afterId is the same, there are no more posts to load
                        self.isFetchingPosts = false
                        return
                    }
                    
                    if loadMore {
                        self.posts += redditResponse.data.children
                    } else {
                        self.posts = redditResponse.data.children
                    }
                    
                    self.afterId = redditResponse.data.after
                    self.tableView.reloadData()
                    self.isFetchingPosts = false
                }
            } catch {
                print("Failed with error: \(error)")
                self.isFetchingPosts = false
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height

        // a bit in advance
        if offsetY > contentHeight - height * 3 {
            fetchPosts(loadMore: true)
        }
    }

}
