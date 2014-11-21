//
//  SupermarketService.swift
//  PracticaFinal
//
//  Created by Luis Valdés on 17/11/14.
//  Copyright (c) 2014 Luis Valdés. All rights reserved.
//

import UIKit

class SupermarketService: NSObject {
    class var sharedService: SupermarketService {
        struct Static {
            static let instance = SupermarketService()
        }
        return Static.instance
    }
    
    func loadDataFromLocalJSON() {
        let fileName: String = "supermarkets.json"
        if let path = NSBundle.mainBundle().pathForResource(fileName, ofType:nil) {
            if let array = self.readArray(fromPath: path) {
                self.parseArraySupermarkets(array)
            }
        }
    }
    
    func loadDataFromApi() {
        let urlString = "https://dl.dropboxusercontent.com/u/129447712/supermarkets.json"
        if let url = NSURL(string: urlString) {
            NetworkingService.sharedService.downloadData(fromUrl: url, withBackgroundThreadCompletionBlock: { (data) in
                if let array = self.readArray(fromData: data) {
                    self.parseArraySupermarkets(array)
                }
                
            })
        }
    }
    
    
    // MARK: - Private functions
    
    private func readArray(fromPath path: String!) -> NSMutableArray? {
        if (path == nil) {
            return nil
        }
        let data = NSData(contentsOfFile:path)
        return self.readArray(fromData: data)
    }
    
    private func readArray(fromURL url: NSURL!) -> NSMutableArray? {
        if (url == nil) {
            return nil
        }
        let data = NSData(contentsOfURL:url)
        return self.readArray(fromData: data)
    }
    
    private func readArray(fromData data: NSData!) -> NSMutableArray? {
        if (data == nil || data!.length == 0) {
            NSLog("Error reading data")
            return nil
        }
        var error: NSError?
        let array: NSMutableArray = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSMutableArray
        if (error != nil) {
            NSLog("Error parsing JSON: %@", error!)
            return nil
        } else {
            return array
        }
    }
    
    
    private func parseArraySupermarkets(array: NSMutableArray) {
        let managedContext = CoreDataStackService.sharedStack.managedObjectContext!
        
        for dict in array {
            let name = dict["name"] as String!
            if (name == nil) {
                continue
            }
            let latitude    = dict["Latitude"] as String?
            let longitude   = dict["Longitude"] as String?
            
            let supermarket: SupermarketEntity = SupermarketEntity.insertSupermarketWithName(name, inManagedObjectContext: managedContext)
            if (latitude != nil && longitude != nil) {
                supermarket.latitude    = latitude!
                supermarket.longitude   = longitude!
            }
            
            if let productsArray = dict["products"] as? NSArray {
                for dictProduct in productsArray {
                    if let productName = dictProduct["name"] as String? {
                        let product = ProductEntity.insertProductWithName(productName, fromSupermarket: supermarket, inManagedObjectContext: managedContext)
                        if let imageString = dictProduct["image"] as? String {
                            product.imageUrl = imageString
                        }
                    }
                }
            }
        }
        
        CoreDataStackService.sharedStack.saveContext()
    }
}
