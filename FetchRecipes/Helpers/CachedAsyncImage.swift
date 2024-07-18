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
    private let cache: ImageCaching
    
    init(url: URL? = nil, cache: ImageCaching = ImageCache.shared, @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.content = content
        self.cache = cache
    }
    
    var body: some View {
        content(phase)
            .task(id: url) {
                await loadImage()
            }
    }
    
    private func loadImage() async {
        guard let url else {
            withAnimation { phase = .empty }
            return
        }
        
        if let cachedImage = await cache.get(for: url) {
            withAnimation { phase = .success(Image(uiImage: cachedImage)) }
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let uiImage = UIImage(data: data) else {
                throw CachedAsyncImageError.invalidImageData
            }
            
            await cache.set(uiImage, for: url)
            withAnimation { phase = .success(Image(uiImage: uiImage)) }
        } catch {
            let cachedError: CachedAsyncImageError = (error as? URLError).map { .networkError($0) } ?? .networkError(error)
            withAnimation { phase = .failure(cachedError) }
        }
    }
}

#Preview {
    struct Preview: View {
        @State private var testURL: URL? = nil
        let cache = MockImageCache()
        
        var body: some View {
            CachedAsyncImage(url: testURL, cache: cache) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .scaledToFit()
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 128, height: 128)
            .task {
                guard let sampleImage = UIImage(systemName: "photo"),
                      let url = URL(string: "https://example.com/test.png") else {
                    return
                }
                
                await cache.set(sampleImage, for: url)
                await MainActor.run { testURL = url }
            }
        }
    }
    
    return Preview()
}
