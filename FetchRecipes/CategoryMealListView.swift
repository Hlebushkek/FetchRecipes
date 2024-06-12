//
//  CategoryMealListView.swift
//  FetchRecipes
//
//  Created by Hlib Sobolevskyi on 2024-06-11.
//

import SwiftUI

struct CategoryMealListView: View {
    @Environment(CategoryViewModel.self) private var viewModel
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 8) {
            if viewModel.isLoading && viewModel.briefs.isEmpty {
                ProgressView()
            } else if let error = viewModel.error {
                Text(error.localizedDescription)
            } else {
                ForEach(viewModel.briefs) { brief in
                    NavigationLink {
                        MealDetailedView(id: brief.idMeal)
                            .ignoresSafeArea(edges: .top)
                    } label: {
                        MealBriefView(brief: brief)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
        .navigationTitle(viewModel.loader.category)
        .task {
            await viewModel.reload()
        }
    }
}

extension CategoryMealListView {
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
    CategoryMealListView()
}
