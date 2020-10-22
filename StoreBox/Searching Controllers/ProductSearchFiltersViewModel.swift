//
//  ProductSearchFiltersViewModel.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 12/10/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation

protocol ProductSearchFiltersViewModelDelegate: class {
    func productSearchFiltersViewModel(didSubmitFilters filters: [String : Any] )
}

class ProductSearchFiltersViewModel {
    typealias Section = ProductSearchFiltersViewController.Section
    typealias SearchFilter = ProductSearchFiltersViewController.SearchFilter
    typealias SearchFilterParams = ProductsSearchingService.SearchFiltersParams
    typealias FilterSectionsSelectionType = FilterSectionsManager.SectionFilters.SelectionType
    
    let filterSectionsManager: FilterSectionsManager
    let listingService = ListingService()
    var sections: [Section] { return filterSectionsManager.sections }
    let sortedSections: [Section] = [.sortBy , .cities , .subCategory]
    weak var searchFiltersSubmitionDelegate: ProductSearchFiltersViewModelDelegate?
    
    init(filterSectionsManagerDelegate: FilterSectionsManagerDelegate? = nil) {
        self.filterSectionsManager = .init(delegate: filterSectionsManagerDelegate)
    }
    
    func getSearchFilters(for section: Section) -> [SearchFilter] {
        filterSectionsManager.sectionFilters(for: section)?.filters ?? []
    }
    
    func isFilterSelected(filter: SearchFilter, in section: Section) -> Bool {
        return filterSectionsManager.isFilterSelected(filter: filter, in: section)
    }
    
    func removeAllSelectedFilters() {
        filterSectionsManager.deselectAllFilters()
    }
    
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
    
    func extractFiltersParams(from filters: [SearchFilter]) -> [String] {
        return filters.map({$0.filterValue})
    }
    
    
    func extractAssociatedFilters(from filters: [SearchFilter]) -> [String : String] {
        return filters.reduce([String:String]()) { (results, filter) -> [String : String] in
            // the dictionary will avoid any duplicated associated filter key, duplicated keyed means two CompositeSearchFilter shared the same associated filter key
            results.merging(filter.assotiatedFilters) { (lhs, rhs) -> String in
                return rhs
            }
        }
    }
    
    func submitSearchFiltersParams() {
        searchFiltersSubmitionDelegate?.productSearchFiltersViewModel(didSubmitFilters: getSearchFiltersParams())
    }
}


extension ProductSearchFiltersViewModel {
    // MARK:- Handle Fetching dynamic FilterSection
    /// Fetching Dynamic FilterSections From Server, silent response (no errors will be shown)
    func fetchDynamicFilterSections() {
        fetchFilterSection(type: SubcategoriesList.self, section: .subCategory)
        fetchFilterSection(type: CitiesList.self, section: .cities)
    }
    
    func fetchFilterSection<T: Decodable>(type: T.Type, section: Section) {
        let urlRequest = ListingService.Router().urlRequest(for: section)
        listingService.getList(listType: type, urlRequest, completion: handleFetchingFilterSection(serviceError:list:))
    }
    
    func handleFetchingFilterSection<T: Decodable>(serviceError: NetworkServiceError?, list: T?) {
        setSectionFilters(from: list)
    }
    
    func setSectionFilters(from filtersList: Decodable? ) {
        var sectionFilters: FilterSectionsManager.SectionFilters
        
        if let subcategoriesList = filtersList as? SubcategoriesList {
            let searchFilters = subcategoriesList.asSearchFilters()
            sectionFilters = FilterSectionsManager.SectionFilters(filters: searchFilters, selectionType: .multiple)
            filterSectionsManager.set(sectionFilters: sectionFilters, to: .subCategory)
        }
        if let citiesList = filtersList as? CitiesList {
            let searchFilters = citiesList.asSearchFilters()
            sectionFilters = FilterSectionsManager.SectionFilters(filters: searchFilters, selectionType: .multiple)
            filterSectionsManager.set(sectionFilters: sectionFilters, to: .cities)
        }
    }
    
    
}

// MARK:- Default Search Filters

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
