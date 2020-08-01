//
//  Taxi.swift
//  mytaxi
//
//  Created by Kalpesh Talkar on 02/10/19.
//  Copyright © 2019 Kalpesh Talkar. All rights reserved.
//

import Foundation

@objc class Taxi: NSObject {
    
    @objc public var id: Int = 0
    @objc public var coordinate: Coordinate? = nil
    @objc public var fleetType: String? = nil
    @objc public var heading: Double = 0
    
    init(json: JSONObject) {
        if let value = json["id"] as? Int {
            id = value
        }
        if let value = json["coordinate"] as? JSONObject {
            coordinate = Coordinate(json: value)
        }
        if let value = json["fleetType"] as? String {
            fleetType = value
        }
        if let value = json["heading"] as? Double {
            heading = value
        }
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let taxi = object as? Taxi {
            return taxi.id == id
        }
        return false
    }

}

@objc extension Taxi {
    
    @objc func getHeadingDirection() -> String {
        // Reference 1: http://snowfence.umn.edu/Components/winddirectionanddegreeswithouttable3.htm
        // Reference 2: https://stackoverflow.com/questions/48118390/how-to-use-swift-to-convert-direction-degree-to-text
        let directions = ["North", "North East", "East", "South East", "South", "South West", "West", "North West"]
        let index = Int((heading + 22.5) / 45.0) & 7
        return directions[index]
    }
    
}
