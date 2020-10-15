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
    
    func testFetchDynamicFilterSections() {
        sut.fetchDynamicFilterSections()
    }
    
    // for ListingService Extension in SUT
    func testListingServiceRouterURLRequestForNoneDynamicSearchFilters_ShouldReturnEmptyURLRequestEmptyPath() {
        _ = ListingService.Router().urlRequest(for: .sortBy)
    }
    
    func arrangeSutWithFailedSearchingService() {
        sut = .init(searchingService: ProductsSearchingServiceFake(responseType: .failed))
    }
    func arrangeSutWithSuccessfulResponseSearchingService() {
        sut = .init(searchingService: ProductsSearchingServiceFake(responseType: .success))
    }
}
