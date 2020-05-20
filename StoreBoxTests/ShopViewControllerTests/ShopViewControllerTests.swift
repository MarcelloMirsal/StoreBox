//
//  ShopViewControllerTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 05/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox
class ShopViewControllerTests: XCTestCase {

    var sut: ShopViewController!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let rootSut = (UIStoryboard(name: "ShopViewController").getInitialViewController(of: UINavigationController.self).topViewController as! ShopViewController)
        let nv = UINavigationController(rootViewController: rootSut)
        sut = nv.topViewController as? ShopViewController
        sut.setupSearchController()
        _ = sut.view
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSearchControllerInNavigation_ShouldBeNotNil() {
        XCTAssertNotNil(sut.navigationItem.searchController)
    }

    
    func testCategoriesViewHeightConstraint_ShouldBeEqualTo100() {
        XCTAssertEqual(sut.categoriesViewHeightConstraint.constant, 100)
    }
    
    func testCollectionViewDynamicSizeDelegate_categoriesHeightConstraintShouldBeUpdatedToEstimatedSize() {
        let estimatedSize = CGSize(width: 50, height: 50)
        sut.collectionView(setDynamicSize: estimatedSize)
        XCTAssertEqual(sut.categoriesViewHeightConstraint.constant, estimatedSize.height)
    }
    
    func testSearchControllerDelegateDidPresent_ShouldChangeTitleAndSizeOfNavigationBarForSearching() {
        sut.didPresentSearchController(sut.searchController)
        XCTAssertEqual(sut.navigationItem.title, "Search")
        XCTAssertEqual(sut.navigationController?.navigationBar.prefersLargeTitles , false)
    }
    
    func testSearchControllerDelegateWiiDismiss_ShouldChangeTitleAndSizeOfNavigationBarForShopDefaults() {
        sut.willDismissSearchController(sut.searchController)
        XCTAssertEqual(sut.navigationItem.title, "Shop")
        XCTAssertEqual(sut.navigationController?.navigationBar.prefersLargeTitles , true)
    }
    
}
