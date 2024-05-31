//
//  ProductsEntity+CoreDataProperties.swift
//  
//
//  Created by Suriya_MacBook on 30/05/24.
//
//

import Foundation
import CoreData


extension ProductsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductsEntity> {
        return NSFetchRequest<ProductsEntity>(entityName: "ProductsEntity")
    }

    @NSManaged public var category_id: String?
    @NSManaged public var desc: String?
    @NSManaged public var id: String?
    @NSManaged public var image_url: String?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var rating: Double
    @NSManaged public var review_count: Int32
    @NSManaged public var card_offer_ids: String?
    @NSManaged public var colors: String?

}
