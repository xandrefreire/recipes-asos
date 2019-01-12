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

class RecipeListViewController: UIViewController {

    // Mark: - Constants
    enum Constants {
        static let columns: CGFloat = 2
        static let itemSpacing: CGFloat = 10
        static let itemHeight: CGFloat = 215
    }
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
           collectionView.register(RecipeCell.self)
        }
    }
    
    // MARK: Properties
    private let collectionViewLayout: UICollectionViewFlowLayout
    private let viewModel: RecipeListViewModelProtocol
    private let cellPresenter: RecipeCellPresenter

    // Mark: - Initialization
    init(viewModel: RecipeListViewModelProtocol, cellPresenter: RecipeCellPresenter, collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()) {
        self.viewModel = viewModel
        self.cellPresenter = cellPresenter
        self.collectionViewLayout = collectionViewLayout
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // Mark: - Setup View
    func calculateItemWidth() -> CGFloat {
        let viewWidth: CGFloat = view.frame.size.width
        let totalSpacing: CGFloat = (Constants.columns - 1) * Constants.itemSpacing
        
        return (viewWidth - totalSpacing) / Constants.columns
    }
    
    func setupView() {
        collectionView.dataSource = self
        let width = calculateItemWidth()
        collectionViewLayout.itemSize = CGSize(width: width, height: width)
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
