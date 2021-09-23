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
        }
    }
}

struct LandMarkRow_Previews : PreviewProvider{
    static var previews: some View{
        
        Group{
            LandMarkRow(landmark: landmarks[2])
            LandMarkRow(landmark: landmarks[3])
        }
        .previewLayout(.fixed(width: 300, height: 70))

        
    }
}
