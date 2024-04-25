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
    let List: [PlatForm]
}

// MARK: - List
public class PlatForm: NSObject, Codable {
    public let id: Int
    public let title: String
    public let url: String
}
