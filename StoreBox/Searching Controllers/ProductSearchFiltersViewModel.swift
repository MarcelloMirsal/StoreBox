//
//  ProductSearchFiltersViewModel.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 12/10/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//
import UIKit
protocol ProductSearchFiltersViewModelDelegate: class {
    func productSearchFiltersViewModel(didSubmitFilters filters: [String : Any] )
}
extension ProductSearchFiltersViewModel {
    typealias SearchFilterParams = ProductsSearchingService.SearchFiltersParams
    typealias FilterSectionsSelectionType = FilterSectionsManager.SelectionType
    typealias ViewDataSource = UITableViewDiffableDataSource<Section, ListItem<SearchFilter> >
}

class ProductSearchFiltersViewModel {
    private(set) lazy var filterSectionsManager: FilterSectionsManager = .init(delegate: self)
    let searchService = ProductsSearchingService()
    weak var searchFiltersSubmitionDelegate: ProductSearchFiltersViewModelDelegate?
    var tableViewDataSource: ViewDataSource!
    
    
    var sections: [Section] { return filterSectionsManager.sections }
    let sortedSections: [Section] = [.sortBy , .cities , .subCategory]
    
    // MARK:- TableViewDataSource configuration
    func set(tableViewDataSource: ViewDataSource) {
        self.tableViewDataSource = tableViewDataSource
        var currentSnapshot = self.tableViewDataSource.snapshot()
        currentSnapshot.appendSections(sortedSections)
        self.tableViewDataSource.apply(currentSnapshot, animatingDifferences: false)
    }
    /// set searchFilters directly to dataSource, filters will not be tracked by the FilterSectionsManager, used only when to pass defaults filters from the manager
    func set(searchFilters: [ListItem<SearchFilter>], to section: Section ) {
        var currentSnapshot = tableViewDataSource.snapshot()
        currentSnapshot.appendItems(searchFilters, toSection: section)
        tableViewDataSource.apply(currentSnapshot)
    }
    
    // MARK:- Loading default search filters
    func loadDefaultFilterSections() {
        filterSectionsManager.filterSections.forEach { (section , sectionFilters) in
            set(searchFilters: sectionFilters.filters, to: section)
        }
    }
    
    // MARK:- Loading Dynamic search filters
    /// Fetching Dynamic FilterSections From Server, silent response (no errors will be shown)
    func fetchDynamicFilterSections() {
        let router = ListingService.Router()
        let subcategoriesURLRequest = router.urlRequest(for: .subCategory)
        let citiesURLRequest = router.urlRequest(for: .cities)
        
        searchService.dynamicSearchFiltersList(type: SubcategoriesListDTO.self, urlRequest: subcategoriesURLRequest) { [weak self] (serviceError, list) in
            self?.dynamicFiltersResponseHandlerBlock(serviceError, list,.subCategory, .multiple)
        }
        searchService.dynamicSearchFiltersList(type: CitiesListDTO.self, urlRequest: citiesURLRequest) { [weak self] (serviceError, list) in
            self?.dynamicFiltersResponseHandlerBlock(serviceError, list,.cities, .multiple)
        }
    }
    lazy var dynamicFiltersResponseHandlerBlock: (NetworkServiceError?, SearchFiltersConvertible?,Section, FilterSectionsSelectionType) -> () = { [weak self] (serviceError, filters,section, selectionType) in
        guard let filters = filters?.asSearchFilters().map({ListItem<SearchFilter>(item: $0)}) else { return }
        self?.filterSectionsManager.set(sectionFilters: .init(filters: filters, selectionType: selectionType), to: section)
    }
    
    // MARK:- handle filter selection
    func selectFilter(at indexPath: IndexPath) {
        guard let selectedFilter = tableViewDataSource.itemIdentifier(for: indexPath), let filterSection = tableViewDataSource.snapshot().sectionIdentifiers[at: indexPath.section] else { return }
        filterSectionsManager.select(filter: selectedFilter, at: filterSection)
    }
    
