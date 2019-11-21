//
//  RequestModels.swift
//  custom_aipark_sdk
//
//  Created by Julian Glaab on 15.11.19.
//  Copyright © 2019 Julian Glaab. All rights reserved.
//

import Foundation

public extension Encodable {
    
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves)) as? [String: Any] ?? [:]
    }
    
}

/// Feedback Request
public struct FeedbackRequest: Codable {
    var appVersion: AppVersion
    var device: Device
    var timestampDescription: TimestampDescription
    var deviceHeading: Int
    var feedbackPosition: CenterPoint
    var parkingAreaFeedback: ParkingAreaFeedback?
    var generalFeedback: GeneralFeedback?
    
    public init(appVersion: AppVersion, device: Device, timestampDescription: TimestampDescription, deviceHeading: Int, feedbackPosition: CenterPoint, parkingAreaFeedback: ParkingAreaFeedback?=nil, generalFeedback: GeneralFeedback?=nil) {
        self.appVersion = appVersion
        self.device = device
        self.timestampDescription = timestampDescription
        self.deviceHeading = deviceHeading
        self.feedbackPosition = feedbackPosition
        self.parkingAreaFeedback = parkingAreaFeedback
        self.generalFeedback = generalFeedback
    }
    
}

public struct ParkingAreaFeedback: Codable {
    var parkingAreaId: Int
    var feedbackType: [FeedbackType]
    var textDescription: String?
    var observedOccupancy: ObservedOccupancy?
    
    public init(parkingAreaId: Int, feedbackType: [FeedbackType],textDescription: String?=nil,observedOccupancy: ObservedOccupancy?=nil) {
        self.parkingAreaId = parkingAreaId
        self.feedbackType = feedbackType
        self.textDescription = textDescription
        self.observedOccupancy = observedOccupancy
    }
}

public struct GeneralFeedback: Codable {
    var feedbackType: GeneralFeedbackType
    var textDescription: String?
    
    public init(feedbackType: GeneralFeedbackType, textDescription: String?=nil) {
        self.feedbackType = feedbackType
        self.textDescription = textDescription
    }
}

/// Image Feedback Reqest

public struct ImageFeedbackRequest: Codable {
    
    var appVersion: AppVersion
    var device: Device
    var timestampDescription: TimestampDescription
    var deviceHeading: Int
    var feedbackPosition: CenterPoint
    var contentType: ContentType
        
    public init(appVersion: AppVersion, device: Device, timestampDescription: TimestampDescription, deviceHeading: Int, feedbackPosition: CenterPoint, contentType: ContentType) {
        self.appVersion = appVersion
        self.device = device
        self.timestampDescription = timestampDescription
        self.deviceHeading = deviceHeading
        self.feedbackPosition = feedbackPosition
        self.contentType = contentType
    }
}

public struct Device: Codable {
    var manufacturer: String
    var deviceModel: String
    var uuid: String
    var osVersion: OSVersion
}

public struct OSVersion: Codable {
    var sdk: String
    var version: String
    public init(sdk: String,version:String) {
        self.sdk = sdk
        self.version = version
    }
}

public struct AppVersion: Codable {
    var name: String
    var version: String
    public init(name: String, version: String) {
        self.name = name
        self.version = version
    }
}

/// askParkingAssistant Request Model
public struct AskParkingAssistantRequest: Codable {
    var mapLayers: [MapLayers]
    var requestType: LastMileRoutingRequest
    var localeDefinition: LocaleDefinition?
    var outputFormat: OutputFormat?
    var excludeTags : [ExcludeTags]?
    var includeTags: [IncludeTags]?
    var mapResolutionLevel: MapResolutionLevel?
    var fromTime: TimestampDescription?
    var toTime: TimestampDescription?
    var getDriveByParkingEntityResults: GetDriveByParkingEntityResults?
    var maxDistanceInM : Int?
    var maxDurationInSec: Int?
    var preferences : [Preferences]?
    
