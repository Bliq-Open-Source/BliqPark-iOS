//
//  BliqAPI.swift
//  custom_aipark_sdk
//
//  Created by Julian Glaab on 15.11.19.
//  Copyright © 2019 Julian Glaab. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

public class BliqPark {
    
    var apiKey: String
    var connector : BliqAPI
    var loggingController : LoggingController
    
    public init(apiKey: String) {
        // setup SDK, Cache and API
        self.apiKey = apiKey
        self.connector = BliqAPI(apiKey)
        loggingController = LoggingController(aiparkAPIkey: apiKey)
    }
    
    /**
     Retrieve On-Street Parking Areas
     
     - parameter request: defines type of request
     - parameter mapLayers: states what kind of data should be retrieved (RULES, PREDICTION, LIVE)
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func getOnStreetParkingOptions(request: RequestPrototype, mapLayers: [MapLayers], mapResolutionLevel: MapResolutionLevel? = nil, localeDefinition: LocaleDefinition? = nil, outputFormat: OutputFormat? = nil, excludeTags: [ExcludeTags]? = nil, includeTags: [IncludeTags]? = nil, fromTime: TimestampDescription? = nil, toTime: TimestampDescription? = nil,completionHandler: @escaping ([ParkingArea]?,Error?) -> ()) {
        
        self.connector.getOnStreetParkingOptions(request: request, mapLayers: mapLayers, mapResolutionLevel: mapResolutionLevel, localeDefinition: localeDefinition, outputFormat: outputFormat, excludeTags: excludeTags, includeTags: includeTags, fromTime: fromTime, toTime: toTime) {
            (parkingAreas,Error) in
            completionHandler(parkingAreas,Error)
        }
    }
    
    /**
     Retrieve Off-Street Parking Areas
     
     - parameter request: defines type of request
     - parameter mapLayers: states what kind of data should be retrieved (RULES, PREDICTION, LIVE)
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func getOffStreetParkingOptions(request: RequestPrototype, mapLayers: [MapLayers], localeDefinition: LocaleDefinition? = nil, outputFormat: OutputFormat? = nil, excludeTags: [ExcludeTags]? = nil, includeTags: [IncludeTags]? = nil, fromTime: TimestampDescription? = nil, toTime: TimestampDescription? = nil,completionHandler: @escaping ([ParkingArea]?,Error?) -> ()) {
        
        self.connector.getOffStreetParkingOptions(request: request, mapLayers: mapLayers, localeDefinition: localeDefinition, outputFormat: outputFormat, excludeTags: excludeTags, includeTags: includeTags, fromTime: fromTime, toTime: toTime) {
            (parkingAreas,Error) in
            completionHandler(parkingAreas,Error)
        }
    }
    
    /**
     AskParkingAssistant provides a preselected set of parking information and a optimal driving route
     
     - parameter request: defines type of request
     - parameter mapLayers: states what kind of data should be retrieved (RULES, PREDICTION, LIVE)
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func askParkingAssistant(request: RequestPrototype, mapLayers: [MapLayers], mapResolutionLevel: MapResolutionLevel? = nil, localeDefinition: LocaleDefinition? = nil, outputFormat: OutputFormat? = nil, excludeTags: [ExcludeTags]? = nil, includeTags: [IncludeTags]? = nil, fromTime: TimestampDescription? = nil, toTime: TimestampDescription? = nil, getDriveByParkingEntityResults: GetDriveByParkingEntityResults? = nil, maxDistanceInM : Int? = nil, maxDurationInSec: Int? = nil, preferences : [Preferences]? = nil, completionHandler: @escaping (ParkingAssistance?,Error?) -> ()){
        
        self.connector.askParkingAssistant(request: request, mapLayers: mapLayers, mapResolutionLevel: mapResolutionLevel, localeDefinition: localeDefinition, outputFormat: outputFormat, excludeTags: excludeTags, includeTags: includeTags, fromTime: fromTime, toTime: toTime, getDriveByParkingEntityResults: getDriveByParkingEntityResults, maxDistanceInM: maxDistanceInM, maxDurationInSec: maxDurationInSec, preferences: preferences) {
            (parkingAssistance,Error) in
            completionHandler(parkingAssistance,Error)
        }
    }
    
    /**
    submitFeedback sends feedback on parking entities to Bliq
    - parameter completion: completion handler to receive the response code and the error objects
    */
    public func submitFeedback(deviceHeading: Int, feedbackPosition: CLLocationCoordinate2D, parkingAreaFeedback: ParkingAreaFeedback?=nil, generalFeedback: GeneralFeedback?=nil, completionHandler: @escaping (Int?,Error?) -> ()){
        self.connector.submitFeedback(deviceHeading: deviceHeading, feedbackPosition: feedbackPosition, parkingAreaFeedback: parkingAreaFeedback, generalFeedback: generalFeedback) {
            (responseCode, Error) in
            completionHandler(responseCode,Error)
        }
    }
    
    
    /**
    uploadImage sends an image with parking information to Bliq
    - parameter completion: completion handler to receive the response code and the error objects
    */
    public func submitImage(image: UIImage, deviceHeading: Int, feedbackPosition: CLLocationCoordinate2D, contentType: ContentType,completionHandler: @escaping (Int?,Error?) -> ()){
        self.connector.submitImage(image: image, deviceHeading: deviceHeading, feedbackPosition: feedbackPosition, contentType: contentType) {
            (responseCode, Error) in
            completionHandler(responseCode, Error)
        }
        
    }
    
    
}



