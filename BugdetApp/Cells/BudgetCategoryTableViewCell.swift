//
//  BudgetCategoryTableViewCell.swift
//  BugdetApp
//
//  Created by Finn Christoffer Kurniawan on 29/01/23.
//

import Foundation
import UIKit

class BudgetTableViewCell: UITableViewCell {
    
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Properties
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var amoutLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    private lazy var remainingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.alpha = 0.5
        return label
    }()
    
    private lazy var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 44)
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var vStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.alignment = .trailing
        stackView.axis = .vertical
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    // MARK: - Helpers
    
    private func setupUI() {
        stackView.addArrangedSubview(nameLabel)
        vStackView.addArrangedSubview(amoutLabel)
        vStackView.addArrangedSubview(remainingLabel)
        stackView.addArrangedSubview(vStackView)
        addSubview(stackView)
        
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    func configure(_ budgetCategory: BudgetCategory) {
        nameLabel.text = budgetCategory.name
        amoutLabel.text = budgetCategory.amount.formatAsCurrency()
        remainingLabel.text = "Remaining: \(budgetCategory.remainingAmout.formatAsCurrency())"
    }
}



#if DEBUG
import SwiftUI

struct BudgetTableViewCellRepresentable: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        BudgetTableViewCell(style: .default, reuseIdentifier: "BudgetTableViewCell")
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}


struct BudgetTableViewCell_Preview: PreviewProvider {
    static var previews: some View {
        BudgetTableViewCellRepresentable()
    }
}

#endif
