//
//  DevServerAppsMetricsView.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/16/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import SwiftUI

public struct ServerAppsView: View {
    
    @ObservedObject var appServerData: AppServerData = AppServerData()
    
    public init() {
        
    }
    
    public var body: some View {
        NavigationView {
            List {
                
                Text("Page: \(self.appServerData.currentPage) limit:\(self.appServerData.pageLimit)")
                
                Button(action: {
                    self.appServerData.nextPage( )
                }) {
                    HStack {
                        Image(systemName: "plus.square.fill")
                            .foregroundColor(.green)
                            .imageScale(.large)
                        Text("next page")
                    }
                }//end button
                
                Button(action: {
                    self.appServerData.prevPage( )
                }) {
                    HStack {
                        Image(systemName: "plus.square.fill")
                            .foregroundColor(.green)
                            .imageScale(.large)
                        Text("prev page")
                    }
                }//end button
                
                Section(header:Text("Apps")) {
                    ForEach( appServerData.apps) { app in
                        NavigationLink(destination: ServerAppDetailView(model: app)) {
                            VStack(alignment: .leading) {
                                Text("\(app.appIdentifier)")
                                    .font(.body)
                                    .bold()
                                Text("appVersion: \(app.appVersion) (\(app.appBuild)) ")
                                    .font(.body)
                                Text("system: \(app.deviceSystemName)")
                                    .font(.body)
                                Text("updated: \(app.lastUpdateTime)")
                                    .font(.body)
                            }
                        }
                    }//end ForEach
                }//end Section
                
            }//end List
                .listStyle(GroupedListStyle())
                .navigationBarTitle(Text("Apps (Server)"))
            
        }//end  NavigationView
            .onAppear {
                AnalyticsService.dispatchAnalyticEvent(.viewDidAppear(viewName: "ServerAppsView"))
                self.appServerData.load()
        }
    }//end body
}

struct ServerAppsView_Previews: PreviewProvider {
    static var previews: some View {
        ServerAppsView()
    }
}
