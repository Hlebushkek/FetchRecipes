//
//  ImageCache.swift
//  FetchRecipes
//
//  Created by Hlib Sobolevskyi on 2024-07-18.
//

import UIKit

protocol ImageCaching: Actor {
    func set(_ image: UIImage, for url: URL)
    func get(for url: URL) -> UIImage?
}

actor ImageCache: ImageCaching { // TODO: Create protocol
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func set(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url.absoluteString as NSString)
    }

    func get(for url: URL) -> UIImage? {
        return cache.object(forKey: url.absoluteString as NSString)
    }
}

actor MockImageCache: ImageCaching {
    private var mockCache: [String: UIImage] = [:]
    
    func set(_ image: UIImage, for url: URL) {
        mockCache[url.absoluteString] = image
    }

    func get(for url: URL) -> UIImage? {
        return mockCache[url.absoluteString]
    }
}
