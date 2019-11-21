//
//  OnStreetParkingOptions.swift
//  
//
//  Created by Julian Glaab on 16.11.19.
//

import Foundation
import CoreLocation


public class ParkingArea {
    
    // shape
    public var shapeType : ShapeType?
    public var outlinePolygon : [[CLLocationCoordinate2D]] = []
    public var outlinePoint : CLLocationCoordinate2D?
    
    // properties
    public var id : Int?
    public var streetName: String?
    public var capacity : Int?
    public var orientation: String?
    public var centerPoint: CLLocationCoordinate2D?
    public var priceInformation: PriceInformation?
    public var parkingTags: [String]?
    public var openingHours : OpeningHours?
    public var occupancy: Occupancy?
    public var maxStay: [MaxStaySchedule]?
    
    init?(raw: Feature) {
        self.id = raw.id
        // -------------- EXTRACT PROPERTIES ------------------
        if let coordinates = raw.properties.parkingEntity?.centerPoint.coordinates {
            self.centerPoint = CLLocationCoordinate2D(latitude: coordinates[1], longitude: coordinates[0])
        }
        self.maxStay = raw.properties.parkingEntity?.maxStay
        self.occupancy = raw.properties.parkingEntity?.occupancy
        self.openingHours = raw.properties.parkingEntity?.openingHours
        self.orientation = raw.properties.parkingEntity?.orientation
        self.capacity = raw.properties.parkingEntity?.capacity
        self.parkingTags = raw.properties.parkingEntity?.parkingTags
        self.priceInformation = raw.properties.parkingEntity?.priceInformation
        self.streetName = raw.properties.parkingEntity?.streetName
        
        
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

func unwrapOnStreetParkingAreaResponse(apiResponse: OnStreetParkingOptionsResponse) -> [ParkingArea]{
    
    var parkingAreas: [
        ParkingArea] = []
    // unwrap data
    for f in apiResponse.features {
        if let p = ParkingArea(raw: f) {
            parkingAreas.append(p)
        }
    }
    return parkingAreas
}

func unwrapOffStreetParkingAreaResponse(apiResponse: OffStreetParkingOptionsResponse) -> [ParkingArea]{
    
    var parkingAreas: [
        ParkingArea] = []
    // unwrap data
    for f in apiResponse.features {
        if let p = ParkingArea(raw: f) {
            parkingAreas.append(p)
        }
    }
    return parkingAreas
}


func getShapeType(shapeString: String?) -> ShapeType {
    switch shapeString {
    case "Point":
        return .Point
    case "LineString":
        return .LineString
    case "MultiPolygon":
        return .MultiPolygon
    default:
        return .Unknown
    }
}

public enum ShapeType {
    case Point
    case LineString
    case MultiPolygon
    case Unknown
}
