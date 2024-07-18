//
//  ContentView.swift
//  FetchRecipes
//
//  Created by Hlib Sobolevskyi on 2024-06-11.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel: CategoryViewModel
    
    init(loader: MealBriefLoaderProtocol) {
        self.viewModel = CategoryViewModel(loader)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                CategoryMealListView()
                    .padding(.horizontal)
                    .environment(viewModel)
            }
            .refreshable {    
                await viewModel.reload()
            }
        }
    }
}

#Preview {
    ContentView(loader: MockMealBriefLoader(category: Config.category))
}
