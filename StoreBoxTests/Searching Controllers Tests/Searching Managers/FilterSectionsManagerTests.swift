//
//  FilterSectionsManagerTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 12/10/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox

class FilterSectionsManagerTests: XCTestCase {

    var sut: FilterSectionsManager!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = FilterSectionsManager()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSections_ShouldBeEqualToFilterSections() {
        let filterSections = Array(sut.filterSections.keys)
        
        XCTAssertEqual(sut.sections, filterSections)
    }
    
    func testSetSectionFiltersToSection_ShouldSetFiltersToThePassedSection() {
        let sectionFilters = FilterSectionsManager.SectionFilters(filters: [
            .init(name: "KSA"),
            .init(name: "NY")
        ], selectionType: .signle)
        let section = ProductSearchFiltersViewController.Section.cities
        
        sut.set(sectionFilters: sectionFilters, to: section)
        
        XCTAssertEqual(sectionFilters, sut.sectionFilters(for: section))

    }
    
    func testSectionFiltersForSection_ShouldReturnFiltersEqualToTheSavedFilters() {
        let section = ProductSearchFiltersViewController.Section.sortBy
        let sectionFilters = sut.sectionFilters(for: section)
        
        XCTAssertEqual(sut.filterSections[section], sectionFilters)
    }
    
    func testHandleSingleSelection_DeselectedFilterShouldBeSelected() {
        let section = ProductSearchFiltersViewController.Section.sortBy
        let filter = sut.sectionFilters(for: section)!.filters.first!
        
        sut.select(filter: filter, at: section)
        
        XCTAssertTrue(sut.isFilterSelected(filter: filter, in: section))
    }
    
    func testHandleSingleSelection_SelectedFilterShouldBeDeselected() {
        let section = ProductSearchFiltersViewController.Section.sortBy
        let firstFilter = sut.sectionFilters(for: section)!.filters.first!
        let secondFilter = sut.sectionFilters(for: section)!.filters[at: 1]!
        sut.select(filter: firstFilter, at: section)
        sut.select(filter: secondFilter, at: section)
        
        XCTAssertFalse(sut.isFilterSelected(filter: firstFilter, in: section))
    }
    
    func testHandleMultipleSelection_DeselectedFilterShouldBeSelected() {
        let section = ProductSearchFiltersViewController.Section.subCategory
        let firstFilter = ProductSearchFiltersViewController.SearchFilter(name: "1")
        let secondFilter = ProductSearchFiltersViewController.SearchFilter(name: "2")
        
        let sectionFilters = FilterSectionsManager.SectionFilters(filters: [
            firstFilter, secondFilter
        ], selectionType: .multiple)
        
        sut.set(sectionFilters: sectionFilters, to: section)
        
                
        sut.select(filter: firstFilter, at: section)
        
        XCTAssertTrue(sut.isFilterSelected(filter: firstFilter, in: section))
    }
    
    func testHandleMultipleSelection_SelectedFilterShouldBeDeSelected() {
        let section = ProductSearchFiltersViewController.Section.subCategory
        let firstFilter = ProductSearchFiltersViewController.SearchFilter(name: "1")
        let secondFilter = ProductSearchFiltersViewController.SearchFilter(name: "2")
        let sectionFilters = FilterSectionsManager.SectionFilters(filters: [
            firstFilter, secondFilter
        ], selectionType: .multiple)
        sut.set(sectionFilters: sectionFilters, to: section)
        
                
        sut.select(filter: firstFilter, at: section)
        sut.select(filter: firstFilter, at: section)
        
        XCTAssertFalse(sut.isFilterSelected(filter: firstFilter, in: section))
    }
    
    func testHandleMultipleSelection_AllSelectedFiltersShouldBeStillSelectedAfterDeselectingOtherFilters() {
        
        let section = ProductSearchFiltersViewController.Section.subCategory
        let firstFilter = ProductSearchFiltersViewController.SearchFilter(name: "1")
        let secondFilter = ProductSearchFiltersViewController.SearchFilter(name: "2")
        let sectionFilters = FilterSectionsManager.SectionFilters(filters: [
            firstFilter, secondFilter
        ], selectionType: .multiple)
        sut.set(sectionFilters: sectionFilters, to: section)
        
                
        sut.select(filter: firstFilter, at: section) // selecting 1
        sut.select(filter: secondFilter, at: section) // selecting 2
        sut.select(filter: firstFilter, at: section) // selecting 1 // (deselection)
        
        XCTAssertTrue(sut.isFilterSelected(filter: secondFilter, in: section))
        
    }
    
    func testSelectFilterAtSection_FilterShouldBeSelected() {
        let section = ProductSearchFiltersViewController.Section.subCategory
        let firstFilter = ProductSearchFiltersViewController.SearchFilter(name: "1")
        let sectionFilters = FilterSectionsManager.SectionFilters(filters: [
            firstFilter
        ], selectionType: .multiple)
        sut.set(sectionFilters: sectionFilters, to: section)
        
        sut.select(filter: firstFilter, at: section)
        
        XCTAssertTrue(sut.isFilterSelected(filter: firstFilter, in: section))
    }
    
    func testSelectFilterAtNoneExistSection_FilterShouldBeNotSelected() {
        let section = ProductSearchFiltersViewController.Section.cities
        let firstFilter = ProductSearchFiltersViewController.SearchFilter(name: "1")
        
        sut.select(filter: firstFilter, at: section)
        
        XCTAssertFalse(sut.isFilterSelected(filter: firstFilter, in: section))
    }
    
    func testIsFilterSelected_ShouldReturnFalseIfFilterIsNotSelected() {
        let section = FilterSectionsManager.Section.sortBy
        let filter = ProductSearchFiltersViewController.SearchFilter(name: "Filter")
        
        let isFilterSelected = sut.isFilterSelected(filter: filter, in: section )
        
        XCTAssertFalse(isFilterSelected)
    }
    
    
    
}
