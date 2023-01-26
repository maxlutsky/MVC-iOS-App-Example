//
//  ApiManager.swift
//  Example Project (iOS)
//
//  Created by Max on 04/05/2021.
//

import Foundation

class MoviesSource: MoviesSourceProtocol {
    private let baseUrl = URL(string: "http://www.omdbapi.com/")!
    private let apiKey = "db54b145"
    private let decoder = JSONDecoder()
    
    func getMoviesBySearch(search: String, page: Int, closure: @escaping ([Movie]?, Error?) -> Void) {
        let params: [String: String] = ["apikey" :apiKey,
                                        "s": search,
                                        "page": String(page)]
#if DEBUG
        print(params)
#endif
        let task = URLSession.shared.dataTask(with: getUrlWithParams(url: baseUrl, params: params)) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    closure(nil, error)
                }
            } else if let data = data {
                do {
                    let movies = try self.decoder.decode(Movies.self, from: data)
                    DispatchQueue.main.async {
                        closure(movies.search, nil)
                    }
                } catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        closure(nil, error)
                    }
                }
            }
#if DEBUG
            print(data)
#endif
        }
        
        task.resume()
    }
    
    private func getUrlWithParams(url: URL, params: [String: String]) -> URL {
        let queryItems = params.map {
            URLQueryItem(name: "\($0)", value: "\($1)")
        }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryItems
        return urlComponents?.url ?? url
    }
}
