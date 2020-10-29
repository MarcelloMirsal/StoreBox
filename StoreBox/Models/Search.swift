//
//  Search.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 26/10/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation

protocol SearchFilterProtocol {
    /// the main search filter parameter value, like sorting , categories and cities (standalone filter)
    var filterValue: String { get set }
}


/// a Search filter that composite from multiple filters
protocol CompositeSearchFilterProtocol: SearchFilterProtocol{
    /// the secondary search filters used to specify presentation direction like ascending & descending
    var assotiatedFilters: [String : String] { get }
}

protocol SearchFilterConvertible {
    func asSearchFilter() -> SearchFilter
}
protocol SearchFiltersConvertible {
    func asSearchFilters() -> [SearchFilter]
}


struct SearchFilter: CompositeSearchFilterProtocol, Hashable {
    let name: String
    var filterValue: String
    let assotiatedFilters: [String : String]
    init(name: String, filterValue: String = "", assotiatedFilters: [String : String] = [:] ) {
        self.name = name
        self.filterValue = filterValue
        self.assotiatedFilters = assotiatedFilters
    }
}

struct AutocompleteSearchResult: Equatable, Hashable {
    let result: String
    let detailsDescription: String
}
