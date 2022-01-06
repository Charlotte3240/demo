//
//  FirstProjectApp.swift
//  FirstProject
//
//  Created by 刘春奇 on 2021/3/23.
//

import SwiftUI

@main
struct FirstProjectApp: App {
    @StateObject private var modelData = ModelData()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
