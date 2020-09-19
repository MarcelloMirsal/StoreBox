//
//  Product.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 17/09/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation

struct Product: Codable {
    let id: Int
    let name: String
    let price: Double
    let discount: Double

    let priceAfterDiscount: Double
    let storeName: String
    let subCategoryName: String
    
    enum CodingKeyes: String, CodingKey {
        case id, name, price, discount
        case priceAfterDiscount = "price_after_discount"
        case storeName = "store_name"
        case subCategoryName = "sub_category_name"
    }
}

struct ProductAutocompleteSearchResult: Codable {
    let name: String
    let subCategoryName: String
    enum CodingKeyes: String , CodingKey {
        case name , subCategoryName = "sub_category_name"
    }
}

struct ListPagination: Codable {
    let currentPage: Int
    let nextPage: Int?
    let previousPage: Int?
    let totalPages: Int
    let totalEntries: Int
    
    enum CodingKeyes: String, CodingKey {
        case currentPage = "current_page"
        case nextPage = "next_page"
        case previousPage = "previous_page"
        case totalPages = "total_pages"
        case totalEntries = "total_entries"
    }
    
}

struct ProductsList: Codable {
    let products: [Product]
    let pagination: ListPagination
    enum CodingKeyes: String , CodingKey {
        case products
        case pagination
    }
}
