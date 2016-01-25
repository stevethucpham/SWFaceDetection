//
//  Utils.swift
//  PhotoPicker
//
//  Created by IOSDev on 1/25/16.
//  Copyright © 2016 Russell Austin. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    static func saveImage (image: UIImage, path: NSURL ) -> Bool{
        
//        let pngImageData = UIImagePNGRepresentation(image)
        let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let imagePath = path.URLByAppendingPathComponent("test.jpg")
        let result = jpgImageData!.writeToFile(imagePath.path!, atomically: true)
        return result
    }
    
    static func getDocumentsURL() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }
    
    static func loadImageFromPath(path: NSURL) -> UIImage? {
        
        let imagePath = path.URLByAppendingPathComponent("test.jpg")
        let image = UIImage(contentsOfFile: imagePath.path!)
        
        if image == nil {
            
            print("missing image at: \(imagePath.path!)")
        }
        print("Loading image from path: \(imagePath.path!)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
    }
    
    static func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

}
