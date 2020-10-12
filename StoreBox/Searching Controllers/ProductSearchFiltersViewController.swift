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
    var dataSource: UITableViewDiffableDataSource<Section, SearchFilter>!
    let viewModel = ProductSearchFiltersViewModel()
    
    // MARK:- Factory
    static func initiate() -> ProductSearchFiltersViewController {
        let viewController = ProductSearchFiltersViewController(style: .insetGrouped)
        viewController.title = "Search Filters"
        return viewController
    }
    
    // MARK:- View's life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.filterSectionsManager.delegate = self
        setupTableView()
        setupTableViewDataSource()
        DispatchQueue.main.async {
            self.loadFilterSections()
        }
    }
    
    // MARK:- Methods
    func loadFilterSections() {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections(viewModel.sections) // to presented in this order
        viewModel.sections.forEach { (section) in
            let filters = viewModel.getSearchFilters(for: section)
            snapshot.appendItems(filters, toSection: section)
        }
        dataSource.apply(snapshot , animatingDifferences: true)
    }
    
    func handleFilterSelection(at indexPath: IndexPath) {
        if let section = section(at: indexPath.section) {
            let snapshot = dataSource.snapshot()
            let filter = snapshot.itemIdentifiers(inSection: section)[indexPath.row]
            viewModel.filterSectionsManager.select(filter: filter, at: section)
        }
    }
    
    
    // MARK:- UI setup
    func setupTableView() {
        tableView.backgroundColor = .systemGroupedBackground
        tableView.sectionHeaderHeight = 48
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(TitledTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: headerId)
    }
    
    // MARK:- TableView dataSource setup
    func setupTableViewDataSource() {
        dataSource = .init(tableView: tableView, cellProvider: dataSourceCellProvider(tableView:indexPath:filter:))
        tableView.dataSource = dataSource
    }
    
    func dataSourceCellProvider(tableView: UITableView, indexPath: IndexPath, filter: SearchFilter) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath)
        
        var isFilterSelected = false
        if let section = section(at: indexPath.section) {
            isFilterSelected = viewModel.isFilterSelected(filter: filter, in: section)
        }
        
        
        cell.selectionStyle = .none
        cell.textLabel?.text = filter.name
        cell.accessoryType = isFilterSelected ? .checkmark : .none
        
        
        return cell
    }
    
    func section(at index: Int) -> Section? {
        let snapshot = dataSource.snapshot()
        guard let section = snapshot.sectionIdentifiers[at: index] else { return nil }
        return section
    }
}

// MARK:- TableView Delegate
extension ProductSearchFiltersViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as? TitledTableViewHeaderFooterView
        headerView?.sectionLabel.text = "\(section)"
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleFilterSelection(at: indexPath)
    }
}


// MARK:- FilterSectionsManagerDelegate implementaion
extension ProductSearchFiltersViewController: FilterSectionsManagerDelegate {
    func filterSectionsManager(didDeselectFilter filter: FilterSectionsManager.SearchFilter) {
        guard let _ = dataSource.snapshot().indexOfItem(filter) else { return }
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([filter])
        dataSource.apply(snapshot)
    }
    
    func filterSectionsManager(didSelectFilter filter: FilterSectionsManager.SearchFilter) {
        guard let _ = dataSource.snapshot().indexOfItem(filter) else { return }
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([filter])
        dataSource.apply(snapshot)
    }
    
    
}

// MARK:- Helper Models
extension ProductSearchFiltersViewController {
    enum Section: Int {
        case sortBy = 0
        case city
        case subCategory
    }
    
    struct SearchFilter: Hashable, NetworkRequestParameterValue {
        let uuid = UUID()
        let name: String
        var requestParamValue: String = ""
    }
    
}
