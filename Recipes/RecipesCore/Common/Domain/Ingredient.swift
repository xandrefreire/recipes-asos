//
//  Ingredient.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 11/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import Foundation

struct Ingredient: Decodable {
    
    enum Category: String, Decodable {
        case meat = "Meat"
        case drinks = "Drinks"
        case condiments = "Condiments"
        case baking = "Baking"
        case produce = "Produce"
        case misc = "Misc"
        case dairy = "Dairy"
    }
    
    let name: String
    let quantity: String
    let type: Ingredient.Category
}
