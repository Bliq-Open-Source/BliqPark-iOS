//
//  ParkingAssistance.swift
//  custom_aipark_sdk
//
//  Created by Julian Glaab on 16.11.19.
//  Copyright © 2019 Julian Glaab. All rights reserved.
//

import Foundation
import CoreLocation

public class ParkingAssistance {
    
    var parkingAreas : [ParkingArea]?
    var optimalRoute : OptimalRoute?
    
    public init(optimalRoute: OptimalRoute?, parkingAreas: [ParkingArea]? = nil) {
        self.optimalRoute = optimalRoute
        self.parkingAreas = parkingAreas
    }
}

public class OptimalRoute {
    
    // shape
    public var shapeType : ShapeType?
    public var outlinePolygon : [[CLLocationCoordinate2D]] = []
    public var outlinePoint : CLLocationCoordinate2D?
    
    // Properties
    var stopoverPoints : [CLLocationCoordinate2D]?
    var destination: CLLocationCoordinate2D?
    var parkingProbability: Double?
    var visitedParkingSpots: Int?
    var parkingSituation: String?
    var parkingAdvice: String?
    var estimatedSearchTime: EstimatedSearchTime?
    
    init?(raw: Feature) {
        // -------------- EXTRACT PROPERTIES ------------------
        if let coordinates = raw.properties.optimalTrip?.destination.coordinates {
            self.destination = CLLocationCoordinate2D(latitude: coordinates[1], longitude: coordinates[0])
        }
        if let coordinates = raw.properties.optimalTrip?.stopoverPoints {
            var stopoverPoints : [CLLocationCoordinate2D] = []
            for c in coordinates {
                stopoverPoints.append(CLLocationCoordinate2D(latitude: c.coordinates[1], longitude: c.coordinates[0]))
            }
            self.stopoverPoints = stopoverPoints
        }
        self.estimatedSearchTime = raw.properties.optimalTrip?.estimatedSearchTime
        self.parkingAdvice = raw.properties.optimalTrip?.parkingAdvice
        self.parkingProbability = raw.properties.optimalTrip?.parkingProbability
        self.parkingSituation = raw.properties.optimalTrip?.parkingSituation
        self.visitedParkingSpots = raw.properties.optimalTrip?.visitedParkingSpots
        // -------------- EXTRACT SHAPE -----------------------
        let shapeDictionary = raw.geometry.value as? [String: Any]
        if let shapeT = shapeDictionary?["type"] {
            let stringShape = shapeT as? String
            self.shapeType = getShapeType(shapeString: stringShape)
        } else {
            print("Error - no shape provided for parking Area !")
            return nil
        }
        
        // coordinates are different based on shapeType
        if let shapeCoord = shapeDictionary?["coordinates"] {
            if shapeType == .Unknown {
                print("Unknown Shape in ParkingArea !")
                return nil
            }
            else if shapeType == .MultiPolygon {
                let coordinates = shapeCoord as? [[[[Double]]]]
                // array may contains multiple polygons !
                if coordinates != nil && (coordinates?.count ?? 0) > 0 {
                    if let coordinates = coordinates?[0] {
                        var polygonCounter = 0
                        for polygon in coordinates {
                            outlinePolygon.append([])
                            for point in polygon {
                                outlinePolygon[polygonCounter].append(CLLocationCoordinate2D(latitude: point[1], longitude: point[0]))
                            }
                            polygonCounter += 1
                        }
                    }
                }
            } else if shapeType == .LineString {
                let coordinates = shapeCoord as? [[Double]]
                if let coordinates = coordinates {
                    if outlinePolygon.count == 0 {
                        outlinePolygon.append([])
                    }
                    
                    for point in coordinates {
                        self.outlinePolygon[0].append(CLLocationCoordinate2D(latitude: point[1], longitude: point[0]))
                    }
                }
            } else if shapeType == .Point {
                let coordinate = shapeCoord as? [Double]
                if let coordinate = coordinate, coordinate.count > 1 {
                    self.outlinePoint = CLLocationCoordinate2D(latitude: coordinate[1], longitude: coordinate[0])
                }
            }
        }
        
        // ---------------------- END SHAPE EXTRACTION -----------------------
    }
}

func unwrapParkingAssistantResponse(apiResponse: AskParkingAssistantResponse) -> ParkingAssistance {
    
    var parkingAreas: [ParkingArea] = []
    var optimalRoute : OptimalRoute?
    // unwrap data
    for f in apiResponse.features {
        
        if let _ = f.properties.optimalTrip {
            optimalRoute = OptimalRoute(raw: f)
        }
        
        if let _ = f.properties.parkingEntity {
            if let p = ParkingArea(raw: f) {
                parkingAreas.append(p)
            }
        }
    }
    return ParkingAssistance(optimalRoute: optimalRoute, parkingAreas: parkingAreas)
}

