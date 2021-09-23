//
//  MapView.swift
//  FirstProject
//
//  Created by 刘春奇 on 2021/3/23.
//

import SwiftUI
import MapKit


struct MapView: View {
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 31.21105, longitude: 121.621072), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    var body: some View {
        Map(coordinateRegion: $region)
        
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
