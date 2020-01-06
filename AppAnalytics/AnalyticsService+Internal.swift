//
//  AnalyticsService+internal.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/19/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import Foundation

// MARK: vapor configuration
extension AnalyticsService {
    
    /// internal Vapor Network Environment, configured via `AnalyticsConfiguration` on start
    internal enum NetworkEnvironment {
        
        /**
         Examples
         scheme: "http", "https"
         host: "localhost", "yack-yack-57526.herokuapp.com"
         port: nil, 8080
         */
        case local( scheme:String, host:String, port:Int?)
        case stage( scheme:String, host:String, port:Int?)
        case production( scheme:String, host:String, port:Int?)
        
        /// description example : "local", "stage", "production"
        public var description:String {
            switch self {
            case .local: return "local"
            case .stage: return "stage"
            case .production: return "production"
            }
        }
        
        // rootURL fully composed root url example: "http://github.com:8080/" note the tailing "/"
        internal var getRootURL:String {
            var components = URLComponents()
            components.scheme = AnalyticsService.shared().environment.URLScheme //"https"
            components.host = AnalyticsService.shared().environment.URLHost // "api.github.com"
            components.port = AnalyticsService.shared().environment.URLPort
            components.path = "/"
            let url = components.url!
            return url.absoluteString
        }
        
        /// URLScheme component example: "https"
        internal var URLScheme:String {
            switch self {
            case .local ( let scheme, _, _ ): return scheme
            case .stage ( let scheme, _, _ ): return scheme
            case .production ( let scheme, _, _ ): return scheme
            }
        }
        
        /// URLHost component Example: "localhost" or "lit-oasis-33333.herokuapp.com"
        internal var URLHost:String {
            switch self {
            case .local ( _, let host, _ ): return host
            case .stage ( _, let host, _ ): return host
            case .production ( _, let host, _ ): return host
            }
        }
        
        /// optional URLPort component examle: 8080, nil
        internal var URLPort:Int? {
            switch self {
            case .local ( _, _, let port ): return port
            case .stage ( _, _, let port ): return port
            case .production ( _, _, let port ): return port
            }
        }
    }
}

extension AnalyticsService {
    
    /// tokenCount from the internal tokenBucket
    internal var tokenCount:Int {
        return tokenBucket.tokenCount
    }
}

extension AnalyticsService {
    
    /// start the flush service, default wait is 2.5 seconds
    internal func triggerLocalDataFlush(seconds:TimeInterval = 2.5) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // first check the network connection
            AnalyticsService.shared().attemptToFlushLocalData()
        }
    }
    
    /// Attempt to flush the local data by sending it to the server. This method is rate limited by the tokenBucket and will early out if there are 0 tokens in the bit bucket
    internal func attemptToFlushLocalData() {
        // print( "tokenBucket.tokenCount: \(tokenBucket.tokenCount)")
        if (tokenBucket.tokenCount > 0) {
            // MAS TODO check for network connection first
            AnalyticsService.shared().flushLocalEventsToServer()
        } else {
            //print( "skip the flush we dont have enough tokens")
        }
    }
}

// MARK: - flushLocalEventsToServer
extension AnalyticsService {
    
    /// flushLocalEventsToServer utilizes the tokenBucket for throttling.
    
    internal func flushLocalEventsToServer() {
        flushLocalEventsToServerMain()
        // flushLocalEventsToServerBackground()
    }
    
    internal func flushLocalEventsToServerMain() {
        
        // Thread.printCurrent("flushLocalEventsToServerMain")
        
        // MAS TODO do this off of the main thread ...
        let localEvents = CoreDataManager.shared.fetchLocalEventsOldestFirst()
        
        for (_,event) in localEvents.enumerated() {
            // print( "tokenBucket.tokenCount: \(tokenBucket.tokenCount)")
            if tokenBucket.tokenCount > 0 {
                // MAS TODO this needs to be spun out in an asyc thread
                //tokenBucket.consume(1)
                if (tokenBucket.tryConsumeBlocking(1, until: Date().addingTimeInterval(0.1))) {
                    // print( "sending event \(event.name ?? "~")")
                    ServerDispatchServices.sendEventToServerAndDeleteFromCoreData(event)
                }
            } else {
                //print( "tokenBucket is empty, must try again later")
            }
        }
    }
}


