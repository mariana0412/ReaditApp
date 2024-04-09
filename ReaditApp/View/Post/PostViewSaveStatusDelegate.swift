//
//  PostViewSaveStatusDelegate.swift
//  ReaditApp
//
//  Created by Mariana Piz on 05.03.2024.
//

import Foundation

protocol PostViewSaveStatusDelegate: AnyObject {
    func postViewDidRequestChangeSaveStatus(for post: Post)
}
