//
//  DevServerDeviceMetricDetailView.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/17/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import SwiftUI

public struct ServerDeviceDetailView: View {
    
    var model: DeviceServerViewModel
    
    @ObservedObject var deviceMetricDetailServerData: DeviceDetailServerData
    
    public init(model: DeviceServerViewModel) {
        self.model = model
        self.deviceMetricDetailServerData = DeviceDetailServerData(appleIdentifierForVendor: model.appleIdentifierForVendor)
    }
    
    public var body: some View {
        NavigationView {
            List {
                Section(header:Text("Device Info ")) {
                    Text("appleIdentifierForVendor: \(model.appleIdentifierForVendor)")
                    Text("appleIdentifierForAdvertiser: \(model.appleIdentifierForAdvertiser)")
                    Text("deviceSystemVersion: \(model.deviceSystemVersion)")
                    Text("deviceModel: \(model.deviceModel)")
                    Text("deviceLocalizedModel: \(model.deviceLocalizedModel)")
                    Text("deviceName: \(model.deviceName)")
                    Text("deviceSystemName: \(model.deviceSystemName)")
                    Text("deviceUserInterfaceIdiom: \(model.deviceUserInterfaceIdiom)")
                    Text("lastDeviceUpdateTime: \(model.lastDeviceUpdateTime)")
                    Text("deviceCreationTime: \(model.deviceCreationTime)")
                }
                
                Section(header:Text("Analytics")) {
                    Text("eventCount: \(deviceMetricDetailServerData.eventCount)")
                    Text("crashCount: \(deviceMetricDetailServerData.crashCount)")
                }
                
                Section(header:Text("Operations")) {
                    
                    Button(action: {
                        self.deviceMetricDetailServerData.load()
                    }) {
                        HStack {
                            Image(systemName: "plus.square.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                            Text("Fetch Device Server metrics")
                        }
                    }//end button
                    
                    Text("Page: \(deviceMetricDetailServerData.currentPage) limit:\(deviceMetricDetailServerData.pageLimit)")
                    
                    Button(action: {
                        self.deviceMetricDetailServerData.nextPage( )
                    }) {
                        HStack {
                            Image(systemName: "plus.square.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                            Text("next page")
                        }
                    }//end button
                    
                    Button(action: {
                        self.deviceMetricDetailServerData.prevPage( )
                    }) {
                        HStack {
                            Image(systemName: "plus.square.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                            Text("prev page")
                        }
                    }//end button
                }//end Section
                
                Section(header:Text("Events")) {
                    ForEach( deviceMetricDetailServerData.events) { event in
                        NavigationLink(
                        destination: ServerEventDetailView( model: event ) ) {
                            VStack(alignment: .leading) {
                                Text("\(event.name)")
                                    .font(.body)
                                    .bold()
                                Text("created: \(event.creationTime) ")
                                    .font(.body)
                                Text("idfv: \(event.appleIdentifierForVendor) ")
                                    .font(.body)
                            }
                        }
                    }//end ForEach
                }//end Section
                
                Section(header:Text("Crashes")) {
                    ForEach( deviceMetricDetailServerData.crashs) { crash in
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
                
            }//end List
                .listStyle(GroupedListStyle())
                .navigationBarTitle(Text("Device Detail"))
        }//end  NavigationView
            .onAppear {
                AnalyticsService.dispatchAnalyticEvent(.viewDidAppear(viewName: "ServerDeviceDetailView"))
                self.deviceMetricDetailServerData.load( )
        }
    }//end body
}

struct ServerDeviceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ServerDeviceDetailView(
            model: DeviceServerViewModel.mock
        )
    }
}

