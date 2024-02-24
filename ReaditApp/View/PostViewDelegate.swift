//
//  PostViewDelegate.swift
//  ReaditApp
//
//  Created by Mariana Piz on 24.02.2024.
//

import Foundation

protocol PostViewDelegate: AnyObject {
    func postViewDidRequestShare(_ postView: PostView, withURL url: String)
}