    func isFilterSelected(filter: ListItem<SearchFilter>, in section: Section) -> Bool {
        return filterSectionsManager.isFilterSelected(filter: filter, in: section)
    }
    
    func removeAllSelectedFilters() {
        filterSectionsManager.deselectAllFilters()
    }
    
    // MARK:- Section info
    func section(at index: Int) -> String {
        return section(at: index).rawValue
    }
    
    func section(at index: Int) -> Section {
        return tableViewDataSource.snapshot().sectionIdentifiers[index]
    }
    
    // MARK:- Get SearchFilters Params
    func getSearchFiltersParams() -> [String: Any] {
        var searchParams: [String: Any ] = [:]
        
        for selectedSection in filterSectionsManager.selectedFilters.keys {
            let selectedFilters = filterSectionsManager.selectedFilters(at: selectedSection)
            let searchFilterParamKey = SearchFilterParams(section: selectedSection).rawValue
            searchParams[searchFilterParamKey] = extractFiltersParams(from: selectedFilters)
            let associatedFilter = extractAssociatedFilters(from: selectedFilters)
            searchParams.merge(associatedFilter, uniquingKeysWith: { _,rhs in rhs})
        }
        return searchParams
    }
    func extractFiltersParams(from filters: [ListItem<SearchFilter>]) -> [String] {
        return filters.map({$0.item.filterValue})
    }
    func extractAssociatedFilters(from filters: [ListItem<SearchFilter>]) -> [String : String] {
        return filters.reduce([String:String]()) { (results, filter) -> [String : String] in
            // the dictionary will avoid any duplicated associated filter key, duplicated keyed means two CompositeSearchFilter shared the same associated filter key
            results.merging(filter.item.assotiatedFilters) { (lhs, rhs) -> String in
                return rhs
            }
        }
    }
    
    // MARK:- handle Filters SubmitionDelegate
    func submitSearchFiltersParams() {
        searchFiltersSubmitionDelegate?.productSearchFiltersViewModel(didSubmitFilters: getSearchFiltersParams())
    }
    
}
// MARK:- Handling FilterSectionsManagerDelegate
extension ProductSearchFiltersViewModel: FilterSectionsManagerDelegate {
    func filterSectionManager(didAppendFiltersAtSection section: FilterSectionsManager.Section) {
        if let filters = filterSectionsManager.sectionFilters(for: section)?.filters {
            var currentSnapshot = tableViewDataSource.snapshot()
            currentSnapshot.appendItems(filters, toSection: section)
            tableViewDataSource.apply(currentSnapshot)
        }
    }
    
    func filterSectionsManager(didDeselectFilters filters: [ListItem<SearchFilter>] ) {
        var currentSnapshot = tableViewDataSource.snapshot()
        currentSnapshot.reloadItems(filters)
        tableViewDataSource.apply(currentSnapshot)
    }
    func filterSectionsManager(didSelectFilter filter: ListItem<SearchFilter> ) {
        var currentSnapshot = tableViewDataSource.snapshot()
        currentSnapshot.reloadItems([filter])
        tableViewDataSource.apply(currentSnapshot)
    }
}

extension ListingService.Router {
    func urlRequest(for section: ProductSearchFiltersViewModel.Section) -> URLRequest {
        switch section {
            case .subCategory:
                return self.subCategoryNetworkRequest.urlRequest!
            case .cities:
                return self.citiesNetworkRequest.urlRequest!
            default:
                return NetworkRequest(path: "").urlRequest!
        }
    }
}

extension ProductsSearchingService.SearchFiltersParams {
    init(section: ProductSearchFiltersViewModel.Section) {
        switch section {
            case .sortBy:
                self = .sort
            case .cities:
                self = .city
            case .subCategory:
                self = .subcategories
        }
    }
}
