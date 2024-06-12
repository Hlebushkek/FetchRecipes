//
//  CategoryListView.swift
//  FetchRecipes
//
//  Created by Hlib Sobolevskyi on 2024-06-11.
//

import SwiftUI

struct CategoryListView: View {
    let loader: MealBriefLoader
    @State private var briefs: [MealBrief] = []
    
    init(category: String) {
        self.loader = MealBriefLoader(category: category)
    }
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 8) {
            ForEach(briefs) { brief in
                NavigationLink {
                    MealDetailedView(id: brief.idMeal)
                } label: {
                    MealBriefView(brief: brief)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .foregroundStyle(.primary)
            }
        }
        .navigationTitle(loader.category)
        .task {
            try? await load()
        }
    }
    
    private func load() async throws {
        briefs = try await loader.load().sorted(by: { $0.strMeal < $1.strMeal })
    }
}

extension CategoryListView {
    struct MealBriefView: View {
        var brief: MealBrief
        
        var body: some View {
            VStack(spacing: 0) {
                GeometryReader { geo in
                    CachedAsyncImage(url: brief.strMealThumb) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable()
                        case .failure:
                            Text("Oops! Something went wrong...")
                        default:
                            Rectangle().fill(.gray)
                        }
                    }
                }.aspectRatio(1, contentMode: .fit)
                
                ZStack {
                    Rectangle().fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.primaryGradientStart,
                                Color.primaryGradientEnd
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    Text(brief.strMeal)
                        .font(.title2)
                        .bold()
                        .padding()
                }
            }
        }
    }
}

#Preview {
    CategoryListView(category: "Dessert")
}
