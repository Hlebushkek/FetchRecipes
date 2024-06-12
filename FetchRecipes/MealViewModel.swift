//
//  MealViewModel.swift
//  FetchRecipes
//
//  Created by Hlib Sobolevskyi on 2024-06-12.
//

import Foundation

@Observable class MealViewModel {
    var isLoading: Bool = false
    var error: Error?
    private var task: Task<Void, Never>?
    
    var id: String
    var meal: Meal?
    
    let loader = MealLoader()
    
    init(id: String) {
        self.id = id
    }
    
    func reload() async {
        task?.cancel()
        isLoading = true
        error = nil
        
        task = Task { [weak self] in
            guard let self else { return }
            
            do {
                let meal = try await loader.load(id: id)
                await MainActor.run {
                    self.meal = meal
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
