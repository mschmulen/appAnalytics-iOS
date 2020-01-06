//
//  DeviceServerData.swift
//  AppAnalytics
//
//  Created by Matthew Schmulen on 12/18/19.
//  Copyright © 2019 Matthew Schmulen. All rights reserved.
//

import SwiftUI

class DeviceServerData: ObservableObject {
    
    // paging info
    @Published var pageLimit: Int
    @Published var currentPage: Int
    @Published var devices: [DeviceServerViewModel]
    
    init() {
        pageLimit = 5
        currentPage = 0
        devices = []
    }
    
    func nextPage() {
        currentPage += 1
        load()
    }
    
    func prevPage() {
        if currentPage <= 0 {
            currentPage = 0
        } else {
            currentPage -= 1
        }
        load()
    }
    
    func load() {
        let service = VaporNetworkService<VaporDeviceModel>()
        service.pagableFetch( limit: pageLimit, page: currentPage ) { (serverDevices) in
            guard let serverDevices = serverDevices else { return }
            
            self.devices = []
            for model in serverDevices {
                self.devices.append(
                    DeviceServerViewModel(
                        id: UUID(),
                        appleIdentifierForVendor: model.appleIdentifierForVendor,
                        appleIdentifierForAdvertiser: model.appleIdentifierForAdvertiser,
                        deviceSystemVersion: model.deviceSystemVersion,
                        deviceModel: model.deviceModel,
                        deviceLocalizedModel: model.deviceLocalizedModel,
                        deviceName: model.deviceName,
                        deviceSystemName: model.deviceSystemName,
                        deviceUserInterfaceIdiom: model.deviceUserInterfaceIdiom,
                        lastDeviceUpdateTime: model.lastDeviceUpdateTime,
                        deviceCreationTime: model.deviceCreationTime
                    )
                )
            }
        }
    }
    
}

