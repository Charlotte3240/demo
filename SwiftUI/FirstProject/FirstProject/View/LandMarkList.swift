//
//  LandMarkList.swift
//  FirstProject
//
//  Created by 刘春奇 on 2021/4/23.
//

import SwiftUI

struct LandMarkList: View {
    var body: some View {
        List(landmarks,id : \.id){ landmark in
            LandMarkRow(landmark: landmark)
        }
    }
}

struct LandMarkList_Previews: PreviewProvider {
    static var previews: some View {
        LandMarkList()
    }
}
