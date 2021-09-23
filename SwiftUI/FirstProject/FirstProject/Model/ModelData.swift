//
//  ModelData.swift
//  FirstProject
//
//  Created by 刘春奇 on 2021/4/21.
//

import Foundation

var landmarks : [LandMark] = load("landmarkData.json")


func load<T : Decodable>(_ fileName : String) -> T {
    let data : Data
    
    guard let file  = Bundle.main.url(forResource: fileName, withExtension: nil) else {
        fatalError("can't find bundle file")
    }
    
    // 转data
    do {
        try data = Data(contentsOf: file)
    } catch {
        fatalError("can't find bundle fila to data")
    }
    
    //decode
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("couldn't parse \(fileName) as \(T.self) : \n \(error)")
    }
    
    
    
    
}
