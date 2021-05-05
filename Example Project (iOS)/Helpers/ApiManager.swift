//
//  ApiManager.swift
//  Example Project (iOS)
//
//  Created by Max on 04/05/2021.
//

import Foundation

class ApiManager {
    static let baseUrl = "http://www.omdbapi.com/"
    static let apiKey = "db54b145"
    static let decoder = JSONDecoder()
    
    static let nsCache = NSCache<NSString, NSData>()
    
    static func getMoviesBySearch(search: String, page: Int, closure: @escaping ([Movie]?, Error?) -> Void) {
        if let URL = URL(string: baseUrl) {
            let params: [String: String] = ["apikey" :apiKey,
                                            "s": search,
                                            "page": String(page)]
            print(params)
            let task = URLSession.shared.dataTask(with: URL.appendURLParams(params: params)) { (data, response, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        closure(nil, error)
                    }
                } else if let data = data {
                    do {
                        let movies = try decoder.decode(Movies.self, from: data)
                        DispatchQueue.main.async {
                            closure(movies.Search, nil)
                        }
                    } catch {
                        print(error.localizedDescription)
                        DispatchQueue.main.async {
                            closure(nil, nil)
                        }
                    }
                }
                print(data)
            }
            
            task.resume()
            
        }
    }
    
    static func getImageDataFromURL(url: String, closure: @escaping (Data?) -> Void){
        
        if let data = nsCache.object(forKey: url as NSString) {
            closure(data as Data)
        } else if let URL = URL(string: url) {
            let task = URLSession.shared.dataTask(with: URL) { (data, response, error) in
                if let data = data {
                    nsCache.setObject(data as NSData, forKey: url as NSString)
                    DispatchQueue.main.async {
                        closure(data)
                    }
                }
            }
            task.resume()
        }
    }
}

extension URL {
    func appendURLParams(params: [String: String]) -> URL{
        let queryItems = params.map {
            return URLQueryItem(name: "\($0)", value: "\($1)")
        }
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryItems
        return urlComponents?.url ?? self
    }
}

extension String {
    func encodeToUrlParam() -> String {
        self.replacingOccurrences(of: " ", with: "%20")
    }
}
