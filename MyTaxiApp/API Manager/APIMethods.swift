//
//  APIMethods.swift
//  mytaxi
//
//  Created by Kalpesh Talkar on 02/10/19.
//  Copyright © 2019 Kalpesh Talkar. All rights reserved.
//

typealias TaxiListClosure = (_ taxiList: Array<Taxi>?, _ error: String?) -> Void

class APIMethods {
    
    static func searchTaxis(coordinate1: Coordinate, coordinate2: Coordinate, completion: TaxiListClosure?) {
        let request = APIRequest(url: API.taxiList, method: .get)
        request.parameters = JSONObject()
        request.parameters!["p1Lat"] = coordinate1.latitude
        request.parameters!["p1Lon"] = coordinate1.longitude
        request.parameters!["p2Lat"] = coordinate2.latitude
        request.parameters!["p2Lon"] = coordinate2.longitude
        APIManager.request(request) { (response, headers, error) in
            var taxiList = Array<Taxi>()
            if let json = response as? JSONObject {
                if let jsonArray = json["poiList"] as? JSONArray {
                    for taxiJson in jsonArray {
                        taxiList.append(Taxi(json: taxiJson))
                    }
                }
            }
            completion?(taxiList, error)
        }
    }
    
}
