//
//  LocationServices.swift
//  custom_aipark_sdk
//
//  Created by Julian Glaab on 16.11.19.
//  Copyright © 2019 Julian Glaab. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import CoreMotion

extension LoggingController: CLLocationManagerDelegate {
    
    func escalateLocationServiceAuthorization() {
        // Escalate only when the authorization is set to when-in-use
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager?.requestAlwaysAuthorization()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            print("Changed Authorization - Always authorized")
            startDefaultLocationLogging()
        case .authorizedWhenInUse:
            print("Changed Authorization - WhenInUs authorized")
            startDefaultLocationLogging()
            locationManager?.requestAlwaysAuthorization()
        default: print("Changed Authorization - Not authorized")
        }
    }
    
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }
        
        if locations.count > 0 {
            startDeviceMotion(currentLocation: mostRecentLocation.coordinate, currentSpeed: mostRecentLocation.speed)
        }
        
    }
    
    func deleteNonRoutePoints() {
        if currentState == .stationary || currentState == .walking || currentState == .unknown {
            if loggedLocations.count > NUMBER_DEFAULT_LOGGED_ENTRIES {
                loggedLocations.remove(at: 0)
            }
        }
    }
    
    func startDefaultLocationLogging() {
        locationManager?.startMonitoringSignificantLocationChanges()
    }
}
