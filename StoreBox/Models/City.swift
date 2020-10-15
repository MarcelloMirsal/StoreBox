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
    
    enum CodingKeyes: String , CodingKey {
        case id
        case name
    }
}

extension City: SearchFilterConvertible {
    func asSearchFilter() -> ProductSearchFiltersViewController.SearchFilter {
        return .init(name: name, filterValue: "\(id)")
    }
}


struct CitiesList: Codable {
    let cities: [City]
    let pagination: ListPagination
    
    enum CodingKeyes: String , CodingKey {
        case id
        case name
    }
}

extension CitiesList: SearchFiltersConvertible {
    func asSearchFilters() -> [ProductSearchFiltersViewController.SearchFilter] {
        return cities.map({$0.asSearchFilter()})
    }
}

