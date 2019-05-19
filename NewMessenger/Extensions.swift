//
//  Extensions.swift
//  NewMessenger
//
//  Created by Farukh IQBAL on 25/02/2017.
//  Copyright © 2017 Farukh. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        // Check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage as? UIImage
            return
        }
        
        // Otherwise fire off a new download
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: url as! URL, completionHandler: { (data, response, error) in
            
            // Dowload hit an error so let's return out
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                }
            })
        }).resume()
    }
}
