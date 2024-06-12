//
//  MealService.swift
//  FetchRecipes
//
//  Created by Hlib Sobolevskyi on 2024-06-11.
//

import SwiftUI

class MealBriefLoader {
    private var urlSession: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 30
        
        return URLSession(configuration: configuration)
    }
    
    let category: String
    
    init(category: String) {
        self.category = category
    }
    
    func load() async throws -> [MealBrief] {
        let categoryQuery = URLQueryItem(name: "c", value: category)
        let apiEndpoint = Config.baseURL.appending(path: "filter.php").appending(queryItems: [categoryQuery])
        let req = URLRequest(url: apiEndpoint)
        
        let (data, _) = try await urlSession.data(for: req)
        let container = try JSONDecoder().decode(MealBriefs.self, from: data)
        
        return container.meals
    }
}

class MealLoader {
    private var urlSession: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 30
        
        return URLSession(configuration: configuration)
    }
    
    func load(id: String) async throws -> Meal? {
        let idQuery = URLQueryItem(name: "i", value: id)
        let apiEndpoint = Config.baseURL.appending(path: "lookup.php").appending(queryItems: [idQuery])
        let req = URLRequest(url: apiEndpoint)
        
        let (data, _) = try await urlSession.data(for: req)
        let meals = try JSONDecoder().decode(Meals.self, from: data)
        
        return meals.meals.first
    }
}
