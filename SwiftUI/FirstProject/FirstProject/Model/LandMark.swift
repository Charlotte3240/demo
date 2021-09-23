//
//  LandMark.swift
//  FirstProject
//
//  Created by 刘春奇 on 2021/4/21.
//

import Foundation
import SwiftUI
import CoreLocation

struct LandMark : Hashable,Codable,Identifiable {
    var id :Int
    var name : String
    var category : String
    var state : String
    var isFeatured : Bool
    var isFavorite : Bool
    var park : String
    var description : String
    
    private var imageName : String
    var image : Image{
        Image(imageName)
    }

    var location : CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: coordinates.latitude,
                               longitude: coordinates.latitude)
    }
    
    private var coordinates : Coordinates
    struct Coordinates : Hashable,Codable {
        var latitude : Double
        var longitude : Double
    }

    
    
}



