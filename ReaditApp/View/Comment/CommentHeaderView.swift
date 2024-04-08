//
//  HeaderView.swift
//  ReaditAppComments
//
//  Created by Mariana Piz on 23.03.2024.
//

import SwiftUI

struct CommentHeaderView: View {
    
    let username: String
    let timePassed: String
    
    var body: some View {
        HStack {
            Text("\(username)")
                .fontWeight(.bold)
            Text("•")
            Text("\(timePassed)")
            Spacer()
        }
        .padding(.bottom, 4)
    }
}

#Preview {
    CommentHeaderView(username: "username", timePassed: "4h")
}
