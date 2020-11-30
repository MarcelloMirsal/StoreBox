//
//  PromotionsDTO.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 19/11/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation


struct ShoppingPromotionsDTO: Codable {
    let bannerAds: [BannerAdDTO]
    let productAds: [ProductAdDTO]
    let categories: [CategoryDTO]
    let recommendedProductsSections: [RecommendedProductsSectionDTO]
    
    func mapObject() -> ShoppingPromotions {
        let mappedBannerAds = bannerAds.map({$0.mapObject()})
        let mappedProductAds = productAds.map({$0.mapObject()})
        let mappedCategories = categories.map({$0.mapObject()})
        let mappedRecommendedProductsSections = recommendedProductsSections.map({$0.mapObject()})
        
        return ShoppingPromotions(bannerAds: mappedBannerAds , productAds: mappedProductAds, categories: mappedCategories, recommendedProductsSections: mappedRecommendedProductsSections)
    }
    
    enum CodingKeys: String, CodingKey {
        case bannerAds, productAds, categories
        case recommendedProductsSections = "productsForUser"
    }
    
}

struct BannerAdDTO: Codable {
    let id: Int
    let imageURL: String
    
    func mapObject() -> BannerAd {
        return BannerAd(id: id, imageURL: imageURL)
    }
    enum CodingKeys: String, CodingKey {
        case id , imageURL = "imageUrl"
    }
}

struct ProductAdDTO: Codable {
    let id: Int
    let productId: Int
    let name: String
    let price: Double
    let discount: Double
    let hasDiscount: Bool
    let description: String
    let priceAfterDiscount: Double
    
    func mapObject() -> ProductAd {
        return ProductAd(id: id, productId: productId, name: name
            , description: description, price: price, priceAfterDiscount: priceAfterDiscount, hasDiscount: hasDiscount)
    }
}


struct RecommendedProductsSectionDTO: Codable {
    let id: Int
    let name: String
    let products: [Product]
    func mapObject() -> RecommendedProductsSection {
        return RecommendedProductsSection(id: id, name: name, products: products)
    }
}
