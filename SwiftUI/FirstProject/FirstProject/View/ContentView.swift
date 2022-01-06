//
//  ContentView.swift
//  FirstProject
//
//  Created by 刘春奇 on 2021/3/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LandMarkList()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 12 mini")
                .environmentObject(ModelData())
        }
    }
}
