//
//  Utilites.swift
//  Timer
//
//  Created by Maslov Sergey on 01.03.16.
//  Copyright © 2016 Home. All rights reserved.
//

import Foundation

class Utilites {
    class func scaleImage(image: UIImage, toSize newSize: CGSize) -> (UIImage) {
        let newRect = CGRectIntegral(CGRectMake(0,0, newSize.width, newSize.height))
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetInterpolationQuality(context, .High)
        let flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height)
        CGContextConcatCTM(context, flipVertical)
        CGContextDrawImage(context, newRect, image.CGImage)
        let newImage = UIImage(CGImage: CGBitmapContextCreateImage(context)!)
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    class func secondsToTimer(seconds: Int) -> String {
        if seconds < 60 {
            return NSString(format: "  :%02d",seconds) as String
        } else {
            let minutes = seconds/60
            let sec = seconds - minutes * 60
        
            return NSString(format: "%02d:%02d", minutes, sec) as String
        }
        
    }
    
    class func printFonts() {
        let fontFamilyNames = UIFont.familyNames()
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNamesForFamilyName(familyName as! String)
            print("Font Names = [\(names)]")
        }
    }

}