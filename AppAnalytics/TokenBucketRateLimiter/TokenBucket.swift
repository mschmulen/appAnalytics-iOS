//
//  TokenBucket.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/12/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import Foundation

/**
 Token Bucket
 
 A Token bucket is a simple algorithm used for rate-limiting events and shaping network traffic

 Notes:
 The benefit of using a TokenBucket is that it does not require any system level timers to manage the dispatching of events to the network. When the system wants to send an event it first checks the token bucket to see if it has enough tokens to to do this. If not then then the event must wait for the buck to be refreshed the token refresh is determined by the `tokensPerInterval` and the `interval`. the tokenBucket is checked for potential refresh every time the system requests a `tokenCount`.
 
 For the Analytics usage the `tokenCount` is checked everytime an event is posted to the local storage via the `dispatchAnalyticEvent` call. Every `dispatchAnalyticEvent` will trigger a `flush` request that will request events oldest first and dispatch them to the network as the accumulated tokens permit, in this way events are dispatched FIFO style and will not overwhelm the network with a large body of network requests.
 
 References:
 
 - https://en.wikipedia.org/wiki/Token_bucket
 - https://pfandrade.me/blog/rate-limiting-using-a-token-bucket-in-swift/
 - https://github.com/pfandrade/TokenBucket
 - https://github.com/nuclearace/SwiftRateLimiter
 
 - https://www.juniper.net/documentation/en_US/junos/topics/concept/policer-algorithm-single-token-bucket.html
 
 - https://dzone.com/articles/detailed-explanation-of-guava-ratelimiters-throttl
 
 */
internal class TokenBucket {
    
    /// capacity
    public let capacity: Int

    /// private replenish interval in seconds
    public private(set) var replenishingInterval: TimeInterval
    
    /// private tokens per interval
    public private(set) var tokensPerInterval: Int

    /// private last replenish date
    private var lastReplenished: Date
    
    /// private condition to wait until the desired tokens are available.
    private let condition = NSCondition()
    
    /// private tokenCount
    private var _tokenCount: Int
    
    /// get the current token count, also triggers a replenish
    public var tokenCount: Int {
        
        // Thread.printCurrent("tokenCount")
        
        // MAS TODO Note be carefull with this as it can be accessed from multiple threads
        // queue.sync{
            replenish()
            return _tokenCount
        //}
    }
    
    // DispatchQueue for async callback
    //private let queue: DispatchQueue
    
    /**
     TokenBucket initializer
     - Parameter capacity: number of tokens in the bucket
     - Parameter tokensPerInterval: tokens refreshed per interval
     - Parameter interval: interval in seconds the tokens will be replenished.
     - Parameter initialTokenCount: inital token couunt
     
     Note this is a really poor implimentation because its locking the main thread ... you should do something about this
     */
    public init(
        capacity: Int,
        tokensPerInterval: Int,
        interval: TimeInterval,
        initialTokenCount: Int = 0
    ) {
        guard interval > 0.0 else {
            fatalError("interval must be a positive number")
        }
        self.capacity = capacity
        self.tokensPerInterval = tokensPerInterval
        self.replenishingInterval = interval
        self._tokenCount = min(capacity, initialTokenCount)
        self.lastReplenished = Date()
        
        // self.queue = .main
        // self.queue = DispatchQueue(label: "TokenBucketQueue")
    }
    
    /// consumer will wait indefinitely for the desired tokens to become available
    public func consumeBlocking(_ count: Int) {
        guard count <= capacity else {
            fatalError("Cannot consume \(count) amount of tokens on a bucket with capacity \(capacity)")
        }
        let _ = tryConsumeBlocking(count, until: Date.distantFuture)
    }
    
    /// try and consume within a given amount of time for the tokens to become available
    public func tryConsumeBlocking(_ count: Int, until limitDate: Date) -> Bool {
        guard count <= capacity else {
            fatalError("Cannot consume \(count) amount of tokens on a bucket with capacity \(capacity)")
        }
        return wait(until: limitDate, for: count)
    }
    
    // MAS TODO async callback
    // reference https://github.com/nuclearace/SwiftRateLimiter 
    /// try and consume within a given amount of time for the tokens to become available
//    public func tryConsumeAsync(_ count: Int, after timeInterval: TimeInterval, callback: @escaping (Int) -> (Bool)) {
//        guard count <= capacity else {
//            fatalError("Cannot consume \(count) amount of tokens on a bucket with capacity \(capacity)")
//        }
//
//        // Used if we have to wait for more tokens
//        func createDispatchLater() {
//            queue.asyncAfter(deadline: DispatchTime.now() + timeInterval)) {
//                //self.removeTokens(count, callback: callback)
//                print( "dispatch later call")
//            }
//        }
//
//        guard count <= contains else {
//            return createDispatchLater()
//        }
//
//        contains -= count
//        callback(contains)
//    }
    
}

extension TokenBucket {
    
    /// replenish Note: Locks the requesting thread
    private func replenish() {
        condition.lock()
        // Thread.printCurrent("replenish")
        let ellapsedTime = abs(lastReplenished.timeIntervalSinceNow)
        if  ellapsedTime > replenishingInterval {
            let ellapsedIntervals = Int((floor(ellapsedTime / Double(replenishingInterval))))
            _tokenCount = min(_tokenCount + (ellapsedIntervals * tokensPerInterval), capacity)
            lastReplenished = Date()
            condition.signal()
        }
        condition.unlock()
    }
    
    /// wait Note: Locks the requesting thread
    private func wait(until limitDate: Date, for tokens: Int) -> Bool {
        replenish()
        condition.lock()
        // Thread.printCurrent("wait")
        
        defer {
            condition.unlock()
        }
        while _tokenCount < tokens {
            if limitDate < Date() {
                return false
            }
            DispatchQueue.global().async {
                self.replenish()
            }
            condition.wait(until: Date().addingTimeInterval(0.2))
        }
        _tokenCount -= tokens
        return true
    }

}

/*

 Usage:

 var dateBuffer: [Date] = []
 let dateQueue = DispatchQueue(label: "Date Buffer Writing Queue")
 let bucket = TokenBucket(capacity: 10, tokensPerInterval: 1, interval: 0.3)
 
 let globalQueue = DispatchQueue.global()
 var expectations: [XCTestExpectation] = []
 (0..<20).forEach { (i) in
     let expectation = self.expectation(description: "block \(i)")
     globalQueue.async {
         bucket.consume(1)
         dateQueue.sync {
             dateBuffer.append(Date())
         }
         expectation.fulfill()
     }
     expectations.append(expectation)
 }
 
 wait(for: expectations, timeout: 10.0)
 
 // there should be 20 dates on the buffers
 XCTAssertEqual(dateBuffer.count, 20)
 // spaced by roughly 0.3 seconds
 dateBuffer.enumerated().forEach { (idx, date) in
     guard idx > 0 else {
         return
     }
     XCTAssertEqual(date.timeIntervalSince(dateBuffer[idx-1]), 0.3, accuracy: 0.2)
 }
 */


/*

Usage Example:
 
let bucket = TokenBucket(capacity: 10, tokensPerInterval: 1, interval: 0.5)
XCTAssertEqual(bucket.tokenCount, 0)
XCTAssertFalse(bucket.tryConsume(1, until: Date().addingTimeInterval(0.01)))

// wait long enough for the first replenish
Thread.sleep(until: Date().addingTimeInterval(0.6))
// and try again
XCTAssertTrue(bucket.tryConsume(1, until: Date().addingTimeInterval(0.1)))
XCTAssertEqual(bucket.tokenCount, 0)
 
 
 */