import CoreData

extension AnalyticsService {
    
    internal func flushLocalEventsToServerBackground() {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            // Thread.printCurrent("flushLocalEventsToServerBackground")
            
            // background request
            let context = CoreDataManager.shared.backgroundContext
            let fetchRequest = NSFetchRequest<CoreDataLocalEvent>(entityName: "CoreDataLocalEvent")
            let sort = NSSortDescriptor(key: "dispatchTime", ascending: true)
            fetchRequest.sortDescriptors = [sort]
            
            let localEvents:[CoreDataLocalEvent]
            do{
                let models = try context.fetch(fetchRequest)
                localEvents = models
            }catch let fetchErr {
                print("❌ Failed to fetch Person:",fetchErr)
                localEvents = []
            }
            
            print( "localEvents \(localEvents.count)")
            
            for (_,event) in localEvents.enumerated() {
                
                print( "event \(event.name ?? "~")")
//                // print( "tokenBucket.tokenCount: \(tokenBucket.tokenCount)")
//                if self.tokenBucket.tokenCount > 0 {
//                    // MAS TODO this needs to be spun out in an asyc thread
//                    //tokenBucket.consume(1)
//                    if (self.tokenBucket.tryConsumeBlocking(1, until: Date().addingTimeInterval(0.1))) {
//                        // print( "sending event \(event.name ?? "~")")
//                        ServerDispatchServices.sendEventToServerAndDeleteFromCoreData(event)
//                    }
//                } else {
//                    //print( "tokenBucket is empty, must try again later")
//                }
            }
            
            
            
//          for address in [PhotoURLString.overlyAttachedGirlfriend,
//                          PhotoURLString.successKid,
//                          PhotoURLString.lotsOfFaces] {
//            let url = URL(string: address)
//
//            downloadGroup.enter()
//            let photo = DownloadPhoto(url: url!) { _, error in
//              if error != nil {
//                storedError = error
//              }
//              downloadGroup.leave()
//            }
//            PhotoManager.shared.addPhoto(photo)
//          }
//          downloadGroup.wait()

//          DispatchQueue.main.async {
//            completion?(storedError)
//          }
        }
    }
    
}

//struct AccessToken {
//    let count:Int
//    var isValid:Bool {
//        return true
//    }
//}
//
//class BackgroundService {
//    
//    typealias Handler = (Result<AccessToken>) -> Void
//    
////    private let loader: AccessTokenLoader
//    private let queue: DispatchQueue
//    private var token: AccessToken?
//    private var pendingHandlers = [Handler]()
//    
//    init(
////        loader: AccessTokenLoader,
//         queue: DispatchQueue = .init(label: "BackgroundService")
//    ) {
////        self.loader = loader
//        self.queue = queue
//    }
//
////    func retrieveToken(then handler: @escaping Handler) {
////        queue.async { [weak self] in
////            self?.performRetrieval(with: handler)
////        }
////    }
//    
//    func retrieveToken(then handler: @escaping Handler) {
//        if let token = token, token.isValid {
//            return handler(.value(token))
//        }
//
//        pendingHandlers.append(handler)
//
//        // We'll only start loading if the current handler is
//        // alone in the array after being inserted.
//        guard pendingHandlers.count == 1 else {
//            return
//        }
//
////        loader.load { [weak self] result in
////            self?.handle(result)
////        }
//    }
//    
//}

//private extension BackgroundService {
//
//    func handle(_ result: Result<AccessToken>) {
//        token = result.value
//
//        let handlers = pendingHandlers
//        pendingHandlers = []
//        handlers.forEach { $0(result) }
//    }
//
//}

