//
//  MealService.swift
//  FetchRecipes
//
//  Created by Hlib Sobolevskyi on 2024-06-11.
//

import SwiftUI

class MealBriefLoader {
    let category: String
    
    init(category: String) {
        self.category = category
    }
    
    func load() async throws -> [MealBrief] {
        let categoryQuery = URLQueryItem(name: "c", value: category)
        let apiEndpoint = Config.baseURL.appending(path: "filter.php").appending(queryItems: [categoryQuery])
        let req = URLRequest(url: apiEndpoint)
        
        let (data, _) = try await URLSession.shared.data(for: req)
        let container = try JSONDecoder().decode(MealBriefs.self, from: data)
        
        return container.meals
    }
}

class MealLoader {
    func load(id: String) async throws -> Meal? {
        let idQuery = URLQueryItem(name: "i", value: id)
        let apiEndpoint = Config.baseURL.appending(path: "lookup.php").appending(queryItems: [idQuery])
        let req = URLRequest(url: apiEndpoint)
        
        let (data, _) = try await URLSession.shared.data(for: req)
        let meals = try JSONDecoder().decode(Meals.self, from: data)
        
        return meals.meals.first
    }
}
