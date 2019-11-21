//
//  TileConverter.swift
//  custom_aipark_sdk
//
//  Created by Julian Glaab on 16.11.19.
//  Copyright © 2019 Julian Glaab. All rights reserved.
//

import Foundation

public class TileConverter {
    
    public static func getTileNrForCoordinate(latitude: Double, longitude: Double, zoom: Int) -> Tile {
        let addFactor : Int = 0
        // - - -
        let tileX = Int(floor((longitude + 180) / 360.0 * pow(2.0, Double(zoom+addFactor))))
        let tileY = Int(floor((1 - log( tan( latitude * Double.pi / 180.0 ) + 1 / cos( latitude * Double.pi / 180.0 )) / Double.pi ) / 2 * pow(2.0, Double(zoom+addFactor))))
        
        return Tile(x: tileX, y: tileY)
    }
}

public class Tile: Hashable {
    public var x: Int
    public var y: Int
    var timestamp: Date
    
    public var hashValue: Int {
        return x.hashValue ^ y.hashValue
    }
    
    public init(x: Int, y: Int){
        self.x = x
        self.y = y
        timestamp = Date()
    }
    
    public static func == (lhs: Tile, rhs: Tile) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

