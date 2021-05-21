//
//  Taxonomy.swift
//  EventSearch
//
//  Created by Jonathan Park on 5/20/21.
//

import Foundation

struct Taxonomy: Decodable {
    let parentId: Int?
    let id: Int
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case parentId = "parent_id"
        case id
        case name
    }
}
