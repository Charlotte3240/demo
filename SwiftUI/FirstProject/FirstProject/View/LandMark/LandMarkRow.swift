//
//  LandMarkRow.swift
//  FirstProject
//
//  Created by 刘春奇 on 2021/4/23.
//

import SwiftUI

struct LandMarkRow : View {
    
    var landmark : LandMark
    
    var body: some View{
        HStack {
            landmark.image
                .resizable()
                .frame(width: 50, height: 50)
            Text(landmark.name)
            Spacer()
            
            FavoriteButton(isSet: .constant(landmark.isFavorite))
        }
    }
}

struct LandMarkRow_Previews : PreviewProvider{
    static var landmarks = ModelData().landmarks
    
    static var previews: some View{
        
        Group{
            LandMarkRow(landmark: landmarks[0])
            LandMarkRow(landmark: landmarks[1])
        }
        .previewLayout(.fixed(width: 375, height: 70))

        
    }
}
