//
//  ServerCrashDetailView.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/18/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import SwiftUI
import CoreData

@available(iOS 13.0, *)
public struct ServerCrashDetailView: View {
    
    var model: CrashServerViewModel
    
    public var header: some View {
        Group {
            Text("Event Detail").font(.largeTitle)
        }
    }

//    public var content: some View {
//        Group {
//            Text("crashType: \(String(describing:model.crashType))")
//                .font(.body)
//            Text("name: \(String(describing:model.name))")
//                .font(.body)
//            Text("creationTime: \(String(describing:model.creationTime))")
//                .font(.body)
//            Text("IDFV: \(String(describing:model.appleIdentifierForVendor))")
//                .font(.body)
//            Text("appIdentifier: \(String(describing:model.appIdentifier))")
//                .font(.body)
//            Text("appVersion: \(String(describing:model.appVersion))")
//                .font(.body)
//            Text("appBuildNumber: \(String(describing:model.appBuildNumber))")
//                .font(.body)
//            Text("callStack: \(String(describing:model.callStack))")
//                .font(.body)
//        }
//    }
    
    public var listView: some View {
        List {
            Section(header:Text("Info")) {
                Text("crashType: \(String(describing:model.crashType))")
                    .font(.body)
                Text("name: \(String(describing:model.name))")
                    .font(.body)
                Text("creationTime: \(String(describing:model.creationTime))")
                    .font(.body)
                Text("IDFV: \(String(describing:model.appleIdentifierForVendor))")
                    .font(.body)
                Text("appIdentifier: \(String(describing:model.appIdentifier))")
                    .font(.body)
                Text("appVersion: \(String(describing:model.appVersion))")
                    .font(.body)
                Text("appBuildNumber: \(String(describing:model.appBuildNumber))")
                    .font(.body)
            }
            
            Section(header:Text("CallStack")) {
                ForEach( model.callStackPretty) { record in
                    VStack(alignment: .leading) {
                        Text("\(record.info)")
                            .font(.body)
                    }
                }//end ForEach
            }//end Section
        }//end List
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("Crash Detail"))
        
    }// end callStackContent
    
    
    public var operations: some View {
        Group {
                Button(action: {
                    print( "YACK")
                }) {
                    HStack {
                        Image(systemName: "plus.square.fill")
                            .foregroundColor(.green)
                            .imageScale(.large)
                        Text("YACK")
                    }
                }//end button
        }
    }//end operations
    
    public var body: some View {
        NavigationView {
            // header
            listView
        }//end NavigationView
            .navigationBarTitle(Text("Crash Detail"))
        .onAppear {
            AnalyticsService.dispatchAnalyticEvent(.viewDidAppear(viewName: "ServerCrashDetailView"))
        }
    }//end body
    
//        public var body: some View {
//    //        NavigationView {
//                VStack(alignment: .leading, spacing: 2) {
//    //                header
//                    listView
//    //                Spacer()
//                }//end VStack
//    //        }//end NavigationView
//    //            .navigationBarTitle(Text("Event Detail"))
//            .onAppear {
//                AnalyticsService.dispatchAnalyticEvent(.viewDidAppear(viewName: "DevServerEventDetailView"))
//            }
//        }//end body

    
}
