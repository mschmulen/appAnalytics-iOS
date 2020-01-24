//
//  ServerAppDetailView.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/17/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import SwiftUI

public struct ServerAppDetailView: View {
    
    var model: AppServerViewModel
    
    @ObservedObject var appMetricDetailServerData: AppDetailServerData
    
    public init(model: AppServerViewModel) {
        self.model = model
        self.appMetricDetailServerData = AppDetailServerData(
            appIdentifier: model.appIdentifier,
            appVersion: model.appVersion
        )
    }
    
    public var body: some View {
        NavigationView {
            List {
                
                Section(header:Text("AppDetails")) {
                    Text("appIdentifier: \(model.appIdentifier)")
                    Text("appVersion: \(model.appVersion)")
                    Text("appBuild: \(model.appBuild)")
                    Text("deviceSystemName: \(model.deviceSystemName)")
                    Text("lastUpdateTime: \(model.lastUpdateTime)")
                }
                
                Section(header:Text("Analytics")) {
                    Text("CrashCount: \(appMetricDetailServerData.crashCount)")
                    Text("ActiveDevices: \(appMetricDetailServerData.activeDevices)")
                    Text("NewDevices: \(appMetricDetailServerData.newDevices)")
                }
                
                Section(header:Text("Operations")) {
                    
                    Button(action: {
                        self.appMetricDetailServerData.load()
                    }) {
                        HStack {
                            Image(systemName: "plus.square.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                            Text("Fetch Device Server metrics")
                        }
                    }//end button
                    
                    Text("Page: \(appMetricDetailServerData.currentPage) limit:\(appMetricDetailServerData.pageLimit)")
                    
                    Button(action: {
                        self.appMetricDetailServerData.nextPage( )
                    }) {
                        HStack {
                            Image(systemName: "plus.square.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                            Text("next page")
                        }
                    }//end button
                    
                    Button(action: {
                        self.appMetricDetailServerData.prevPage( )
                    }) {
                        HStack {
                            Image(systemName: "plus.square.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                            Text("prev page")
                        }
                    }//end button
                }//end Section
                
                
                Section(header:Text("Crashes")) {
                    ForEach( appMetricDetailServerData.crashs) { crash in
                        NavigationLink(destination:
                            ServerCrashDetailView( model: crash)
                        ) {
                            VStack(alignment: .leading) {
                                Text("\(crash.crashType) ")
                                    .font(.body)
                                    .bold()
                                Text("\(crash.name) ")
                                    .font(.body)
                                Text("IDFV: \(crash.appleIdentifierForVendor)")
                                    .font(.body)
                                Text("created: \(crash.creationTime) ")
                                    .font(.body)
                            }
                        }
                    }//end ForEach
                }//end Section
                
                Section(header:Text("Events")) {
                    ForEach( appMetricDetailServerData.events) { event in
                        NavigationLink(destination:
                            ServerEventDetailView( model: event)
                        ) {
                            VStack(alignment: .leading) {
                                Text("\(event.name) ")
                                    .font(.body)
                                    .bold()
                                Text("IDFV: \(event.appleIdentifierForVendor)")
                                    .font(.body)
                                Text("created: \(event.creationTime) ")
                                    .font(.body)
                            }
                        }
                    }//end ForEach
                }//end Section
                
            }//end List
                .listStyle(GroupedListStyle())
                .navigationBarTitle(Text("App Detail"))
        }//end  NavigationView
            .onAppear {
                AnalyticsService.dispatchAnalyticEvent(.viewDidAppear(viewName: "ServerAppDetailView"))
                self.appMetricDetailServerData.load()
        }
    }//end body
}

struct ServerAppDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ServerAppDetailView(model: AppServerViewModel.mock)
    }
}

