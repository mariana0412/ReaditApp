//
//  CommentRatingView.swift
//  ReaditAppComments
//
//  Created by Mariana Piz on 23.03.2024.
//

import SwiftUI

struct CommentRatingView: View {
    
    let rating: Int
    
    var body: some View {
        HStack {
            Text("Rating: \(rating)")
                .underline()
            Spacer()
        }
    }
}

#Preview {
    CommentRatingView(rating: 203)
}
