//
//  BudgetDetailsViewController.swift
//  BugdetApp
//
//  Created by Finn Christoffer Kurniawan on 28/01/23.
//

import Foundation
import UIKit
import SnapKit
import CoreData

class BudgetDetailsViewController: UIViewController {
    
    private var persistentContainer: NSPersistentContainer
    private var fetchedResultsController: NSFetchedResultsController<Transaction>!
    private var budgetCategory: BudgetCategory
    
    init(budgetCategory: BudgetCategory, persistentContainer: NSPersistentContainer) {
        self.budgetCategory = budgetCategory
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
        
        let request = Transaction.fetchRequest()
        request.predicate = NSPredicate(format: "category =%@", budgetCategory)
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            errorMessageLabel.text = "Unable to fetch transactions."
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    private lazy var nameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Transaction name"
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textfield.leftViewMode = .always
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    private lazy var amountTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Transaction name"
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textfield.leftViewMode = .always
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TransactionTableViewCell")
        return tableView
    }()
    
    private lazy var saveTransactionButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.setTitle("Save Transaction", for: .normal)
        button.addTarget(self, action: #selector(saveTransactionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var errorMessageLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor.red
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
       let label = UILabel()
        label.text = budgetCategory.amount.formatAsCurrency()
        return label
    }()
    
    private lazy var transactionsTotalLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    var transactionTotal: Double {
        let transaction = fetchedResultsController.fetchedObjects ?? []
        return transaction.reduce(0) { next, transaction in
            next + transaction.amount
        }
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        return stackView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraint()
        updateTransactionTotal()
    }
    // MARK: - Helpers
    
    private func setupUI() {
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = budgetCategory.name
        
        stackView.addArrangedSubview(amountLabel)
        stackView.setCustomSpacing(50, after: amountLabel)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(amountTextField)
        stackView.addArrangedSubview(saveTransactionButton)
        stackView.addArrangedSubview(errorMessageLabel)
        stackView.addArrangedSubview(transactionsTotalLabel)
        stackView.addArrangedSubview(tableView)
        
        view.addSubview(stackView)
    }
    
    private func setupConstraint() {
        nameTextField.snp.makeConstraints { make in
            make.width.equalTo(200)
        }
        
        amountTextField.snp.makeConstraints { make in
            make.width.equalTo(200)
        }
        
        saveTransactionButton.snp.makeConstraints { make in
            make.centerX.equalTo(stackView)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(600)
        }
    }
    
    private var isFormValid: Bool {
        guard let name = nameTextField.text, let amount = amountTextField.text else {return false}
        
        return !name.isEmpty && !amount.isEmpty && amount.isNumeric && amount.isGreaterThan(0)
    }
    
    private func saveTransaction() {
        
        guard let name = nameTextField.text, let amount = amountTextField.text else {
            return
        }
        
        let transaction = Transaction(context: persistentContainer.viewContext)
        transaction.name = name
        transaction.amount = Double(amount) ?? 0.0
        transaction.category = budgetCategory
        transaction.dateCreated = Date()
        
        
        do {
            try persistentContainer.viewContext.save()
            resetForm()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            errorMessageLabel.text = "Unable to save transaction."
        }
    }
    
    private func updateTransactionTotal() {
        transactionsTotalLabel.text = transactionTotal.formatAsCurrency()
    }
    
    private func resetForm() {
        nameTextField.text = ""
        amountTextField.text = ""
        errorMessageLabel.text = ""
    }
    
    // MARK: - Selector
    
    @objc func saveTransactionButtonTapped(_ sender: UIButton) {
        if isFormValid {
            saveTransaction()
        } else {
            errorMessageLabel.text = "Make sure name and amount is valid."
        }
    }
    
    
}

// MARK: - TableView Delegate & Datasource

extension BudgetDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (fetchedResultsController.fetchedObjects ?? []).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath)
        
        let transaction = fetchedResultsController.object(at: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = transaction.name
        content.secondaryText = transaction.amount.formatAsCurrency()
        cell.contentConfiguration = content
        
        return cell
    }
}

extension BudgetDetailsViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.updateTransactionTotal()
            self.tableView.reloadData()
        }
    }
}

extension BudgetDetailsViewController: UITableViewDelegate {
    
}