class BliqAPI {
    
    // initialization
    private let API_URL_PUBLIC = "https://api.aipark.io:443/aipark/v2/"
    let API_URL_PRIVATE = "https://api.aipark.de:8443/aipark-app/v1/"
    let apikey : String
    
    private let TILE_ZOOM_LEVEL = 16
    private let dispatching_queue : DispatchQueue
    let defaults = UserDefaults.standard
    
    init(_ apikey: String) {
        self.headers = [
            "accept": "application/json",
            "apikey": apikey,
            "Content-Type": "application/json",
            "uuid": UIDevice.current.identifierForVendor!.uuidString
        ]
        self.apikey = apikey
        dispatching_queue = DispatchQueue(label: "", qos: .userInitiated)
    }
    
    // header for API calls
    var headers : [String: String] = [:]
    
    func askParkingAssistant(request: RequestPrototype, mapLayers: [MapLayers], mapResolutionLevel: MapResolutionLevel? = nil, localeDefinition: LocaleDefinition? = nil, outputFormat: OutputFormat? = nil, excludeTags: [ExcludeTags]? = nil, includeTags: [IncludeTags]? = nil, fromTime: TimestampDescription? = nil, toTime: TimestampDescription? = nil, getDriveByParkingEntityResults: GetDriveByParkingEntityResults? = nil, maxDistanceInM : Int? = nil, maxDurationInSec: Int? = nil, preferences : [Preferences]? = nil, completionHandler: @escaping (ParkingAssistance?,Error?) -> ()){
        
        let parameters = AskParkingAssistantRequest(mapLayers: mapLayers, requestType: request as! LastMileRoutingRequest, mapResolutionLevel: mapResolutionLevel, localeDefinition: localeDefinition, outputFormat: outputFormat, excludeTags: excludeTags, includeTags: includeTags, fromTime: fromTime, toTime: toTime, getDriveByParkingEntityResults: getDriveByParkingEntityResults, maxDistanceInM: maxDistanceInM, maxDurationInSec: maxDurationInSec, preferences: preferences)
        
        
        Alamofire.request(API_URL_PUBLIC+"askParkingAssistant", method: .post, parameters:  parameters.dictionary, encoding: JSONEncoding.default, headers: self.headers).responseJSON {
            response in
            switch response.result {
            case .success:
                
                if response.response?.statusCode != 200 {
                    print(response.value.debugDescription)
                }
                
                if let data = response.data {
                    
                    DispatchQueue(label: "", qos: .userInitiated).async {
                        do {
                            let out = try JSONDecoder().decode(AskParkingAssistantResponse.self, from: data)
                            let parkingAssistance = unwrapParkingAssistantResponse(apiResponse: out)
                            // handle result
                            completionHandler(parkingAssistance,nil)
                            
                        }
                        catch let jsonErr {
                            print(jsonErr)
                            print(response.debugDescription)
                            completionHandler(nil, jsonErr)
                        }
                    }
                }
                break
            case .failure(let error):
                completionHandler(nil, error)
                print(error)
            }
        }
        
    }
    
