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
    
    
    func testGetSearchFiltersParamsFromEmptySelectedFilters_ShouldReturnEmptyParams() {
        XCTAssertTrue(sut.getSearchFiltersParams().isEmpty)
    }
    
    func testGetSearchFiltersParamsFromSelectedFilters_SearchParamsFiltersShouldBeEqualToSelectedFilters() {
        let selectedFilters = arrangeSutWithSelectedSearchFilterSections()
        
        let searchParams = sut.getSearchFiltersParams()
        let searchParamsFilters = searchParams.reduce([], { $0 + $1.value })
        
        XCTAssertEqual(Set(searchParamsFilters), Set(selectedFilters))
    }
    
    
    func testURLRequestRouter_() {
        _ = ListingService.Router().urlRequest(for: .sortBy)
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
        
        sut.filterSectionsManager.set(sectionFilters: .init(filters: sortFilters, selectionType: .signle), to: sortSection)
        sut.filterSectionsManager.set(sectionFilters: .init(filters: cityFilters, selectionType: .multiple), to: citySection)
        sut.filterSectionsManager.set(sectionFilters: .init(filters: [subcategoryFilter1], selectionType: .multiple), to: .subCategory)
        
        
        // selection
        sut.filterSectionsManager.select(filter: sortFilter, at: sortSection)
        sut.filterSectionsManager.select(filter: cityFilter1, at: citySection)
        sut.filterSectionsManager.select(filter: subcategoryFilter1, at: .subCategory)
        selectedFilters = [sortFilter , cityFilter1 , subcategoryFilter1]
        
        return selectedFilters
        
    }
    
    
}
