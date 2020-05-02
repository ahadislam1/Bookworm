//
//  RatingView.swift
//  Bookworm
//
//  Created by Ahad Islam on 5/2/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    
    var label = ""
    var maximumRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(4))
    }
}
