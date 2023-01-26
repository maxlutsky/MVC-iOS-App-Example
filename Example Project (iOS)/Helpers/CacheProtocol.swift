//
//  CacheProtocol.swift
//  Example Project (iOS)
//
//  Created by Max Lutsky on 26.01.2023.
//

import Foundation

protocol CacheProtocol {
    func getImageDataFromURL(url: String, closure: @escaping (Data?, String?) -> Void)
}

class CacheManager: CacheProtocol {
    let nsCache = NSCache<NSString, NSData>()
    
    func getImageDataFromURL(url: String, closure: @escaping (Data?, String?) -> Void) {
        if let data = nsCache.object(forKey: url as NSString) {
            closure(data as Data, url)
        } else if let URL = URL(string: url) {
            let task = URLSession.shared.dataTask(with: URL) { (data, response, error) in
                if let data = data {
                    self.nsCache.setObject(data as NSData, forKey: url as NSString)
                    DispatchQueue.main.async {
                        closure(data, url)
                    }
                }
            }
            task.resume()
        }
    }
}
