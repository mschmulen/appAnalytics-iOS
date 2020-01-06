appAnalytics-iOS
---

Framework for self hosted iOS application analytics and simple crash reporting 

Companion server can be found at: [https://github.com/mschmulen/appAnalyticsServer](https://github.com/mschmulen/appAnalyticsServer) 




## Overview

The framework SDK leverages a local CoreData (sqlite) data store to hold analytics allowing for offline caching of events and bursts the analytics events to the server using a TokenBucket to throttle burst size and network consumption.  The basic `AnalyticEvent` `AnalyticEvent.viewDidAppear` or `AnalyticEvent.customEvent` can be used directly or the Application can create custom events by conforming to the `AnalyticEventProtocol` protocol.  Additionally the framework can be configured to also catch, cache and upload `CrashEvents` with stack trace information for crash signals and uncaught swift exceptions.  The framework leverages a local UUID for each crash event to prevent duplicate events from being entered into the Analytics server side data store and also to insure that events are not removed from the local device storage until a server confirmation is recieved by the client.

If the host application integrates the appropriate `applicationDidBecomeActive`, `applicationWillResignActive`, etc. The service will automatically report lifecycle events

```
didFinishLaunchingWithOptions
applicationDidBecomeActive
applicationWillResignActive
applicationDidEnterBackground
applicationWillEnterForeground
applicationWillTerminate
applicationDidReceiveMemoryWarning
```

## Getting started 

1. `git clone git@github.com:mschmulen/appAnalytics-iOS.git`
1. `cd appAnalytics-iOS`
1. `open AppAnalytics.xcodeproj/`
1. run or deploy companion server 
1. run the sample app

## Sample SwiftUI App with localhost server 

Demo and test app for testing swift analytics, configured to use `localhost` make sure and run the Companion server can be found at: 

1. Start the local companion server:  [https://github.com/mschmulen/appAnalyticsServer](https://github.com/mschmulen/appAnalyticsServer)
1. Select the `AnalyticsSwiftUIExample` build target 
1. Compile and run in the local simuation

## Usage

In the AppDelegate `didFinishLaunchingWithOptions` initialize the AnalyticsService

```
let analyticsServiceConfig = AnalyticsServiceConfiguration.defaultLocalConfiguration
AnalyticsService.start(config: analyticsServiceConfig)
_ = AnalyticsService.shared().application(application, didFinishLaunchingWithOptions: launchOptions)
```

Dispatch an event:

```
AnalyticsService.dispatchAnalyticEvent(.viewDidAppear(viewName: "HomeView"))
```

## Developer Notes:

#### Note about the TokenBucket

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

#### Note about threading 

TODO


#### Note about configuration 

TODO



#### Documentation Notes

install jazzy with:

`[sudo] gem install jazzy`

update `docs` with:

`jazzy --min-acl internal --no-hide-documentation-coverage --theme fullwidth --output ./docs --documentation=./*.md`