    func getOnStreetParkingOptions(request: RequestPrototype, mapLayers: [MapLayers], mapResolutionLevel: MapResolutionLevel? = nil, localeDefinition: LocaleDefinition? = nil, outputFormat: OutputFormat? = nil, excludeTags: [ExcludeTags]? = nil, includeTags: [IncludeTags]? = nil, fromTime: TimestampDescription? = nil, toTime: TimestampDescription? = nil,completionHandler: @escaping ([ParkingArea]?,Error?) -> ()){
        
        // create different requests based on request type
        var r : Encodable?
        switch request.dataType {
        case .IDRequest:
            r = OnStreetParkingOptionsIDRequest(mapLayers: mapLayers, requestType: request as! IDRequest, mapResolutionLevel: mapResolutionLevel, localeDefinition: localeDefinition, outputFormat: outputFormat, excludeTags: excludeTags, includeTags: includeTags, fromTime: fromTime, toTime: toTime)
        case .NextToPointRequest:
            r = OnStreetParkingOptionsNextToPointRequest(mapLayers: mapLayers, requestType: request as! NextToPointRequest, mapResolutionLevel: mapResolutionLevel, localeDefinition: localeDefinition, outputFormat: outputFormat, excludeTags: excludeTags, includeTags: includeTags, fromTime: fromTime, toTime: toTime)
        case .PolygonRequest:
            r = OnStreetParkingOptionsPolygonRequest(mapLayers: mapLayers, requestType: request as! PolygonRequest, mapResolutionLevel: mapResolutionLevel, localeDefinition: localeDefinition, outputFormat: outputFormat, excludeTags: excludeTags, includeTags: includeTags, fromTime: fromTime, toTime: toTime)
        case .TileRequest:
            r = OnStreetParkingOptionsTileRequest(mapLayers: mapLayers, requestType: request as! TileRequest, mapResolutionLevel: mapResolutionLevel, localeDefinition: localeDefinition, outputFormat: outputFormat, excludeTags: excludeTags, includeTags: includeTags, fromTime: fromTime, toTime: toTime)
        case .LastMileRoutingRequest:
            break
        }
        let parameters = r as! Codable
        
        Alamofire.request(API_URL_PUBLIC+"getOnStreetParkingOptions", method: .post, parameters:  parameters.dictionary, encoding: JSONEncoding.default, headers: self.headers).responseJSON {
            response in
            switch response.result {
            case .success:
                
                if response.response?.statusCode != 200 {
                    print(response.value.debugDescription)
                }
                
                if let data = response.data {
                    
                    DispatchQueue(label: "", qos: .userInitiated).async {
                        do {
                            let out = try JSONDecoder().decode(OnStreetParkingOptionsResponse.self, from: data)
                            let parkingAreas = unwrapOnStreetParkingAreaResponse(apiResponse: out)
                            // handle result
                            completionHandler(parkingAreas,nil)
                            
                        }
                        catch let jsonErr {
                            //print(response.debugDescription)
                            print(jsonErr)
                            completionHandler(nil, jsonErr)
                        }
                    }
                }
                break
            case .failure(let error):
                completionHandler(nil, error)
                print(error)
            }
        }
        
    }
    
    // getOffStreetParkingOptions
    func getOffStreetParkingOptions(request: RequestPrototype, mapLayers: [MapLayers], localeDefinition: LocaleDefinition? = nil, outputFormat: OutputFormat? = nil, excludeTags: [ExcludeTags]? = nil, includeTags: [IncludeTags]? = nil, fromTime: TimestampDescription? = nil, toTime: TimestampDescription? = nil,completionHandler: @escaping ([ParkingArea]?,Error?) -> ()){
        
        // create different requests based on request type
        var r : Encodable?
        switch request.dataType {
        case .IDRequest:
            r = OffStreetParkingOptionsIDRequest(mapLayers: mapLayers, requestType: request as! IDRequest, localeDefinition: localeDefinition, outputFormat: outputFormat, excludeTags: excludeTags, includeTags: includeTags, fromTime: fromTime, toTime: toTime)
        case .NextToPointRequest:
            r = OffStreetParkingOptionsNextToPointRequest(mapLayers: mapLayers, requestType: request as! NextToPointRequest, localeDefinition: localeDefinition, outputFormat: outputFormat, excludeTags: excludeTags, includeTags: includeTags, fromTime: fromTime, toTime: toTime)
        case .PolygonRequest:
            r = OffStreetParkingOptionsPolygonRequest(mapLayers: mapLayers, requestType: request as! PolygonRequest, localeDefinition: localeDefinition, outputFormat: outputFormat, excludeTags: excludeTags, includeTags: includeTags, fromTime: fromTime, toTime: toTime)
        case .TileRequest:
            r = OffStreetParkingOptionsTileRequest(mapLayers: mapLayers, requestType: request as! TileRequest, localeDefinition: localeDefinition, outputFormat: outputFormat, excludeTags: excludeTags, includeTags: includeTags, fromTime: fromTime, toTime: toTime)
        case .LastMileRoutingRequest:
            break
        }
        let parameters = r as! Codable
        
        Alamofire.request(API_URL_PUBLIC+"getOffStreetParkingOptions", method: .post, parameters:  parameters.dictionary, encoding: JSONEncoding.default, headers: self.headers).responseJSON {
            response in
            switch response.result {
            case .success:
                
                if response.response?.statusCode != 200 {
                    print(response.value.debugDescription)
                }
                
                if let data = response.data {
                    
                    DispatchQueue(label: "", qos: .userInitiated).async {
                        do {
                            let out = try JSONDecoder().decode(OffStreetParkingOptionsResponse.self, from: data)
                            let parkingAreas = unwrapOffStreetParkingAreaResponse(apiResponse: out)
                            // handle result
                            completionHandler(parkingAreas,nil)
                            
                        }
                        catch let jsonErr {
                            print(jsonErr)
                            print(response.debugDescription)
                            completionHandler(nil, jsonErr)
                        }
                    }
                }
                break
            case .failure(let error):
                completionHandler(nil, error)
                print(error)
            }
        }
    }
    
