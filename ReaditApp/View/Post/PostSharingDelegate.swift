//
//  PostViewSharingDelegate.swift
//  ReaditApp
//
//  Created by Mariana Piz on 05.03.2024.
//

import Foundation

protocol PostSharingDelegate: AnyObject {
    func didRequestSharePost(withURL url: String)
}

