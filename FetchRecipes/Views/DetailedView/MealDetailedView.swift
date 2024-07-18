//
//  MealDetailedView.swift
//  FetchRecipes
//
//  Created by Hlib Sobolevskyi on 2024-06-11.
//

import SwiftUI

struct MealDetailedView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var viewModel: MealViewModel
    
    init(id: String, _ loader: MealLoaderProtocol) {
        self.viewModel = MealViewModel(id: id, loader: loader)
    }
    
    var body: some View {
        ScrollView {
            GeometryReader { geo in
                CachedAsyncImage(url: viewModel.meal?.strMealThumb) { phase in
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
                Text(viewModel.meal?.strMeal ?? "")
                    .font(.title)
                    .bold()
                
                Text(viewModel.meal?.strInstructions ?? "")
                
                if let ingredients = viewModel.meal?.ingredients {
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
            .errorHandling(error: viewModel.error)
        }
        .redacted(reason: viewModel.isLoading && viewModel.meal == nil ? .placeholder : [])
        .refreshable {
            await viewModel.reload()
        }
        .task {
            await viewModel.reload()
        }
    }
}

#Preview {
    MealDetailedView(id: "0", MockMealLoader())
}
