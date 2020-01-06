//
//  VaporNetworkService+pageable.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/18/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import Foundation

/// PageableProtocol, identifying model requests that support paging
public protocol PageableProtocol {
}

//// MARK: - AppQueryAbleProtocol
extension VaporNetworkService where T : PageableProtocol {

    /**
     Fetch a list of models with an upper limit and a specific sort
     - Parameter limit: limit count
     - Parameter page: page count
     - Parameter withCompletion: completion handler
     
     GET http://localhost:8080/events?limit=20&page=10
     */
    func pagableFetch(limit:Int, page:Int, withCompletion completion: @escaping ([T]?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        
        var components = URLComponents()
        components.scheme = AnalyticsService.shared().environment.URLScheme
        components.host = AnalyticsService.shared().environment.URLHost
        components.port = AnalyticsService.shared().environment.URLPort
        components.path = "/\(T.endpointRouteURL)"
        components.queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        let url = components.url!
        
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

