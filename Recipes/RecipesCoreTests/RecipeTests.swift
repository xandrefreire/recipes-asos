//
//  RecipeTests.swift
//  RecipesCoreTests
//
//  Created by Alexandre Freire on 11/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import XCTest
@testable import RecipesCore

class RecipeTests: XCTestCase {

    class Dummy {}
    
    private var recipe: Recipe!
    
    override func setUp() {
        let path = Bundle(for: Dummy.self).path(forResource: "one_recipe", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let decoder = JSONDecoder()
        recipe = try! decoder.decode(Recipe.self, from: data)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRecipeExistence() {
        XCTAssertNotNil(recipe)
    }
    
    func testRecipe_CreatedFromValidJson() {
        XCTAssertEqual(recipe.name, "Crock Pot Roast")
        XCTAssertEqual(recipe.ingredients.count, 5)
        XCTAssertEqual(recipe.steps.count, 4)
        XCTAssertEqual(recipe.imageURL, URL(string: "http://img.sndimg.com/food/image/upload/w_266/v1/img/recipes/27/20/8/picVfzLZo.jpg")!)
        XCTAssertEqual(recipe?.originalURL, nil)
    }
    
    func testRecipe_WhenCustomStepsCalled_ThenReturnsTheCorrectTuple() {
        let steps = recipe.steps
        
        XCTAssertEqual(steps[0].description, "Place beef roast in crock pot.")
            XCTAssertEqual(steps[0].time, 0)
        
        XCTAssertEqual(steps[1].description, "Mix the dried mixes together in a bowl and sprinkle over the roast.")
        XCTAssertEqual(steps[1].time, 0)
        
        XCTAssertEqual(steps[2].description, "Pour the water around the roast.")
        XCTAssertEqual(steps[2].time, 0)
        
        XCTAssertEqual(steps[3].description, "Cook on low for 7-9 hours.")
        XCTAssertEqual(steps[3].time, 420)
    }
    
    func testRecipe_IngredientsCount() {
        XCTAssertEqual(recipe.ingredientsCount, 5)
    }
    
    func testRecipe_StepsCount() {
        XCTAssertEqual(recipe.stepsCount, 4)
    }
    
    func testRecipe_Complexity() {
        XCTAssertEqual(recipe.complexity, .hard)
    }
    
    func testRecipe_TimeRequired() {
        XCTAssertEqual(recipe.timeRequired, "+20min")
    }
    
    func testRecipe_ContainsIngredient_CaseInsensitive() {
        XCTAssertTrue(recipe.contains(ingredient: "water"))
        XCTAssertTrue(recipe.contains(ingredient: "Water"))
        XCTAssertTrue(recipe.contains(ingredient: "WaTeR"))
        
        XCTAssertFalse(recipe.contains(ingredient: "wine"))
    }
    
    func testRecipe_ContainsStep_CaseInsensitive() {
        XCTAssertTrue(recipe.contains(step: "Cook"))
        XCTAssertTrue(recipe.contains(step: "cooK"))
        XCTAssertTrue(recipe.contains(step: "Mix"))
        
        XCTAssertFalse(recipe.contains(step: "Boil"))
    }
    
    func testRecipe_ContainsName_CaseInsensitive() {
        XCTAssertTrue(recipe.contains(name: "Roast"))
        XCTAssertTrue(recipe.contains(name: "Pot Roast"))
        XCTAssertTrue(recipe.contains(name: "poT roAsT"))
        
        XCTAssertFalse(recipe.contains(name: "tomatoe"))
    }
    
    
}
