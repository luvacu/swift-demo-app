//
//  NetworkingService.swift
//  PracticaFinal
//
//  Created by Luis Valdés on 18/11/14.
//  Copyright (c) 2014 Luis Valdés. All rights reserved.
//

import UIKit

class NetworkingService: NSObject {
    class var sharedService: NetworkingService {
        struct Static {
            static let instance = NetworkingService()
        }
        return Static.instance
    }
    
    // Tries to retrieve a NSData object from the specified URL in a background thread.
    // Note that the completion function will be executed on the main thread
    func downloadData(fromUrl url: NSURL, withMainThreadCompletionBlock completionBlock: (NSData?) -> Void) {
        self.downloadData(fromUrl: url, completionBlock: completionBlock, shouldExecuteCompletionBlockInMainThread: true)
    }

    // Tries to retrieve a NSData object from the specified URL in a background thread.
    // Note that the completion function will be executed on the same background thread as the download process
    func downloadData(fromUrl url: NSURL, withBackgroundThreadCompletionBlock completionBlock: (NSData?) -> Void) {
        self.downloadData(fromUrl: url, completionBlock: completionBlock, shouldExecuteCompletionBlockInMainThread: false)
    }
    
    // MARK: - Private functions
    
    // Tries to retrieve a NSData object from the specified URL in a background thread.
    // Note that the completion function will be executed on the main thread or 
    // on the same background thread as the download process, depending on the parameter 'shouldExecuteCompletionBlockInMainThread'
    func downloadData(fromUrl url: NSURL, completionBlock: (NSData?) -> Void, shouldExecuteCompletionBlockInMainThread: Bool) {
        let task = NSURLSession.sharedSession().downloadTaskWithURL(url) { (dataUrl, response, error) in
            var data: NSData?
            if (error == nil && response != nil && (response as NSHTTPURLResponse).statusCode == 200) {
                if (dataUrl != nil) {
                    // Create NSData
                    data = NSData(contentsOfURL:dataUrl)
                    if (data != nil && data!.length == 0) {
                        // Downloaded data is empty. Nullify
                        data = nil
                    }
                }
            } else {
                if (error != nil) {
                    NSLog("Error downloading data. Error: %@", error)
                }
                if (response != nil) {
                    NSLog("Error downloading data. Response: %@", response)
                }
            }
            
            if (data != nil) {
                NSLog("Data downloaded successfully")
            } else {
                NSLog("Error downloading data or it was empty")
            }
            
            if (shouldExecuteCompletionBlockInMainThread) {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completionBlock(data)
                }
            } else {
                completionBlock(data)
            }
        }
        
        task.resume()
    }
}
