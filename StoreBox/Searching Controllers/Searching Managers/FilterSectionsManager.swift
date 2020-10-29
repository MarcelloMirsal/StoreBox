//
//  FilterSectionsManager.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 12/10/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation

protocol FilterSectionsManagerDelegate: class {
    func filterSectionsManager(didDeselectFilters filters: [ListItem<SearchFilter>])
    func filterSectionsManager(didSelectFilter filter: ListItem<SearchFilter>)
    func filterSectionManager(didAppendFiltersAtSection section: FilterSectionsManager.Section )
}
protocol FilterSectionsManagerDataSource: class {
    func filterSectionsManager()
}
/// Managing search filter sections addition  & selection, allowing a section to select a single or multiple filters and keep track of them
class FilterSectionsManager {
    typealias Section = ProductSearchFiltersViewModel.Section
    typealias SearchFilterSection =  [ Section : SectionFilters ]
    typealias SelectedSearchFilters = [Section : Set< ListItem<SearchFilter> > ]
    typealias AssociatedFilters = ProductsSearchingService.AssociatedSearchFiltersParams
    
    private(set) var filterSections: SearchFilterSection = [:]
    private(set) var selectedFilters: SelectedSearchFilters = [:]
    weak var delegate: FilterSectionsManagerDelegate?
    
    var sections: [Section] { return filterSections.map({ $0.key}) }
    
    init(delegate: FilterSectionsManagerDelegate? = nil) {
        self.filterSections = self.getDefaultFilterSection()
        self.delegate = delegate
    }
    
    // MARK:- Default search filters
    private func getDefaultFilterSection() -> SearchFilterSection  {
        let sortSearchFilters = [
            .init(name: "Price: low to high", filterValue: "price", assotiatedFilters: AssociatedFilters.ascendingSorting() ) ,
            .init(name: "Price: hight to low", filterValue: "price", assotiatedFilters: AssociatedFilters.descendingSorting() ),
            .init(name: "Newest", filterValue: "created_at", assotiatedFilters: AssociatedFilters.descendingSorting() ),
            .init(name: "Older", filterValue: "created_at", assotiatedFilters: AssociatedFilters.ascendingSorting())
        ].map({ListItem<SearchFilter>(item: $0)})
        return [ .sortBy : .init(filters: sortSearchFilters, selectionType: .single) ]
    }
    
    // MARK:- SectionFilters setting & getting
    func set(sectionFilters: SectionFilters, to section: Section) {
        filterSections[section] = sectionFilters
        delegate?.filterSectionManager(didAppendFiltersAtSection: section)
    }
    
    func sectionFilters(for section: Section) -> SectionFilters? {
        return filterSections[section]
    }
    
    // MARK:- filter selection
    func selectedFilters(at section: Section) -> [ListItem<SearchFilter>] {
        guard let filtersSet = selectedFilters[section] else { return [] }
        return Array(filtersSet)
    }
    
    func isFilterSelected(filter: ListItem<SearchFilter>, in section: Section) -> Bool {
        guard selectedFilters[section]?.contains(filter) == true else {
            return false
        }
        return true
    }
    
    func select(filter: ListItem<SearchFilter> , at section: Section) {
        guard let sectionSelectionType = filterSections[section]?.selectionType else {
            return
        }
        switch sectionSelectionType {
            case .single:
                handleSingleSelection(selectedFilter: filter, at: section)
            case .multiple:
                handleMultipleSelection(selectedFilter: filter, at: section)
        }
    }
    
    func deselectAllFilters() {
        let deSelectedFilters = Array(selectedFilters.values).reduce([]) { (result, sectionFilters) -> [ListItem<SearchFilter>]  in
            return result + Array(sectionFilters)
        }
        selectedFilters = [:]
        delegate?.filterSectionsManager(didDeselectFilters: deSelectedFilters)
    }
    
    // MARK:- Selection handling
    private func handleSingleSelection(selectedFilter: ListItem<SearchFilter>, at section: Section) {
        if let previousSelectedFilter = selectedFilters[section]?.first {
            selectedFilters[section] = []
            delegate?.filterSectionsManager(didDeselectFilters: [previousSelectedFilter])
        }
        selectedFilters[section] = [selectedFilter]
        delegate?.filterSectionsManager(didSelectFilter: selectedFilter)
    }
    
    private func handleMultipleSelection(selectedFilter: ListItem<SearchFilter>, at section: Section) {
        if selectedFilters[section]?.contains(selectedFilter) ?? false {
            selectedFilters[section]?.remove(selectedFilter)
            delegate?.filterSectionsManager(didDeselectFilters: [selectedFilter])
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
        var filters: [ListItem<SearchFilter>]
        let selectionType: SelectionType
    }
    enum SelectionType {
        case single
        case multiple
    }
}

