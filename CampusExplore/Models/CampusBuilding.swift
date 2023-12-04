//
//  CampusBuilding.swift
//  CampusExplore
//
//  Created by Charan on 01/12/23.
//

import Foundation

struct CampusBuilding: Codable {
    let details: String
    let images: [String]
    let name: String
}


struct Faculty: Codable {
    let subject: String?
    let about: String
    let name: String
    let image: String
}

struct Event: Codable {
    let description: String
    let eventName: String
    let date: String
    let dateTimeStamp: Double?
}
