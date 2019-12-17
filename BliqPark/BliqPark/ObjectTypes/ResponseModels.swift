//
//  Models.swift
//  custom_aipark_sdk
//
//  Created by Julian Glaab on 14.11.19.
//  Copyright © 2019 Julian Glaab. All rights reserved.
//

import Foundation

public struct AskParkingAssistantResponse: Decodable {
    public let type: String
    public let features: [Feature]
    public let dataType: String
    public let responseMetaData: ResponseMetaData
}

public struct OnStreetParkingOptionsResponse: Decodable {
    public let type: String
    public let features : [Feature]
    public let dataType: String
    public let responseMetaData: ResponseMetaData
}

public struct OffStreetParkingOptionsResponse: Decodable {
    public let type: String
    public let features : [Feature]
    public let dataType: String
    public let responseMetaData: ResponseMetaData
}

public struct ResponseMetaData: Decodable {
    public let statusMessage: String
    public let dataType: String
}

public struct Feature: Decodable {
    public let geometry : AnyDecodable
    public let id : Int?
    public let properties : Properties
}

public struct LineString: Codable {
    public let coordinates: [[Double]]
    public let type: String
}

public struct MultiPolygon: Codable {
    public let coordinates: [[[Double]]]
    public let type: String
}

public struct CenterPoint: Codable {
    public var coordinates : [Double]
    public var type: String
    public init(latitude: Double, longitude: Double) {
        self.coordinates = [longitude, latitude]
        self.type = "Point"
    }
}

public struct Properties : Decodable {
    public let parkingEntity : ParkingEntity?
    public let optimalTrip: OptimalTrip?
}

public struct OptimalTrip: Decodable {
    public let stopoverPoints : [CenterPoint]
    public let destination: CenterPoint
    public let parkingProbability: Double
    public let visitedParkingSpots: Int
    public let parkingSituation: String
    public let parkingAdvice: String
    public let estimatedSearchTime: EstimatedSearchTime
}

public struct EstimatedSearchTime: Decodable {
    public let searchTimeWithParkingAssistant: Int
    public let searchTimeWithoutParkingAssistant: Int
    
}

public struct ParkingEntity: Codable {
    public  let capacity : Int
    public let centerPoint: CenterPoint
    public let occupancy : Occupancy?
    public let openingHours: OpeningHours?
    public let maxStay: [MaxStaySchedule]?
    public let priceInformation: PriceInformation?
    public let orientation : String?
    public let parkingTags: [String]
    public let streetName: String?
    public let parkingEntityName: String?
}

public struct PriceInformation: Codable {
    public let schedules: [PriceSchedule]?
    public let calculatedPrice: Int?
}

public struct PriceSchedule: Codable {
    public let schedule: ScheduleKey
    public let priceModel: PriceModel
}

public struct PriceModel: Codable {
    public let interval: Int?
    public let prices: [Price]
}

public struct Price: Codable {
    public let currencyCode: String
    public let priceValue: String?
    public let maxPriceValue: String?
}

public struct Occupancy: Codable {
    public var color : String?
    public var occupancyPredicted: OccupancyPredicted?
    public var state: String?
    public var timestampDescription: TimestampDescription
}

public struct OccupancyPredicted: Codable {
    public let parkingProbability: Int?
}

public struct TimestampDescription: Codable {
    public var unixSeconds: Int?
    public var timestampDescription: String?
    public var unixMilliSeconds: Int?
    
    public init(unixSeconds: Int? = nil,timestampDescription: String? = nil, unixMilliSeconds: Int? = nil) {
        self.unixSeconds = unixSeconds
        self.timestampDescription = timestampDescription
        self.unixMilliSeconds = unixMilliSeconds
    }
    
}

public struct OpeningHours: Codable {
    public let simpleOpeningStatus: String?
    public let schedules: [OpeningHourSchedule]?
}

public struct OpeningHourSchedule: Codable {
    public let scheduleType: String
    public let schedule: ScheduleKey
}

public struct MaxStaySchedule: Codable {
    public let allowedTimeInMinutes: Int
    public let schedule: ScheduleKey
}

public struct ScheduleKey: Codable {
    public let days: [String]?
    public let validFromYear: Int?
    public let validToYear: Int?
    public let validFromMonth: Int?
    public let validToMonth: Int?
    public let validFromDay: Int?
    public let validToDay: Int?
    public let validFromTime: String?
    public let validToTime: String?
    public let description: String?
    public let priority: Int?
}

