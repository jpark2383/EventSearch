//
//  Event.swift
//  EventSearch
//
//  Created by Jonathan Park on 5/20/21.
//

import Foundation
struct Stat: Decodable {
    let listingCount: Double?
    let averagePrice: Double?
    let lowestPrice: Double?
    let highestPrice: Double?
    
    enum CodingKeys: String, CodingKey {
        case listingCount = "listing_count"
        case averagePrice = "average_price"
        case highestPrice = "highest_price"
        case lowestPrice = "lowest_price"
    }
}

struct Meta: Decodable {
    let total: Int
    let took: Int
    let page: Int
    let perPage: Int
    
    enum CodingKeys: String, CodingKey {
        case total
        case took
        case page
        case perPage = "per_page"
    }
}

struct Events: Decodable {
    let events: [Event]
    let meta: Meta?

    enum CodingKeys: String, CodingKey {
        case events
        case meta
    }
}

struct Event: Decodable {
    let stats: Stat?
    let title: String
    let url: String?
    let localDateTime: String?
    let dateTimeUTC: String?
    let performers: [Performer]?
    let venue: Venue?
    let shortTitle: String?
    let score: Double?
    let taxonomies: [Taxonomy]?
    let type: String?
    let id: Int
    
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case stats
        case title
        case url
        case localDateTime = "datetime_local"
        case performers
        case venue
        case shortTitle = "short_title"
        case dateTimeUTC = "datetime_utc"
        case score
        case taxonomies
        case type
        case id
    }
}
