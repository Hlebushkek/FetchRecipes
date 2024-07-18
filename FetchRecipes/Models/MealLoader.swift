//
//  MealService.swift
//  FetchRecipes
//
//  Created by Hlib Sobolevskyi on 2024-06-11.
//

import SwiftUI

protocol MealLoaderProtocol {
    func load(id: String) async throws -> Meal?
}

class MealLoader: MealLoaderProtocol {
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

class MockMealLoader: MealLoaderProtocol {
    func load(id: String) async throws -> Meal? {
        Meal(idMeal: id,
             strMeal: "TestMeal",
             strDrinkAlternate: nil,
             strCategory: "TestCategory",
             strArea: "TestArea",
             strInstructions: "TestInstructions",
             strMealThumb: URL(string: "https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg"),
             strTags: nil,
             strYoutube: nil,
             ingredients: [
                Ingreditent(name: "Ingredient1", measure: "Measure1")
             ],
             strSource: nil,
             strImageSource: nil,
             strCreativeCommonsConfirmed: nil,
             dateModified: Date.now.formatted())
    }
}
