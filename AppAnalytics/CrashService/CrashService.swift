//
//  AnalyticsService+CrashReporting.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/16/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import Foundation
import UIKit

// MARK: - GLOBAL VARIABLE
private var app_old_exceptionHandler:(@convention(c) (NSException) -> Swift.Void)? = nil

/// Crash Service
class CrashService {
    
    /**
     startCrashReporting
     
     References:
     - [x] https://stackoverflow.com/questions/25441302/how-should-i-use-nssetuncaughtexceptionhandler-in-swift
     - [x] https://forums.developer.apple.com/thread/114812
     - [x] https://forums.developer.apple.com/thread/113742
     - https://programming.vip/docs/capture-of-ios-swift-crash.html
     
     Vendor References:
     - Rollbar https://rollbar.com/blog/ios-error-monitoring/
     - Rollbar https://github.com/rollbar/rollbar-ios
     
     Project references:
     - https://github.com/zixun/CrashEye/blob/master/CrashEye/Classes/CrashEye.swift
     - https://github.com/xiaoyi6409/XYCrashManager
     
     Misc Notes:
     
     EXC_BAD_INSTRUCTION is also known as SIGILL (illegal instruction signal), and is actually a signal, something like a hardware interrupt, not an exception.  If you want to handle these signals, you need to go into C-land and set up a signal handler, and using something like sigaction(2) set up the handler to handle the signal.  If you look through the man pages on signaction (2), kill (2), etc., you'll get a feel for signals and signal handling.  The default handler prints the signal name, other diagnostic info, then terminates the process, as you have observed.
     
     */
    public class func startCrashReporting() {
        
        app_old_exceptionHandler = NSGetUncaughtExceptionHandler()
        NSSetUncaughtExceptionHandler(CrashService.RecieveException)
        self.setCrashSignalHandler()
        
        //        // check if a crash already exists from previous session
        //        if let exception = UserDefaults.standard.object(forKey: "ExceptionHandler") as? [String] {
        //            print("!!! Error occured on previous session! \n", exception, "\n\n")
        //            var exceptions = ""
        //            for e in exception {
        //                exceptions = exceptions + e + "\n"
        //            }
        //            print( "!!! MAS TODO Send it to the server")
        //
        //            // remove it
        //            UserDefaults.standard.removeObject(forKey: "ExceptionHandler")
        //            UserDefaults.standard.synchronize()
        //        }
    }
    
    /// stop crash reporting
    public class func stopCrashReporting() {
        NSSetUncaughtExceptionHandler(app_old_exceptionHandler)
    }
}

// MARK: Force crash/Exception
extension CrashService {
    
    public class func forceException() {
        print( "force exception")
        let exception = NSException(name: NSExceptionName(rawValue: "arbitrary"), reason: "arbitrary reason", userInfo: nil)
        exception.raise()
    }
    
    public class func forceCrashIndexOutOfRange() {
        let someArray = [1,2,3]
        let value = someArray[5]
        print( "value \(value)")
//        let names = ["matt", "mark", "jeff"]
//        let out = names[33]
    }
    
    public class func forceCrashForceUnwrap() {
        let yack:Int! = nil
        let a:Int = yack  + 33
        print( a )
    }
    
    public class func forceKillApp() {
        CrashService.killApp()
    }
    
    private class func killApp(){
        NSSetUncaughtExceptionHandler(nil)
        
        signal(SIGABRT, SIG_DFL)
        signal(SIGILL, SIG_DFL)
        signal(SIGSEGV, SIG_DFL)
        signal(SIGFPE, SIG_DFL)
        signal(SIGBUS, SIG_DFL)
        signal(SIGPIPE, SIG_DFL)
        
        kill(getpid(), SIGKILL)
    }
    
}

// MARK: crash reporting
extension CrashService {
    
    private static let RecieveException: @convention(c) (NSException) -> Swift.Void = {
        (exception) -> Void in
        if (app_old_exceptionHandler != nil) {
            app_old_exceptionHandler!(exception);
        }
        
        // let callStackReturnAddressesNSNumber = exception.callStackReturnAddresses //[NSNumber]
        // let callStackReturnAddresses = "\(callStackReturnAddressesNSNumber)"
        let callStackReturnAddresses = "[]"
        
        let callStack = exception.callStackSymbols.joined(separator: "\r")
        let reason = exception.reason ?? "~"
        let name = exception.name
        
        let model = CrashModel(type:CrashModel.CrashType.exception,
                               name:name.rawValue,
                               reason:reason,
                               callStack:callStack,
                               callStackReturnAddresses:callStackReturnAddresses
        )
        
        didCatchCrash(with:model)
    }
    
