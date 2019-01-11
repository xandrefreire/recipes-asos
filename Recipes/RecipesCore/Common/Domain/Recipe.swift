//
//  Recipe.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 11/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import Foundation

typealias Step = (description: String, time: Int)

struct Recipe: Decodable {
    
    enum Complexity: String {
        case easy, medium, hard
    }
    
    let name: String
    let ingredients: [Ingredient]
    private let _steps: [String]
    private let _timers: [Int]
    let imageURL: URL
    let originalURL: URL
    
    private enum CodingKeys: String, CodingKey {
        case name, ingredients, imageURL, originalURL
        case _steps = "steps"
        case _timers = "timers"
    }
}

extension Recipe {
    var steps: [Step] {
        return _steps.enumerated().map {
            return ($1, _timers[$0])
        }
    }
    
    var ingredientsCount: Int {
        return ingredients.count
    }
    
    var stepsCount: Int {
        return steps.count
    }
}

extension Recipe {
    var complexity: Complexity {
        switch ingredientsCount {
        case 0..<3:
            return .easy
        case 3..<5:
            return .medium
        default:
            return .hard
        }
    }
    
    var timeRequired: String {
        let totalTime = _timers.reduce(0, +)
        switch totalTime {
        case 0..<10:
            return "0-10min"
        case 10..<20:
            return "10-20min"
        default:
            return "+20min"
        }
    }
}


