//
//  LandMarkDetail.swift
//  FirstProject
//
//  Created by Charlotte on 2022/1/5.
//

import SwiftUI

struct LandMarkDetail : View{
    @EnvironmentObject var modelData : ModelData
    
    var model : LandMark
    
    var landmarkIndex : Int{
        modelData.landmarks.firstIndex(where: {$0.id == model.id})!
    }

    var body: some View {
        ScrollView {
            VStack {
                MapView(coordinate: model.location)
                    .frame(height: 300)
                    .ignoresSafeArea(edges: .top)
                
                CircleImage(image: model.image)
                    .offset(y:-130)
                    .padding(.bottom,-130)
                
                VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                    HStack {
                        Text(model.name)
                            .font(.title)
                        FavoriteButton(isSet: $modelData.landmarks[landmarkIndex].isFavorite)
                    }
                    HStack {
                        Text(model.park)
                        Spacer()
                        Text(model.state)
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    
                    // 添加一个分割线
                    Divider()
                    
                    Text("About \(model.name)")
                        .font(.title2)
                    Text(model.description)
                        .foregroundColor(.gray)
                    
                })
                .padding()
                
                Spacer()
                
            }
        }
        .navigationTitle(model.name)
        .navigationBarTitleDisplayMode(.inline)

    }
    
}

struct LandMarkDetail_Previews: PreviewProvider {
    static let modelData = ModelData()
    
    
    static var previews: some View {
        LandMarkDetail(model: ModelData().landmarks[0])
            .environmentObject(modelData)
    }
}
