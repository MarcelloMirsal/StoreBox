//
//  City.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 15/10/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation
struct City: Codable {
    let id: Int
    let name: String
}
extension City: SearchFilterConvertible {
    func asSearchFilter() -> SearchFilter {
        return .init(name: name, filterValue: "\(id)")
    }
}
struct CitiesList: Codable {
    let cities: [City]
    let pagination: ListPagination
}
extension CitiesList: SearchFiltersConvertible {
    func asSearchFilters() -> [SearchFilter] {
        return cities.map({$0.asSearchFilter()})
    }
}

