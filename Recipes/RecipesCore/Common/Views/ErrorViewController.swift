//
//  ErrorViewController.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 14/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import UIKit

class ErrorViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: Properties
    private let error: String
    
    // MARK: Initialization
    init(error: String) {
        self.error = error
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelDidTap))
        errorLabel.text = error
    }
    
    @objc func cancelDidTap() {
        dismiss(animated: true, completion: nil)
    }
}
