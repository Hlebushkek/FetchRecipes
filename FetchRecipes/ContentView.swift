//
//  ContentView.swift
//  FetchRecipes
//
//  Created by Hlib Sobolevskyi on 2024-06-11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                CategoryListView(category: Config.category)
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ContentView()
}
