//
//  ShopViewModel.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 01/11/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

protocol ShopViewModelDelegate: class {
    func loadShoppingPromotionsDidFailed()
    func loadShoppingPromotionsDidSuccess()
}

extension ShopViewModel {
    typealias ViewDataSource = UICollectionViewDiffableDataSource<Section, ListItem<Any>>
}

final class ShopViewModel {
    private(set) var collectionViewDataSource: ViewDataSource!
    let shopViewLayoutManager = ShopViewSectionLayoutManager()
    let promotionsService = PromotionsService()
    weak var delegate: ShopViewModelDelegate?
    
    private(set) var sections: [Section] = [
        .bannerAds,
        .productAds,
        .categories
    ]
    
    func section(atIndex index: Int) -> Section? {
        return sections[at: index]
    }
    
    func append(section: Section) {
        sections.append(section)
    }
    
    // MARK:- Setup collectionViewDataSource
    func set(collectionViewDataSource: ViewDataSource) {
        self.collectionViewDataSource = collectionViewDataSource
    }
    
    func set(shoppingPromotions: ShoppingPromotions) {
        var newSnapshot = collectionViewDataSource.snapshot()
        
        let bannerAds = shoppingPromotions.bannerAds.map(mapToListItem(item:))
        let productAds = shoppingPromotions.productAds.map(mapToListItem(item:))
        let categories = shoppingPromotions.categories.map(mapToListItem(item:))
        
        newSnapshot.appendSections(sections)
        newSnapshot.appendItems(bannerAds, toSection: .bannerAds)
        newSnapshot.appendItems(productAds, toSection: .productAds)
        newSnapshot.appendItems(categories, toSection: .categories )

        for recommendedProductsSection in shoppingPromotions.recommendedProductsSections {
            let recommendedProducts = recommendedProductsSection.products.map(mapToListItem(item:))
            
            let sectionDescription = recommendedProductsSection.name
            let recommendedProductsSection = Section.productRecommendation(sectionTitle: sectionDescription)
            append(section: recommendedProductsSection)
            newSnapshot.appendSections([recommendedProductsSection])
            newSnapshot.appendItems(recommendedProducts, toSection: recommendedProductsSection)
        }
        collectionViewDataSource.apply(newSnapshot, animatingDifferences: false)
    }
    
    func mapToListItem(item: Any) -> ListItem<Any> {
        return ListItem<Any>(item: item)
    }
    
    func  layoutForSection(atIndex index: Int) -> NSCollectionLayoutSection? {
        switch self.section(atIndex: index) {
            case .bannerAds:
                return ShopViewSectionLayoutManager.bannerAdsLayout()
            case .productAds:
                return ShopViewSectionLayoutManager.productsAdsLayout()
            case .categories:
                return ShopViewSectionLayoutManager.categoriesLayout()
            case .productRecommendation(_):
                return ShopViewSectionLayoutManager.productsRecommendationLayout()
            default:
                return nil
        }
    }
    
    // MARK:- service requests
    func loadShoppingPromotions() {
        promotionsService.shoppingPromotions(completion: handleShoppingPromotionsResponse)
    }
    
    private(set) lazy var handleShoppingPromotionsResponse = { [weak self] (serviceError: NetworkServiceError?, shoppingPromotionsDTO: ShoppingPromotionsDTO?) in
        if let shoppingPromotions = shoppingPromotionsDTO?.mapObject() {
            self?.set(shoppingPromotions: shoppingPromotions)
            self?.delegate?.loadShoppingPromotionsDidSuccess()
        } else {
            self?.delegate?.loadShoppingPromotionsDidFailed()
        }
    }
    
    
}


extension ShopViewModel {
    enum Section: Hashable {
        case bannerAds
        case productAds
        case categories
        case productRecommendation(sectionTitle: String)
        
        func title() -> String {
            switch self {
                case .categories:
                    return "Categories"
                case .productRecommendation(let title):
                    return title
                default:
                    return ""
            }
        }
    }
}
