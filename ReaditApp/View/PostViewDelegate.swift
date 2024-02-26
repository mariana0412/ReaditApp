//
//  PostViewSharingDelegate.swift
//  ReaditApp
//
//  Created by Mariana Piz on 24.02.2024.
//

import Foundation

protocol PostViewDelegate: AnyObject {
    func postViewDidRequestShare(withURL url: String)
    func postViewDidRequestChangeSaveStatus(for post: RedditPost, isSaved: Bool)
}