//
//  NetworkServiceParserTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 19/09/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox

class NetworkServiceParserTests: XCTestCase {
    
    var sut: NetworkServiceParser!
    
    override func setUp() {
        sut = ProductsSearchingService.Parser() // using this class as SUT
    }
    
    func testDecoderDecodingStrategy_ShouldBeEqualToSnakeCase() {
        switch sut.decoder.keyDecodingStrategy {
            case .convertFromSnakeCase:
                break
            default:
                XCTFail()
        }
    }
    
    func testParseFromNilData_ShouldThrowNoDataFound() {
        let exp = expectation(description: "testParseFromNilData")
        
        do {
            let _ : Product  = try sut!.parse(from: nil)
        }
        catch NetworkServiceError.noDataFound { exp.fulfill() }
        catch { XCTFail() }
        wait(for: [exp], timeout: 1)
    }
    
    func testParseFromEmptyData_ShouldThrowJSONDecodingFailure() {
        let exp = expectation(description: "testParseFromEmptyData")
        let data = Data()
        
        do {
            let _: Product = try sut.parse(from: data)
        }
        catch NetworkServiceError.jsonDecodingFailure { exp.fulfill() }
        catch { XCTFail() }
        wait(for: [exp], timeout: 1)
    }
    
    func testParseFromWrongDictData_ShouldThrowJSONDecodingFailure() {
        let exp = expectation(description: "testParseFromWrongDictData")
        let dict = ["WRONG Key" : 10]
        let dictData = try! JSONSerialization.data(withJSONObject: dict)
        
        do {
            let _: Product = try sut.parse(from: dictData)
        }
        catch NetworkServiceError.jsonDecodingFailure { exp.fulfill() }
        catch { XCTFail() }
        wait(for: [exp], timeout: 1)
    }
    
    func testParseSuccessfulDataResponse_ParsedProductsShouldBeNotNil() {
        let product1 = Product(id: 1, name: "0", price: 0, discount: 0, priceAfterDiscount: 0, storeName: "", subCategoryName: "")
        
        let product2 = Product(id: 1, name: "0", price: 0, discount: 0, priceAfterDiscount: 0, storeName: "", subCategoryName: "")
        
        let responseDict = [ product1, product2  ]
        
        let dictData = try! JSONEncoder().encode(responseDict)
        
        let parsedProducts: [Product]? = try? sut.parse(from: dictData)
        
        XCTAssertNotNil(parsedProducts)
    }
    
}
