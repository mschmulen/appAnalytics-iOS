//
//  VaporNetworkService+IDFAQueryable.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/17/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import Foundation

/// IDFAQueryableProtocol
public protocol IDFVQueryableProtocol {
    var appleIdentifierForVendor:String { get }
}

// MARK: - IDFAQueryableProtocol
extension VaporNetworkService where T : IDFVQueryableProtocol {
    
    /**
     Fetch a list of models with an upper limit and a specific sort
     - Parameter limit: limit count
     - Parameter page: page count
     - Parameter search: search term
     - Parameter withCompletion: completion handler
     
     GET http://localhost:8080/events/XXXXXXX?limit=20&page=10
     
     // TODO get IDFV
     GET http://localhost:8080/events/XXXXXXX?limit=20&page=10
     
     */
    func customFetch(limit: Int, page: Int, appleIdentifierForVendor: String, withCompletion completion: @escaping ([T]?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        
        // MAS TODO deprecate the old way on the server
//        var components = URLComponents()
//        components.scheme = AnalyticsService.shared().environment.URLScheme
//        components.host = AnalyticsService.shared().environment.URLHost
//        components.port = AnalyticsService.shared().environment.URLPort
//        components.path = "/\(T.endpointRouteURL)/\(appleIdentifierForVendor)"
//        components.queryItems = [
//            URLQueryItem(name: "limit", value: "\(limit)"),
//            URLQueryItem(name: "page", value: "\(page)")
//        ]
//        let url = components.url!
        
        var components = URLComponents()
        components.scheme = AnalyticsService.shared().environment.URLScheme
        components.host = AnalyticsService.shared().environment.URLHost
        components.port = AnalyticsService.shared().environment.URLPort
        components.path = "/\(T.endpointRouteURL)"
        components.queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        components.queryItems?.append(
            URLQueryItem(name: "appleIdentifierForVendor", value: "\(appleIdentifierForVendor)")
        )
        let url = components.url!
        
        // GET http://localhost:8080/events/XXXXXXX?limit=5&page=0
        // serverApps.count 6
        
        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                completion(nil)
                return
            }
            
            // let debugJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            // print(debugJSON)
            
            let models = try? JSONDecoder().decode([T].self, from: data)
            completion(models)
        })
        task.resume()
    }//end fetch with limit
    
} //end VaporNetworkService