    public init(mapLayers: [MapLayers],requestType: LastMileRoutingRequest, mapResolutionLevel: MapResolutionLevel? = nil, localeDefinition: LocaleDefinition? = nil,outputFormat: OutputFormat? = nil,excludeTags : [ExcludeTags]? = nil,includeTags: [IncludeTags]? = nil,fromTime: TimestampDescription? = nil,toTime: TimestampDescription? = nil, getDriveByParkingEntityResults: GetDriveByParkingEntityResults? = nil, maxDistanceInM: Int? = nil, maxDurationInSec: Int? = nil, preferences: [Preferences]? = nil) {
        self.mapLayers = mapLayers
        self.requestType = requestType
        self.mapResolutionLevel = mapResolutionLevel
        self.localeDefinition = localeDefinition
        self.outputFormat = outputFormat
        self.excludeTags = excludeTags
        self.includeTags = includeTags
        self.fromTime = fromTime
        self.toTime = toTime
        self.getDriveByParkingEntityResults = getDriveByParkingEntityResults
        self.maxDistanceInM = maxDistanceInM
        self.maxDurationInSec = maxDurationInSec
        self.preferences = preferences
    }
    
}

public enum Preferences: String, Codable {
    case shortWalkingLevel1 = "SHORT_WALKING_LEVEL_1"
    case shortWalkingLevel2 = "SHORT_WALKING_LEVEL_2"
    case shortWalkingLevel3 = "SHORT_WALKING_LEVEL_3"
    case shortWalkingLevel4 = "SHORT_WALKING_LEVEL_4"
    case shortDrivingLevel1 = "SHORT_DRIVING_LEVEL_1"
    case shortDrivingLevel2 = "SHORT_DRIVING_LEVEL_2"
    case shortDrivingLevel3 = "SHORT_DRIVING_LEVEL_3"
    case shortDrivingLevel4 = "SHORT_DRIVING_LEVEL_4"
    case saveMoney = "SAVE_MONEY"
    case tryHisLuck = "TRY_HIS_LUCK"
    case carPark = "CAR_PARK"
}

public enum DriveByParkingEntityTags: String, Codable {
    case customer = "CUSTOMER"
    case free = "FREE"
    case paid = "PAID"
    case _private = "PRIVATE"
    case employee = "EMPLOYEE"
    case carPark = "CAR_PARK"
    case underground = "UNDERGROUND"
    case airport = "AIRPORT"
    case parkAndRide = "PARK_AND_RIDE"
    case surface = "SURFACE"
    case truck = "TRUCK"
    case bus = "BUS"
    case onStreet = "ON_STREET"
    case offStreet = "OFF_STREET"
    case taxi = "TAXI"
}

public struct GetDriveByParkingEntityResults: Codable {
    
    public enum Constraints: String, Codable {
        case parallelToRoute = "PARALLEL_TO_ROUTE"
    }
    
    var constraints: [Constraints]?
    var driveByParkingEntityTags: [DriveByParkingEntityTags]
    var maxDistanceToRouteInMeter: Int?
    
    public init(constraints: [Constraints]?, driveByParkingEntityTags: [DriveByParkingEntityTags], maxDistanceToRouteInMeter: Int?) {
        self.constraints = constraints
        self.driveByParkingEntityTags = driveByParkingEntityTags
        self.maxDistanceToRouteInMeter = maxDistanceToRouteInMeter
        
    }
    
}

/// getOnStreetParkingOptions Request Models

public struct OnStreetParkingOptionsIDRequest: Codable {
    var mapLayers: [MapLayers]
    var requestType: IDRequest
    var mapResolutionLevel: MapResolutionLevel?
    var localeDefinition: LocaleDefinition?
    var outputFormat: OutputFormat?
    var excludeTags : [ExcludeTags]?
    var includeTags: [IncludeTags]?
    var fromTime: TimestampDescription?
    var toTime: TimestampDescription?
    
