//
//  Coordinate.swift
//  mytaxi
//
//  Created by Kalpesh Talkar on 02/10/19.
//  Copyright © 2019 Kalpesh Talkar. All rights reserved.
//

@objc class Coordinate : NSObject {
    
    var latitude: Double = 0
    var longitude: Double = 0
    
    init(json: JSONObject) {
        if let value = json["latitude"] as? Double {
            latitude = value
        }
        if let value = json["longitude"] as? Double {
            longitude = value
        }
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let coordinate = object as? Coordinate {
            return coordinate.latitude == latitude && coordinate.longitude == longitude
        }
        return false
    }
    
    override var description: String {
        return "\(latitude),\(longitude)"
    }

}

import MapKit

extension Coordinate {
    
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    func locationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}
