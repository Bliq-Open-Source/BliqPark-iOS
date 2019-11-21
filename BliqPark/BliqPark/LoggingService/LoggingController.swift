//
//  LoggingController.swift
//  custom_aipark_sdk
//
//  Created by Julian Glaab on 16.11.19.
//  Copyright © 2019 Julian Glaab. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion
import CoreLocation

public class LoggingController: NSObject {
    // Parameters
    let SPEED_LIMIT_NON_ACTIVE_ROUTE = 4.0
    let NUMBER_DEFAULT_LOGGED_ENTRIES = 10
    let KEY_NAME_FOR_PARKING_POSITION = "LastParkingPosition"
    let MAXIMUM_STATIONARY_TIME = 19
    
    // object variables
    var lastLocation: CLLocationCoordinate2D?
    var locations: [CLLocationCoordinate2D] = []
    var currentState: TrackRecognitionState = .unknown
    var nrPointsHighway: Int = 0
    var gpsAccuracyHigh: Bool = false
    
    var apiConnector: BliqAPI? = nil
    var parkingPosition: CLLocationCoordinate2D? = nil
    var parkingCandidate: CLLocationCoordinate2D? = nil
    var stopTime: Date?
    
    var locationManager: CLLocationManager? = nil
    var loggedLocations: [RoutePoint] = []
    var activeRouteLogging = false
    
    // dont allow initialitation without apikey
    private override init() {}
    
    public init(aiparkAPIkey: String) {
        super.init()
        startLogging(aiparkAPIkey)
    }
    
    public func startLogging(_ apikey: String) {
        
        let defaultstore = UserDefaults.standard
        
        
        
        if let lastposition = defaultstore.value(forKey: KEY_NAME_FOR_PARKING_POSITION) as? CLLocationCoordinate2D {
            parkingPosition = lastposition
        }
        
        self.apiConnector = BliqAPI(apikey)
        
        locationManager = LocationFabric.getLocationServiceInstance()
        locationManager?.delegate = self
        if LocationFabric.isLocationServiceEnabled() {
            startDefaultLocationLogging()
        }
        
        locationManager!.allowsBackgroundLocationUpdates = true
        locationManager!.pausesLocationUpdatesAutomatically = false
    }
    
    
    private let motion = CMMotionActivityManager()
    
    
    func startDeviceMotion(currentLocation: CLLocationCoordinate2D, currentSpeed: CLLocationSpeed) {
        
        lastLocation = currentLocation
        
        if CMMotionActivityManager.isActivityAvailable() {
            
            motion.startActivityUpdates(to: OperationQueue.main) { (activitystate) in
                
                let newRoutePoint = RoutePoint(currentLocation: currentLocation, currentMotion: self.mapActivityState(currentState: activitystate), currentSpeed: currentSpeed)
                self.loggedLocations.append(newRoutePoint)
                self.handleLocationUpdate(newRoutePoint)
                
                self.deleteNonRoutePoints()
            }
        }
    }
    
    func mapActivityState(currentState: CMMotionActivity?) -> Motion {
        if let currentState = currentState {
            if currentState.automotive {
                return .DRIVING
            } else if currentState.stationary {
                return .STATIONARY
            } else if currentState.walking {
                return .WALKING
            } else {
                return .UNKNOWN
            }
            
        } else {
            return .UNKNOWN
        }
        
    }
}

enum TrackRecognitionState: String {
    case unknown
    case stationary
    case walking
    case driving_validation
    case driving_still
    case driving
    case below_driving
    case track_arrival_stationary
    case track_arrival_walking
}

enum Motion: String {
    case WALKING
    case DRIVING
    case STATIONARY
    case UNKNOWN
}

class RoutePoint
{
    var time: Date
    var location: CLLocationCoordinate2D
    var motion: Motion?
    var speed: Double
    
    init(currentLocation: CLLocationCoordinate2D, currentMotion: Motion?, currentSpeed: CLLocationSpeed) {
        self.time = Date()
        self.location = currentLocation
        self.motion = currentMotion
        // CllocationSpeed is in m/s - so convert in km/h
        self.speed = currentSpeed * 3.6
        // negativ values are possible but not requested
        if self.speed < 0 {
            self.speed = self.speed * -1
        }
    }
}
