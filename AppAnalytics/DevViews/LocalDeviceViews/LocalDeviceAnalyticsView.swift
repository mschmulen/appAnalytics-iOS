//
//  LocalDeviceAnalyticsView.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 11/6/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
public struct LocalDeviceAnalyticsView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(fetchRequest: CoreDataLocalEvent.allEventsFetchRequest()) var events: FetchedResults<CoreDataLocalEvent>
    
//    @FetchRequest(entity: LocalEvent.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
//    var events: FetchedResults<LocalEvent>
    
    @State private var refreshing = false
    private var contextDidSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    
    // TODO show the current tokenCount in the TokenBucket
    @State private var tokenCount = "XXX"
    @State private var eventCount = "XXX"
    @State private var deviceIDFV = "XXX"
    @State private var deviceIDFA = "XXX"
    @State private var appIdentifier = "XXX"
    @State private var appVersion = "XXX"

    public init() {
    }
    
    public var body: some View {
        NavigationView {
            List {
                Section(header:Text("Analaytics")) {
                    Text("Analytics (Local)")
                    Text("\(tokenCount)")
                    Text("\(eventCount)")
                }
                
                Section(header:Text("Device Info")) {
                    Text("\(deviceIDFV)")
                    Text("\(deviceIDFA)")
                    Text("\(appIdentifier)")
                    Text("\(appVersion)")
                }
                
                Section(header:Text("Operations")) {

                    Button(action: {
                        for _ in 1...20 {
                            AnalyticsService.dispatchAnalyticEvent(.testEventA)
                        }

                    }) {
                        HStack {
                            Image(systemName: "plus.square.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                            Text("triger 20 events")
                        }
                    }//end button

                    Button(action: {
                        AnalyticsService.shared().triggerLocalDataFlush(seconds: 2.5)
                        self.tokenCount = "tokenCount: \(AnalyticsService.shared().tokenCount)"
                    }) {
                        HStack {
                            Image(systemName: "plus.square.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                            Text("triger local data flush in 2.5 seconds")
                        }
                    }//end button

                    Button(action: {
                        ServerDispatchServices.sendDeviceInfoToServer()
                    }) {
                        HStack {
                            Image(systemName: "plus.square.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                            Text("sendDeviceToServer")
                        }
                    }//end button

                    Button(action: {
                        ServerDispatchServices.sendAppInfoToServer()
                    }) {
                        HStack {
                            Image(systemName: "plus.square.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                            Text("sendAppInfoToServer")
                        }
                    }//end button
                    
                    
                    Button(action: {
                        // AnalyticsService.shared().triggerLocalDataFlush(seconds: 2.5)
                        print( "TODO delete all events on the server")
                    }) {
                        HStack {
                            Image(systemName: "plus.square.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                            Text("WIP delete all Events on the server")
                        }
                    }//end button
                    
                }//end Section
                
                Section(header:Text("Events")) {
                    ForEach( self.events) { model in
                        NavigationLink(destination: DevLocalEventDetailView(model: model)) {
                            VStack(alignment: .leading) {
                                Text(model.name ?? "~")
                                    .font(.headline)
                                    .bold()
                            }
                        }
                    }//end ForEach
                }//end Section
                
            }//end List
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("Analytics (Local)"))
            // .navigationBarItems(trailing: EditButton())
        }//end  NavigationView
        .onAppear {
            AnalyticsService.dispatchAnalyticEvent(.viewDidAppear(viewName: "DevAnalyticsView"))
        }
        .onReceive(self.contextDidSave) { _ in
            self.refreshing.toggle()
            self.eventCount = "event count: \(self.events.count)"
            self.tokenCount = "tokenCount: \(AnalyticsService.shared().tokenCount)"
            
            self.deviceIDFV = "IDFV: \(AnalyticsService.shared().localDeviceInfo.appleIdentifierForVendor)"
            
            self.deviceIDFA = "IDFA: \(AnalyticsService.shared().localDeviceInfo.appleIdentifierForAdvertiser ?? "nil")"
            
            self.appIdentifier = "Id: \(AnalyticsService.shared().appInfo.bundleIdentifier)"
            self.appVersion = " \(AnalyticsService.shared().appInfo.bundleShortVersion) (\(AnalyticsService.shared().appInfo.bundleVersion))"
            
        }//end onReceive
    }//end body
}//end View

struct LocalDeviceAnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        LocalDeviceAnalyticsView()
    }
}

