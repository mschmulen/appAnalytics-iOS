//
//  VaporModel.swift
//

import Foundation

/// typealias for Vapor id (Int)
public typealias VaporID = Int

/// VaporModel protocol
public protocol VaporModel:Codable {
    
    /// vapor id
    var id:VaporID? {get}
    
    /// endpointRouteURL example :"events"
    static var endpointRouteURL:String { get }
    
    // static var mock: Fetchable { get }
}

