//
//  FavoriteButton.swift
//  FirstProject
//
//  Created by Charlotte on 2022/1/5.
//

import SwiftUI

struct FavoriteButton : View{
    @Binding var isSet : Bool
    
    var body: some View{
        Button {
            isSet.toggle()
        } label: {
            Label("Toogle favorite button", systemImage: isSet ? "star.fill" : "star")
                .labelStyle(.iconOnly)
                .foregroundColor(isSet ? .orange : .gray)
        }
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteButton(isSet: .constant(true))
    }
}
