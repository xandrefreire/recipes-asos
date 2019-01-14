//
//  RecipeLibraryTests.swift
//  RecipesCoreTests
//
//  Created by Alexandre Freire on 11/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import XCTest
@testable import RecipesCore

class RecipeLibraryTests: XCTestCase {

    class Dummy {}
    
    var library: RecipeLibrary!
    
    override func setUp() {
        let path = Bundle(for: Dummy.self).path(forResource: "recipes", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let decoder = JSONDecoder()
        let recipes = try? decoder.decode([Recipe].self, from: data)
        library = RecipeLibrary(recipes: recipes!)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRecipeLibraryExistence() {
        XCTAssertNotNil(library)
    }

    func testRecipeLibaryCount() {
        XCTAssertEqual(library.count, 9)
    }
    
    func testRecipeLibary_RecipeAtIndex_ReturnsTheCorrectRecipe() {
        var recipe = library.recipe(at: 0)
        
        XCTAssertEqual(recipe?.name, "Crock Pot Roast")
        XCTAssertEqual(recipe?.ingredients.count, 5)
        XCTAssertEqual(recipe?.steps.count, 4)
        XCTAssertEqual(recipe?.imageURL, URL(string: "http://img.sndimg.com/food/image/upload/w_266/v1/img/recipes/27/20/8/picVfzLZo.jpg")!)
        XCTAssertEqual(recipe?.originalURL, URL(string: "http://www.food.com/recipe/to-die-for-crock-pot-roast-27208")!)
        
        recipe = library.recipe(at: 3)
        XCTAssertEqual(recipe?.name, "Big Night Pizza")
        XCTAssertEqual(recipe?.originalURL, nil)

    }
    
    func testRecipeLibrary_FilteredByQuery_ReturnsTheCorrectSubLibrary() {
        var filtered = library.recipes(filteredBy: "Pizza")
        
        XCTAssertEqual(filtered.count, 1)
        
        filtered = library.recipes(filteredBy: "Roast")
        
        XCTAssertEqual(filtered.count, 2)
    }
    
    func testRecipeLibrary_FilteredByQueryAndComplexity_ReturnsTheCorrectSubLibrary() {
        var filtered = library.recipes(filteredBy: "Pizza", complexity: .hard)
        XCTAssertEqual(filtered.count, 0)
        
        filtered = library.recipes(filteredBy: "Roast", complexity: .hard)
        XCTAssertEqual(filtered.count, 0)
        filtered = library.recipes(filteredBy: "Roast", complexity: .medium)
        XCTAssertEqual(filtered.count, 1)
        filtered = library.recipes(filteredBy: "Roast", complexity: .easy)
        XCTAssertEqual(filtered.count, 1)
    }
}
