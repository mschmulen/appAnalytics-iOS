//
//  VaporNetworkService+Filterable.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/18/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

//import Foundation
//
///// IDFAQueryableProtocol
//public protocol FilterableProtocol {
//}
//
//extension VaporAnalyticEventModel:FilterableProtocol {
//    
//}
//
//// MARK: - IDFAQueryableProtocol
//extension VaporNetworkService where T : FilterableProtocol {
//    
//    /**
//     Fetch a list of models with an upper limit and a specific sort
//     - Parameter limit: limit count
//     - Parameter page: page count
//     - Parameter search: search term
//     - Parameter withCompletion: completion handler
//     
//     GET http://localhost:8080/events/XXXXXXX?limit=20&page=10
//     
//     // TODO get IDFV
//     GET http://localhost:8080/events/XXXXXXX?limit=20&page=10
//     
//     */
//    func customFetch(limit: Int, page: Int, appleIdentifierForVendor:String?, appIdentifier:String?, appVersion:String?, withCompletion completion: @escaping ([T]?) -> Void) {
//        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
//        
//        var components = URLComponents()
//        components.scheme = AnalyticsService.shared().environment.URLScheme
//        components.host = AnalyticsService.shared().environment.URLHost
//        components.port = AnalyticsService.shared().environment.URLPort
//        components.path = "/\(T.endpointRouteURL)"
//        components.queryItems = [
//            URLQueryItem(name: "limit", value: "\(limit)"),
//            URLQueryItem(name: "page", value: "\(page)")
//        ]
//        if let appleIdentifierForVendor = appleIdentifierForVendor {
//            components.queryItems?.append(
//                URLQueryItem(name: "appleIdentifierForVendor", value: "\(appleIdentifierForVendor)")
//            )
//        }
//
//        if let appIdentifier = appIdentifier {
//            components.queryItems?.append(
//                URLQueryItem(name: "appIdentifier", value: "\(appIdentifier)")
//            )
//        }
//        
//        if let appVersion = appVersion {
//            components.queryItems?.append(
//                URLQueryItem(name: "appVersion", value: "\(appVersion)")
//            )
//        }
//
//        
////        components.queryItems = [
////            URLQueryItem(name: "appleIdentifierForVendor", value: "\(appleIdentifierForVendor)"),
////        ]
//        
//        let url = components.url!
//        
//        // GET http://localhost:8080/events/XXXXXXX?limit=5&page=0
//        // serverApps.count 6
//        
//        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
//            guard let data = data else {
//                completion(nil)
//                return
//            }
//            
//            // let debugJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//            // print(debugJSON)
//            
//            let models = try? JSONDecoder().decode([T].self, from: data)
//            completion(models)
//        })
//        task.resume()
//    }//end fetch with limit
//    
//} //end VaporNetworkService
