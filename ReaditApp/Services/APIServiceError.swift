//
//  APIServiceError.swift
//  ReaditAppComments
//
//  Created by Mariana Piz on 25.03.2024.
//

import Foundation

enum APIServiceError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError(Error)
}
