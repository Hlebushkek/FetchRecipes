//
//  MealDetailedView.swift
//  FetchRecipes
//
//  Created by Hlib Sobolevskyi on 2024-06-11.
//

import SwiftUI

struct MealDetailedView: View {
    var id: String
    
    @Environment(\.dismiss) var dismiss
    
    @State private var meal: Meal?
    private let loader = MealLoader()
    
    var body: some View {
        ScrollView {
            GeometryReader { geo in
                CachedAsyncImage(url: meal?.strMealThumb) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                    case .failure:
                        Text("Oops! Something went wrong...")
                    default:
                        Rectangle().fill(.gray)
                    }
                }
            }
            .aspectRatio(1, contentMode: .fit)
            
            VStack(alignment: .leading, spacing: 16) {
                Text(meal?.strMeal ?? "Unknown")
                    .font(.title)
                    .bold()
                
                Text(meal?.strInstructions ?? "Unknown")
                
                if let ingredients = meal?.ingredients {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Ingredients:")
                            .font(.title2)
                            .bold()
                        
                        ForEach(ingredients) { i in
                            Text("\(i.name): \(i.measure ?? "as desired")")
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .ignoresSafeArea(edges: .top)
        .redacted(reason: meal == nil ? .placeholder : [])
        .task {
            try? await load()
        }
    }
    
    private func load() async throws {
        meal = try? await loader.load(id: id)
    }
}

#Preview {
    MealDetailedView(id: "0")
}
