//
//  PhoneSearchNavigator.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 13/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import Foundation

final class PhoneSearchNavigator: SearchNavigator {
    
    // MARK: Properties
    private var searchController: UISearchController!

    // MARK: SearchNavigator
    func installSearch(viewController: UIViewController, scopeOptions: [String]? = nil) {
        guard let resultsViewController = viewController as? UISearchResultsUpdating else {
            fatalError("viewController must conform to UISearchResultsUpdating protocol")
        }
        
        
        
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = resultsViewController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("Search", comment: "")
        searchController.searchBar.searchBarStyle = .minimal
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.showsScopeBar = true

        if let viewControllerWithScopeOptions = viewController as? UISearchBarDelegate,
            let scopeOptions = scopeOptions {
            searchController.searchBar.scopeButtonTitles = scopeOptions
            searchController.searchBar.delegate = viewControllerWithScopeOptions
        }
        searchController.searchBar.sizeToFit()
        viewController.navigationItem.titleView = searchController.searchBar
        viewController.definesPresentationContext = true
    }
}
