//
//  Movie.swift
//  Example Project (iOS)
//
//  Created by Max on 04/05/2021.
//

import Foundation

struct Movies: Codable {
    var search: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}

struct Movie: Codable {
    var title: String?
    var poster: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case poster = "Poster"
    }
}
