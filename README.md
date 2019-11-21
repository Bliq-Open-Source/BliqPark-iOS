![BliqPark](https://github.com/Bliq-Open-Source/BliqPark-iOS/blob/master/logo.png)

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)]()
[![CocoaPods Compatible](https://img.shields.io/badge/CocoaPod-1.1.3-brightgreen.svg)](https://cocoapods.org/pods/AIPARKSDK)
[![Platform](https://img.shields.io/badge/Platform-iOS-brightgreen.svg)](https://github.com/AIPARK-Open-Source/AiparkiOSSDK)
[![Twitter](https://img.shields.io/badge/Twitter-%40AIPARK10-blue.svg)](https://twitter.com/AIPARK10)
[![License](https://img.shields.io/github/license/AIPARK-Open-Source/AiparkiOSSDK.svg)](https://www.apache.org/licenses/LICENSE-2.0.html)

# Starting Guide

This guide will show you how to use the BliqPark framework which helps you to use the BliqPark services.

## Requirements
- iOS 12+
- swift 4

## Installation
### Cocoa Pods
[CocoaPod](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:
```bash
gem install cocoapods
```

To integrate BliqPark into your Xcode project using CocoaPods, specify it in your Podfile:
```
platform :ios, '12.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'BliqPark'
end
```

### Dependencies
The following cocoa pods are required to run BliqPark
- Alamofire
- SwiftyJSON

## First Steps
To use the BliqPark SDK, import the package and initialize the BliqPark class.
```swift
import BliqPark

let bliq = Bliq(apiKey: <yourAPIKey>)
```

### Authorization
#### PLIST
To use AIPARK, we need the current GPS position of the device. Therefore, add the following keys to the info.plist file.

| Key | Purpose |
| ----- | --------- |
| NSLocationWhenInUseUsageDescription | Reason why GPS is used while app is in use |
| NSLocationAlwaysAndWhenInUseUsageDescription | Reason why GPS is used in background |
| NSMotionUsageDescription | Reason why motion sensor is used (required to detect leaving a parking spot). |

#### CAPABILITIES
You also need to allow location updates in Background Mode. Otherwise there will be an exception during the usage of the framework.

### Request ParkingAreas
To request parking areas, you need to specify a request object. This object contains the location or area that you wish to get parking areas from.
#### Tiles
Tiles are predefined map areas. To visualize these tiles, you can visit this website [Tiles](http://tools.geofabrik.de/map/#2/29.1466/31.9609&type=Geofabrik_Standard&grid=1). You can request tiles on the zoom levels 15 to 16. To convert a GPS coordinate with Latitude/Longitude into a tile, you can use a predefined method:
```swift
func getTileForCoordinates(latitude: Double, longitude: Double, zoom: Int) -> (x: Int, y: Int)
```

An example of a request to get parking areas is shown below. This returns a set of parking areas from the specified tiles.
```swift
let bliq = BliqPark(apiKey: <yourAPIKey>)
let point = CLLocationCoordinate2D(latitude: 52.26421778466458, longitude: 10.520997047424316)
let request = NextToPointRequest(value: .init(limit: 30, point: CenterPoint(latitude: point.latitude, longitude: point.longitude)))
bliq.getOnStreetParkingOptions(request: request, mapLayers: [.prediction,.rules]) {
  (parkingAreas,Error) in
  for entry in parkingAreas ?? [] {
    print(entry.streetName)
  }
}
```

### Problems
#### SIGABRT after start
If you see error messages like the following right after the app started the permission for the background mode is missing. To solve this go to your project in XCode and click on your project name in the left bar. Then switch to the capabilities tab and activate the 'Background Modes', specially the 'Location updates'.

```
*** Assertion failure in -[CLLocationManager setAllowsBackgroundLocationUpdates:], /BuildRoot/Library/Caches/com.apple.xbs/Sources/CoreLocationFramework_Sim/CoreLocation-2245.4.104/Framework/CoreLocation/CLLocationManager.m:652
*** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Invalid parameter not satisfying: !stayUp || CLClientIsBackgroundable(internal->fClient)'
```
