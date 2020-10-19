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
    
    typealias SearchFilter = ProductSearchFiltersViewModel.SearchFilter
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
    
    func testDeselectAllFilters_SelectedFiltersShouldBeEmpty() {
        _ = arrangeSutWithSelectedSearchFilterSections()
        sut.deselectAllFilters()
        XCTAssertTrue(sut.selectedFilters.isEmpty)
    }
    
    // MARK:- SUT Delegate Tests
    func testDelegateDidUpdateSection_ShouldBeCalledAfterSetSectionFilters() {
        let exp = expectation(description: "testDelegateDidUpdateSection" )
        let delegateSpy = FilterSectionsManagerDelegateSpy(exp: exp)
        sut.delegate = delegateSpy
        
        sut.set(sectionFilters: .init(filters: [.init(name: "Filter")], selectionType: .signle), to: .cities)
        
        XCTAssertTrue(delegateSpy.didUpdateSection ?? false)
        wait(for: [exp], timeout: 1)
    }
    
    func testDelegateDidSelectFilter_ShouldBeCalledAfterSelectingASelectedFilter() {
        let exp = expectation(description: "testDelegateDidSelectFilter" )
        let delegateSpy = FilterSectionsManagerDelegateSpy(exp: exp)
        let filter = arrangeSutWithSelectedSearchFilterSections().first!
        sut.deselectAllFilters()
        sut.delegate = delegateSpy
        
        sut.select(filter: filter, at: .cities)
        
        XCTAssertTrue(delegateSpy.didSelectFilter ?? false)
        wait(for: [exp], timeout: 1)
    }
    
    func testDelegateDidDeselectFilter_ShouldBeCalledAfterSelectingASelectedFilter() {
        let exp = expectation(description: "testDelegateDidDeselectFilter" )
        exp.isInverted = true
        let delegateSpy = FilterSectionsManagerDelegateSpy(exp: exp)
        let _ = arrangeSutWithSelectedSearchFilterSections()
        sut.delegate = delegateSpy
        
        sut.select(filter: .init(name: "x"), at: .sortBy)
        
        XCTAssertTrue(delegateSpy.didDeselectFilter ?? false)
        wait(for: [exp], timeout: 1)
    }
    
    
    
    
    
    func arrangeSutWithSelectedSearchFilterSections() -> [ProductSearchFiltersViewModel.SearchFilter] {
        var selectedFilters = [SearchFilter]()
        let sortFilter = SearchFilter(name: "sortFilter", filterValue: "sortFilter")
        let sortFilters: [SearchFilter] = [ sortFilter ]
        let sortSection = ProductSearchFiltersViewModel.Section.sortBy
        
        let cityFilter1 = SearchFilter(name: "city1", filterValue: "city1")
        let cityFilter2 = SearchFilter(name: "city1", filterValue: "city1")
        let cityFilters: [SearchFilter] = [ cityFilter1 , cityFilter2 ]
        let citySection = ProductSearchFiltersViewModel.Section.cities
        
        let subcategoryFilter1 = SearchFilter(name: "sub1", filterValue: "sub1")
        
        sut.set(sectionFilters: .init(filters: sortFilters, selectionType: .signle), to: sortSection)
        sut.set(sectionFilters: .init(filters: cityFilters, selectionType: .multiple), to: citySection)
        sut.set(sectionFilters: .init(filters: [subcategoryFilter1], selectionType: .multiple), to: .subCategory)
        
        
        // selection
        sut.select(filter: sortFilter, at: sortSection)
        sut.select(filter: cityFilter1, at: citySection)
        sut.select(filter: subcategoryFilter1, at: .subCategory)
        selectedFilters = [sortFilter , cityFilter1 , subcategoryFilter1]
        
        return selectedFilters
        
    }
    
    
}


private class FilterSectionsManagerDelegateSpy: FilterSectionsManagerDelegate {
    
    let exp: XCTestExpectation
    var didUpdateSection: Bool?
    var didDeselectFilter: Bool?
    var didSelectFilter: Bool?
    
    init(exp: XCTestExpectation) {
        self.exp = exp
    }
    func filterSectionsManager(didDeselectFilter filter: FilterSectionsManager.SearchFilter) {
        didDeselectFilter = true
    }
    
    func filterSectionsManager(didSelectFilter filter: FilterSectionsManager.SearchFilter) {
        didSelectFilter = true
        exp.fulfill()
    }
    
    func filterSectionsManager(didUpdateSection section: FilterSectionsManager.Section) {
        didUpdateSection = true
        exp.fulfill()
    }
}
