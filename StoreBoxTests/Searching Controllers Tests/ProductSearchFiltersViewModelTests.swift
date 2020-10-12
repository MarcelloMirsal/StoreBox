//
//  ProductSearchFiltersViewModelTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 12/10/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox

class ProductSearchFiltersViewModelTests: XCTestCase {
    
    var sut: ProductSearchFiltersViewModel!
    
    override func setUp() {
        sut = ProductSearchFiltersViewModel()
    }
    
    func testSutSections_ShouldBeEqualToFilterSectionsManagerSections() {
        XCTAssertEqual(sut.filterSectionsManager.sections, sut.sections)
    }
    
    func testSutGetSearchFiltersForStaticSection_ShouldReturnFiltersEqualToFilterSectionManager() {
        let staticSection = ProductSearchFiltersViewController.Section.sortBy
        let filters = sut.getSearchFilters(for: staticSection)
        
        let managerFilters = sut.filterSectionsManager.sectionFilters(for: staticSection)?.filters ?? []
        print(managerFilters)
        XCTAssertEqual(filters, managerFilters )
    }
    
    func testIsFilterSelected_ShouldReturnFalseIfFilterDeSelected() {
        let isFilterSelected = sut.isFilterSelected(filter: .init(name: "1"), in: .city)
        XCTAssertFalse(isFilterSelected)
    }
    
    func testSutGetSearchFiltersForNoneExistSection_ShouldReturnEmptySearchFilters() {
        let section = ProductSearchFiltersViewController.Section.city
        let filters = sut.getSearchFilters(for: section)
        
        XCTAssertTrue(filters.isEmpty)
    }
    
    
}
