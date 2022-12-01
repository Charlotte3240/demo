//
//  ContentView.swift
//  DesktopExtension
//
//  Created by 360-jr on 2022/8/23.
//

import SwiftUI
import WidgetKit
struct ContentView: View {
    @State var content : String = "Hello world!"
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: {
                    QRView()
                        .navigationBarHidden(true)
//                        .navigationTitle("second title")
                }) {
                    Text("二维码")
                }
                Spacer()
                            
                Button {
                    WidgetCenter.shared.reloadTimelines(ofKind: "RainbowFartSmall")
                    WidgetCenter.shared.reloadTimelines(ofKind: "RainbowFartLarge")
                } label: {
                    Text("refresh rainbow fart")
                }
                            
            }
            .navigationTitle("导航栏")
//            .navigationBarHidden(true)  // 隐藏导航栏
            .navigationBarTitleDisplayMode(.inline)

            .frame(height: 400)
            .padding()
            // wiget open urls
            .onOpenURL { url in
                debugPrint(url.absoluteString)
                if url.scheme == "alipays" || url.scheme == "weixin"{
                    UIApplication.shared.open(url)
                }else{
                    content = url.relativeString
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(content: "hello world")
    }
}
