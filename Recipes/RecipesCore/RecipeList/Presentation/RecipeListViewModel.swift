//
//  RecipeListViewModel.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 12/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import Foundation
import RxSwift

protocol RecipeListView: class {
    var title: String? { get set }
    func setLoading(_ loading: Bool)
    func update(with library: RecipeLibrary)
    func show(error: Error)
}

protocol RecipeListViewModelProtocol {
    var recipesCount: Int { get }
    var didLoadLibrary: () -> Void { get set }
    var didGetError: (Error) -> Void { get set }
    func recipe(at index: Int) -> Recipe?
}

final class RecipeListViewModel: RecipeListViewModelProtocol {
    
    
    // MARK: Properties
    private var library: RecipeLibrary?
    internal var repository: RecipeLibraryRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    // MARK: Initialization
    init(repository: RecipeLibraryRepositoryProtocol) {
        self.repository = repository
        self.library = nil
        
        repository.library()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.library = $0
                self.didLoadLibrary()
                
            }, onError: { [weak self] in
                self?.didGetError($0)
            })
            .disposed(by: disposeBag)
        
    }
    
    // MARK: RecipeListViewModelProtocol
    var didLoadLibrary: () -> Void = { }
    var didGetError: (Error) -> Void = { _ in }
    var recipesCount: Int {
        guard let count = library?.count else {
            return 0
        }
        
        return count
    }
    
    func recipe(at index: Int) -> Recipe? {
        return library?.recipe(at: index)
    }
}
