//
//  CommentListView.swift
//  ReaditAppComments
//
//  Created by Mariana Piz on 23.03.2024.
//

import SwiftUI

struct CommentListView: View {
    
    struct Const {
        static let subredditTopic = "iphone"
        static let postId = "142kbgp"
    }
    
    @State private var comments: [Comment] = []
    @State private var isLoadingMoreComments = false
    @Environment(\.colorScheme) var colorScheme
    @State private var showingDetail = false
    @State private var selectedComment: Comment?
    
    var apiService = CommentService()
    var onCommentSelected: ((Comment) -> Void)?
    
    var body: some View {
        NavigationView {
            List(comments.indices, id: \.self) { index in
                let comment = comments[index]
                
                Button(action: {
                    self.onCommentSelected?(comment)
                }) {
                    CommentView(comment: comment)
                }
                
                .listRowBackground(colorScheme == .light ? Color(UIColor(red: 253, green: 223, blue: 194)) : Color(UIColor(red: 70, green: 61, blue: 54)))
                .foregroundStyle(colorScheme == .light ? Color.black : Color.white)
                .onAppear {
                    if index == comments.count - 2 { // the second last comment
                        loadMoreComments()
                    }
                }
            }
            .navigationTitle("Comments")
            .onAppear {
                loadInitialComments()
            }
        }
    }

    private func loadInitialComments() {
        Task {
            do {
                comments = try await apiService.fetchComments(subreddit: Const.subredditTopic, postId: Const.postId)
            } catch {
                print("Failed to fetch comments: \(error)")
            }
        }
    }
    
    private func loadMoreComments() {
        guard !isLoadingMoreComments else { return }
        isLoadingMoreComments = true
        
        defer {
            isLoadingMoreComments = false
        }

        Task {
            do {
                let moreComments = try await apiService.fetchMoreComments(subreddit: Const.subredditTopic, postId: Const.postId)
                comments.append(contentsOf: moreComments)
            } catch {
                print("Failed to fetch more comments: \(error)")
            }
            
        }
    }
}


#Preview {
    CommentListView()
}
