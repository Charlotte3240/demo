//
//  main.swift
//  HCJSONDecode
//
//  Created by 刘春奇 on 2021/4/23.
//

import Foundation


let json = JSON([
    "string":JSON("value"),
    "bool" : JSON(true),
    "int":JSON(1),
    "double":JSON(1.5),
    "array": JSON([JSON(1),JSON(2),JSON(3)]),
    "object": JSON([
        "subKey":JSON("subValue")
    ]),
    "null":JSON.null

])

print(json)

