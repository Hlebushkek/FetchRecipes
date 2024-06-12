//
//  FetchRecipesApp.swift
//  FetchRecipes
//
//  Created by Hlib Sobolevskyi on 2024-06-11.
//

import SwiftUI

@main
struct FetchRecipesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(category: Config.category)
        }
    }
}
