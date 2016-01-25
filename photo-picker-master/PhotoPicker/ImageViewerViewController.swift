//
//  ImageViewerViewController.swift
//  PhotoPicker
//
//  Created by IOSDev on 1/25/16.
//  Copyright © 2016 Russell Austin. All rights reserved.
//

import UIKit
import CoreImage

class ImageViewerViewController: UIViewController {

    @IBOutlet weak var capturedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.capturedImage.image = Utils.loadImageFromPath(Utils.getDocumentsURL())!
//        let effectImage = self.imageEffect(self.capturedImage.image!)
//        self.capturedImage.image = effectImage
        self.capturedImage.image = self.imageEffect(Utils.loadImageFromPath(Utils.getDocumentsURL())!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getImageOrientation (image:UIImage) -> (Int) {
        var exifOrientation = 0;
        switch (image.imageOrientation) {
        case .Up:
            exifOrientation = 1;
            break;
        case .Down:
            exifOrientation = 3;
            break;
        case .Left:
            exifOrientation = 8;
            break;
        case .Right:
            exifOrientation = 6;
            break;
        case .UpMirrored:
            exifOrientation = 2;
            break;
        case .DownMirrored:
            exifOrientation = 4;
            break;
        case .LeftMirrored:
            exifOrientation = 5;
            break;
        case .RightMirrored:
            exifOrientation = 7;
            break;
        }
        return exifOrientation
    }
    
    
    func imageEffect(effectImage: UIImage) -> UIImage {
        let ciImage  = CIImage(CGImage:effectImage.CGImage!)
        let ciDetector = CIDetector(ofType:CIDetectorTypeFace
            ,context:nil
            ,options:[
                CIDetectorAccuracy:CIDetectorAccuracyHigh
            ])
        
        let imageOptions = NSDictionary(dictionary:[CIDetectorImageOrientation:self.getImageOrientation(effectImage)])
                
        let features = ciDetector.featuresInImage(ciImage,options:imageOptions as? [String : AnyObject])
        
        UIGraphicsBeginImageContext(effectImage.size)
        effectImage.drawInRect(CGRectMake(0,0,effectImage.size.width,effectImage.size.height))
        
        for feature in features{
            
            //context
            let drawCtxt = UIGraphicsGetCurrentContext()
            let faceFeature = feature as! CIFaceFeature
            //face
            var faceRect = (feature as! CIFaceFeature).bounds
            faceRect.origin.y = effectImage.size.height - faceRect.origin.y - faceRect.size.height
            CGContextSetStrokeColorWithColor(drawCtxt, UIColor.redColor().CGColor)
            CGContextStrokeRect(drawCtxt,faceRect)
            
            //mouse
            if(faceFeature.hasMouthPosition){
                let mouseRectY = effectImage.size.height - faceFeature.mouthPosition.y
                let mouseRect  = CGRectMake(faceFeature.mouthPosition.x - 5,mouseRectY - 5,10,10)
                CGContextSetStrokeColorWithColor(drawCtxt,UIColor.blueColor().CGColor)
                CGContextStrokeRect(drawCtxt,mouseRect)
            }
            
            //hige
            let higeImg      = UIImage(named:"hige_100.png")
            let mouseRectY = effectImage.size.height - faceFeature.mouthPosition.y
            //ヒゲの横幅は顔の4/5程度
            let higeWidth  = faceRect.size.width * 4/5
            let higeHeight = higeWidth * 0.3 // 元画像が100:30なのでWidthの30%が縦幅
            let higeRect  = CGRectMake(faceFeature.mouthPosition.x - higeWidth/2,mouseRectY - higeHeight/2,higeWidth,higeHeight)
            CGContextDrawImage(drawCtxt,higeRect,higeImg!.CGImage)
            
            //leftEye
            if((faceFeature.hasLeftEyePosition)){
                let leftEyeRectY = effectImage.size.height - faceFeature.leftEyePosition.y
                let leftEyeRect  = CGRectMake(faceFeature.leftEyePosition.x - 5,leftEyeRectY - 5,10,10)
                CGContextSetStrokeColorWithColor(drawCtxt, UIColor.blueColor().CGColor)
                CGContextStrokeRect(drawCtxt,leftEyeRect)
            }
            
            //rightEye
            if((faceFeature.hasRightEyePosition) ){
                let rightEyeRectY = effectImage.size.height - faceFeature.rightEyePosition.y
                let rightEyeRect  = CGRectMake(faceFeature.rightEyePosition.x - 5,rightEyeRectY - 5,10,10)
                CGContextSetStrokeColorWithColor(drawCtxt, UIColor.blueColor().CGColor)
                CGContextStrokeRect(drawCtxt,rightEyeRect)
            }
        }
        let drawedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return drawedImage
    }
}
