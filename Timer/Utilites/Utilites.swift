//
//  Utilites.swift
//  Timer
//
//  Created by Maslov Sergey on 01.03.16.
//  Copyright © 2016 Home. All rights reserved.
//

import Foundation
import AudioToolbox

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
    
    class func vibrate() {
        if Utilites.isVibrateEnabled() {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
    }
    
    class func isVibrateEnabled() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let isVibrate = defaults.objectForKey(Constants.UserDefaultsKeys.UseActionVibrations) as? Bool {
            return isVibrate
        }
        defaults.setBool(true, forKey: Constants.UserDefaultsKeys.UseActionVibrations)
        return true
    }
    
    class func isUseIcons() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let isUseIcons = defaults.objectForKey(Constants.UserDefaultsKeys.UseActionIcons) as? Bool {
            return isUseIcons
        }
        defaults.setBool(true, forKey: Constants.UserDefaultsKeys.UseActionIcons)
        return true
    }
    
    class func secondsToTimer(seconds: Int) -> String {
        if seconds < 60 {
            return NSString(format: ":%02d",seconds) as String
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
    
    class func showWithAnimation(view: UIView) {
        view.alpha = 0
        UIView.animateWithDuration(5.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    view.alpha = 1
        }, completion: nil)
    }

}