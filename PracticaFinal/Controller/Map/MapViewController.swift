//
//  MapViewController.swift
//  PracticaFinal
//
//  Created by Luis Valdés on 18/11/14.
//  Copyright (c) 2014 Luis Valdés. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate {
    @IBOutlet var mapView: MKMapView!
    var fetchedResultsController: NSFetchedResultsController

    required init(coder aDecoder: NSCoder) {
        self.fetchedResultsController = SupermarketEntity.supermarketsFetchedResultsController(inManagedObjectContext: CoreDataStackService.sharedStack.managedObjectContext!)
        super.init(coder: aDecoder)
        self.fetchedResultsController.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.fetch(self.fetchedResultsController)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.addAnnotationsToMapFromFetchedRC(self.fetchedResultsController)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.pinColor                    = .Red
        pin.rightCalloutAccessoryView   = UIButton.buttonWithType(.InfoDark) as UIView
        pin.canShowCallout              = true
        return pin
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let supermarket = view.annotation as SupermarketEntity
        if let listVC = self.storyboard?.instantiateViewControllerWithIdentifier("ProductListViewController") as? ProductListViewController {
            listVC.supermarket = supermarket
            self.navigationController?.pushViewController(listVC, animated: true)
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.addAnnotationsToMapFromFetchedRC(self.fetchedResultsController)
        }
    }
    
    // MARK: - Private methods
    
    private func fetch(controller: NSFetchedResultsController) {
        var error: NSError?
        if !controller.performFetch(&error) {
            NSLog("Error fetching data: \(error ?? nil) / \(error?.userInfo ?? nil)")
        }
    }
    
    private func addAnnotationsToMapFromFetchedRC(controller: NSFetchedResultsController) {
        if let supermarkets = controller.fetchedObjects {
            self.mapView.addAnnotations(supermarkets)
            self.mapView.showAnnotations(supermarkets, animated: false)
        }
    }
}
