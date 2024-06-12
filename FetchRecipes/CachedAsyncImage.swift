//
//  CachedAsyncImage.swift
//  FetchRecipes
//
//  Created by Hlib Sobolevskyi on 2024-06-12.
//

import SwiftUI

enum CachedAsyncImageError: Error, LocalizedError {
    case networkError(Error)
    case invalidImageData
}

struct CachedAsyncImage<Content>: View where Content: View {
    let url: URL?
    var content: (AsyncImagePhase) -> Content
    
    @State private var phase: AsyncImagePhase = .empty
    private let urlSession: URLSession = .shared
    
    init(url: URL? = nil, @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.content = content
    }
    
    var body: some View {
        content(phase)
            .task(id: url) {
                guard let url else {
                    withAnimation { phase = .empty }
                    return
                }
                
                if let cachedImage = ImageCache.shared.get(for: url) {
                    withAnimation { phase = .success(Image(uiImage: cachedImage)) }
                    return
                }
                
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    guard let uiImage = UIImage(data: data) else {
                        throw CachedAsyncImageError.invalidImageData
                    }
                    
                    ImageCache.shared.set(uiImage, for: url)
                    withAnimation { phase = .success(Image(uiImage: uiImage)) }
                } catch {
                    if let urlError = error as? URLError {
                        phase = .failure(CachedAsyncImageError.networkError(urlError))
                    } else {
                        phase = .failure(CachedAsyncImageError.networkError(error))
                    }
                }
            }
    }
}

class ImageCache {
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

#Preview {
    CachedAsyncImage(url: nil) { _ in EmptyView() }
}