    // Feedback APIs
    func getMetaData() -> (AppVersion, Device,TimestampDescription) {
        // App information
        let systemVersion = "iOS\(UIDevice.current.systemVersion)"
        let model = UIDevice.current.modelName
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        
        
        var appN = "unknown"
        if let name = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String {
            appN = "\(name)"
        }
        
        var appV = "v0"
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appV = "v\(version)"
        }
        let appVersion = AppVersion(name: appN, version: appV)
        let osVersion = OSVersion(sdk: "2.0", version: systemVersion)
        let device = Device(manufacturer: "Apple", deviceModel: model, uuid: uuid, osVersion: osVersion)
        let timestamp = TimestampDescription(unixSeconds: Int(Date().timeIntervalSince1970))
        return (appVersion,device,timestamp)
    }
    
    func submitImage(image: UIImage, deviceHeading: Int, feedbackPosition: CLLocationCoordinate2D, contentType: ContentType,completionHandler: @escaping (Int?,Error?) -> ()) {

        // endpoint
        let url = "https://api.aipark.de:443/aipark/v1/submitImage"
        let customHeaders = [
            "accept": "application/json",
            "apikey": self.apikey,
            "Content-Type": "application/json",
            "uuid": UIDevice.current.identifierForVendor!.uuidString,
            "content-type": "multipart/form-data",
            "Content-Disposition" : "form-data"
        ]
        
        let (appVersion, device, timestamp) = getMetaData()
        let parameters = ImageFeedbackRequest(appVersion: appVersion, device: device, timestampDescription: timestamp, deviceHeading: deviceHeading, feedbackPosition: CenterPoint(latitude: feedbackPosition.latitude, longitude: feedbackPosition.longitude), contentType: contentType)
        
        
        guard let imageData = image.jpegData(compressionQuality: 0) else {return}
        if let parameterData = try? JSONSerialization.data(
            withJSONObject: parameters.dictionary,
            options: []) {
            
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 60 // increase timeout interval to make sure no data gets lost
            
            manager.upload(multipartFormData: { multipartFormData in
                //Parameter for Upload files
                let filename = "image_\(Int(Date().timeIntervalSince1970)).jpg"
                multipartFormData.append(imageData, withName: "file",fileName: filename , mimeType: "image/jpeg")
                multipartFormData.append(parameterData,withName: "req_body")
                
            }, usingThreshold:UInt64.init(),
               to: url,
                method: .post,
                headers: customHeaders,
                encodingCompletion: { (result) in
                    
                    switch result {
                    case .success(let upload, _, _):
                        upload.uploadProgress(closure: { (progress) in
                            print("Image upload progress: \(progress.fractionCompleted*100)%")
                        })
                        
                        upload.responseJSON { response in
                            if response.response?.statusCode != 200 {
                                print(response.value.debugDescription)
                            }
                            completionHandler(response.response?.statusCode,nil)
//                            print("the resopnse code is : \(response.response?.statusCode)")
//                            print("the response is : \(response)")
//                            print("the request is: \(response.debugDescription)")
                        }
                        break
                    case .failure(let encodingError):
                        print("the error is  : \(encodingError.localizedDescription)")
                        completionHandler(nil,encodingError)
                        break
                    }
            })
        }
        else {
            completionHandler(nil,nil)
        }
    }
    
    func submitFeedback(deviceHeading: Int, feedbackPosition: CLLocationCoordinate2D,parkingAreaFeedback: ParkingAreaFeedback?=nil, generalFeedback: GeneralFeedback?=nil,completionHandler: @escaping (Int?,Error?) -> ()) {
        // endpoint
        let url = "https://api.aipark.de:443/aipark/v1/submitFeedback"
        let customHeaders = [
            "accept": "application/json",
            "apikey": self.apikey,
            "Content-Type": "application/json",
            "uuid": UIDevice.current.identifierForVendor!.uuidString
        ]
        
        let (appVersion, device, timestamp) = getMetaData()
        let parameters = FeedbackRequest(appVersion: appVersion, device: device, timestampDescription: timestamp, deviceHeading: deviceHeading, feedbackPosition: CenterPoint(latitude: feedbackPosition.latitude, longitude: feedbackPosition.longitude), parkingAreaFeedback: parkingAreaFeedback, generalFeedback: generalFeedback)
        
        Alamofire.request(url, method: .post, parameters:  parameters.dictionary, encoding: JSONEncoding.default, headers: customHeaders).responseJSON {
            response in
            switch response.result {
            case .success:
                if response.response?.statusCode != 200 {
                    print(response.value.debugDescription)
                }
                completionHandler(response.response?.statusCode,nil)
            case .failure(let error):
                completionHandler(nil, error)
                print(response.value.debugDescription)
                print(error)
            }
        }
        
    }

    
}

