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
    
    typealias SearchFilter = ProductSearchFiltersViewModel.SearchFilter
    typealias AssociatedSearchFilterParams = ProductsSearchingService.AssociatedSearchFiltersParams


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
        let isFilterSelected = sut.isFilterSelected(filter: .init(name: "1"), in: .cities)
        XCTAssertFalse(isFilterSelected)
    }
    
    func testSutGetSearchFiltersForNoneExistSection_ShouldReturnEmptySearchFilters() {
        let section = ProductSearchFiltersViewController.Section.cities
        let filters = sut.getSearchFilters(for: section)
        
        XCTAssertTrue(filters.isEmpty)
    }
    
    func testSetSectionFiltersFromNilList_FilterSectionsShouldBeTheSame() {
        let prevoiusFilterSections = sut.filterSectionsManager.filterSections
        sut.setSectionFilters(from: nil)
        let updatedFilterSections = sut.filterSectionsManager.filterSections
        XCTAssertEqual(prevoiusFilterSections, updatedFilterSections)
    }
    
    func testSetSectionFiltersFromSubcategoriesList_FilterSectionsShouldBeContainTheSubcategoriesFilter() {
        let subcategories: [Subcategory] = .init(repeating: .init(id: 10, name: "name"), count: 3)
        let subcategoriesList = SubcategoriesList(subCategories: subcategories, pagination: .emptyListPagination())
        
        sut.setSectionFilters(from: subcategoriesList)
        let isContainsSubcategoriesFilters = sut.filterSectionsManager.filterSections.contains(where: {$0.key == .subCategory})
        XCTAssertTrue(isContainsSubcategoriesFilters)
        XCTAssertNotNil(sut.filterSectionsManager.sectionFilters(for: .subCategory))
    }
    
    func testSetSectionFiltersFromCitiesList_FilterSectionsShouldBeContainTheCitiesFilter() {
        let cities: [City] = .init(repeating: .init(id: 10, name: "name"), count: 3)
        let citiesList = CitiesList(cities: cities, pagination: .emptyListPagination())
        
        sut.setSectionFilters(from: citiesList)
        let isContainsCitiesFilters = sut.filterSectionsManager.filterSections.contains(where: {$0.key == .cities})
        
        XCTAssertTrue(isContainsCitiesFilters)
        XCTAssertNotNil(sut.filterSectionsManager.sectionFilters(for: .cities))
    }
    
    func testHandleFetchingFilterSectionWithNilList() {
        let subcategoriesList = SubcategoriesList(subCategories: [], pagination: .emptyListPagination())
        sut.handleFetchingFilterSection(serviceError: nil, list: subcategoriesList)
    }
    
    func testRemoveAllSelectedFilters_SelectedFiltersShouldBeEmpty() {
        _ = arrangeSutWithSelectedSearchFilterSections()
        sut.removeAllSelectedFilters()
        XCTAssertTrue(sut.filterSectionsManager.selectedFilters.isEmpty)
    }
    
    func testFetchDynamicFilterSections() {
        sut.fetchDynamicFilterSections()
    }
    
    func testExtractFiltersParamsFromEmptyFilters_ShouldReturnEmptyFiltersValue() {
        let filtersValue = sut.extractFiltersParams(from: [])
        XCTAssertTrue(filtersValue.isEmpty)
    }
    
    func testExtractFiltersParamsFromFilters_ShouldReturnFiltersValueEqualToExtractedFiltersValue() {
        let filters = arrangeSutWithSelectedSearchFilterSections()
        let filtersValue = filters.map({$0.filterValue})
        
        let extractedFiltersValue = sut.extractFiltersParams(from: filters)
        XCTAssertEqual(filtersValue, extractedFiltersValue)
    }
    
    func testExtractAssociatedFiltersFromEmptyFilters_ShouldReturnEmptyDict() {
        let associatedFiltersDict = sut.extractAssociatedFilters(from: [])
        XCTAssertTrue(associatedFiltersDict.isEmpty)
    }
    
    func testExtractAssociatedFiltersFilters_ShouldReturnDict() {
        let associatedFilter = ["KEY" : "VALUE" ]
        let filter1 = SearchFilter(name: "name", filterValue: "NAME", assotiatedFilters: associatedFilter )
        let filter2 = SearchFilter(name: "Id", filterValue: "123", assotiatedFilters: associatedFilter )
        
        let filtersWithSameAssociatedFilter = [ filter1 , filter2  ]
        
        var associatedFilters: [String : String] = [:]
        
        associatedFilters = filtersWithSameAssociatedFilter.reduce([:]) { (result, filter) -> [String : String] in
            result.merging(filter.assotiatedFilters, uniquingKeysWith: {_,lhs in lhs})
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
            let filtersValue = filterManager.selectedFilters(at: section).map({$0.filterValue})
            let filtersKey = ProductsSearchingService.SearchFiltersParams.init(section: section)
            return [filtersKey.rawValue : String(describing: filtersValue)].merging(result, uniquingKeysWith: {_,rhs in rhs})
        }.merging(associatedSearchFilters, uniquingKeysWith: {_ , rhs in rhs })
        
        let searchFiltersParams = sut.getSearchFiltersParams().mapValues({String(describing: $0)})
        XCTAssertEqual(searchFiltersParams, params)
        print(searchFiltersParams , params)
    }
    
    
    func testURLRequestRouter_() {
        _ = ListingService.Router().urlRequest(for: .sortBy)
    }
    
    func testSubmitSearchFiltersParams_FiltersSubmitionDelegateSpyShouldSubmitFilters() {
        let exp = expectation(description: "testSubmitSearchFiltersParams" )
        let delegateSpy = ProductSearchFiltersViewModelDelegateSpy(exp: exp)
        sut.searchFiltersSubmitionDelegate = delegateSpy
        sut.submitSearchFiltersParams()
        
        XCTAssertTrue(delegateSpy.didSubmitFilters ?? false)
        wait(for: [exp], timeout: 1)
    }
    
    
    func arrangeSutWithSelectedSearchFilterSections() -> [ProductSearchFiltersViewModel.SearchFilter] {
        var selectedFilters = [SearchFilter]()
        let sortAssociatedFilter = AssociatedSearchFilterParams.descendingSorting()
        let sortFilter = SearchFilter(name: "sortFilter", filterValue: "sortFilterValue" , assotiatedFilters: sortAssociatedFilter )
        let sortFilters: [SearchFilter] = [ sortFilter ]
        let sortSection = ProductSearchFiltersViewModel.Section.sortBy
        
        let cityFilter1 = SearchFilter(name: "city1", filterValue: "city1Value" , assotiatedFilters: AssociatedSearchFilterParams.descendingSorting()) // adding associated filter that alreardy exist in other(sortFilter above) filter within the selected filters, duplicated filters should not be placed on the search params only one is allowed
        
        
        let cityFilter2 = SearchFilter(name: "city2", filterValue: "city2Value")
        let cityFilters: [SearchFilter] = [ cityFilter1 , cityFilter2 ]
        let citySection = ProductSearchFiltersViewModel.Section.cities
        
        let subcategoryFilter1 = SearchFilter(name: "sub1", filterValue: "sub1Value")
        
        sut.filterSectionsManager.set(sectionFilters: .init(filters: sortFilters, selectionType: .signle), to: sortSection)
        sut.filterSectionsManager.set(sectionFilters: .init(filters: cityFilters, selectionType: .multiple), to: citySection)
        sut.filterSectionsManager.set(sectionFilters: .init(filters: [subcategoryFilter1], selectionType: .multiple), to: .subCategory)
        
        
        // selection
        sut.filterSectionsManager.select(filter: sortFilter, at: sortSection)
        sut.filterSectionsManager.select(filter: cityFilter1, at: citySection)
        sut.filterSectionsManager.select(filter: cityFilter2, at: citySection)
        sut.filterSectionsManager.select(filter: subcategoryFilter1, at: .subCategory)
        selectedFilters = [sortFilter , cityFilter1 , cityFilter2, subcategoryFilter1]
        
        return selectedFilters
        
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
