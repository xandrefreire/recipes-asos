//
//  IngredientView.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 13/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import UIKit

final class RowView: UIView, NibLoadableView {
    
    private enum Constants {
        static let height: CGFloat = 70
    }
    
    // MARK: - Outlets
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    // MARK: - Overrides
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: Constants.height)
    }
}
