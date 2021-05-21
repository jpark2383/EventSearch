//
//  Performer.swift
//  EventSearch
//
//  Created by Jonathan Park on 5/20/21.
//

import Foundation

struct Images: Decodable {
    let large: String?
    let huge: String?
    let small: String?
    let medium: String?
    
    enum CodingKeys: String, CodingKey {
        case large
        case huge
        case small
        case medium
    }
}

struct Genre: Decodable {
    
}

struct Performer: Decodable {
    let name: String?
    let shortName: String?
    let url: String?
    let image: String?
    let images: Images?
    let score: Double?
    let slug: String?
    let taxonomies: [Taxonomy]?
    let id: Int
    let hasUpcomingEvents: Bool?
    let links: [String]?
    
    enum CodingKeys: String, CodingKey {
        case name
        case shortName = "short_name"
        case url
        case image
        case images
        case score
        case slug
        case taxonomies
        case id
        case hasUpcomingEvents = "has_upcoming_events"
        case links
    }
}
