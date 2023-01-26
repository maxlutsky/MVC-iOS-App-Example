//
//  MoviesSourceProtocol.swift
//  Example Project (iOS)
//
//  Created by Max Lutsky on 26.01.2023.
//

import Foundation

protocol MoviesSourceProtocol {
    func getMoviesBySearch(search: String, page: Int, closure: @escaping ([Movie]?, Error?) -> Void)
}


