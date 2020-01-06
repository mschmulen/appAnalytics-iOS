//
//  DevLocalEventDetailView.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 10/18/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import SwiftUI
import CoreData

@available(iOS 13.0, *)
public struct DevLocalEventDetailView: View {
    
    var model: CoreDataLocalEvent
    
    public var header: some View {
        Group {
            Text("Event Detail (Local)").font(.largeTitle)
        }
    }
    
    public var content: some View {
        Group {
            Text("name: \(model.name ?? "~")")
                .font(.body)
            Text("dispatchTime: \(String(describing:model.dispatchTime))")
                .font(.body)
            Text("localDeviceEventUUID: \(String(describing:model.localDeviceEventUUID))")
                .font(.body)
            
            Text("appIdentifier: \(model.appIdentifier ?? "" )")
                .font(.body)
            Text("appVersion: \(model.appVersion ?? "" )")
                .font(.body)
            Text("appBuildNumber: \(model.appBuildNumber ?? "" )")
                .font(.body)
            
            Text("protectedMetaData: \(model.protectedMetaData ?? "" )")
                .font(.body)
            Text("appMetaData: \(model.appMetaData ?? "")")
                .font(.body)

            Text("appMetaData: \(model.appUserIdentifier ?? "")")
                .font(.body)
        }
    }
    
    public var operations: some View {
        Group {
            Button(action: {
                print( "Send event to server")
                ServerDispatchServices.sendEventToServerAndDeleteFromCoreData(self.model)
            }) {
                HStack {
                    Image(systemName: "plus.square.fill")
                        .foregroundColor(.green)
                        .imageScale(.large)
                    Text("Send to server")
                }
            }//end button
        }
    }//end operations
    
    public var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 2) {
                operations
                header
                content
                Spacer()
            }//end VStack
        }//end NavigationView
            .navigationBarTitle(Text("Event Detail"))
            .onAppear {
                AnalyticsService.dispatchAnalyticEvent(.viewDidAppear(viewName: "LocalDeviceEventDetailView"))
        }
    }//end body
}

