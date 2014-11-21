//
//  SupermarketListViewController.swift
//  PracticaFinal
//
//  Created by Luis Valdés on 17/11/14.
//  Copyright (c) 2014 Luis Valdés. All rights reserved.
//

import UIKit

class SupermarketListViewController: UIViewController, FetchedResultsControllerDataSourceDelegate {
    @IBOutlet var tableview: UITableView!
    var dataSource: FetchedResultsControllerDataSource?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let reuseIdentifier = "SupermarketCell"
//        self.tableview.registerClass(A CLASS, forCellReuseIdentifier: reuseIdentifier) // NOT necessary as we created a prototype cell in the storyboard
        
        let fetchedRC = SupermarketEntity.supermarketsFetchedResultsController(inManagedObjectContext: CoreDataStackService.sharedStack.managedObjectContext!)
        
        self.dataSource                             = FetchedResultsControllerDataSource(tableView: self.tableview)
        self.dataSource?.fetchedResultsController   = fetchedRC
        self.dataSource?.delegate                   = self
        self.dataSource?.reuseIdentifier            = reuseIdentifier
    }
    
    // MARK: - FetchedResultsControllerDataSourceDelegate
    
    func configureCell(cell: UITableViewCell, withObject object: AnyObject) {
        cell.textLabel.text = (object as SupermarketEntity).name
    }
    
    // MARK: - 
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? UITableViewCell {
            if let selectedIndexPath = self.tableview.indexPathForCell(cell) {
                if let object: AnyObject = self.dataSource?.objectAtIndexPath(selectedIndexPath) {
                    let vc = segue.destinationViewController as ProductListViewController
                    vc.supermarket = object as SupermarketEntity
                    self.tableview.deselectRowAtIndexPath(selectedIndexPath, animated: true)
                }
            }
        }
    }
}
