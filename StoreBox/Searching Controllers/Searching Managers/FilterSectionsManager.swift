//
//  FilterSectionsManager.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 12/10/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation

protocol FilterSectionsManagerDelegate: class {
    func filterSectionsManager(didDeselectFilter filter: FilterSectionsManager.SearchFilter)
    func filterSectionsManager(didSelectFilter filter: FilterSectionsManager.SearchFilter)
    func filterSectionsManager(didUpdateSection section: FilterSectionsManager.Section)
}

protocol FilterSectionsManagerDataSource: class {
    func filterSectionsManager()
}


/// Managing search filter sections addition  & selection, allowing a section to select a single or multiple filters and keep track of them
class FilterSectionsManager {
    
    typealias Section = ProductSearchFiltersViewController.Section
    typealias SearchFilter = ProductSearchFiltersViewController.SearchFilter
    typealias SearchFilterSection =  [ Section : SectionFilters ]
    typealias SelectedSearchFilters = [Section : Set<SearchFilter> ]
    typealias AssociatedFilters = ProductsSearchingService.AssociatedSearchFiltersParams
    
    private(set) var filterSections: SearchFilterSection = [:]
    private(set) var selectedFilters: SelectedSearchFilters = [:]
    weak var delegate: FilterSectionsManagerDelegate?
    
    var sections: [Section] {
        return filterSections.map({ $0.key})
    }
    
    init(delegate: FilterSectionsManagerDelegate? = nil) {
        self.filterSections = self.getDefaultFilterSection()
        self.delegate = delegate
    }
    
    private func getDefaultFilterSection() -> SearchFilterSection  {
        return [
            .sortBy : .init(filters: [
                .init(name: "Price: low to hight", filterValue: "price", assotiatedFilters: AssociatedFilters.ascendingSorting() ) ,
                .init(name: "Price: hight to low", filterValue: "price", assotiatedFilters: AssociatedFilters.descendingSorting() ),
                .init(name: "Newest", filterValue: "created_at", assotiatedFilters: AssociatedFilters.descendingSorting() ),
                .init(name: "Older", filterValue: "created_at", assotiatedFilters: AssociatedFilters.ascendingSorting())
            ], selectionType: .signle)
        ]
    }
    
    func set(sectionFilters: SectionFilters, to section: Section) {
        filterSections[section] = sectionFilters
        delegate?.filterSectionsManager(didUpdateSection: section)
    }
    
    func sectionFilters(for section: Section) -> SectionFilters? {
        return filterSections[section]
    }
    
    func selectedFilters(at section: Section) -> [SearchFilter] {
        guard let filtersSet = selectedFilters[section] else { return [] }
        return Array(filtersSet)
    }
    
    func isFilterSelected(filter: SearchFilter, in section: Section) -> Bool {
        guard selectedFilters[section]?.contains(filter) == true else {
            return false
        }
        return true
    }
    
    func select(filter: SearchFilter , at section: Section) {
        guard let sectionSelectionType = filterSections[section]?.selectionType else {
            return
        }
        switch sectionSelectionType {
            case .signle:
                handleSingleSelection(selectedFilter: filter, at: section)
            case .multiple:
                handleMultipleSelection(selectedFilter: filter, at: section)
        }
    }
    
    func deselectAllFilters() {
        let selectedSections = selectedFilters.keys
        selectedFilters = [:]
        selectedSections.forEach({ delegate?.filterSectionsManager(didUpdateSection: $0) })
    }
    
    private func handleSingleSelection(selectedFilter: SearchFilter, at section: Section) {
        if let previousSelectedFilter = selectedFilters[section]?.first {
            selectedFilters[section] = []
            delegate?.filterSectionsManager(didDeselectFilter: previousSelectedFilter)
        }
        selectedFilters[section] = [selectedFilter]
        delegate?.filterSectionsManager(didDeselectFilter: selectedFilter)
    }
    
    private func handleMultipleSelection(selectedFilter: SearchFilter, at section: Section) {
        if selectedFilters[section]?.contains(selectedFilter) ?? false {
            selectedFilters[section]?.remove(selectedFilter)
            delegate?.filterSectionsManager(didDeselectFilter: selectedFilter)
            return
        }
        var updateSelectedFiltersSet = Set(selectedFilters[section] ?? [])
        updateSelectedFiltersSet.insert(selectedFilter)
        selectedFilters[section] = updateSelectedFiltersSet
        delegate?.filterSectionsManager(didSelectFilter: selectedFilter)
    }
}

// MARK:- Helpers models
extension FilterSectionsManager {
    struct SectionFilters: Equatable {
        var filters: [SearchFilter]
        let selectionType: SelectionType
        
        enum SelectionType {
            case signle
            case multiple
        }
    }
    
    
}

