//
//  ViewController.swift
//  BugdetApp
//
//  Created by Finn Christoffer Kurniawan on 27/01/23.
//

import UIKit
import CoreData

class BudgetCategoriesTableViewController: UITableViewController {

    private var persistentContainers: NSPersistentContainer
    
    init(persistentContainers: NSPersistentContainer) {
        self.persistentContainers = persistentContainers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    // MARK: - Helpers

    private func setupUI() {
        
        let addBudgetCattegoryButton = UIBarButtonItem(title: "Add Category", style: .done, target: self, action: #selector(showAddBudgetCategory))
        self.navigationItem.rightBarButtonItem = addBudgetCattegoryButton
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Budget"
    }
    
    // MARK: - Selectors
    
    @objc func showAddBudgetCategory(_ sender: UIBarButtonItem) {
        let navController = UINavigationController(rootViewController: AddBudgetCategoryViewController(persistentContainer: persistentContainers))
        present(navController,animated: true)
    }

}

