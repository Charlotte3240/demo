//
//  ContentView.swift
//  FirstProject
//
//  Created by 刘春奇 on 2021/3/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            MapView()
                .frame(height: 300)
                .ignoresSafeArea(edges: .top)
            
            CircleImage()
                .offset(y:-130)
                .padding(.bottom,-130)
            
            VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                Text("Charlotte")
                    .font(.title)
                HStack {
                    Text("a wondeful coder")
                        
                    Spacer()
                    Text("in shanghai")
                }
                .font(.subheadline)
                .foregroundColor(.gray)
                
                // 添加一个分割线
                Divider()
                
                Text("About this person")
                    .font(.title2)
                Text("this a description infomation")
                    .foregroundColor(.gray)
                
            })
            .padding()
            
            Spacer()
            
        }
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 12 mini")
        }
    }
}
