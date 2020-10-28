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
    
    enum CodingKeys: String, CodingKey {
        case id, name, price, discount
        case priceAfterDiscount = "priceAfterDiscount"
        case storeName = "storeName"
        case subCategoryName = "subCategoryName"
    }
}

extension Product: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct ListPagination: Codable {
    let currentPage: Int
    let nextPage: Int?
    let previousPage: Int?
    let totalPages: Int
    let totalEntries: Int
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "currentPage"
        case nextPage = "nextPage"
        case previousPage = "previousPage"
        case totalPages = "totalPages"
        case totalEntries = "totalEntries"
    }
    
    static func emptyListPagination() -> ListPagination {
        return ListPagination(currentPage: 1, nextPage: nil, previousPage: nil, totalPages: 1, totalEntries: 0)
    }
}

struct ProductsList: Codable {
    private(set) var products: [Product]
    private(set) var pagination: ListPagination
    
    mutating func append(products: [Product]) {
        self.products += products
    }
    
    mutating func set(pagination: ListPagination) {
        self.pagination = pagination
    }
    
    static func emptyList() -> ProductsList {
        return .init(products: [], pagination: .emptyListPagination())
    }
    
    enum CodingKeys: String , CodingKey {
        case products
        case pagination
    }
}
