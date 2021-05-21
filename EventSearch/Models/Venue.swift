//
//  Venue.swift
//  EventSearch
//
//  Created by Jonathan Park on 5/20/21.
//

import Foundation
struct Location: Decodable {
    let lat: Double
    let lon: Double
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lon
    }
}


struct Venue: Decodable {
    let name: String
    let address: String?
    let extendedAddress: String?
    let city: String?
    let state: String?
    let zip: String?
    let location: Location
    let url: String
    let score: Double?
    let id: Int
    let timezone: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case address
        case extendedAddress = "extended_address"
        case city
        case zip = "postal_code"
        case state
        case location
        case url
        case score
        case id
        case timezone
    }
}
