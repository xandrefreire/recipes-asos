//
//  RecipeListViewModel.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 12/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol RecipeListView: class {
    var title: String? { get set }
    func setLoading(_ loading: Bool)
    func update(with library: RecipeLibrary)
    func show(error: Error)
}

protocol RecipeListViewModelProtocol {
    var complexitySelected: Recipe.Complexity? { get set }
    var query: BehaviorRelay<String> { get set }
    var recipesCount: Int { get }
    func didLoad(then completion: @escaping () -> Void, catchError: @escaping (Error) -> Void)
    func recipe(at index: Int) -> Recipe?
    func didSelect(recipe: Recipe)
}

final class RecipeListViewModel: RecipeListViewModelProtocol {
    
    
    // MARK: Properties
    private var library: RecipeLibrary?
    private var filteredLibrary: RecipeLibrary?
    internal var repository: RecipeLibraryRepositoryProtocol
    private let detailNavigator: DetailNavigator
    private let disposeBag = DisposeBag()
    
    // MARK: Initialization
    init(repository: RecipeLibraryRepositoryProtocol, detailNavigator: DetailNavigator) {
        self.repository = repository
        self.detailNavigator = detailNavigator
        self.library = nil
    }
    
    // MARK: RecipeListViewModelProtocol
    var recipesCount: Int {
        guard let count = filteredLibrary?.count else {
            return 0
        }
        
        return count
    }
    
    var complexitySelected: Recipe.Complexity? = nil
    
    var query: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    func recipe(at index: Int) -> Recipe? {
        return filteredLibrary?.recipe(at: index)
    }
    
    func didLoad(then completion: @escaping () -> Void, catchError: @escaping (Error) -> Void) {
        repository.library()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.library = $0
                self.filteredLibrary = self.library
                completion()
            }, onError: {
                catchError($0)
            })
            .disposed(by: disposeBag)
        
        query.asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                guard $0.count >= 2 else {
                    self.filteredLibrary = self.library?.recipes(withComplexity: self.complexitySelected)
                    completion()
                    return
                }
                
                self.filteredLibrary = self.library?.recipes(filteredBy: $0, complexity: self.complexitySelected)
                completion()
            }, onError: {
                catchError($0)
            })
            .disposed(by: disposeBag)
    }
    
    func didSelect(recipe: Recipe) {
        detailNavigator.showDetail(of: recipe)
    }
}
