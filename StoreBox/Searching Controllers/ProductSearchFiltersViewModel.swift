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
    
    let filterSectionsManager = FilterSectionsManager()
    
    init() {
        let dynamicSectionFilters = FilterSectionsManager.SectionFilters(filters: [
            .init(name: "1"),
            .init(name: "2"),
            .init(name: "3"),
            .init(name: "4"),
            .init(name: "5"),
        ], selectionType: .multiple)
        filterSectionsManager.set(sectionFilters: dynamicSectionFilters, to: .subCategory)
    }
    
    var sections: [Section] {
        return filterSectionsManager.sections
    }
    
    func getSearchFilters(for section: Section) -> [SearchFilter] {
        filterSectionsManager.sectionFilters(for: section)?.filters ?? []
    }
    
    func isFilterSelected(filter: SearchFilter, in section: Section) -> Bool {
        return filterSectionsManager.isFilterSelected(filter: filter, in: section)
    }
}
