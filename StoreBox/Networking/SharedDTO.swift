//
//  SharedDTO.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 28/10/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation
// Data Transfer Objects
struct ListPaginationDTO: Codable {
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
    
    static func emptyListPagination() -> ListPaginationDTO {
        return .init(currentPage: 1, nextPage: nil, previousPage: nil, totalPages: 1, totalEntries: 0)
    }
    
    func map() -> ListPagination {
        ListPagination.init(currentPage: currentPage, nextPage: nextPage, previousPage: previousPage, totalPages: totalPages, totalEntries: totalEntries)
    }
}


struct CategoryDTO: Codable {
    let id: Int
    let name: String
    func mapObject() -> Category {
        return Category(id: id, name: name)
    }
}

struct SubcategoryDTO: Codable, SearchFilterConvertible {
    let id: Int
    let name: String
    func asSearchFilter() -> SearchFilter {
        return .init(name: name, filterValue: "\(id)")
    }
}
struct SubcategoriesListDTO: Codable, SearchFiltersConvertible {
    let subCategories: [SubcategoryDTO]
    let pagination: ListPaginationDTO
    
    func asSearchFilters() -> [SearchFilter] {
        return subCategories.map({$0.asSearchFilter()})
    }
}

struct CityDTO: Codable {
    let id: Int
    let name: String
}
extension CityDTO: SearchFilterConvertible {
    func asSearchFilter() -> SearchFilter {
        return .init(name: name, filterValue: "\(id)")
    }
}

struct CitiesListDTO: Codable {
    let cities: [CityDTO]
    let pagination: ListPaginationDTO
}
extension CitiesListDTO: SearchFiltersConvertible {
    func asSearchFilters() -> [SearchFilter] {
        return cities.map({$0.asSearchFilter()})
    }
}

struct SearchFilterDTO {
    let name: String
    var filterValue: String
    let assotiatedFilters: [String : String]
}
