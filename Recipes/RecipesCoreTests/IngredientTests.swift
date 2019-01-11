//
//  IngredientTests.swift
//  RecipesCoreTests
//
//  Created by Alexandre Freire on 11/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import XCTest
@testable import RecipesCore

class IngredientTests: XCTestCase {

    class Dummy {}
    
    private var data: Data!
    private var decoder: JSONDecoder!
    override func setUp() {
        let path = Bundle(for: Dummy.self).path(forResource: "ingredient", ofType: "json")!
        data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        decoder = JSONDecoder()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testIngredient_CreatedFromValidJson() {
        let ingredient = try? decoder.decode(Ingredient.self, from: data)
        XCTAssertNotNil(ingredient)
        XCTAssertEqual(ingredient?.name, " beef roast")
        XCTAssertEqual(ingredient?.quantity, "1")
        XCTAssertEqual(ingredient?.type, .meat)
    }
}
