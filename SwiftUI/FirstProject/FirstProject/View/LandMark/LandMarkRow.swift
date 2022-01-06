//
//  LandMarkRow.swift
//  FirstProject
//
//  Created by 刘春奇 on 2021/4/23.
//

import SwiftUI

struct LandMarkRow : View {
    @EnvironmentObject var modelData : ModelData
    
    var landmarkIndex : Int{
        modelData.landmarks.firstIndex(where: {$0.id == landmark.id})!
    }
    
    var landmark : LandMark
    
    var body: some View{
        HStack {
            landmark.image
                .resizable()
                .frame(width: 50, height: 50)
            Text(landmark.name)
            Spacer()
            
            FavoriteButton(isSet: $modelData.landmarks[landmarkIndex].isFavorite)
                .buttonStyle(.plain) // 加上了button style 之后 就可以比navigationLink 优先级高
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
