//
//  ImageDetail.swift
//  ReaditApp
//
//  Created by Mariana Piz on 13.02.2024.
//

import Foundation

struct ImageDetail: Codable {
    let source: ImageResolution
    let resolutions: [ImageResolution]
}
