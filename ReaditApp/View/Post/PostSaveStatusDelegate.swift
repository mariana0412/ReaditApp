//
//  PostViewSaveStatusDelegate.swift
//  ReaditApp
//
//  Created by Mariana Piz on 05.03.2024.
//

import Foundation

protocol PostSaveStatusDelegate: AnyObject {
    func didRequestChangeSaveStatus(for post: Post)
}
