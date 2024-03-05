//
//  SharePostDelegate.swift
//  ReaditApp
//
//  Created by Mariana Piz on 05.03.2024.
//

import Foundation

protocol PostViewSharingDelegate: AnyObject {
    func postViewDidRequestShare(withURL url: String)
}
