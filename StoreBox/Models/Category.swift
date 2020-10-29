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
}
extension Subcategory: SearchFilterConvertible {
    func asSearchFilter() -> SearchFilter {
        return SearchFilter(name: name, filterValue: "\(id)")
    }
}

struct SubcategoriesList: Codable {
    private(set) var subCategories: [Subcategory]
    private(set) var pagination: ListPagination
}
extension SubcategoriesList: SearchFiltersConvertible {
    func asSearchFilters() -> [SearchFilter] {
        return subCategories.map({$0.asSearchFilter()})
    }
}
