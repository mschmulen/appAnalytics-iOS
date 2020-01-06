//
//  ServerEventDetailView.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/17/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import SwiftUI
import CoreData

@available(iOS 13.0, *)
public struct ServerEventDetailView: View {
    
    var model: EventServerViewModel
    
    public var header: some View {
        Group {
            Text("Event Detail").font(.largeTitle)
        }
    }
    
//    public var content: some View {
//        Group {
//            Text("name: \(String(describing:model.name))")
//                .font(.body)
//            Text("creationTime: \(String(describing:model.creationTime))")
//                .font(.body)
//            Text("IDFV: \(String(describing:model.appleIdentifierForVendor))")
//                .font(.body)
//
//            Text("appIdentifier: \(String(describing:model.appIdentifier))")
//            .font(.body)
//            Text("appVersion: \(String(describing:model.appVersion))")
//            .font(.body)
//            Text("appBuildNumber: \(String(describing:model.appBuildNumber))")
//            .font(.body)
//
//            Text("protectedMetaData: \(String(describing:model.protectedMetaData))")
//            .font(.body)
//            Text("appMetaData: \(String(describing:model.appMetaData))")
//            .font(.body)
//        }
//    }//end Content

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
        }//end Group
    }//end operations
    
    public var listView: some View {
           List {
               Section(header:Text("Info")) {
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
            
            Section(header:Text("metaData")) {
                Text("protectedMetaData: \(String(describing:model.protectedMetaData))")
                    .font(.body)
                Text("appMetaData: \(String(describing:model.appMetaData))")
                    .font(.body)
            }
            
           }//end List
            .listStyle(GroupedListStyle())
       }// end listView
    
//    public var body: some View {
////        NavigationView {
//            VStack(alignment: .leading, spacing: 2) {
//                operations
//                header
//                content
//                Spacer()
//            }//end VStack
////        }//end NavigationView
////            .navigationBarTitle(Text("Event Detail"))
//        .onAppear {
//            AnalyticsService.dispatchAnalyticEvent(.viewDidAppear(viewName: "ServerEventDetailView"))
//        }
//    }//end body
    
    public var body: some View {
        NavigationView {
            listView
        }//end NavigationView
            .navigationBarTitle(Text("Event Details"))
        .onAppear {
            AnalyticsService.dispatchAnalyticEvent(.viewDidAppear(viewName: "ServerEventDetailView"))
        }
    }//end body
    
}

