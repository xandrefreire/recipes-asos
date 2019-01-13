//
//  RecipeListViewController.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 12/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol RecipeListViewControllerProvider: class {
    var viewController: UIViewController { get }
}
class RecipeListViewController: UIViewController {

    // Mark: - Constants
    enum Constants {
        static let columns: CGFloat = 2
        static let itemSpacing: CGFloat = 10
        static let itemHeight: CGFloat = 290
        static let inset: CGFloat = 8
    }
    
    // MARK: - Outlets
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
           collectionView.register(RecipeCell.self)
        }
    }
    
    // MARK: Properties
    private let collectionViewLayout: UICollectionViewFlowLayout
    private var viewModel: RecipeListViewModelProtocol
    private let cellPresenter: RecipeCellPresenter
    private let searchNavigator: SearchNavigator

    // Mark: - Initialization
    init(viewModel: RecipeListViewModelProtocol, cellPresenter: RecipeCellPresenter, searchNavigator: SearchNavigator, collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()) {
        self.viewModel = viewModel
        self.cellPresenter = cellPresenter
        self.collectionViewLayout = collectionViewLayout
        self.searchNavigator = searchNavigator
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchNavigator.installSearch(viewController: self)
        viewModel.didLoad(then: { [weak self] in
            self?.loadingView.stopAnimating()
            self?.collectionView.reloadData()
        }, catchError: { _ in
            // TODO: Implement
        })
    }
    
    // Mark: - Setup View
    func calculateItemWidth() -> CGFloat {
        let viewWidth: CGFloat = view.frame.size.width
        let totalSpacing: CGFloat = (Constants.columns - 1) * Constants.itemSpacing + 2 * Constants.inset
        
        return (viewWidth - totalSpacing) / Constants.columns
    }
    
    func setupView() {
        title = "Recipes"
        collectionView.dataSource = self
        collectionView.delegate = self
        let width = calculateItemWidth()
        collectionViewLayout.itemSize = CGSize(width: width, height: Constants.itemHeight)
        collectionViewLayout.sectionInset = UIEdgeInsets(top: Constants.inset, left: Constants.inset, bottom: Constants.inset, right: Constants.inset)
        collectionView.collectionViewLayout = collectionViewLayout
    }
}

extension RecipeListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.recipesCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(RecipeCell.self, for: indexPath)
        
        let recipe = viewModel.recipe(at: indexPath.row)
    
        if let recipe = recipe {
            cellPresenter.present(recipe, in: cell)
        }
        
        return cell
    }
}

extension RecipeListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let recipe = viewModel.recipe(at: indexPath.row) else { return }
        viewModel.didSelect(recipe: recipe)
    }
}

extension RecipeListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.query.accept(searchController.searchBar.text ?? "")
    }
}
