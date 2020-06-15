//
//  SearchDetailsViewControllerTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 14/06/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox

class SearchDetailsViewControllerTests: XCTestCase {
    
    var sut: SearchDetailsViewController!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = UIStoryboard(name: "SearchDetailsViewController").getInitialViewController(of: SearchDetailsViewController.self)
        _ = sut.view
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window?.rootViewController = sut
        appDelegate.window?.makeKeyAndVisible()
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDequeueRegisteredProductCell_ShouldBeNotNil() {
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = sut.collectionView.dequeueReusableCell(withReuseIdentifier: sut.cellId, for: indexPath) as? ProductCollectionViewCell
        XCTAssertNotNil(cell)
    }
    
    func testCellAtIndexPath_ShouldBeNotNil() {
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = sut.collectionView(sut.collectionView, cellForItemAt: indexPath)
        XCTAssertNotNil(cell)
    }
    
    func testHeaderViewDequeueAtIndexPath_ShouldBeNotNil() {
        sut.collectionView.reloadData()
        let indexPath = IndexPath(item: 0, section: 0)
        let headerView = sut.collectionView(sut.collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        print(headerView)
    }
    
    func testFilterButtonHandler_PresentedViewControllerShouldBeNotNil(){
        sut.handleFilterButton()
        XCTAssertNotNil(sut.presentedViewController)
    }

    
}
