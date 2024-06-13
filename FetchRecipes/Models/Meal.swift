//
//  Meal.swift
//  FetchRecipes
//
//  Created by Hlib Sobolevskyi on 2024-06-11.
//

import Foundation

struct MealBriefs: Decodable {
    let meals: [MealBrief]
}

struct MealBrief: Decodable, Identifiable {
    let strMeal: String
    let strMealThumb: URL?
    let idMeal: String
    
    var id: String { idMeal }
}

struct Meals: Decodable {
    let meals: [Meal]
}

struct Meal: Decodable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strDrinkAlternate: String?
    let strCategory: String
    let strArea: String
    let strInstructions: String
    let strMealThumb: URL?
    let strTags: String?
    let strYoutube: URL?
    let ingredients: [Ingreditent]
    let strSource: URL?
    let strImageSource: URL?
    let strCreativeCommonsConfirmed: String?
    let dateModified: String?
    
    var id: String { idMeal }
}

struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int?
    
    init?(intValue: Int) {
        return nil
    }
}

extension Meal {
    enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strDrinkAlternate, strCategory, strArea, strInstructions, strMealThumb, strTags, strYoutube, strSource, strImageSource, strCreativeCommonsConfirmed, dateModified
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
                
        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strDrinkAlternate = try container.decodeIfPresent(String.self, forKey: .strDrinkAlternate)
        strCategory = try container.decode(String.self, forKey: .strCategory)
        strArea = try container.decode(String.self, forKey: .strArea)
        strInstructions = try container.decode(String.self, forKey: .strInstructions)
        strMealThumb = try? container.decode(URL.self, forKey: .strMealThumb)
        strTags = try container.decodeIfPresent(String.self, forKey: .strTags)
        strYoutube = try? container.decode(URL.self, forKey: .strYoutube)
        strSource = try? container.decodeIfPresent(URL.self, forKey: .strSource)
        strImageSource = try? container.decodeIfPresent(URL.self, forKey: .strImageSource)
        strCreativeCommonsConfirmed = try container.decodeIfPresent(String.self, forKey: .strCreativeCommonsConfirmed)
        dateModified = try container.decodeIfPresent(String.self, forKey: .dateModified)
        
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        var igredients = [Ingreditent]()
        for index in 0...20 {
            guard let ingredientKey = DynamicCodingKeys(stringValue: "strIngredient\(index)"),
                  let name = try dynamicContainer.decodeIfPresent(String.self, forKey: ingredientKey),
                  !name.isEmpty else {
                continue
            }
            
            if let measureKey = DynamicCodingKeys(stringValue: "strMeasure\(index)"),
               let measure = try dynamicContainer.decodeIfPresent(String.self, forKey: measureKey),
               !measure.isEmpty {
                igredients.append(Ingreditent(name: name, measure: measure))
            } else {
                igredients.append(Ingreditent(name: name, measure: nil))
            }
        }
        
        self.ingredients = igredients
    }
}

struct Ingreditent: Hashable, Identifiable {
    let name: String
    let measure: String?
    
    var id: Int { hashValue }
}
