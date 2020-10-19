//
//  ProductSearchFiltersViewModel.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 12/10/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation

class ProductSearchFiltersViewModel {
    
    typealias Section = ProductSearchFiltersViewController.Section
    typealias SearchFilter = ProductSearchFiltersViewController.SearchFilter
    typealias SearchFilterParams = ProductsSearchingService.SearchFiltersParams
    typealias FilterSectionsSelectionType = FilterSectionsManager.SectionFilters.SelectionType
    
    let filterSectionsManager: FilterSectionsManager
    let listingService = ListingService()
    var sections: [Section] { return filterSectionsManager.sections }
    let sortedSections: [Section] = [.sortBy , .cities , .subCategory]
    
    
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
    
    func getSearchFiltersParams() -> [SearchFilterParams: [SearchFilter] ] {
        let filterSections = filterSectionsManager.filterSections
        var searchParams: [SearchFilterParams : [SearchFilter] ] = [:]
        
        for selectedSection in filterSectionsManager.selectedFilters.keys {
            let sectionSelectionType = filterSections[selectedSection]!.selectionType
            let selectedFilters = filterSectionsManager.selectedFilters(at: selectedSection)
            let searchFilterParam = SearchFilterParams(section: selectedSection)
            switch sectionSelectionType {
                case .signle, .multiple :
                    searchParams[searchFilterParam] = selectedFilters
            }
        }
        return searchParams
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

fileprivate extension ProductsSearchingService.SearchFiltersParams {
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
