//
//  TopNavView.swift
//  AnalyticsSwiftUIExample
//
//  Created by Matthew Schmulen on 10/18/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import SwiftUI
import AppAnalytics

struct HomeView: View {
    
    @State private var envConfig:String = "XXX"
    @State private var idfv:String = "XXX"
    @State private var appUserIdentifier:String = "XXX"
    @State private var appIdentifier:String = "XXX"
    @State private var appVersion:String = "XXX"
    
    var body: some View {
        VStack {
            Text("HomeView Analytics")
            Text("Environment: \(envConfig)")
            Text("\(idfv)")
            Text("appUserIdentifier: \(appUserIdentifier)")
            Text("\(appIdentifier)")
            Text("\(appVersion)")
            Text("build env: \(appBuildEnvironment.description)")
            Text("network env: \(appNetworkEnvironment.description)")
            Text("network scheme: \(appNetworkEnvironment.scheme)")
            Text("network host: \(appNetworkEnvironment.host)")
        }//end VStack
        .onAppear {
            AnalyticsService.dispatchAnalyticEvent(.viewDidAppear(viewName: "HomeView"))
            self.envConfig = "TODO"
            self.idfv = AnalyticsService.shared().appleIdentifierForVendor
            self.appUserIdentifier = AnalyticsService.shared().appUserIdentifier
            self.appIdentifier = AnalyticsService.shared().appIdentifier
            self.appVersion = AnalyticsService.shared().appVersion
        }
    }//end body
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
