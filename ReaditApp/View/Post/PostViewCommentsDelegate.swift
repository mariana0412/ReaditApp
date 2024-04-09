//
//  PostViewCommentsDelegate.swift
//  ReaditApp
//
//  Created by Mariana Piz on 05.03.2024.
//

import Foundation

protocol PostViewCommentsDelegate: AnyObject {
    func postViewDidRequestComments(for post: Post)
}
