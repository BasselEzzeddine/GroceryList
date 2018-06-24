//
//  Configuration.swift
//  GroceryList
//
//  Created by Bassel Ezzeddine on 24/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

class Configuration: NSObject {
    
    // MARK: - Properties
    static let sharedInstance = Configuration()
    var properties: NSDictionary?
    
    // MARK: - NSObject
    override init() {
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as! String
        if let path = Bundle.main.path(forResource: currentConfiguration, ofType: "plist") {
            properties = NSDictionary(contentsOfFile: path)
        }
    }
    
    // MARK: - Methods
    func currencyEndpoint() -> String {
        return properties!.object(forKey: "currency_endpoint") as! String
    }
    
    func currencyEndpointKey() -> String {
        return properties!.object(forKey: "currency_endpoint_key") as! String
    }
}
