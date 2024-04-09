//
//  CommentView.swift
//  ReaditAppComments
//
//  Created by Mariana Piz on 23.03.2024.
//

import SwiftUI

struct CommentView: View {
    let comment: Comment
    
    var body: some View {
        VStack {
            CommentHeaderView(username: comment.username, timePassed: comment.timeAgo)
            
            Text(comment.text)
                .lineLimit(3)
                .padding(.bottom, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            CommentRatingView(rating: comment.ratings)
        }
        .padding()
    }
}

#Preview {
    CommentView(comment: Comment(username: "user", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas non bibendum sem. Vivamus at fringilla tortor, nec molestie tortor. Nam vestibulum non arcu non fermentum. Fusce in lorem vitae nulla sollicitudin molestie ut at nulla. Nunc nec aliquam libero. In dapibus gravida ex, ut accumsan quam dictum et. Sed semper dolor et vehicula porttitor. Etiam faucibus ante nec massa lacinia, et pharetra lectus porta. Aliquam dignissim lorem vitae justo convallis, vitae sodales nisi hendrerit. Donec commodo, leo quis condimentum facilisis, urna lectus luctus mi, non pulvinar eros metus vel diam. Duis odio diam, laoreet eget faucibus quis, laoreet at lectus. Pellentesque quis blandit justo, finibus ultrices metus. Morbi sit amet leo vel dolor suscipit lacinia id auctor eros.", ratings: 56, timeAgo: "4h ago", url: URL(string: "https://www.reddit.com/r/ios/comments/1bmywr5/comment/kwfazao/")!))
}