    public init(mapLayers: [MapLayers],requestType: IDRequest, mapResolutionLevel: MapResolutionLevel? = nil, localeDefinition: LocaleDefinition? = nil,outputFormat: OutputFormat? = nil,excludeTags : [ExcludeTags]? = nil,includeTags: [IncludeTags]? = nil,fromTime: TimestampDescription? = nil,toTime: TimestampDescription? = nil) {
        self.mapLayers = mapLayers
        self.requestType = requestType
        self.mapResolutionLevel = mapResolutionLevel
        self.localeDefinition = localeDefinition
        self.outputFormat = outputFormat
        self.excludeTags = excludeTags
        self.includeTags = includeTags
        self.fromTime = fromTime
        self.toTime = toTime
    }
}

public struct OnStreetParkingOptionsNextToPointRequest: Codable {
    var mapLayers: [MapLayers]
    var requestType: NextToPointRequest
    var mapResolutionLevel: MapResolutionLevel?
    var localeDefinition: LocaleDefinition?
    var outputFormat: OutputFormat?
    var excludeTags : [ExcludeTags]?
    var includeTags: [IncludeTags]?
    var fromTime: TimestampDescription?
    var toTime: TimestampDescription?
    
    public init(mapLayers: [MapLayers],requestType: NextToPointRequest, mapResolutionLevel: MapResolutionLevel? = nil, localeDefinition: LocaleDefinition? = nil,outputFormat: OutputFormat? = nil,excludeTags : [ExcludeTags]? = nil,includeTags: [IncludeTags]? = nil,fromTime: TimestampDescription? = nil,toTime: TimestampDescription? = nil) {
        self.mapLayers = mapLayers
        self.requestType = requestType
        self.mapResolutionLevel = mapResolutionLevel
        self.localeDefinition = localeDefinition
        self.outputFormat = outputFormat
        self.excludeTags = excludeTags
        self.includeTags = includeTags
        self.fromTime = fromTime
        self.toTime = toTime
    }
}

public struct OnStreetParkingOptionsPolygonRequest: Codable {
    var mapLayers: [MapLayers]
    var requestType: PolygonRequest
    var mapResolutionLevel: MapResolutionLevel?
    var localeDefinition: LocaleDefinition?
    var outputFormat: OutputFormat?
    var excludeTags : [ExcludeTags]?
    var includeTags: [IncludeTags]?
    var fromTime: TimestampDescription?
    var toTime: TimestampDescription?
    
    public init(mapLayers: [MapLayers],requestType: PolygonRequest, mapResolutionLevel: MapResolutionLevel? = nil, localeDefinition: LocaleDefinition? = nil,outputFormat: OutputFormat? = nil,excludeTags : [ExcludeTags]? = nil,includeTags: [IncludeTags]? = nil,fromTime: TimestampDescription? = nil,toTime: TimestampDescription? = nil) {
        self.mapLayers = mapLayers
        self.requestType = requestType
        self.mapResolutionLevel = mapResolutionLevel
        self.localeDefinition = localeDefinition
        self.outputFormat = outputFormat
        self.excludeTags = excludeTags
        self.includeTags = includeTags
        self.fromTime = fromTime
        self.toTime = toTime
    }
}

public struct OnStreetParkingOptionsTileRequest: Codable {
    var mapLayers: [MapLayers]
    var requestType: TileRequest
    var mapResolutionLevel: MapResolutionLevel?
    var localeDefinition: LocaleDefinition?
    var outputFormat: OutputFormat?
    var excludeTags : [ExcludeTags]?
    var includeTags: [IncludeTags]?
    var fromTime: TimestampDescription?
    var toTime: TimestampDescription?
    
