//
//  LocalDeviceCrashsView.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/16/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
public struct LocalDeviceCrashsView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(fetchRequest: CoreDataCrashEvent.allCrashEventsFetchRequest()) var events: FetchedResults<CoreDataCrashEvent>
    
    private var contextDidSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    
    @State private var eventCount = "XXX"
    
    public init() {
    }
    
    public var body: some View {
        NavigationView {
            List {
                Section(header:Text("Analytics")) {
                    Text("Crashs (Local)")
                    Text("\(eventCount)")
                }
                
                Section(header:Text("Operations")) {
                    
                    Button(action: {
                        CrashService.forceException()
                    }) {
                        HStack {
                            Image(systemName: "plus.square.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                            Text("force local exception")
                        }
                    }//end button
                    
                    Button(action: {
                        CrashService.forceCrashIndexOutOfRange()
                    }) {
                        HStack {
                            Image(systemName: "plus.square.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                            Text("force local forceCrashIndexOutOfRange")
                        }
                    }//end button
                    
                    Button(action: {
                        CrashService.forceCrashForceUnwrap()
                    }) {
                        HStack {
                            Image(systemName: "plus.square.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                            Text("force local forceCrashForceUnwrap")
                        }
                    }//end button
                    
                    Button(action: {
                        CrashService.forceKillApp()
                    }) {
                        HStack {
                            Image(systemName: "plus.square.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                            Text("force local forceCrashSIGKILL")
                        }
                    }//end button
                    
                }//end Section

                Section(header:Text("Crashs")) {
                    ForEach( self.events) { model in
                        NavigationLink(destination: DevCrashEventDetailView(model: model)) {
                            VStack(alignment: .leading) {
                                Text("\(model.crashType ?? "~") \(model.name ?? "~") \(model.localCrashUUID?.uuidString ?? "~")")
                                    .font(.headline)
                                    .bold()
                            }
                        }
                    }//end ForEach
                }//end Section
            }//end List
                .listStyle(GroupedListStyle())
                .navigationBarTitle(Text("Crashs (Local)"))
                // .navigationBarItems(trailing: EditButton())
        }//end  NavigationView
        .onAppear {
            AnalyticsService.dispatchAnalyticEvent(.viewDidAppear(viewName: "LocalDeviceCrashsView"))
        }
        .onReceive(self.contextDidSave) { _ in
                self.eventCount = "event count: \(self.events.count)"
        }
    }//end body
}

struct LocalDeviceCrashsView_Previews: PreviewProvider {
    static var previews: some View {
        LocalDeviceCrashsView()
    }
}

