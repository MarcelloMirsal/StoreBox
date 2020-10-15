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
        viewModel.fetchDynamicFilterSections()
        setupTableView()
        setupTableViewDataSource()
        loadFilterSections()
    }
    
    // MARK:- UI setup
    func setupTableView() {
        tableView.backgroundColor = .systemGroupedBackground
        tableView.sectionHeaderHeight = 48
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(TitledTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: headerId)
    }
    
    // MARK:- Methods
    func loadFilterSections() {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.sortBy , .cities, .subCategory])
        viewModel.sections.forEach { (section) in
            let filters = viewModel.getSearchFilters(for: section)
            snapshot.appendItems(filters, toSection: section)
        }
        dataSource.apply(snapshot , animatingDifferences: false)
    }
    
    func handleFilterSelection(at indexPath: IndexPath) {
        guard let section = section(at: indexPath.section) else { return }
        let snapshot = dataSource.snapshot()
        let sectionFilters = snapshot.itemIdentifiers(inSection: section)
        if let filter = sectionFilters[at: indexPath.row] {
            viewModel.filterSectionsManager.select(filter: filter, at: section)
        }
    }
    
    func reload(filter: SearchFilter) {
        guard let _ = dataSource.snapshot().indexOfItem(filter) else { return }
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([filter])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK:- TableView dataSource setup
    func setupTableViewDataSource() {
        dataSource = .init(tableView: tableView, cellProvider: { [unowned self]
            (tableView, indexPath, filter) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath)
            
            var isFilterSelected = false
            if let section = self.section(at: indexPath.section) {
                isFilterSelected = self.viewModel.isFilterSelected(filter: filter, in: section)
            }
            cell.selectionStyle = .none
            cell.textLabel?.text = filter.name
            cell.accessoryType = isFilterSelected ? .checkmark : .none
            return cell
        })
        tableView.dataSource = dataSource
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
        let sectionIndex = section
        headerView?.sectionLabel.text = self.section(at: sectionIndex)?.rawValue
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleFilterSelection(at: indexPath)
    }
}


// MARK:- FilterSectionsManagerDelegate implementaion
extension ProductSearchFiltersViewController: FilterSectionsManagerDelegate {
    func filterSectionsManager(didUpdateSection section: FilterSectionsManager.Section) {
        var snapshot = dataSource.snapshot()
        let searchFilters = viewModel.getSearchFilters(for: section)
        snapshot.appendItems(searchFilters, toSection: section)
        dataSource.apply(snapshot)
    }
    
    func filterSectionsManager(didDeselectFilter filter: FilterSectionsManager.SearchFilter) {
        reload(filter: filter)
    }
    
    func filterSectionsManager(didSelectFilter filter: FilterSectionsManager.SearchFilter) {
        reload(filter: filter)
    }
    
    
}

// MARK:- Helper Models
extension ProductSearchFiltersViewController {
    enum Section: String {
        case sortBy = "Sort by"
        case cities = "City"
        case subCategory = "Category"
    }
    
    struct SearchFilter: Hashable {
        let uuid = UUID()
        let name: String
        var filterValue: String
        
        init(name: String, filterValue: String = "") {
            self.name = name
            self.filterValue = filterValue
        }
    }
}