    private static let RecieveSignal : @convention(c) (Int32) -> Void = {
        (signal) -> Void in
        
        var stack = Thread.callStackSymbols
        stack.removeFirst(2)
        let callStackReturnAddresses = "[]"
        let callStack = stack.joined(separator: "\r")
        let reason = "Signal \(CrashService.name(of: signal))(\(signal)) was raised.\n"
        
        let model = CrashModel(type:CrashModel.CrashType.signal,
                               name:CrashService.name(of: signal),
                               reason:reason,
                               callStack:callStack,
                               callStackReturnAddresses: callStackReturnAddresses
        )
        
        didCatchCrash(with:model)
        
        // MAS TODO Dispatch or cach this so as to report it later
        CrashService.killApp()
    }
    
    private class func name(of signal:Int32) -> String {
        switch (signal) {
        case SIGABRT:
            return "SIGABRT"
        case SIGILL:
            return "SIGILL"
        case SIGSEGV:
            return "SIGSEGV"
        case SIGFPE:
            return "SIGFPE"
        case SIGBUS:
            return "SIGBUS"
        case SIGPIPE:
            return "SIGPIPE"
        default:
            return "OTHER"
        }
    }
    
    private class func appInfo() -> String {
        let displayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") ?? ""
        let shortVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? ""
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") ?? ""
        let deviceModel = UIDevice.current.model
        let systemName = UIDevice.current.systemName
        let systemVersion = UIDevice.current.systemVersion
        return "App: \(displayName) \(shortVersion)(\(version))\n" +
            "Device:\(deviceModel)\n" + "OS Version:\(systemName) \(systemVersion)"
    }
    
    private class func setCrashSignalHandler(){
        signal(SIGABRT, CrashService.RecieveSignal)
        signal(SIGILL, CrashService.RecieveSignal)
        signal(SIGSEGV, CrashService.RecieveSignal)
        signal(SIGFPE, CrashService.RecieveSignal)
        signal(SIGBUS, CrashService.RecieveSignal)
        signal(SIGPIPE, CrashService.RecieveSignal)
        //http://stackoverflow.com/questions/36325140/how-to-catch-a-swift-crash-and-do-some-logging
        signal(SIGTRAP, CrashService.RecieveSignal)
    }
    
    private class func didCatchCrash(with model:CrashModel) {
        
        // Save the crash data to coreData ... this may not be a good idea.
        CoreDataManager.shared.createCrashEvent(
            type: model.type.description,
            name: model.name,
            reason: model.reason,
            callStack: model.callStack,
            dispatchTime: Date()
        )
        
        // Note it may be better to save it to the UserDefaults instead of Core Data
        //            //save it to the user defaults
        //            UserDefaults.standard.set(exception.callStackSymbols, forKey: "ExceptionHandler")
        //            UserDefaults.standard.synchronize()

        
        
        // MAS TODO
        //        let crashInfoModel = CrashInfoModel(
        //            type: .exception,
        //            name: model.name,
        //            reason: model.reason,
        //            appinfo: model.appinfo,
        //            callStack: model.callStack)
        //        print( "dispatch \(crashInfoModel)")
        
        // MIS Notes https://stackoverflow.com/questions/36325140/how-to-catch-a-swift-crash-and-do-some-logging
        
        //        NSSetUncaughtExceptionHandler only catches uncaught exceptions which is only a small subset of possible crashes.
        
        //        Exceptions in Objective-C are defined to be fatal and it is not recommended to catch them and even more not recommended to run any non-async safe code, which includes any Objective-C and Swift code
        
        //        To catch crashes you need to setup signal handlers and then only run async-safe code at the time of the crash, which is only a small subset of C. Especially you may not allocate new memory at crash time at all.
        
        //        Please remember, when your app crashed it is in a highly unstable code and object or variable references may point to something completely unexpected. So you really shouldn't do anything at crash time at all.
        
        //        The best open source way to work with crashes is using PLCrashReporter, which also provides method to invoke code at crash time. But again, this has to be async-safe.
        
    }
    
}
