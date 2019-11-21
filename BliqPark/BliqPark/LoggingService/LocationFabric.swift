//
//  LocationFabric.swift
//  custom_aipark_sdk
//
//  Created by Julian Glaab on 16.11.19.
//  Copyright © 2019 Julian Glaab. All rights reserved.
//

import Foundation
import MapKit

class LocationFabric {
    
    static var locationManager : CLLocationManager?
    
    static func requestAuthorization() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
    }
    
    static func getLocationServiceInstance() -> CLLocationManager {
        
        if self.locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.requestWhenInUseAuthorization()
            
            return self.locationManager!
        } else {
            return self.locationManager!
        }
    }
    
    static func isLocationServiceEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            }
        } else {
            return false
        }
    }
    
    static func enableLocationServices() {
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager?.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            break
            
        case .authorizedWhenInUse:
            locationManager?.requestAlwaysAuthorization()
            break
            
        case .authorizedAlways:
            // Enable any of your app's location features
            break
        }
    }
    
}

