//
//  ProductDetailViewController.swift
//  PracticaFinal
//
//  Created by Luis Valdés on 18/11/14.
//  Copyright (c) 2014 Luis Valdés. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    @IBOutlet var navBarItem: UINavigationItem!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var product: ProductEntity!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navBarItem.title = product.name
        self.activityIndicator.hidden = true
        if (product.imageUrl != nil) {
            if let imageUrl = NSURL(string: product.imageUrl!) {
                self.activityIndicator.hidden = false
                // Download image as NSData
                self.setImage(fromUrl: imageUrl)
            }
        }
    }


    
    func setImage(fromUrl url: NSURL) {
        NetworkingService.sharedService.downloadData(fromUrl: url, withMainThreadCompletionBlock: { (data) in
            self.activityIndicator.hidden = true
            if data == nil {
                return
            }
            self.imageView.image = UIImage(data: data!)
        })
    }

    
    
}
