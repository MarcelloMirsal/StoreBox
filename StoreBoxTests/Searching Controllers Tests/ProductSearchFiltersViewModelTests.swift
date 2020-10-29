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
    
    typealias AssociatedSearchFilterParams = ProductsSearchingService.AssociatedSearchFiltersParams
    typealias Section = ProductSearchFiltersViewModel.Section
    var sut: ProductSearchFiltersViewModel!
    let tableView = UITableView(frame: .init(x: 0, y: 0, width: 100, height: 100))
    lazy var fakeTableViewDataSource: ProductSearchFiltersViewModel.ViewDataSource = .init(tableView: self.tableView, cellProvider: {_,_,_ in return .init()})
    
    override func setUp() {
        sut = ProductSearchFiltersViewModel()
        sut.set(tableViewDataSource: fakeTableViewDataSource)
    }
    
    // MARK:- test properties
    func testFilterSectionsManagerDelegate_ShouldBeEqualToSUT() {
        XCTAssertTrue(sut === sut.filterSectionsManager.delegate )
    }
    func testSutSections_ShouldBeEqualToFilterSectionsManagerSections() {
        XCTAssertEqual(sut.filterSectionsManager.sections, sut.sections)
    }
    
    // MARK:- TableViewDataSource Tests
    func testSetTableViewDataSource_TableViewDataSourceShouldBeNotNil() {
        sut.set(tableViewDataSource: fakeTableViewDataSource)
        XCTAssertNotNil(sut.tableViewDataSource)
    }
    
    func testSetTableViewDataSource_SnapshotSectionsShouldEqualToSortedSections() {
        sut.set(tableViewDataSource: fakeTableViewDataSource)
        XCTAssertEqual(sut.sortedSections, sut.tableViewDataSource.snapshot().sectionIdentifiers)
    }
    
    func testSetSearchFiltersToSection_ShouldSetSearchFiltersToDataSource() {
        let searchFilters = [ListItem<SearchFilter>(item: .init(name: "Filter"))]
        let section = Section.subCategory
        
        sut.set(searchFilters: searchFilters, to: section)
        
        let passedSearchFilters = sut.tableViewDataSource.snapshot().itemIdentifiers(inSection: section).map({$0.item})
        
        XCTAssertEqual(passedSearchFilters, searchFilters.map({$0.item}))
    }
    
    // MARK:- loading default filterSections tests
    func testLoadDefaultFilterSections_DataSourceShouldBeNotEmpty() {
        sut.loadDefaultFilterSections()
        let snapshot = sut.tableViewDataSource.snapshot()
        let defaultSection = Section.sortBy
        let searchFilters = snapshot.itemIdentifiers(inSection: defaultSection)
        
        sut.loadDefaultFilterSections()
        
        XCTAssertTrue(searchFilters.isEmpty == false)
    }
    
    // MARK:- Fetching dynamic searchFilters tests
    func testFetchDynamicFilterSections() {
        sut.fetchDynamicFilterSections()
    }
    
    func testDynamicFiltersResponseHandlerBlockWithNilFilters_FiltersAtPassedSectionShouldBeNil() {
        let section = Section.cities
        sut.dynamicFiltersResponseHandlerBlock(nil , nil,  section , .single)
        
        let filters = sut.filterSectionsManager.sectionFilters(for: section)
        XCTAssertNil(filters)
    }
    
    func testDynamicFiltersResponseHandlerBlockWithFilters_FiltersAtPassedSectionShouldBeNotNil() {
        let section = Section.cities
        let cityFilter = CityDTO(id: 10, name: "NAME")
        
        let dynamicFiltersList = CitiesListDTO(cities: [cityFilter], pagination: .emptyListPagination() )
        
        sut.dynamicFiltersResponseHandlerBlock(nil , dynamicFiltersList,  section , .single)
        
        XCTAssertNotNil(sut.filterSectionsManager.sectionFilters(for: section))
    }
    
    // MARK:- Filter Selection tests
    func testSelectFilterAtIndexPath_FilterAtIndexPathShouldBeSelected() {
        let selectedFilter = arrangeSutWithSelectedSearchFilterSections().first!
        let indexPath = sut.tableViewDataSource.indexPath(for: selectedFilter)!
        let section = sut.tableViewDataSource.snapshot().sectionIdentifiers[indexPath.section]
        
        sut.selectFilter(at: indexPath)
        let isFilterSelected = sut.isFilterSelected(filter: selectedFilter, in: section)
        XCTAssertTrue(isFilterSelected)
    }
    func testSelectFilterAtIndexPath_FilterAtNotExistIndexPathShouldBeNil() {
        let indexPath = IndexPath(row: 1000, section: 1000)
        
        sut.selectFilter(at: indexPath)
        
        let selectedFilter = sut.filterSectionsManager.selectedFilters(at: .sortBy)[at: indexPath.row]
        XCTAssertNil(selectedFilter)
    }
    func testIsFilterSelected_ShouldReturnFalseIfFilterDeSelected() {
        let isFilterSelected = sut.isFilterSelected(filter: .init(item: .init(name: "name")), in: .cities)
        XCTAssertFalse(isFilterSelected)
    }
    func testRemoveAllSelectedFilter_SelectedFiltersShouldBeEmpty() {
        _ = arrangeSutWithSelectedSearchFilterSections()
    
        sut.removeAllSelectedFilters()
        
        XCTAssertTrue(sut.filterSectionsManager.selectedFilters.isEmpty)
    }
    
    // MARK:- Section info test
    func testSectionAtIndex_ShouldReturnSectionRawValue() {
        let index = 0
        let rawValue: String = sut.section(at: index)
        XCTAssertEqual(rawValue, sut.sortedSections[index].rawValue)
    }
    
    
    // MARK:- Get SearchFilters Params tests
    func testExtractFiltersParamsFromEmptyFilters_ShouldReturnEmptyFiltersValue() {
        let filtersValue = sut.extractFiltersParams(from: [])
        XCTAssertTrue(filtersValue.isEmpty)
    }
    func testExtractFiltersParamsFromFilters_ShouldReturnFiltersValueEqualToExtractedFiltersValue() {
        let filters = arrangeSutWithSelectedSearchFilterSections()
        let filtersValue = filters.map({$0.item.filterValue})
        let extractedFiltersValue = sut.extractFiltersParams(from: filters)
        XCTAssertEqual(filtersValue, extractedFiltersValue)
    }
    func testExtractAssociatedFiltersFromEmptyFilters_ShouldReturnEmptyDict() {
        let associatedFiltersDict = sut.extractAssociatedFilters(from: [])
        XCTAssertTrue(associatedFiltersDict.isEmpty)
    }
    func testExtractAssociatedFilters_ShouldReturnDict() {
        let associatedFilter = ["KEY" : "VALUE" ]
        let filter1 = ListItem<SearchFilter>(item: SearchFilter(name: "name", filterValue: "NAME", assotiatedFilters: associatedFilter ))
        let filter2 = ListItem<SearchFilter>(item: SearchFilter(name: "Id", filterValue: "123", assotiatedFilters: associatedFilter ))
        
        let filtersWithSameAssociatedFilter = [ filter1 , filter2  ]
        
        var associatedFilters: [String : String] = [:]
        
        associatedFilters = filtersWithSameAssociatedFilter.reduce([:]) { (result, filter) -> [String : String] in
            result.merging(filter.item.assotiatedFilters, uniquingKeysWith: {_,lhs in lhs})
        } // == ["KEY": "VALUE"]
        
        let extractedAssociatedFiltersDict = sut.extractAssociatedFilters(from: filtersWithSameAssociatedFilter)
        
        XCTAssertEqual(extractedAssociatedFiltersDict , associatedFilters)
    }
    
    func testGetSearchFiltersParamsFromEmptySelectedFilters_ShouldReturnEmptyParams() {
        XCTAssertTrue(sut.getSearchFiltersParams().isEmpty)
    }
    
    func testGetSearchFiltersParamsFromSelectedFilters_ShouldReturnFiltersValuesAndItsAssociatedFilters() {
        let filterManager = sut.filterSectionsManager
        let selectedFilters = arrangeSutWithSelectedSearchFilterSections()
        let associatedSearchFilters = sut.extractAssociatedFilters(from: selectedFilters)
        let selectedFiltersSections = filterManager.selectedFilters.keys
        
        let params = selectedFiltersSections.reduce([String : String]()) { (result, section) -> [String : String] in
            let filtersValue = filterManager.selectedFilters(at: section).map({$0.item.filterValue})
            let filtersKey = ProductsSearchingService.SearchFiltersParams.init(section: section)
            return [filtersKey.rawValue : String(describing: filtersValue)].merging(result, uniquingKeysWith: {_,rhs in rhs})
        }.merging(associatedSearchFilters, uniquingKeysWith: {_ , rhs in rhs })
        
        let searchFiltersParams = sut.getSearchFiltersParams().mapValues({String(describing: $0)})
        XCTAssertEqual(searchFiltersParams, params)
        print(searchFiltersParams , params)
    }
    
    func testGetSearchParams_DuplicatedSearchFiltersShouldReducedToOne() {
        let duplicatedSearchFilter = SearchFilter(name: "name", filterValue: "value", assotiatedFilters: [ "KEY" : "VALUE" ])
        
        let listItem = ListItem<SearchFilter>(item: duplicatedSearchFilter)
        let listItem2 = ListItem<SearchFilter>(item: duplicatedSearchFilter)
        let section = Section.cities
        let section2 = Section.subCategory
        sut.filterSectionsManager.set(sectionFilters: .init(filters: [listItem], selectionType: .multiple), to: section)
        sut.filterSectionsManager.set(sectionFilters: .init(filters: [listItem2], selectionType: .multiple), to: section2)
        sut.filterSectionsManager.select(filter: listItem, at: section)
        sut.filterSectionsManager.select(filter: listItem2, at: section2)
        
        let params = sut.getSearchFiltersParams()
        let isContainingFilter = params.contains { (pair) -> Bool in
            return pair.key == duplicatedSearchFilter.assotiatedFilters.first!.key && String(describing: pair.value) == duplicatedSearchFilter.assotiatedFilters.first!.value
        }
        XCTAssertTrue(isContainingFilter)
    }
    
    // MARK:- test 
    func testSubmitSearchFiltersParams_FiltersSubmitionDelegateSpyShouldSubmitFilters() {
        let exp = expectation(description: "testSubmitSearchFiltersParams" )
        let delegateSpy = ProductSearchFiltersViewModelDelegateSpy(exp: exp)
        sut.searchFiltersSubmitionDelegate = delegateSpy
        sut.submitSearchFiltersParams()
        
        XCTAssertTrue(delegateSpy.didSubmitFilters ?? false)
        wait(for: [exp], timeout: 1)
    }
    
    func testURLRequestRouter_() {
        _ = ListingService.Router().urlRequest(for: .sortBy)
    }
    
    func arrangeSutWithSelectedSearchFilterSections() -> [ListItem<SearchFilter>] {
        let sortFilter = ListItem<SearchFilter>(item: SearchFilter(name: "sortFilter", filterValue: "sortFilter"))
        
        let sortFilters = [ sortFilter ]
        let sortSection = ProductSearchFiltersViewModel.Section.sortBy
        
        let cityFilter1 = ListItem<SearchFilter>(item:SearchFilter(name: "city1", filterValue: "city1") )
        let cityFilter2 = ListItem<SearchFilter>(item: SearchFilter(name: "city1", filterValue: "city1"))
        let cityFilters = [ cityFilter1 , cityFilter2 ]
        let citySection = ProductSearchFiltersViewModel.Section.cities
        
        let subcategoryFilter1 = ListItem<SearchFilter>(item: SearchFilter(name: "sub1", filterValue: "sub1"))
        
        sut.filterSectionsManager.set(sectionFilters: .init(filters: sortFilters, selectionType: .single), to: sortSection)
        sut.filterSectionsManager.set(sectionFilters: .init(filters: cityFilters, selectionType: .multiple), to: citySection)
        sut.filterSectionsManager.set(sectionFilters: .init(filters: [subcategoryFilter1], selectionType: .multiple), to: .subCategory)
        
        
        // selection
        sut.filterSectionsManager.select(filter: sortFilter, at: sortSection)
        sut.filterSectionsManager.select(filter: cityFilter1, at: citySection)
        sut.filterSectionsManager.select(filter: subcategoryFilter1, at: .subCategory)
        
        return [sortFilter , cityFilter1 , subcategoryFilter1]
    }
    
    
}

fileprivate class ProductSearchFiltersViewModelDelegateSpy: ProductSearchFiltersViewModelDelegate {
    let exp: XCTestExpectation
    
    init(exp: XCTestExpectation) {
        self.exp = exp
    }
    
    var didSubmitFilters: Bool?
    
    func productSearchFiltersViewModel(didSubmitFilters filters: [String : Any]) {
        didSubmitFilters = true
        exp.fulfill()
    }
    
}
