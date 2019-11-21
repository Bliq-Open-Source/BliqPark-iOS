//
//  RequestBuilder.swift
//  custom_aipark_sdk
//
//  Created by Julian Glaab on 15.11.19.
//  Copyright © 2019 Julian Glaab. All rights reserved.
//

import Foundation

public protocol RequestPrototype {
    var dataType: RequestType { get set }
    var timestampDescription: TimestampDescription? { get set }
}

public enum ContentType: String, Codable {
    case parkingSign = "PARKINGSIGN"
    case price = "PRICE"
    case entrance = "ENTRANCE"
    case other = "OTHER"
}

public enum FeedbackType: String, Codable {
    case correct = "CORRECT"
    case predictedOccupancyWrong = "PREDICTED_OCCUPANCY_WRONG"
    case liveOccupancyWrong = "LIVE_OCCUPANCY_WRONG"
    case locationWrong = "LOCATION_WRONG"
    case notExisting = "NOT_EXISTING"
    case priceWrong = "PRICE_WRONG"
    case capacityWrong = "CAPACITY_WRONG"
    case restrictionsWrong = "RESTRICTIONS_WRONG"
    case temporarilyInaccessible = "TEMPORARILY_INACCESSIBLE"
    case other = "OTHER"
}

public enum ObservedOccupancy: String, Codable {
    case zeroOpen = "0_OPEN"
    case oneToTwoOpen = "1_2_OPEN"
    case threeToFourOpen = "3_4_OPEN"
    case fivePlusOpen = "5+_OPEN"
}

public enum GeneralFeedbackType: String, Codable {
    case general = "GENERAL"
    case parkingAreaMissing = "PARKINGAREA_MISSING"
}

public enum RequestType: String, Codable {
    case IDRequest = "IDRequest"
    case NextToPointRequest = "NextToPointRequest"
    case PolygonRequest = "PolygonRequest"
    case TileRequest = "TileRequest"
    case LastMileRoutingRequest = "LastMileRoutingRequest"
}

public struct IDRequest: Codable, RequestPrototype {
    public var dataType: RequestType
    public var timestampDescription: TimestampDescription?
    public var value: [Value]
    
    public struct Value: Codable {
        let id: Int
        let timestampDescription: TimestampDescription
        
        public init(id: Int, timestampDescription: TimestampDescription) {
            self.id = id
            self.timestampDescription = timestampDescription
        }
    }
    
    public init(value: [Value]) {
        self.dataType = .IDRequest
        self.value = value
    }
    
    public init(value: [Value], timestampDescription: TimestampDescription) {
        self.dataType = .IDRequest
        self.value = value
        self.timestampDescription = timestampDescription
    }
    
}

public struct TileRequest: Codable, RequestPrototype {
    public var timestampDescription: TimestampDescription?
    public var dataType: RequestType
    public var value: Value
    
    public struct Value: Codable {
        let x : Int
        let y: Int
        let zoom : Int
        
        public init(x: Int, y: Int, zoom: Int) {
            self.x = x
            self.y = y
            self.zoom = zoom
        }
    }
    
    public init(value: Value, timestampDescription: TimestampDescription) {
        self.dataType = .TileRequest
        self.value = value
        self.timestampDescription = timestampDescription
    }
    
    public init(value: Value) {
        self.dataType = .TileRequest
        self.value = value
    }
}

public struct LastMileRoutingRequest: Codable, RequestPrototype {
    public var dataType: RequestType
    public var timestampDescription: TimestampDescription?
    public var value: Value
    
    public struct Value: Codable {
        let departure: CenterPoint
        let destination: CenterPoint
        public init(departure: CenterPoint, destination: CenterPoint) {
            self.departure = departure
            self.destination = destination
        }
    }
    
    public init(value: Value) {
        self.dataType = .LastMileRoutingRequest
        self.value = value
    }
    
    public init(value: Value, timestampDescription: TimestampDescription) {
        self.dataType = .LastMileRoutingRequest
        self.value = value
        self.timestampDescription = timestampDescription
    }
}

public struct PolygonRequest: Codable, RequestPrototype {
    public var timestampDescription: TimestampDescription?
    public var dataType: RequestType
    public var value: Value
    
    public struct Value: Codable {
        let type: String
        let coordinates: [[[Double]]]
        
        public init(coordinates: [[[Double]]]) {
            self.coordinates = coordinates
            self.type = "Polygon"
        }
    }
    
    public init(value: Value) {
        self.dataType = .PolygonRequest
        self.value = value
    }
    
    public init(value: Value, timestampDescription: TimestampDescription) {
        self.dataType = .PolygonRequest
        self.value = value
        self.timestampDescription = timestampDescription
    }
}

public struct NextToPointRequest: Codable, RequestPrototype {
    public var dataType: RequestType
    public var timestampDescription: TimestampDescription?
    public var value: Value
    
    public struct Value: Codable {
        let limit: Int
        let point: CenterPoint
        
        public init(limit: Int, point: CenterPoint) {
            self.limit = limit
            self.point = point
        }
    }
    
    public init(value: Value) {
        self.dataType = .NextToPointRequest
        self.value = value
    }
    
    public init(value: Value, timestampDescription: TimestampDescription) {
        self.dataType = .NextToPointRequest
        self.value = value
        self.timestampDescription = timestampDescription
    }
}


