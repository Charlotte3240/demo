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
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(content.isEmpty ? "Hello, world!" : content)
            
            Button {
                WidgetCenter.shared.reloadTimelines(ofKind: "RainbowFartLarge")
                WidgetCenter.shared.reloadTimelines(ofKind: "RainbowFartSmall")
            } label: {
                Text("refresh")
            }

            
        }
        .padding()
        .onOpenURL { url in
            debugPrint(url.absoluteString)
            content = url.relativeString
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(content: "hello world")
    }
}
