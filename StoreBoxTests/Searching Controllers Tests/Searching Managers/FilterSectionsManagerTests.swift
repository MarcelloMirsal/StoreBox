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
    
    func testSections_ShouldBeEqualToFilterSections() {
        let filterSections = Array(sut.filterSections.keys)
        
        XCTAssertEqual(sut.sections, filterSections)
    }
    
    //MARK:- SectionFilters tests
    func testSetSectionFiltersToSection_ShouldSetFiltersToThePassedSection() {
        let sectionFilters = FilterSectionsManager.SectionFilters(filters: [
            .init(item: .init(name: "KSA"))
        ], selectionType: .single)
        let section = ProductSearchFiltersViewModel.Section.cities
        
        sut.set(sectionFilters: sectionFilters, to: section)
        
        XCTAssertEqual(sectionFilters, sut.sectionFilters(for: section))
    }
    
    func testSectionFiltersForSection_ShouldReturnFiltersEqualToTheSavedFilters() {
        let section = ProductSearchFiltersViewModel.Section.sortBy
        let sectionFilters = sut.sectionFilters(for: section)
        
        XCTAssertEqual(sut.filterSections[section], sectionFilters)
    }
    
    // MARK:- Filter selection tests
    func testSelectedFiltersAtNotExistORNoSelectedFilterInSection_ShouldReturnEmptyFilters() {
        let filters = sut.selectedFilters(at: .subCategory)
        
        XCTAssertTrue(filters.isEmpty)
    }
    func testSelectedFiltersAtSection_ShouldReturnSelectedFilters() {
        let passedFilters = Set(arrangeSutWithSelectedSearchFilterSections())
        let selectedFilters = Set(sut.selectedFilters(at: .sortBy))
        
        XCTAssertTrue(selectedFilters.isSubset(of: passedFilters))
    }
    
    func testSelectFilterAtSection_FilterShouldBeSelected() {
        let section = ProductSearchFiltersViewModel.Section.subCategory
        let firstFilter = ListItem<SearchFilter>(item: .init(name: "name1"))
        let sectionFilters = FilterSectionsManager.SectionFilters(filters: [
            firstFilter
        ], selectionType: .multiple)
        sut.set(sectionFilters: sectionFilters, to: section)
        
        sut.select(filter: firstFilter, at: section)
        
        XCTAssertTrue(sut.isFilterSelected(filter: firstFilter, in: section))
    }
    
    func testSelectFilterAtNoneExistSection_FilterShouldBeNotSelected() {
        let section = ProductSearchFiltersViewModel.Section.cities
        let firstFilter = ListItem<SearchFilter>(item: .init(name: "name1"))
        
        sut.select(filter: firstFilter, at: section)
        
        XCTAssertFalse(sut.isFilterSelected(filter: firstFilter, in: section))
    }
    
    func testIsFilterSelected_ShouldReturnFalseIfFilterIsNotSelected() {
        let section = FilterSectionsManager.Section.sortBy
        let filter = ListItem<SearchFilter>(item: .init(name: "Filter"))
        
        let isFilterSelected = sut.isFilterSelected(filter: filter, in: section )
        
        XCTAssertFalse(isFilterSelected)
    }
    
    func testDeselectAllFilters_SelectedFiltersShouldBeEmpty() {
        _ = arrangeSutWithSelectedSearchFilterSections()
        sut.deselectAllFilters()
        XCTAssertTrue(sut.selectedFilters.isEmpty)
    }
    
    // MARK:- Handling Section selection tests
    func testHandleSingleSelection_DeselectedFilterShouldBeSelected() {
        let section = ProductSearchFiltersViewModel.Section.sortBy
        let filter = sut.sectionFilters(for: section)!.filters.first!
        
        sut.select(filter: filter, at: section)
        
        XCTAssertTrue(sut.isFilterSelected(filter: filter, in: section))
    }
    
    func testHandleSingleSelection_SelectedFilterShouldBeDeselected() {
        let section = ProductSearchFiltersViewModel.Section.sortBy
        let firstFilter = sut.sectionFilters(for: section)!.filters.first!
        let secondFilter = sut.sectionFilters(for: section)!.filters[at: 1]!
        sut.select(filter: firstFilter, at: section)
        sut.select(filter: secondFilter, at: section)
        
        XCTAssertFalse(sut.isFilterSelected(filter: firstFilter, in: section))
    }
    
    func testHandleMultipleSelection_DeselectedFilterShouldBeSelected() {
        let section = ProductSearchFiltersViewModel.Section.subCategory
        let firstFilter = ListItem<SearchFilter>(item: .init(name: "Hello"))
        let secondFilter = ListItem<SearchFilter>(item: .init(name: "2"))
        
        let sectionFilters = FilterSectionsManager.SectionFilters(filters: [
            firstFilter, secondFilter
        ], selectionType: .multiple)
        
        sut.set(sectionFilters: sectionFilters, to: section)
        
        
        sut.select(filter: firstFilter, at: section)
        
        XCTAssertTrue(sut.isFilterSelected(filter: firstFilter, in: section))
    }
    
    func testHandleMultipleSelection_SelectedFilterShouldBeDeSelected() {
        let section = ProductSearchFiltersViewModel.Section.subCategory
        let firstFilter = ListItem<SearchFilter>(item: .init(name: "name1"))
        let secondFilter = ListItem<SearchFilter>(item: .init(name: "name2"))
        let sectionFilters = FilterSectionsManager.SectionFilters(filters: [
            firstFilter, secondFilter
        ], selectionType: .multiple)
        sut.set(sectionFilters: sectionFilters, to: section)
        
        
        sut.select(filter: firstFilter, at: section)
        sut.select(filter: firstFilter, at: section)
        
        XCTAssertFalse(sut.isFilterSelected(filter: firstFilter, in: section))
    }
    
    func testHandleMultipleSelection_AllSelectedFiltersShouldBeStillSelectedAfterDeselectingOtherFilters() {
        
        let section = ProductSearchFiltersViewModel.Section.subCategory
        let firstFilter = ListItem<SearchFilter>(item: .init(name: "name1"))
        let secondFilter = ListItem<SearchFilter>(item: .init(name: "name2"))
        let sectionFilters = FilterSectionsManager.SectionFilters(filters: [
            firstFilter, secondFilter
        ], selectionType: .multiple)
        sut.set(sectionFilters: sectionFilters, to: section)
        
        
        sut.select(filter: firstFilter, at: section) // selecting 1
        sut.select(filter: secondFilter, at: section) // selecting 2
        sut.select(filter: firstFilter, at: section) // selecting 1 // (deselection)
        
        XCTAssertTrue(sut.isFilterSelected(filter: secondFilter, in: section))
        
    }
    
    // MARK:- SUT Delegate Tests
    func testDelegateDidSelectFilter_ShouldBeCalledAfterSelectingASelectedFilter() {
        let exp = expectation(description: "testDelegateDidSelectFilter" )
        let delegateSpy = FilterSectionsManagerDelegateSpy(selectionExp: exp, deSelectionExp: .init(), sectionUpdateExp: .init())
        let filter = arrangeSutWithSelectedSearchFilterSections().first!
        sut.deselectAllFilters()
        sut.delegate = delegateSpy
        
        sut.select(filter: filter, at: .cities)
        
        XCTAssertTrue(delegateSpy.didSelectFilter ?? false)
        wait(for: [exp], timeout: 1)
    }
    
    func testDelegateDidDeselectFilters_ShouldBeCalledAfterSelectingASelectedFilter() {
        let exp = expectation(description: "testDelegateDidDeselectFilter" )
        let delegateSpy = FilterSectionsManagerDelegateSpy(selectionExp: .init(), deSelectionExp: exp, sectionUpdateExp: .init())
        let _ = arrangeSutWithSelectedSearchFilterSections()
        sut.delegate = delegateSpy
        
        sut.select(filter: ListItem<SearchFilter>(item: .init(name: "Filter")) , at: .sortBy)
        
        XCTAssertTrue(delegateSpy.didDeselectFilters ?? false)
        wait(for: [exp], timeout: 1)
    }
    
    // MARK:- SUT Arranges
    func arrangeSutWithSelectedSearchFilterSections() -> [ListItem<SearchFilter>] {
        let sortFilter = ListItem<SearchFilter>(item: SearchFilter(name: "sortFilter", filterValue: "sortFilter"))
        
        let sortFilters = [ sortFilter ]
        let sortSection = ProductSearchFiltersViewModel.Section.sortBy
        
        let cityFilter1 = ListItem<SearchFilter>(item:SearchFilter(name: "city1", filterValue: "city1") )
        let cityFilter2 = ListItem<SearchFilter>(item: SearchFilter(name: "city1", filterValue: "city1"))
        let cityFilters = [ cityFilter1 , cityFilter2 ]
        let citySection = ProductSearchFiltersViewModel.Section.cities
        
        let subcategoryFilter1 = ListItem<SearchFilter>(item: SearchFilter(name: "sub1", filterValue: "sub1"))
        
        sut.set(sectionFilters: .init(filters: sortFilters, selectionType: .single), to: sortSection)
        sut.set(sectionFilters: .init(filters: cityFilters, selectionType: .multiple), to: citySection)
        sut.set(sectionFilters: .init(filters: [subcategoryFilter1], selectionType: .multiple), to: .subCategory)
        
        
        // selection
        sut.select(filter: sortFilter, at: sortSection)
        sut.select(filter: cityFilter1, at: citySection)
        sut.select(filter: subcategoryFilter1, at: .subCategory)
        
        return [sortFilter , cityFilter1 , subcategoryFilter1]
        
    }
}

// MARK:- Test Doubles
private class FilterSectionsManagerDelegateSpy: FilterSectionsManagerDelegate {
    let selectionExp: XCTestExpectation
    let deSelectionExp: XCTestExpectation
    let sectionUpdateExp: XCTestExpectation
    var didUpdateSection: Bool?
    var didDeselectFilters: Bool?
    var didSelectFilter: Bool?
    
    init(selectionExp: XCTestExpectation, deSelectionExp: XCTestExpectation, sectionUpdateExp: XCTestExpectation) {
        self.selectionExp = selectionExp
        self.deSelectionExp = deSelectionExp
        self.sectionUpdateExp = sectionUpdateExp
    }
    func filterSectionsManager(didDeselectFilters filters: [ListItem<SearchFilter>] ) {
        didDeselectFilters = true
        deSelectionExp.fulfill()
    }
    
    func filterSectionsManager(didSelectFilter filter: ListItem<SearchFilter>) {
        didSelectFilter = true
        selectionExp.fulfill()
    }
    
    func filterSectionManager(didAppendFiltersAtSection section: FilterSectionsManager.Section) {
    }
}
