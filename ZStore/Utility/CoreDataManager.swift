//
//  CoreDataManager.swift
//  ZStore
//
//  Created by Apple on 26/05/24.
//

import CoreData
import UIKit



final class CoreManger: NSObject{
        
    let context_k = AppDelegate.shared.persistentContainer.viewContext
    
    private(set) var homeData: MainEntity = .emptyData
    
    func setData(_ data: HomeDataModel){
        for cat in data.category{
            let catgory_entity = CategoryEntity(context: context_k)
            catgory_entity.id = cat.id
            catgory_entity.name = cat.name
            catgory_entity.layout = cat.layout
        }
        for card_offer in data.card_offers {
            let cardoffer_entity = CardOfferEntity(context: context_k)
            cardoffer_entity.id = card_offer.id
            cardoffer_entity.card_name = card_offer.card_name
            cardoffer_entity.image_url = card_offer.image_url
            cardoffer_entity.max_discount = card_offer.max_discount
            cardoffer_entity.offer_desc = card_offer.offer_desc
            cardoffer_entity.percentage = card_offer.percentage
        }
        for product in data.products {
            let product_entity = ProductsEntity(context: context_k)
            product_entity.id = product.id
            product_entity.category_id = product.category_id
            product_entity.desc = product.description
            product_entity.image_url = product.image_url
            product_entity.isFavourite = product.isFavourite ?? false
            product_entity.name = product.name
            product_entity.price = product.price
            product_entity.rating = product.rating
            product_entity.review_count = Int16(product.review_count)
            product_entity.card_offer_ids = product.card_offer_ids as NSObject?
        }
        do{
            try context_k.save()
            print("Data saved successfully")
        }catch let error{
            print("Error : \(error.localizedDescription)")
        }
    }
    
    func fetchData()->MainEntity{
        
        let catgory_entity = CategoryEntity.fetchRequest()
        let cardoffer_entity = CardOfferEntity.fetchRequest()
        let product_entity = ProductsEntity.fetchRequest()
        
//        let product_Entity = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductsEntity")
                
        
        do{
            let categories = try context_k.fetch(catgory_entity)
            let cardoffers = try context_k.fetch(cardoffer_entity)
            let productS = try context_k.fetch(product_entity)
            return MainEntity(category: categories, offer: cardoffers, product: productS)
            
        }catch{
            print("Error getting fetch data : \(error.localizedDescription)")
        }
        return MainEntity()
    }
    func deleteData(alldata: MainEntity){
        guard let categories = alldata.category,let cardoffers = alldata.offer,let products = alldata.product else{return}
        
//        context_k.deletedObjects
        for category in categories {
            context_k.delete(category)
        }
        for cardoffer in cardoffers {
            context_k.delete(cardoffer)
        }
        for product in products {
            context_k.delete(product)
        }
        do{
            try context_k.save()
            print("Save all deleted successfull")
        }catch{
            print("Delete get error : \(error.localizedDescription)")
        }
    }
}

struct MainEntity{
    var category: [CategoryEntity]?
    var offer: [CardOfferEntity]?
    var product: [ProductsEntity]?
}
extension MainEntity{
    static let emptyData = MainEntity(category: [], offer: [], product: [])
}
