//
//  NetworkService.swift
//

import Foundation

// helpful references:
// https://developer.apple.com/documentation/foundation/url_loading_system/uploading_data_to_a_website

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
        task.resume()
    }//end loadGeneric
    
    /**
     Fetch a list of models with an upper limit and a specific sort
     - Parameter limit: limit count
     - Parameter page: page count
     - Parameter withCompletion: completion handler
     
     GET http://localhost:8080/events?limit=20&page=10
     
     pagination reference
     https://mihaelamj.github.io/Adding%20Pagination%20To%20Vapor%20Query/
     
     */
//    public func fetch(limit:Int, page:Int, withCompletion completion: @escaping ([T]?) -> Void) {
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
//        let url = components.url!
//
//        // GET http://localhost:8080/events?limit=20&page=10
//
//        // url http://localhost:8080/events?limit=5&page=0
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
    
}






        // -------------------------------

        //let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
        //        let task = session.uploadTask(with: request, from: uploadData) { data, response, error in
        //            if let error = error {
        //                print ("error: \(error)")
        //                return
        //            }
        //        }
        //        task.resume()
        
//        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
//            guard let data = data else {
//                completion(nil)
//                return
//            }
//            let model = try? JSONDecoder().decode(T.self, from: data)
//            completion(model)
//        })
//        task.resume()

    
//    public func updateGeneric( model:T, withCompletion completion: @escaping (T?) -> Void) {
//        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
//        let url = URL(string:T.endpointURL)!
//        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
//            guard let data = data else {
//                completion(nil)
//                return
//            }
//            let model = try? JSONDecoder().decode(T.self, from: data)
//            completion(model)
//        })
//        task.resume()
//    }
//
//    public func deleteGeneric( model:T, withCompletion completion: @escaping (T?) -> Void) {
//        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
//        let url = URL(string:T.endpointURL)!
//        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
//            guard let data = data else {
//                completion(nil)
//                return
//            }
//            let model = try? JSONDecoder().decode(T.self, from: data)
//            completion(model)
//        })
//        task.resume()
//    }

    // --------------------------------
    
    // let urlString = "http://localhost:8080/locations"
    // let urlString = "http://localhost:8080/weatherInfos"

//    public func fetch() {
//
//        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
//        let url = URL(string: urlString)!
//        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
//            // Parse the data in the response and use it
//        })
//        task.resume()
//    }
    
//    func loadWeatherInfo(withCompletion completion: @escaping ([WeatherInfo]?) -> Void) {
//        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
//        let url = URL(string:urlString)!
//        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
//            guard let data = data else {
//                completion(nil)
//                return
//            }
//            let models = try? JSONDecoder().decode([WeatherInfo].self, from: data)
//            completion(models)
//        })
//        task.resume()
//    }


