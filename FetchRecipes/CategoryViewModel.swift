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
        
        task = Task { [weak self] in
            guard let self else { return }
            
            do {
                let briefs = try await loader.load().sorted(by: { $0.strMeal < $1.strMeal })
                await MainActor.run {
                    self.briefs = briefs
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
        
        await task?.value
    }
}
