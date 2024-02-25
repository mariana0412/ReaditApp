//
//  UIViewControllerExtension.swift
//  ReaditApp
//
//  Created by Mariana Piz on 24.02.2024.
//

import Foundation
import UIKit

extension UIViewController {
    func share(url: String) {
        guard let shareURL = URL(string: url) else { return }

        let activityViewController = UIActivityViewController(activityItems: [shareURL], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    func save(post newPost: RedditPost) {
        PostStorageManager.shared.save(post: newPost)
    }
    
    func unsave(post: RedditPost) {
        PostStorageManager.shared.unsave(post: post)
    }
}
