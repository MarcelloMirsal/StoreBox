//
//  ListItem.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 25/10/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation

/// a wrapper used to represent data models in collectionView & tableView diffable data source
struct ListItem<T>: Hashable {
    let uuid = UUID()
    let item: T
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func == (lhs: ListItem<T>, rhs: ListItem<T>) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
