//
//  Movie.swift
//  Example Project (iOS)
//
//  Created by Max on 04/05/2021.
//

import Foundation

struct Movies: Codable {
    var Search: [Movie]
}

struct Movie: Codable {
    var Title: String?
    var Poster: String?
}
