//
//  Protocols.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 14/10/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation

protocol SearchFilterConvertible {
    func asSearchFilter() -> ProductSearchFiltersViewController.SearchFilter
}
protocol SearchFiltersConvertible {
    func asSearchFilters() -> [ProductSearchFiltersViewController.SearchFilter]
}
