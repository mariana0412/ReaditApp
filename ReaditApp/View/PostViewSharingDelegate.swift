//
//  PostViewSharingDelegate.swift
//  ReaditApp
//
//  Created by Mariana Piz on 24.02.2024.
//

import Foundation

protocol PostViewSharingDelegate: AnyObject {
    func postViewDidRequestShare(withURL url: String)
}
