//
//  MealBriefLoader.swift
//  FetchRecipes
//
//  Created by Hlib Sobolevskyi on 2024-07-18.
//

import Foundation

protocol MealBriefLoaderProtocol {
    var category: String { get }
    
    func load() async throws -> [MealBrief]
}

class MealBriefLoader: MealBriefLoaderProtocol {
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

class MockMealBriefLoader: MealBriefLoaderProtocol {
    let category: String
    
    init(category: String) {
        self.category = category
    }
    
    func load() async throws -> [MealBrief] {
        [
            MealBrief(strMeal: "Meal1", strMealThumb: nil, idMeal: "ID1"),
            MealBrief(strMeal: "Meal2", strMealThumb: URL(string:  "https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg"), idMeal: "ID2"),
            MealBrief(strMeal: "Meal3", strMealThumb: nil, idMeal: "ID3")
        ]
    }
}

