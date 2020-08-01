//
//  APIConstants.swift
//
//  Created by Kalpesh on 6/1/17.
//  Copyright © 2017 Kalpesh Talkar. All rights reserved.
//

enum Environment {
    case Development
    case Production
}

let environment = Environment.Production

struct API {
    
    // Domain
    static let PRODUCTION_DOMAIN = "https://fake-poi-api.mytaxi.com/"
    static let DEVELOPMENT_DOMAIN = "https://fake-poi-api.mytaxi.com/"
    
    
    // Current Domain
    static func getDomain() -> String {
        switch environment {
        case .Development:
            return DEVELOPMENT_DOMAIN
        case .Production:
            return PRODUCTION_DOMAIN
        }
    }
    
    static func getURLPrefix() -> String {
        return getDomain() + "api/"
    }
    
    // Endpoints
    static let taxiList = getDomain()
    
}
