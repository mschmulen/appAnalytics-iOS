//
//  ContentView.swift
//  AnalyticsSwiftUIExample
//
//  Created by Matthew Schmulen on 10/18/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import SwiftUI
import AppAnalytics

@available(iOS 13.0, *)
struct ContentView: View {

    @Environment(\.managedObjectContext) var managedObjectContext

//    @FetchRequest(
//        entity: ProgrammingLanguage.entity(),
//        sortDescriptors: [
//            NSSortDescriptor(keyPath: \ProgrammingLanguage.name, ascending: true),
//            NSSortDescriptor(keyPath: \ProgrammingLanguage.creator, ascending: false)
//        ]
//    ) var events: FetchedResults<ProgrammingLanguage>
        
    @State var selectedView = 0
    
    var body: some View {
        TabView(selection: $selectedView) {
            
            HomeView()
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("Home")
            }.tag(0)
            
            LocalDeviceAnalyticsView()
                .environment(\.managedObjectContext, managedObjectContext)
                .tabItem {
                    Image(systemName: "5.circle")
                    Text("LocalAnalytics")
            }.tag(1)
            
            LocalDeviceCrashsView()
                .environment(\.managedObjectContext, managedObjectContext)
                .tabItem {
                    Image(systemName: "4.circle")
                    Text("LocalCrashs")
            }.tag(2)
            
            ServerAppsView()
                .tabItem {
                    Image(systemName: "4.circle")
                    Text("Apps")
            }.tag(3)
            
            ServerDevicesView()
                .tabItem {
                    Image(systemName: "4.circle")
                    Text("Devices")
            }.tag(4)
                
            //            AnalyticsTestView()
            //                .tabItem {
            //                    Image(systemName: "2.circle")
            //                    Text("Test")
            //            }.tag(5)
            
        }//end VStack
        .onAppear {
            AnalyticsService.dispatchAnalyticEvent(.viewDidAppear(viewName: "ContentView"))
        }
    }//end body
}

//extension ContentView {
//    func dispatchViewDidAppear() {
//        AnalyticsService.dispatchAnalyticEvent(event: AnalyticEventType.viewDidAppear(name: "ContentView"))
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
