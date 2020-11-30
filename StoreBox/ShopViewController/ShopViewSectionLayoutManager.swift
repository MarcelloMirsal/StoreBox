//
//  ShopViewLayoutManager.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 01/11/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class ShopViewSectionLayoutManager {
    
    static func bannerAdsLayout() -> NSCollectionLayoutSection {
        let bannerItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        bannerItem.contentInsets = .init(top: 0, leading: 4, bottom: 0, trailing: 4)
        
        let bannerGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.93), heightDimension: .fractionalWidth(9/16)), subitems: [bannerItem])
        
        let section = NSCollectionLayoutSection(group: bannerGroup)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return section
    }
    
    static func productsRecommendationLayout() -> NSCollectionLayoutSection {
        let productItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/2), heightDimension:  .fractionalHeight(3/4) ))
        productItem.contentInsets = .init(top: 0, leading: 4, bottom: 0, trailing: 4)
        
        let productGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(350) ), subitem: productItem, count: 2)
        
        let section = NSCollectionLayoutSection(group: productGroup)
        section.contentInsets = .init(top: 0, leading: 4, bottom: 0, trailing: 4)
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(42)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        sectionHeader.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    static func productsAdsLayout() -> NSCollectionLayoutSection {
        let productItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension:  .fractionalHeight(1) ))
        productItem.contentInsets = .init(top: 0, leading: 4, bottom: 0, trailing: 4)

        let productGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalWidth(3/4) ), subitems: [productItem])
        
        let section = NSCollectionLayoutSection(group: productGroup)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return section
    }
    
    static func categoriesLayout() -> NSCollectionLayoutSection {
        let spacing: CGFloat = 12
        let categoryItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension:  .fractionalWidth(0.5) ))
        
        let categoryGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(350) ), subitem: categoryItem, count: 2)
        categoryGroup.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: categoryGroup)
        section.interGroupSpacing = spacing
        section.contentInsets = .init(top: 8, leading: spacing, bottom: spacing, trailing: spacing)
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(42)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        sectionHeader.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)

        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
}

