//
//  LocationHandler.swift
//  UberKlone
//
//  Created by Eliu Efraín Díaz Bravo on 05/10/21.
//

import CoreLocation

class LocationHandler: NSObject, CLLocationManagerDelegate {
    static var shared = LocationHandler()
    var locationManager: CLLocationManager!
    var location: CLLocation?
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
}
