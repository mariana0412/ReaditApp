//
//  CommentDetailsView.swift
//  ReaditAppComments
//
//  Created by Mariana Piz on 23.03.2024.
//

import SwiftUI

struct CommentDetailsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let comment: Comment

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    CommentHeaderView(username: comment.username, timePassed: comment.timeAgo)
                    .padding(.bottom, 4)
                    
                    Text(comment.text)
                    
                    CommentRatingView(rating: comment.ratings)
                        .padding(4)
                }
                .padding()
                .background(colorScheme == .light ? Color(UIColor(red: 253, green: 223, blue: 194)) : Color(UIColor(red: 70, green: 61, blue: 54)))
                .foregroundColor(colorScheme == .light ? Color.black : Color.white)
            }
            
            ShareLink(item: comment.url) {
                Text("Share Comment")
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}

#Preview {
    CommentDetailsView(comment: Comment(username: "user", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas non bibendum sem. Vivamus at fringilla tortor, nec molestie tortor. Nam vestibulum non arcu non fermentum. Fusce in lorem vitae nulla sollicitudin molestie ut at nulla. Nunc nec aliquam libero. In dapibus gravida ex, ut accumsan quam dictum et. Sed semper dolor et vehicula porttitor. Etiam faucibus ante nec massa lacinia, et pharetra lectus porta. Aliquam dignissim lorem vitae justo convallis, vitae sodales nisi hendrerit. Donec commodo, leo quis condimentum facilisis, urna lectus luctus mi, non pulvinar eros metus vel diam. Duis odio diam, laoreet eget faucibus quis, laoreet at lectus. Pellentesque quis blandit justo, finibus ultrices metus. Morbi sit amet leo vel dolor suscipit lacinia id auctor eros. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas non bibendum sem. Vivamus at fringilla tortor, nec molestie tortor. Nam vestibulum non arcu non fermentum. Fusce in lorem vitae nulla sollicitudin molestie ut at nulla. Nunc nec aliquam libero. In dapibus gravida ex, ut accumsan quam dictum et. Sed semper dolor et vehicula porttitor. Etiam faucibus ante nec massa lacinia, et pharetra lectus porta. Aliquam dignissim lorem vitae justo convallis, vitae sodales nisi hendrerit. Donec commodo, leo quis condimentum facilisis, urna lectus luctus mi, non pulvinar eros metus vel diam. Duis odio diam, laoreet eget faucibus quis, laoreet at lectus. Pellentesque quis blandit justo, finibus ultrices metus. Morbi sit amet leo vel dolor suscipit lacinia id auctor eros.", ratings: 56, timeAgo: "6y ago", url: URL(string: "https://www.reddit.com/r/ios/comments/1bmywr5/comment/kwfazao/")!))
}
