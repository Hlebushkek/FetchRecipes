//
//  ContentView.swift
//  FetchRecipes
//
//  Created by Hlib Sobolevskyi on 2024-06-11.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel: CategoryViewModel
    
    init(category: String) {
        self.viewModel = CategoryViewModel(category: category)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                CategoryMealListView()
                    .padding(.horizontal)
                    .environment(viewModel)
            }
            .refreshable {
                guard !viewModel.isLoading else {
                    return
                }
                
                await viewModel.reload()
            }
        }
    }
}

#Preview {
    ContentView(category: Config.category)
}
