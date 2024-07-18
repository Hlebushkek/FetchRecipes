//
//  FetchRecipesTests.swift
//  FetchRecipesTests
//
//  Created by Hlib Sobolevskyi on 2024-06-12.
//

import XCTest
@testable import FetchRecipes

final class FetchRecipesTests: XCTestCase {
    func testFetchMealBriefsSuccess() async {
        let categoryViewModel = CategoryViewModel(MockMealBriefLoader(category: Config.category))
        await categoryViewModel.reload()
        
        if let error = categoryViewModel.error {
            XCTFail("Expected array, got error: \(error)")
        } else {
            XCTAssertGreaterThan(categoryViewModel.briefs.count, 0)
        }
    }
   
    func testFetchMealsSuccess() async {
        let mealID = "52772"
        
        let mealViewModel = MealViewModel(id: mealID, loader: MockMealLoader())
        await mealViewModel.reload()
        
        if let error = mealViewModel.error {
            XCTFail("Expected meal, got error: \(error)")
        } else {
            XCTAssertNotNil(mealViewModel.meal)
        }
    }
   
    func testFetchMealsFailure() async {
        let mealID = "0"
        
        let mealViewModel = MealViewModel(id: mealID, loader: MockMealLoader())
        await mealViewModel.reload()
        
        if let _ = mealViewModel.error {
            XCTAssertNil(mealViewModel.meal)
        } else {
            XCTFail("Expected failure, got success instead")
        }
    }
}
