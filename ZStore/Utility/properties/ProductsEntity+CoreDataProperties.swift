//
//  ProductsEntity+CoreDataProperties.swift
//  
//
//  Created by Apple on 30/05/24.
//
//

import Foundation
import CoreData


extension ProductsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductsEntity> {
        return NSFetchRequest<ProductsEntity>(entityName: "ProductsEntity")
    }

    @NSManaged public var card_offer_ids: NSObject?
    @NSManaged public var category_id: String?
    @NSManaged public var desc: String?
    @NSManaged public var id: String?
    @NSManaged public var image_url: String?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var review_count: Int16
    @NSManaged public var rating: Double

}
