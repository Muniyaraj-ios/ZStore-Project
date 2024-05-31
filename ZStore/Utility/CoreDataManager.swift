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
        
    /*private(set)*/ var main_homeData: [ZstoreMainEntity] = ZstoreMainEntity.defaultData
        
    func setData(_ data: HomeDataModel,_ closure:((String)->())?){
        removeExistingEntities(CategoryEntity.self)
        removeExistingEntities(CardOfferEntity.self)
        removeExistingEntities(ProductsEntity.self)
        
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
            product_entity.review_count = Int32(product.review_count)
            product_entity.card_offer_ids = product.card_offer_ids.joined(separator: ",")
            product_entity.colors = product.colors?.joined(separator: ",")
        }
        do{
            try context_k.save()
            print("Data saved successfully")
            closure?("Data Saved Successfully")
        }catch let error{
            print("Error : \(error.localizedDescription)")
            closure?("Data Saved get error : \(error.localizedDescription)")
        }
    }
    func removeExistingEntities<T: NSManagedObject>(_ request: T.Type) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = request.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context_k.execute(deleteRequest)
        } catch let error as NSError {
            print("Could not delete \(request.entity()): \(error), \(error.userInfo)")
        }
    }
    
    func fetchData(_ sorttype: sel_FilterState,_ closure:(()->())?){
        
        let catgory_entity = CategoryEntity.fetchRequest()
        let cardoffer_entity = CardOfferEntity.fetchRequest()
        let product_entity = ProductsEntity.fetchRequest()
        
//        product_entity.predicate = NSPredicate(format: "name CONTAINS %@", "")
        switch sorttype{
        case .rating:
            product_entity.sortDescriptors = [.init(key: "rating", ascending: false)]
            break
        case .price:
            product_entity.sortDescriptors = [.init(key: "price", ascending: false)]
            break
        }
        
        do{
            let categories = try context_k.fetch(catgory_entity)
            let cardoffers = try context_k.fetch(cardoffer_entity)
            let productS = try context_k.fetch(product_entity)
            
            let categoryMainEntity = ZstoreMainEntity(type: .categories, items: MainEntity(category: categories))
            let offerMainEntity = ZstoreMainEntity(type: .offers, items: MainEntity(offer: cardoffers))
            let productMainEntity = ZstoreMainEntity(type: .products, items: MainEntity(product: productS))
            
            main_homeData = [categoryMainEntity,offerMainEntity,productMainEntity]
            
            homeData = MainEntity(category: categories, offer: cardoffers, product: productS)
            closure?()
        }catch{
            print("Error getting fetch data : \(error.localizedDescription)")
            main_homeData = ZstoreMainEntity.defaultData
            homeData = .emptyData
        }
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
    func updateFavouriteStatus(_ productId: String,status favourite: Bool){
        let product_entity = ProductsEntity.fetchRequest()
        product_entity.predicate = NSPredicate(format: "id == %@", productId)
        do{
            let result = try context_k.fetch(product_entity)
            if let product = result.first{
                product.isFavourite = favourite
                try context_k.save()
                print("Favorite status updated successfully.")
            }else {
                print("Product with ID \(productId) not found.")
            }
            
        }catch{
            print("Failed to update favorite status: \(error.localizedDescription)")
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
enum ZstoreProductType{
    case categories
    case offers
    case products
}

struct ZstoreMainEntity{
    var type: ZstoreProductType
    var items: MainEntity
}
extension ZstoreMainEntity{
    static let defaultData = [
        ZstoreMainEntity(type: .categories, items: .emptyData),
        ZstoreMainEntity(type: .offers, items: .emptyData),
        ZstoreMainEntity(type: .products, items: .emptyData),
    ]
    
    mutating func updateFavoriteStatus(for productID: String, isFavorite: Bool) {
          guard type == .products, var products = items.product else {
              return // Handle the case when the type is not products
          }
          
          if let index = products.firstIndex(where: { $0.id == productID }) {
              products[index].isFavourite = isFavorite
              items.product = products
          }
      }
}
