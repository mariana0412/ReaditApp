//
//  PostDetailsDelegate.swift
//  ReaditApp
//
//  Created by Mariana Piz on 21.04.2024.
//

import Foundation

protocol PostDetailsUpdateDelegate: AnyObject {
    func didUpdateSaveStatus(post: Post)
}
