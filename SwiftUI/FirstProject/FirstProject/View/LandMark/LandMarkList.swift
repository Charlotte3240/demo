//
//  LandMarkList.swift
//  FirstProject
//
//  Created by 刘春奇 on 2021/4/23.
//

import SwiftUI

struct LandMarkList: View {
    
    @EnvironmentObject var modelData : ModelData 
    
    @State private var showFavirateOnly = false
    
    var filterLandMarks :[LandMark] {
        modelData.landmarks.filter { landmark in
            !showFavirateOnly || landmark.isFavorite
        }
    }
    
    var body: some View {
        NavigationView {
            // 静态内容可以用List
            List {
                Toggle(isOn: $showFavirateOnly) {
                    Text("show favirate only ?")
                }
                // 如果要有不同的cell ，重复部分就要用foreach
                ForEach(filterLandMarks){ landmark in
                    NavigationLink {
                        LandMarkDetail(model: landmark)
                    } label: {
                        LandMarkRow(landmark: landmark)
                    }
                }
                .navigationTitle("LandMarks")
            }
        }
    }
}

struct LandMarkList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 8"],id:\.self){ deviceName in
            LandMarkList()
                .environmentObject(ModelData())
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
