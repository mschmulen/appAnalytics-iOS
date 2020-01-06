//
//  DevCrashEventDetailView.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/16/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import SwiftUI
import CoreData

@available(iOS 13.0, *)
public struct DevCrashEventDetailView: View {
    
    var model: CoreDataCrashEvent
    
    public var header: some View {
        Group {
            Text("CrashEvent Detail (Local)").font(.largeTitle)
        }
    }
    
    public var content: some View {
        Group {
            Text("name: \(model.name ?? "~")")
                .font(.body)
            Text("crashType: \(model.crashType ?? "~")")
                .font(.body)
            Text("reason: \(model.reason ?? "~")")
                .font(.body)
            Text("dispatchTime: \(String(describing:model.dispatchTime))")
                .font(.body)
            Text("callStack: \(model.callStack ?? "~")")
                .font(.body)
        }
    }
    
    public var operations: some View {
        Group {
                Button(action: {
                ServerDispatchServices.sendCrashEventToServerAndDeleteFromCoreData(self.model)
                }) {
                    HStack {
                        Image(systemName: "plus.square.fill")
                            .foregroundColor(.green)
                            .imageScale(.large)
                        Text("Send to server")
                    }
                }//end button
        }//end Group
    }//end operations
    
    public var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 1) {
                operations
                header
                content
                Spacer()
            }//end VStack
        }//end NavigationView
            .navigationBarTitle(Text("Crash Detail"))
        .onAppear {
            AnalyticsService.dispatchAnalyticEvent(.viewDidAppear(viewName: "DevCrashEventDetailView"))
        }
    }//end body
}
