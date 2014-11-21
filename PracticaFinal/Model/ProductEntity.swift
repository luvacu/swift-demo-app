//
//  ProductEntity.swift
//  PracticaFinal
//
//  Created by Luis Valdés on 15/11/14.
//  Copyright (c) 2014 Luis Valdés. All rights reserved.
//

import Foundation
import CoreData

class ProductEntity: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var imageUrl: String?
    @NSManaged var inSupermarket: SupermarketEntity

    // Helper methods for Managed Object creation
    
    class var entityName: String {
        return "ProductEntity"
    }
    
    class func insertProductWithName(name: String, fromSupermarket supermarket: SupermarketEntity, inManagedObjectContext context: NSManagedObjectContext) -> ProductEntity {
        let product = NSEntityDescription.insertNewObjectForEntityForName(self.entityName, inManagedObjectContext: context) as ProductEntity
        product.name            = name
        product.inSupermarket   = supermarket // This is the reverse relationship of Supermarket -to-many-> Product,
                                            // so we do not have to add this Product to Supermarket manually, it is
                                            // for us automatically. And product.inSupermarket = supermarket is 
                                            // easier to do than the counter part:
                                            // supermarket.mutableSetValueForKey("products").addObject(product)
        return product
    }
}
