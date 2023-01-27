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
    private var fetchedResultsController: NSFetchedResultsController<BudgetCategory>!
    
    init(persistentContainers: NSPersistentContainer) {
        self.persistentContainers = persistentContainers
        super.init(nibName: nil, bundle: nil)
        
        let request = BudgetCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainers.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BudgetTableViewCell")
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
    
    // MARK: - Delegate Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.fetchedObjects ?? []).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetTableViewCell", for: indexPath)
        
        let budgetCategory = fetchedResultsController.object(at: indexPath)
        
        var configuration = cell.defaultContentConfiguration()
        configuration.text = budgetCategory.name
        cell.contentConfiguration = configuration
        
        return cell
    }
}


// MARK: - Extentions

extension BudgetCategoriesTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
