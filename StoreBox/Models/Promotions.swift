//
//  Promotions.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 17/11/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation

struct ShoppingPromotions {
    let bannerAds: [BannerAd]
    let productAds: [ProductAd]
    let categories: [Category]
    let recommendedProductsSections: [RecommendedProductsSection]
}

struct BannerAd {
    let id: Int
    let imageURL: String
}

struct ProductAd {
    let id: Int
    let productId: Int
    let name: String
    let description: String
    let price: Double
    let priceAfterDiscount: Double
    let hasDiscount: Bool
}


struct RecommendedProductsSection {
    let id: Int
    let name: String
    let products: [Product]
}
