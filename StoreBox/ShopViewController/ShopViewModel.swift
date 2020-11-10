//
//  ShopViewModel.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 01/11/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

extension ShopViewModel {
    typealias ViewDataSource = UICollectionViewDiffableDataSource<Section, ListItem<String>>
}

final class ShopViewModel {
    private(set) var collectionViewDataSource: ViewDataSource!
    
    // MARK:- Setup collectionViewDataSource
    func set(collectionViewDataSource: ViewDataSource) {
        self.collectionViewDataSource = collectionViewDataSource
        setFakeDataSourceItems()
    }
    
    
    func setFakeDataSourceItems() {
        var currnetSnapshot = NSDiffableDataSourceSnapshot<ShopViewModel.Section, ListItem<String>>()
        
        let listItem1: ListItem<String> = .init(item: "1")
        let listItem2: ListItem<String> = .init(item: "2")
        let listItem3: ListItem<String> = .init(item: "3")
        
        let listItemA: ListItem<String> = .init(item: "A")
        let listItemB: ListItem<String> = .init(item: "B")
        let listItemC: ListItem<String> = .init(item: "C")
        
        let listItemX: ListItem<String> = .init(item: "A")
        let listItemY: ListItem<String> = .init(item: "B")
        let listItemZ: ListItem<String> = .init(item: "C")
        
        let listItemQ: ListItem<String> = .init(item: "Q")
        let listItemW: ListItem<String> = .init(item: "W")
        let listItemE: ListItem<String> = .init(item: "E")
        
        let listItem00: ListItem<String> = .init(item: "Tools & Electronics")
        let listItem01: ListItem<String> = .init(item: "Shoes")
        let listItem10: ListItem<String> = .init(item: "Smart Phones")
        let listItem11: ListItem<String> = .init(item: "Cloths")
        
        currnetSnapshot.appendSections([.bannerAds,.productAds , .newProducts , .recommendedProducts , .categories])
        
        currnetSnapshot.appendItems([listItem1 , listItem2 , listItem3], toSection: .bannerAds)
        
        currnetSnapshot.appendItems([ listItemA, listItemB, listItemC ], toSection: .productAds)
        
        currnetSnapshot.appendItems([ listItemX, listItemY, listItemZ ], toSection:.newProducts )
        
        currnetSnapshot.appendItems([ listItemQ, listItemW, listItemE ], toSection:  .recommendedProducts)
        
        currnetSnapshot.appendItems([listItem00, listItem01, listItem10 , listItem11], toSection: .categories)
        
        collectionViewDataSource.apply(currnetSnapshot)
    }
}


extension ShopViewModel {
    enum Section: String {
        case bannerAds
        case productAds
        case newProducts = "New Product"
        case recommendedProducts = "Recommended Product"
        case categories = "Categories"
        
        static func description(for section: Section) -> String {
            return section.rawValue
        }
    }
}
