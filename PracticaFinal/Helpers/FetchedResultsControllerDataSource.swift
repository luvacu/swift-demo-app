//
//  FetchedResultsControllerDataSource.swift
//  PracticaFinal
//
//  Created by Luis Valdés on 17/11/14.
//  Copyright (c) 2014 Luis Valdés. All rights reserved.
//

import UIKit
import CoreData

protocol FetchedResultsControllerDataSourceDelegate: class {
    func configureCell(cell: UITableViewCell, withObject object: AnyObject)
}

class FetchedResultsControllerDataSource: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    let tableView: UITableView
    var reuseIdentifier: String?
    var fetchedResultsController: NSFetchedResultsController? {
        didSet {
            if let fetchedRC = fetchedResultsController {
                fetchedRC.delegate = self
                self.fetch(fetchedRC)
            }
        }
    }
    weak var delegate: FetchedResultsControllerDataSourceDelegate?
    
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        self.tableView.dataSource = self
    }
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> AnyObject! {
        return self.fetchedResultsController?.objectAtIndexPath(indexPath)
    }
   
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier((self.reuseIdentifier ?? ""), forIndexPath: indexPath) as UITableViewCell
        if let object: AnyObject = self.fetchedResultsController?.objectAtIndexPath(indexPath) {
                self.delegate?.configureCell(cell, withObject: object)
        }
        return cell
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
//    func controllerWillChangeContent(controller: NSFetchedResultsController) {
//        self.tableView.beginUpdates()
//    }
//    
//    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
//        // TODO: Fill this function
//    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
//        self.tableView.endUpdates()
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Private methods
    
    private func fetch(controller: NSFetchedResultsController) {
        var error: NSError?
        if !controller.performFetch(&error) {
            NSLog("Error fetching data: \(error ?? nil) / \(error?.userInfo ?? nil)")
        }
    }
}
