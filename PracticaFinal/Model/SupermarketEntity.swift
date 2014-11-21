//
//  SupermarketEntity.swift
//  PracticaFinal
//
//  Created by Luis Valdés on 15/11/14.
//  Copyright (c) 2014 Luis Valdés. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class SupermarketEntity: NSManagedObject, MKAnnotation {

    @NSManaged var name: String
    @NSManaged var latitude: String?
    @NSManaged var longitude: String?
    @NSManaged var products: NSSet

    // MKAnnotation properties
    var coordinate: CLLocationCoordinate2D {
        
        
        if (self.latitude == nil || self.latitude!.isEmpty
            || self.latitude == nil || self.longitude!.isEmpty) {
                return CLLocationCoordinate2DMake(0.0, 0.0)
        }
        return CLLocationCoordinate2DMake(  NSString(string: self.latitude!).doubleValue,
                                            NSString(string: self.longitude!).doubleValue)
    }
    var title: String! {
        return self.name
    }
    var subtitle: String! {
        return (products.count == 1) ? "\(products.count) product" : "\(products.count) products"
    }
    
    // MARK: - Helper methods for Managed Object creation
    
    class var entityName: String {
        return "SupermarketEntity"
    }
    
    class func insertSupermarketWithName(name: String, inManagedObjectContext context: NSManagedObjectContext) -> SupermarketEntity {
        let supermarket = NSEntityDescription.insertNewObjectForEntityForName(self.entityName, inManagedObjectContext: context) as SupermarketEntity
        supermarket.name = name
        return supermarket
    }
    
    // MARK: - Helper methods for querying
    
    class func supermarketsFetchedResultsController(inManagedObjectContext context: NSManagedObjectContext) -> NSFetchedResultsController {
        // Class function to retrieve ALL the supermarkets stored in the context
        let request = NSFetchRequest(entityName: self.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.fetchBatchSize = 30 // Load only the first 30 items. The rest are going to be automatically loaded lazily as needed
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func productsFetchedResultsController() -> NSFetchedResultsController {
        // Instance function to retrieve all the products asociated to this supermarket
        let request = NSFetchRequest(entityName: ProductEntity.entityName)
        request.predicate = NSPredicate(format: "inSupermarket = %@", argumentArray: [self])
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.fetchBatchSize = 30 // Load only the first 30 items. The rest are going to be automatically loaded lazily as needed
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    // MARK: -
}
