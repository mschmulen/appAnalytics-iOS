//
//  AnalyticsTestView.swift
//  AnalyticsSwiftUIExample
//
//  Created by Matthew Schmulen on 10/18/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import SwiftUI
import AppAnalytics

struct AnalyticsTestView: View {
    
    //    @Environment(\.managedObjectContext) var managedObjectContext

    //    @FetchRequest(
    //        entity: ProgrammingLanguage.entity(),
    //        sortDescriptors: [
    //            NSSortDescriptor(keyPath: \ProgrammingLanguage.name, ascending: true),
    //            NSSortDescriptor(keyPath: \ProgrammingLanguage.creator, ascending: false)
    //        ]
    //    ) var events: FetchedResults<ProgrammingLanguage>
    
    var body: some View {
        VStack {
            
            Text("App Analytics Test")
            
            Button(action: ({
                AnalyticsService.dispatchAnalyticEvent(.testEventA)
            })) {
                Text("dispatchAnalyticEvent(.testEventA)")
            }
            
            Button(action: ({
                AnalyticsService.dispatchAnalyticEvent(.testEventB)
            })) {
                Text("dispatchAnalyticEvent(.testEventB)")
            }
            
            Button(action: ({
                print( "EventC")
                AnalyticsService.dispatchAnalyticEvent(.testEventC)
            })) {
                Text("dispatchAnalyticEvent(.testEventC)")
            }
            
        }//end VStack
        .onAppear {
            AnalyticsService.dispatchAnalyticEvent(.viewDidAppear(viewName: "AnalyticsTestView"))
        }
    }//end body
}

struct AnalyticsTestView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsTestView()
    }
}
