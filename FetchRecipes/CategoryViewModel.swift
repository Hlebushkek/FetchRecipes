//
//  CategoryViewModel.swift
//  FetchRecipes
//
//  Created by Hlib Sobolevskyi on 2024-06-12.
//

import SwiftUI

@Observable class CategoryViewModel {
    var briefs = [MealBrief]()
    var isLoading: Bool = false
    var error: Error?
    private var task: Task<Void, Never>?
    
    let loader: MealBriefLoader
    
    init(category: String) {
        self.loader = MealBriefLoader(category: category)
    }
    
    func reload() async {
        task?.cancel()
        isLoading = true
        error = nil
        
        task = Task {
            do {
                briefs = try await loader.load().sorted(by: { $0.strMeal < $1.strMeal })
            } catch {
                self.error = error
            }
            
            isLoading = false
        }
    }
}
