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
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
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
    
    var dataSource: UITableViewDiffableDataSource<Section, SearchFilter>!
    private(set) lazy var viewModel: ProductSearchFiltersViewModel = {
        let viewModel = ProductSearchFiltersViewModel(filterSectionsManagerDelegate: self)
        return viewModel
    }()
    
    // MARK:- Factory
    static func initiate() -> ProductSearchFiltersViewController {
        let viewController = ProductSearchFiltersViewController(style: .insetGrouped)
        viewController.title = "Search Filters"
        return viewController
    }
    
    // MARK:- View's life cycle
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTableViewDataSource()
        viewModel.fetchDynamicFilterSections()
        loadFilterSections()
        setupSubViews()
    }
    
    // MARK:- UI setup
    func setupTableView() {
        tableView.tableHeaderView = activityIndicator
        tableView.backgroundColor = .systemGroupedBackground
        tableView.sectionHeaderHeight = 48
        tableView.contentInset.bottom = 64
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(TitledTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: headerId)
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
    
    // MARK:- Methods
    func loadFilterSections() {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections(viewModel.sortedSections)
        viewModel.sections.forEach { (section) in
            let filters = viewModel.getSearchFilters(for: section)
            snapshot.appendItems(filters, toSection: section)
        }
        dataSource.apply(snapshot , animatingDifferences: false)
    }
    
    func handleFilterSelection(at indexPath: IndexPath) {
        if let section = section(at: indexPath.section), let filter = dataSource.itemIdentifier(for: indexPath) {
            viewModel.filterSectionsManager.select(filter: filter, at: section)
        }
    }
    
    func reload(filter: SearchFilter) {
        guard let _ = dataSource.indexPath(for: filter) else { return }
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([filter])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK:- TableView dataSource setup
    func setupTableViewDataSource() {
        dataSource = .init(tableView: tableView, cellProvider: { [unowned self]
            (tableView, indexPath, filter) -> UITableViewCell? in
            
            var isFilterSelected = false
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath)
            
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
        
        if snapshot.itemIdentifiers(inSection: section).isEmpty {
            let searchFilters = viewModel.getSearchFilters(for: section)
            snapshot.appendItems(searchFilters, toSection: section)
            activityIndicator.stopAnimating()
        } else {
            snapshot.reloadSections([section])
        }
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
    
    struct SearchFilter: Hashable, CompositeSearchFilterProtocol {
        
        let uuid = UUID()
        let name: String
        var filterValue: String
        let assotiatedFilters: [String : String]
        
        init(name: String, filterValue: String = "", assotiatedFilters: [String : String] = [:] ) {
            self.name = name
            self.filterValue = filterValue
            self.assotiatedFilters = assotiatedFilters
        }
    }
}


protocol SearchFilterProtocol {
    /// the main search filter parameter value, like sorting , categories and cities (standalone filter)
    var filterValue: String { get set }
}


/// a Search filter that composite from multiple filters
protocol CompositeSearchFilterProtocol: SearchFilterProtocol{
    /// the secondary search filters used to specify presentation direction like ascending & descending
    var assotiatedFilters: [String : String] { get }
}