    public init(mapLayers: [MapLayers],requestType: TileRequest, mapResolutionLevel: MapResolutionLevel? = nil, localeDefinition: LocaleDefinition? = nil,outputFormat: OutputFormat? = nil,excludeTags : [ExcludeTags]? = nil,includeTags: [IncludeTags]? = nil,fromTime: TimestampDescription? = nil,toTime: TimestampDescription? = nil) {
        self.mapLayers = mapLayers
        self.requestType = requestType
        self.mapResolutionLevel = mapResolutionLevel
        self.localeDefinition = localeDefinition
        self.outputFormat = outputFormat
        self.excludeTags = excludeTags
        self.includeTags = includeTags
        self.fromTime = fromTime
        self.toTime = toTime
    }
}

/// getOffStreetParkingOptions Request Models

public struct OffStreetParkingOptionsIDRequest: Codable {
    let mapLayers: [MapLayers]
    let requestType: IDRequest
    var localeDefinition: LocaleDefinition?
    var outputFormat: OutputFormat?
    var excludeTags : [ExcludeTags]?
    var includeTags: [IncludeTags]?
    var fromTime: TimestampDescription?
    var toTime: TimestampDescription?
    
    public init(mapLayers: [MapLayers],requestType: IDRequest, localeDefinition: LocaleDefinition? = nil,outputFormat: OutputFormat? = nil,excludeTags : [ExcludeTags]? = nil,includeTags: [IncludeTags]? = nil,fromTime: TimestampDescription? = nil,toTime: TimestampDescription? = nil) {
        self.mapLayers = mapLayers
        self.requestType = requestType
        self.localeDefinition = localeDefinition
        self.outputFormat = outputFormat
        self.excludeTags = excludeTags
        self.includeTags = includeTags
        self.fromTime = fromTime
        self.toTime = toTime
    }
}

public struct OffStreetParkingOptionsNextToPointRequest: Codable {
    let mapLayers: [MapLayers]
    let requestType: NextToPointRequest
    var localeDefinition: LocaleDefinition?
    var outputFormat: OutputFormat?
    var excludeTags : [ExcludeTags]?
    var includeTags: [IncludeTags]?
    var fromTime: TimestampDescription?
    var toTime: TimestampDescription?
    
    public init(mapLayers: [MapLayers],requestType: NextToPointRequest, localeDefinition: LocaleDefinition? = nil,outputFormat: OutputFormat? = nil,excludeTags : [ExcludeTags]? = nil,includeTags: [IncludeTags]? = nil,fromTime: TimestampDescription? = nil,toTime: TimestampDescription? = nil) {
        self.mapLayers = mapLayers
        self.requestType = requestType
        self.localeDefinition = localeDefinition
        self.outputFormat = outputFormat
        self.excludeTags = excludeTags
        self.includeTags = includeTags
        self.fromTime = fromTime
        self.toTime = toTime
    }
}

public struct OffStreetParkingOptionsPolygonRequest: Codable {
    let mapLayers: [MapLayers]
    let requestType: PolygonRequest
    var localeDefinition: LocaleDefinition?
    var outputFormat: OutputFormat?
    var excludeTags : [ExcludeTags]?
    var includeTags: [IncludeTags]?
    var fromTime: TimestampDescription?
    var toTime: TimestampDescription?
    
    public init(mapLayers: [MapLayers],requestType: PolygonRequest, localeDefinition: LocaleDefinition? = nil,outputFormat: OutputFormat? = nil,excludeTags : [ExcludeTags]? = nil,includeTags: [IncludeTags]? = nil,fromTime: TimestampDescription? = nil,toTime: TimestampDescription? = nil) {
        self.mapLayers = mapLayers
        self.requestType = requestType
        self.localeDefinition = localeDefinition
        self.outputFormat = outputFormat
        self.excludeTags = excludeTags
        self.includeTags = includeTags
        self.fromTime = fromTime
        self.toTime = toTime
    }
}

public struct OffStreetParkingOptionsTileRequest: Codable {
    let mapLayers: [MapLayers]
    let requestType: TileRequest
    var localeDefinition: LocaleDefinition?
    var outputFormat: OutputFormat?
    var excludeTags : [ExcludeTags]?
    var includeTags: [IncludeTags]?
    var fromTime: TimestampDescription?
    var toTime: TimestampDescription?
    
