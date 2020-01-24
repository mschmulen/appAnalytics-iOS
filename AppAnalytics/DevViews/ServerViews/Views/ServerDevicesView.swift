//
//  DevServerDevicesMetricsView.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/17/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import SwiftUI

public struct ServerDevicesView: View {
    
    @ObservedObject var deviceServerData: DeviceServerData = DeviceServerData()
    
    public init() {
    }
    
    public var body: some View {
        NavigationView {
            List {
                Section(header:Text("Operations")) {
                    
                    Text("Page: \(self.deviceServerData.currentPage) limit:\(self.deviceServerData.pageLimit)")
                    
                    Button(action: {
                        self.deviceServerData.nextPage( )
                    }) {
                        HStack {
                            Image(systemName: "plus.square.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                            Text("next page")
                        }
                    }//end button
                    
                    Button(action: {
                        self.deviceServerData.prevPage( )
                    }) {
                        HStack {
                            Image(systemName: "plus.square.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                            Text("prev page")
                        }
                    }//end button
                    
                }//end Section
                
                Section(header:Text("Devices")) {
                    ForEach( deviceServerData.devices) { device in
                        NavigationLink(destination:
                            ServerDeviceDetailView( model: device)
                        ) {
                            VStack(alignment: .leading) {
                                Text("IDFV: \(device.appleIdentifierForVendor)")
                                    .font(.headline)
                                    .bold()
                                Text("created: \(device.deviceCreationTime) ")
                                    .font(.body)
                                Text("updated: \(device.lastDeviceUpdateTime) ")
                                    .font(.body)
                            }
                        }
                    }//end ForEach
                }//end Section
                
            }//end List
                .listStyle(GroupedListStyle())
                .navigationBarTitle(Text("Devices (Server)"))
        }//end  NavigationView
            .onAppear {
                AnalyticsService.dispatchAnalyticEvent(.viewDidAppear(viewName: "ServerDevicesView"))
                self.deviceServerData.load()
        }
    }//end body
}

struct ServerDevicesView_Previews: PreviewProvider {
    static var previews: some View {
        ServerDevicesView()
    }
}
