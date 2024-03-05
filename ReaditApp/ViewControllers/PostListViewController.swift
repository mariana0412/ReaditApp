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
        static let rowHeight: CGFloat = 300
    }
    
    // MARK: - Properties & data
    var posts: [RedditPost] = []
    var allSavedPosts: [RedditPost] = []
    var selectedPost: RedditPost?
    var afterId: String?
    var isFetchingPosts = false
    var showOnlySaved = false

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subredditLabel: UILabel!
    @IBOutlet weak var saved: UIButton!
    @IBOutlet weak var searchBar: UITextField!
    
    @IBAction func showSaved(_ sender: UIButton) {
        showOnlySaved.toggle()
        searchBar.isHidden = !searchBar.isHidden
        
        let iconName = showOnlySaved ? "bookmark.circle.fill" : "bookmark.circle"
        saved.setImage(UIImage(systemName: iconName), for: .normal)
        
        if showOnlySaved {
            allSavedPosts = PostStorageManager.shared.loadPosts()
            posts = allSavedPosts
            searchBar.becomeFirstResponder() // bring up the keyboard
        } else {
            searchBar.resignFirstResponder()
            searchBar.text = ""
            fetchPosts()
        }
        
        tableView.reloadData()
    }
    
    @IBAction func searchTextChanged(_ sender: UITextField) {
        if let searchText = sender.text, !searchText.isEmpty {
            posts = allSavedPosts.filter { $0.data.title.localizedCaseInsensitiveContains(searchText) }
        } else {
            posts = allSavedPosts
        }
        tableView.reloadData()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubredditLabel()
        fetchPosts()
        
        // observe post save status changes on other screen
        NotificationCenter.default.addObserver(self, selector: #selector(handlePostSavedStatusChanged(notification:)), name: .postSavedStatusChanged, object: nil)
    }
    
    @objc func handlePostSavedStatusChanged(notification: Notification) {
        guard let url = notification.userInfo?["url"] as? String,
              let isSaved = notification.userInfo?["isSaved"] as? Bool else { return }

        // find the post in array by url and update its status
        if let index = posts.firstIndex(where: { $0.data.url == url }) {
            posts[index].saved = isSaved
            
            // update UI
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        if showOnlySaved {
            allSavedPosts = PostStorageManager.shared.loadPosts()
            posts = allSavedPosts
            tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        switch segue.identifier {
        case Const.goToPostViewSegueID:
            let postVC = segue.destination as! PostDetailsViewController
            if let selectedPost = self.selectedPost {
                postVC.redditPost = selectedPost
            } else {
                print("No post selected")
            }
        default:
            break
        }
    }
    
    // MARK: - UI Management
    private func setSubredditLabel() {
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
                    
                    updatePostsSavedStatus()
                    
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
    
    private func updatePostsSavedStatus() {
        let savedPostsURLs = PostStorageManager.shared.loadPosts().map { $0.data.url }
        self.posts = self.posts.map { post in
            var modifiedPost = post
            modifiedPost.saved = savedPostsURLs.contains(post.data.url)
            return modifiedPost
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
        cell.postView.sharingDelegate = self
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Const.rowHeight
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height

        // if we are in "show only saved" mode, do not fetch more posts
        if showOnlySaved {
            return
        }
        
        // if not, fetch and even a bit in advance
        if offsetY > contentHeight - height * 3 {
            fetchPosts(loadMore: true)
        }
    }

}

extension PostListViewController: PostViewDelegate {
    
    func postViewDidRequestShare(withURL url: String) {
        share(url: url)
    }
    
    func postViewDidRequestChangeSaveStatus(for post: RedditPost) {
        updateSaveStatus(for: post)
        removePostFromViewIfNecessary(post)
        reloadPotst()
    }
    
    private func updateSaveStatus(for post: RedditPost) {
        if let index = posts.firstIndex(where: { $0.data.url == post.data.url }) {
            posts[index].saved = post.saved
            updatePostSaveStatus(for: posts[index])
        }
    }
    
    private func removePostFromViewIfNecessary(_ post: RedditPost) {
        // remove the post from feed in "show only saved" mode
        if showOnlySaved {
            posts.removeAll { $0.data.url == post.data.url && !$0.saved }
        }
        
        allSavedPosts.removeAll { $0.data.url == post.data.url }
    }
    
    private func reloadPotst() {
        tableView.reloadData()
    }
    
}
