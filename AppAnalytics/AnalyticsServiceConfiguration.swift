//
//  AnalyticsConfiguration.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/18/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import Foundation

/**
 Analytics service configuration
 
 - Parameter environment: Network environment configuration (production, stage, local)
 
 - Parameter tokeBucketRefreshIntervalInSeconds: Refresh interval for TokenBucket tokens
 - Parameter tokenBucketTokensPerInterval: Interval in seconds that the TokenBucket refreshes
 - Parameter tokenBucketCapacity: Maximum capacity of the TokenBuck in tokens
 - Parameter tokenBucketInitialTokenCount: Initial token amount in the TokenBucket
 
 ## Notes on TokenBucket and event dispatch to the network:
 
 **reccomended configuration** :
 - tokeBucketRefreshIntervalInSeconds = 1 second
 - tokenBucketTokensPerInterval = 5
 - tokenBucketCapacity = 30
 - tokenBucketInitialTokenCount = 2
 
 Analytics Services utilizes a TokenBucket (simple algorithm used for rate-limiting events and shaping network traffic)
 
 The benefit of using a TokenBucket is that it does not require any system level timers to manage the dispatching of events to the network. When the system wants to send an event it first checks the TokenBucket to see if it has enough tokens to to do this. If not then then the event must wait for the TokenBucket to be refreshed the token refresh is determined by the `tokensPerInterval` and the `tokeBucketRefreshIntervalInSeconds`. the tokenBucket is checked for potential refresh every time the system requests a `tokenCount` which occurs every time a `dispatchAnalyticEvent` occurs. There is an additional flush request that happens at startup.
 
 Every `dispatchAnalyticEvent` will trigger a `flush` request that will request events oldest first and dispatch them to the network as the accumulated tokens permit, in this way events are dispatched FIFO style and will not overwhelm the network with a large body of network requests.
 
 References:
 - https://en.wikipedia.org/wiki/Token_bucket
 
 */
public struct AnalyticsServiceConfiguration {
    
    public enum Environment {
        case local
        case stage
        case production
    }
    
    let environment: Environment
    
    let scheme:String   // "http",
    let host:String     // "localhost",
    let port:Int?        // 8080
    
    let tokeBucketRefreshIntervalInSeconds: TimeInterval
    let tokenBucketTokensPerInterval: Int
    let tokenBucketCapacity: Int
    let tokenBucketInitialTokenCount: Int
    
    let enableAppleIDFA:Bool
    let enableAppleIDFV:Bool
    let enableCrashReporting:Bool
    let enableAppleSKAdNetwork:Bool
    
    public init(
        environment:Environment,
        scheme:String,
        host:String,
        port:Int?,
        tokeBucketRefreshIntervalInSeconds: TimeInterval,
        tokenBucketTokensPerInterval: Int,
        tokenBucketCapacity: Int,
        tokenBucketInitialTokenCount: Int,
        enableAppleIDFA: Bool,
        enableAppleIDFV: Bool,
        enableCrashReporting: Bool,
        enableAppleSKAdNetwork: Bool
    ) {
        self.environment = environment
        self.scheme = scheme
        self.host = host
        self.port = port
        self.tokeBucketRefreshIntervalInSeconds = tokeBucketRefreshIntervalInSeconds
        self.tokenBucketTokensPerInterval = tokenBucketTokensPerInterval
        self.tokenBucketCapacity = tokenBucketCapacity
        self.tokenBucketInitialTokenCount = tokenBucketInitialTokenCount
        self.enableAppleIDFA = enableAppleIDFA
        self.enableAppleIDFV = enableAppleIDFV
        self.enableCrashReporting = enableCrashReporting
        self.enableAppleSKAdNetwork = enableAppleSKAdNetwork
    }
    
    public static var defaultLocalConfiguration: AnalyticsServiceConfiguration {
        return AnalyticsServiceConfiguration(
            environment: .local,
            scheme: "http",
            host: "localhost",
            port: 8080,
            tokeBucketRefreshIntervalInSeconds: 1.0,
            tokenBucketTokensPerInterval: 5,
            tokenBucketCapacity: 20, // 30 is correct , 5 for testing
            tokenBucketInitialTokenCount:2,
            enableAppleIDFA: false,
            enableAppleIDFV: true,
            enableCrashReporting: true,
            enableAppleSKAdNetwork: false
        )
    }
    
}