/// Logging
extension BliqAPI {
    
    private func getMotionString(motion: Motion?) -> String {
        if let motion = motion {
            switch motion {
            case .DRIVING: return "DRIVING"
            case .STATIONARY: return "STILL"
            case .WALKING: return "WALKING"
            default: return "UNKNOWN"
            }
        } else {
            return "UNKNOWN"
        }
    }
    
    func sendRoute(route: [RoutePoint], completionHandler: @escaping (String?, Error?) -> ()) {
        // process route points
        var completeRoute: [Any] = []
        // Prevent error while route is empty (after waking up)
        if route.count == 0 {
            return
        }
        for i in 0...route.count-1 {
            let singlePoint: [String: Any] =
                [
                    "id": "",
                    "point": [
                        "type": "Point",
                        "coordinates": [route[i].location.longitude,route[i].location.latitude]
                    ],
                    "speed": route[i].speed as Any,
                    "state": getMotionString(motion: route[i].motion) as Any,
                    "timestamp": Int64(route[i].time.timeIntervalSince1970 * 1000) as Any
            ]
            completeRoute += [singlePoint]
        }
        
        // App information
        var appVersion = "v0"
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = "v\(version)"
            
        }
        let systemVersion = "iOS\(UIDevice.current.systemVersion)"
        let model = UIDevice.current.modelName
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        
        let parameter: [String: Any] = [
            "appVersion": [
                "id": "",
                "version": appVersion
            ],
            "device": [
                "deviceModel": [
                    "deviceManufacturer": [
                        "id": "",
                        "name": "Apple"
                    ],
                    "name": model
                ],
                "uuid": uuid
            ],
            "id": "",
            "osVersion": [
                "id": "",
                "sdk": String(14),
                "version": systemVersion
            ],
            "routePoints": completeRoute
        ]
        
        Alamofire.request(API_URL_PRIVATE+"addRoute", method: .post, parameters: parameter, encoding: JSONEncoding.default,  headers: self.headers).validate(statusCode: 200..<300).responseJSON {
            response in
            switch response.result {
            case .success(_):
                let answer = response.result.value! as! Int
                if response.response?.statusCode != 200 {
                    print(response.value.debugDescription)
                }
                completionHandler(String(answer) ,nil)
            case .failure(let error):
                print("Statuscode: \(String(describing: response.response?.statusCode))")
                print(error)
                completionHandler(nil, error)
            }
        }
    }
    
    
    func sendLeavingEvent(_ eventPoint: RoutePoint) {
        let parameter: [String: Any] = [
            "datasource": [
                "type": "ios sdk",
            ],
            "id": "0",
            "point": [
                "type": "Point",
                "coordinates": [eventPoint.location.longitude,eventPoint.location.latitude]
            ],
            "timestamp": Int64(eventPoint.time.timeIntervalSince1970 * 1000)
        ]
        
        Alamofire.request(API_URL_PRIVATE+"addLiveParkEvent", method: .post, parameters: parameter, encoding: JSONEncoding.default,  headers: self.headers).validate(statusCode: 200..<300).responseData {response in
            switch response.result {
            case .success(_):
                if response.response?.statusCode != 200 {
                    print(response.value.debugDescription)
                }
            case .failure(let error):
                break
            }
            
        }
    }
}

