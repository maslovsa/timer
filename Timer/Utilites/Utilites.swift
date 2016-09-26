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
    class func scaleImage(_ image: UIImage, toSize newSize: CGSize) -> (UIImage) {
        let newRect = CGRect(x: 0,y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context!.interpolationQuality = .high
        let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
        context?.concatenate(flipVertical)
        context?.draw(image.cgImage!, in: newRect)
        let newImage = UIImage(cgImage: (context?.makeImage()!)!)
        UIGraphicsEndImageContext()
        return newImage
    }
    
    class func vibrate() {
        if UIDevice.isSimulator {
            return
        }
        
        if Utilites.isVibrateEnabled() {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
    }
    
    class func isVibrateEnabled() -> Bool {
        let defaults = UserDefaults.standard
        if let isVibrate = defaults.object(forKey: Constants.UserDefaultsKeys.UseActionVibrations) as? Bool {
            return isVibrate
        }
        defaults.set(true, forKey: Constants.UserDefaultsKeys.UseActionVibrations)
        return true
    }
    
    class func isUseIcons() -> Bool {
        let defaults = UserDefaults.standard
        if let isUseIcons = defaults.object(forKey: Constants.UserDefaultsKeys.UseActionIcons) as? Bool {
            return isUseIcons
        }
        defaults.set(true, forKey: Constants.UserDefaultsKeys.UseActionIcons)
        return true
    }
    
    class func secondsToTimer(_ seconds: Int) -> String {
        if seconds < 60 {
            return NSString(format: ":%02d",seconds) as String
        } else {
            let minutes = seconds/60
            let sec = seconds - minutes * 60
        
            return NSString(format: "%02d:%02d", minutes, sec) as String
        }
        
    }
    
    class func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName )
            print("Font Names = [\(names)]")
        }
    }
    
    class func showWithAnimation(_ view: UIView) {
        view.alpha = 0
        UIView.animate(withDuration: 5.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    view.alpha = 1
        }, completion: nil)
    }

}


extension UIDevice {
    static var isSimulator: Bool {
        return ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
    }
}
