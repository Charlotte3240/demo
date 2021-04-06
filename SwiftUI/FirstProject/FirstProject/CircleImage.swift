//
//  CircleImage.swift
//  FirstProject
//
//  Created by 刘春奇 on 2021/3/23.
//

import SwiftUI

/// 可以 用作头像
struct CircleImage: View {
    var body: some View {
        Image("landmark")
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white,lineWidth: 4))
            .shadow(radius: 7)
        
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
