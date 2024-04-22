//
//  PlatFormModel.swift
//  PICApp
//
//  Created by 360-jr on 2024/4/22.
//

import Foundation
struct FetchPlatform: Codable{
    let Code: Int
    let Msg: String
    let Data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let List: [List]
}

// MARK: - List
struct List: Codable {
    let id: Int
    let created_at, updated_at: String
    let title, file: String
    let url: String
    let enable: Bool
}
