//
//  CategoryEntity+CoreDataProperties.swift
//  
//
//  Created by Apple on 30/05/24.
//
//

import Foundation
import CoreData


extension CategoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntity> {
        return NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var layout: String?
    @NSManaged public var name: String?

}
