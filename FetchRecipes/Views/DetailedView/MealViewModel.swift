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
    
    private let id: String
    var meal: Meal?
    
    private let loader: MealLoaderProtocol
    
    init(id: String, loader: MealLoaderProtocol) {
        self.id = id
        self.loader = loader
    }
    
    func reload() async {
        guard !isLoading else {
            return
        }
        
        task?.cancel()
        
        await MainActor.run {
            isLoading = true
            error = nil
        }
        
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
