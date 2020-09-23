//
//  Country.swift
//  AutomaticReferenceCount
//
//  Created by Charlotte on 2020/9/22.
//

import Foundation

class Country{
    let name : String
    var captialCity :City!
    init(name : String, captialName : String) {
        self.name = name
        self.captialCity = City(name: captialName, country: self)
    }
}

class City {
    let name : String
    unowned let country : Country
    init(name : String , country : Country) {
        self.name = name
        self.country = country
    }
}
