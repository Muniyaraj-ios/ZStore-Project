//
//  HomeModel.swift
//  ZStore
//
//  Created by Apple on 27/05/24.
//

import Foundation

struct HomeDataModel: Codable{
  let category: [CategoryModel]
  let card_offers: [CardOfferModel]
  let products: [ProductsDataModel]
}
extension HomeDataModel{
    static let emptyData = HomeDataModel(category: [], card_offers: [], products: [])
}

struct CategoryModel: Codable{
  let id: String
  let name: String
  let layout: String
}

struct CardOfferModel: Codable{
  let id: String
  let percentage: Double
  let card_name: String
  let offer_desc: String
  let max_discount: String
  let image_url: String
}

struct ProductsDataModel: Codable{
  let id: String
  let name: String
  let rating: Double
  let review_count: Int
  let price: Double
  let category_id: String
  let card_offer_ids: [String]
  let colors: [String]?
  let image_url: String
  let description: String
  let isFavourite: Bool?
}
