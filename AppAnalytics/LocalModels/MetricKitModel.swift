//
//  DeviceMetrics.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 1/9/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import UIKit
import MetricKit

/**
 MetricKitModel
 
 References:
 https://nshipster.com/metrickit/
 https://appspector.com/blog/metrickit
 https://github.com/apple/swift-metrics
*/
public struct MetricKitModel {
    
    /// identifier for vendor
    let appleIdentifierForVendor: String
    
    /// process payloads
    static func processPayloads( _ payloads: [MXMetricPayload] ) {
        print( " processPayloads: \(payloads)")
        
        for payload in payloads {
            
            print( "payload: \(payload)")
            
//            let url = URL(string: "https://example.com/collectMetrics")!
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.httpBody = payload.jsonRepresentation()
//
//            let task = URLSession.shared.dataTask(with: request)
//            task.priority = URLSessionTask.lowPriority
//            task.resume()
        }
        
    }
    
    /// make a AppInfoModel based on the current environment
    static func make() -> MetricKitModel {
        
        let device = UIDevice.current
        var appleIdentifierForVendor = "~"
        if let IDFV = device.identifierForVendor?.uuidString {
            appleIdentifierForVendor = IDFV
        }
        return MetricKitModel(
            appleIdentifierForVendor:appleIdentifierForVendor
        )
    }
    
    /// mock factory
    public static var mock: MetricKitModel {
        return MetricKitModel(
            appleIdentifierForVendor:"YACK"
        )
    }
    
}

