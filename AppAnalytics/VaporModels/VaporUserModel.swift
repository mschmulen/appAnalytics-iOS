//
//  UserModel.swift
//

import Foundation

public struct VaporUserModel: VaporModel {
    
    /// endpointRouteURL for VaporModel conformance
    public static var endpointRouteURL = "users"
    
    /// vapor id
    public let id: VaporID?
    
    /// associatedAppUserIdentifier = appUserIdentifier
    public let associatedAppUserIdentifier: String
    
    /// initializer
    public init ( associatedAppUserIdentifier: String, id: VaporID? ) {
        self.associatedAppUserIdentifier = associatedAppUserIdentifier
        self.id = id
    }
    
    /// coding keys
    enum CodingKeys: String, CodingKey {
        case id
        case associatedAppUserIdentifier
    }
    
    /// mock factory
    public static var mock: VaporUserModel {
        return VaporUserModel(associatedAppUserIdentifier: "~", id: nil)
    }
}