    public init(mapLayers: [MapLayers],requestType: TileRequest, localeDefinition: LocaleDefinition? = nil,outputFormat: OutputFormat? = nil,excludeTags : [ExcludeTags]? = nil,includeTags: [IncludeTags]? = nil,fromTime: TimestampDescription? = nil,toTime: TimestampDescription? = nil) {
        self.mapLayers = mapLayers
        self.requestType = requestType
        self.localeDefinition = localeDefinition
        self.outputFormat = outputFormat
        self.excludeTags = excludeTags
        self.includeTags = includeTags
        self.fromTime = fromTime
        self.toTime = toTime
    }
}

public enum MapLayers: String, Codable {
    case rules = "RULES"
    case prediction = "PREDICTION"
    case live = "LIVE"
}

public enum MapResolutionLevel: String, Codable {
    case block = "BLOCK"
    case sign = "SIGN"
    case hd = "HD"
}

public enum ExcludeTags: String, Codable {
    case paid = "PAID"
    case free = "FREE"
    case _private = "PRIVATE"
    case customer = "CUSTOMER"
    case parkAndRide = "PARK_AND_RIDE"
}
public enum IncludeTags: String, Codable {
    case paid = "PAID"
    case free = "FREE"
    case _private = "PRIVATE"
    case customer = "CUSTOMER"
    case parkAndRide = "PARK_AND_RIDE"
}

public enum OutputFormat: String, Codable {
    case geoJson = "GEO_JSON"
    case geoJsonDescriptive = "GEO_JSON_DESCRIPTIVE"
    case regularJson = "REGULAR_JSON"
    case predictionOnly = "PREDICTION_ONLY"
}

public struct LocaleDefinition: Codable {
    let contentLanguage: ContentLanguage
    let currencyCode: CurrencyCode
    let unitSystem: UnitSystem
    
    public init(contentLanguage: ContentLanguage, currencyCode: CurrencyCode, unitSystem: UnitSystem) {
        self.contentLanguage = contentLanguage
        self.currencyCode = currencyCode
        self.unitSystem = unitSystem
    }
}

public enum UnitSystem: String, Codable {
    case metric = "METRIC"
    case imperial = "IMPERIAL"
}
/** Used to specify the content language in the response. Default is &#39;EN&#39;. Only support of uppercase contentLanguage code (&#39;en&#39; is currently not supported, instead set &#39;EN&#39;)! See ISO 639-1 Alpha-2 codes of countries: https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes */
public enum ContentLanguage: String, Codable {
    case en = "EN"
    case de = "DE"
}
/** Used to specify the currency (of pricing) in the response. Default is &#39;EUR&#39;. Only support of uppercase currency code (&#39;usd&#39; is currently not supported, instead set &#39;USD&#39;)! See ISO 4217 codes of currencies: https://en.wikipedia.org/wiki/ISO_4217 */
public enum CurrencyCode: String, Codable {
    case eur = "EUR"
    case chf = "CHF"
    case hrk = "HRK"
    case mxn = "MXN"
    case zar = "ZAR"
    case inr = "INR"
    case thb = "THB"
    case cny = "CNY"
    case aud = "AUD"
    case ils = "ILS"
    case krw = "KRW"
    case jpy = "JPY"
    case pln = "PLN"
    case gbp = "GBP"
    case idr = "IDR"
    case huf = "HUF"
    case php = "PHP"
    case _try = "TRY"
    case rub = "RUB"
    case hkd = "HKD"
    case isk = "ISK"
    case dkk = "DKK"
    case cad = "CAD"
    case usd = "USD"
    case myr = "MYR"
    case bgn = "BGN"
    case nok = "NOK"
    case ron = "RON"
    case sgd = "SGD"
    case czk = "CZK"
    case sek = "SEK"
    case nzd = "NZD"
    case brl = "BRL"
}

