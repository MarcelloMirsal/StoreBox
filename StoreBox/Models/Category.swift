//
//  Category.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 13/10/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation

struct Subcategory: Codable {
    
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
    
}

extension Subcategory: SearchFilterConvertible {
    func asSearchFilter() -> ProductSearchFiltersViewController.SearchFilter {
        return ProductSearchFiltersViewController.SearchFilter(name: name, filterValue: "\(id)")
    }
    
    
}

struct SubcategoriesList: Codable {
    private(set) var subCategories: [Subcategory]
    private(set) var pagination: ListPagination
    
    enum CodingKeys: String, CodingKey {
        case subCategories
        case pagination
    }
}

extension SubcategoriesList: SearchFiltersConvertible {
    func asSearchFilters() -> [ProductSearchFiltersViewController.SearchFilter] {
        return subCategories.map({$0.asSearchFilter()})
    }
}
