//
//  imageDownloadHelper.swift
//  FitMeal
//
//  Created by Mingyang Sun on 7/19/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit

class imageDownloadHelper: NSObject {
   
        
        var cache = NSCache()
        
        class var sharedLoader : imageDownloadHelper {
            struct Static {
                static let instance : imageDownloadHelper = imageDownloadHelper()
            }
            return Static.instance
        }
        
        func imageForUrl(urlString: String, completionHandler:(image: UIImage?, url: String) -> ()) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {()in
          var data: NSData? = self.cache.objectForKey(urlString) as? NSData
              
                if let goodData = data {
                    let image = UIImage(data: goodData)
                    dispatch_async(dispatch_get_main_queue(), {() in
                        completionHandler(image: image, url: urlString)
                    })
                    return
                }
                
                var downloadTask: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)!, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                    if (error != nil) {
                        completionHandler(image: nil, url: urlString)
                        return
                    }
                    
                    if data != nil {
                        let image = UIImage(data: data!)
                        self.cache.setObject(data!, forKey: urlString)
                        dispatch_async(dispatch_get_main_queue(), {() in
                            completionHandler(image: image, url: urlString)
                        })
                        return
                    }
                    
                })
                downloadTask.resume()
            })
            
        }
    }

