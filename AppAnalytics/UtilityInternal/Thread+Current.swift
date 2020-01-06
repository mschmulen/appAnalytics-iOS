//
//  Thread+Current.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/20/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import Foundation

extension Thread {
    
    // printCurrent usage: `Thread.printCurrent()`
    internal class func printCurrent(_ message:String = "" ) {
        print("\r⚡️: \(Thread.current)\r" + "🏭: \(OperationQueue.current?.underlyingQueue?.label ?? "None") :\(message)\r")
    }
}

