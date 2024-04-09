//
//  CommentListView.swift
//  ReaditAppComments
//
//  Created by Mariana Piz on 23.03.2024.
//

import SwiftUI

struct CommentListView: View {
    
    @State private var comments: [Comment] = []
    @State private var isLoadingMoreComments = false
    @Environment(\.colorScheme) var colorScheme
    @State private var showingDetail = false
    @State private var selectedComment: Comment?
    
    let commentService = CommentService()
    
    let subredditTopic: String
    let postId: String
    let onCommentSelected: ((Comment) -> Void)?
    
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
                comments = try await commentService.fetchComments(subreddit: subredditTopic, postId: postId)
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
                let moreComments = try await commentService.fetchMoreComments(subreddit: subredditTopic, postId: postId)
                comments.append(contentsOf: moreComments)
            } catch {
                print("Failed to fetch more comments: \(error)")
            }
            
        }
    }
}


#Preview {
    CommentListView(subredditTopic: "ios", postId: "1bz66km", onCommentSelected: nil)
}
