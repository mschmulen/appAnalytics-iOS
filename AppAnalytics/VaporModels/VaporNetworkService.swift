//
//  NetworkService.swift
//

import Foundation

/**
 VaporNetworkService
 */
internal class VaporNetworkService<T:VaporModel> {
    
    /// initializer
    public init() { }
    
    /**
    createGeneric post a model to the server
    - Parameter model: model
    - Parameter withCompletion: completion callback
    */
    public func createGeneric( model:T, withCompletion completion: @escaping (T?, Error?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        
        var components = URLComponents()
        components.scheme = AnalyticsService.shared().environment.URLScheme //"https"
        components.host = AnalyticsService.shared().environment.URLHost // "api.github.com"
        components.port = AnalyticsService.shared().environment.URLPort
        components.path = "/\(T.endpointRouteURL)"
        let url = components.url!
        
        guard let httpBody = try? JSONEncoder().encode(model) else {
            // MAS TOOD handle the error case here 
            completion(nil, nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                do {
                    // let json = try JSONSerialization.jsonObject(with: data, options: [])
                    // print(json)
                    let model = try JSONDecoder().decode(T.self, from: data)
                    completion(model, nil)
                } catch {
                    print(error)
                    completion(nil, error)
                }
            }
        }
        // task.priority = URLSessionTask.lowPriority
        task.resume()
    }//end createGeneric
    
    /**
     fetch a list of models
     - Parameter withCompletion: completion handler
     */
    public func fetch(withCompletion completion: @escaping ([T]?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        
        var components = URLComponents()
        components.scheme = AnalyticsService.shared().environment.URLScheme //"https"
        components.host = AnalyticsService.shared().environment.URLHost // "api.github.com"
        components.port = AnalyticsService.shared().environment.URLPort
        components.path = "/\(T.endpointRouteURL)"
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
        // task.priority = URLSessionTask.lowPriority
        task.resume()
    }//end loadGeneric
}


