//
//  DriverAnnotation.swift
//  UberKlone
//
//  Created by Eliu Efraín Díaz Bravo on 18/10/21.
//

import MapKit
import Foundation

class DriverAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var uid: String
    
    init(uid: String, coordinate: CLLocationCoordinate2D) {
        self.uid = uid
        self.coordinate = coordinate
    }
}
