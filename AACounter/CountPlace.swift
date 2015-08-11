//
//  CountPlace.swift
//  AACounter
//
//  Created by Mike Lee on 8/11/15.
//  Copyright (c) 2015 Mike Lee. All rights reserved.
//

import MapKit

class CountPlace: NSObject, MKAnnotation {
    let title: String
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String {
        return locationName
    }
}