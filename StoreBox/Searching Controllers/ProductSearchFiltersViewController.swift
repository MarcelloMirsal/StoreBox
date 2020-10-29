//
//  ProductSearchFiltersViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 03/10/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class ProductSearchFiltersViewController: UITableViewController {
    let cellId = "cellId"
    let headerId = "headerId"
    private(set) lazy var submitButton: UIRoundButton = {
        let button = UIRoundButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSubmitAction), for: .touchUpInside)
        return button
    }()
    private(set) lazy var resetFilterBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleFiltersResetAction))
        return button
    }()
    private(set) lazy var viewModel: ProductSearchFiltersViewModel = {
        let viewModel = ProductSearchFiltersViewModel()
        return viewModel
    }()
    
    // MARK:- Factory
    static func initiate() -> ProductSearchFiltersViewController {
        let viewController = ProductSearchFiltersViewController(style: .insetGrouped)
        viewController.title = "Search Filters"
        return viewController
    }
    
    // MARK:- View's life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSubViews()
        setupTableViewDataSource()
        DispatchQueue.main.async {
            self.viewModel.loadDefaultFilterSections()
        }
        viewModel.fetchDynamicFilterSections()
    }
    
    // MARK:- UI setup
    func setupTableView() {
        tableView.backgroundColor = .systemGroupedBackground
        tableView.sectionHeaderHeight = 48
        tableView.contentInset.bottom = 64
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(TitledTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: headerId)
    }
    
    fileprivate func setupSubViews() {
        if let navigationView = navigationController?.view {
            navigationView.addSubview(submitButton)
            NSLayoutConstraint.activate([
                submitButton.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: -24),
                submitButton.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor, constant: 16),
                submitButton.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor, constant: -16),
                submitButton.heightAnchor.constraint(equalToConstant: 48)
            ])
            navigationItem.rightBarButtonItem = resetFilterBarButton
        }
    }
    
    // MARK:- Action Handlers
    @objc
    func handleSubmitAction() {
        viewModel.submitSearchFiltersParams()
        dismiss(animated: true)
    }
    
    @objc
    func handleFiltersResetAction() {
        viewModel.removeAllSelectedFilters()
    }
    
    // MARK:- TableView dataSource setup
    func setupTableViewDataSource() {
        let dataSource: ProductSearchFiltersViewModel.ViewDataSource
        dataSource = .init(tableView: tableView, cellProvider: dataSourceCellProvider)
        viewModel.set(tableViewDataSource: dataSource)
    }
    
    private(set) lazy var dataSourceCellProvider: (UITableView, IndexPath, ListItem<SearchFilter>) -> UITableViewCell? = { [id = self.cellId , weak self] (tableView, indexPath, listItem) -> UITableViewCell? in
        guard let strongSelf = self else { return nil }
        var isFilterSelected = false
        
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        
        isFilterSelected = strongSelf.viewModel.isFilterSelected(filter: listItem, in: strongSelf.viewModel.section(at: indexPath.section))
        
        cell.selectionStyle = .none
        cell.textLabel?.text = listItem.item.name
        cell.accessoryType = isFilterSelected ? .checkmark : .none
        return cell
    }
}

// MARK:- TableView Delegate
extension ProductSearchFiltersViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as? TitledTableViewHeaderFooterView
        let sectionIndex = section
        headerView?.sectionLabel.text = viewModel.section(at: sectionIndex)
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectFilter(at: indexPath)
    }
}

// MARK:- Helper Models
extension ProductSearchFiltersViewModel {
    enum Section: String {
        case sortBy = "Sort by"
        case cities = "City"
        case subCategory = "Category"
    }
}
