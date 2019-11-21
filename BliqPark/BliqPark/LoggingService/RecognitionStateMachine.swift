//
//  RecognitionStateMachine.swift
//  custom_aipark_sdk
//
//  Created by Julian Glaab on 16.11.19.
//  Copyright © 2019 Julian Glaab. All rights reserved.
//

import Foundation
import CoreLocation

extension LoggingController {
    func handleLocationUpdate(_ routeUpdate: RoutePoint) {
        // motion state is essential but now always provided !
        if routeUpdate.motion == nil {
            return
        }
        
        switch currentState {
            
        case .unknown:
            if routeUpdate.motion == .DRIVING {
                currentState = .driving
            } else if routeUpdate.motion == .WALKING {
                currentState = .walking
            }
        case .stationary:
            decreaseGPSAccuracy()
            if routeUpdate.motion == .WALKING {
                currentState = .walking
            } else if routeUpdate.motion == .DRIVING {
                currentState = .driving_validation
            }
        case .walking:
            decreaseGPSAccuracy()
            if routeUpdate.motion == .DRIVING {
                currentState = .driving_validation
            } else if routeUpdate.motion == .STATIONARY {
                currentState = .stationary
            }
        case .driving_validation:
            increaseGPSAccuracy()
            if routeUpdate.motion == .DRIVING || routeUpdate.speed > 10 {
                currentState = .driving
                if let apiconnector = apiConnector {
                    apiconnector.sendLeavingEvent(routeUpdate)
                }
            }
        case .driving:
            handleDrivingUpdate(update: routeUpdate)
            if routeUpdate.motion == .WALKING {
                currentState = .below_driving
                parkingCandidate = routeUpdate.location
            } else if routeUpdate.motion == .STATIONARY {
                currentState = .driving_still
                parkingCandidate = routeUpdate.location
                stopTime = Date()
            }
        case .driving_still:
            if routeUpdate.motion == .DRIVING {
                currentState = .driving
            } else if routeUpdate.motion == .WALKING {
                currentState = .walking
            } else {
                if let stopTime = stopTime {
                    let intervalBetweenStop = Calendar.current.dateComponents([.minute], from: stopTime, to: Date()).minute ?? 0
                    if intervalBetweenStop > MAXIMUM_STATIONARY_TIME {
                        if parkingCandidate != nil {
                            storeParkingPosition(parkingCoordinate: parkingCandidate!)
                        }
                        routeFinished()
                        currentState = .stationary
                    }
                }
            }
        case .below_driving:
            if routeUpdate.motion == .DRIVING {
                currentState = .driving
                parkingCandidate = nil
            } else if routeUpdate.motion == .WALKING {
                currentState = .track_arrival_walking
                
                if parkingCandidate != nil {
                    storeParkingPosition(parkingCoordinate: parkingCandidate!)
                }
            }
        case .track_arrival_walking:
            if routeUpdate.motion == .STATIONARY {
                currentState = .track_arrival_stationary
            } else if routeUpdate.motion != .DRIVING {
                routeFinished()
                currentState = .walking
            } else {
                currentState = .driving
            }
        case .track_arrival_stationary:
            if routeUpdate.motion == .WALKING {
                currentState = .track_arrival_walking
            } else if routeUpdate.motion != .DRIVING {
                currentState = .stationary
                routeFinished()
            } else {
                currentState = .driving
            }
        }
        
    }
    
    private func handleDrivingUpdate(update: RoutePoint) {
        // decrease GPS accuracy when driving faster than 80km/h because user is probably on highway and won't park in time
        // this should decrease the power consumption on long highway trips
        
        if update.speed > 80 {
            if nrPointsHighway < 3 {
                nrPointsHighway += 1
            } else {
                gpsAccuracyHigh = false
                decreaseGPSAccuracy()
            }
        } else {
            if gpsAccuracyHigh == false {
                increaseGPSAccuracy()
                nrPointsHighway = 0
            }
        }
    }
    
    private func routeFinished() {
        print("Route finished !")
        apiConnector?.sendRoute(route: loggedLocations) {_,error in
            if error == nil {
                print("Route send successfully")
                self.loggedLocations = []
            } else {
                print("Error sendRoute: \(String(describing: error))")
            }
        }
    }
    
    private func increaseGPSAccuracy() {
        gpsAccuracyHigh = true
        locationManager?.stopMonitoringSignificantLocationChanges()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.distanceFilter = 2.0
        locationManager?.startUpdatingLocation()
    }
    
    private func decreaseGPSAccuracy() {
        locationManager?.stopUpdatingLocation()
        locationManager?.startMonitoringSignificantLocationChanges()
    }
    
    private func storeParkingPosition(parkingCoordinate: CLLocationCoordinate2D) {
        self.parkingPosition = parkingCoordinate
        let defaultstore = UserDefaults.standard
        defaultstore.set(parkingCoordinate, forKey: KEY_NAME_FOR_PARKING_POSITION)
    }
    
}
