//
//  Constants.swift
//  Pangea
//
//  Created by Maslov Sergey on 03.03.16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

struct Constants {
    //MARK: - normal constants
    struct Fonts {
        struct Notifications {
            static let TextCellFontSize = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
            static let NameCellFontSize = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
        }
    }
    
    struct Picker {
        static let FontSize = UIFont.systemFontOfSize(20, weight: UIFontWeightBold)
        static let FontColor = UIColor.blackColor()
        //static let NotificationsTitlesColor = UIColor(red:204.0/255.0, green:0.0/255.0, blue:0.0/255.0, alpha:0.2)
    }
    
    struct CustomCell {
        static let Height: CGFloat = 40.0
    }
    
    struct HeaderCell {

        static let NewNotificationFontSize = UIFont.systemFontOfSize(17, weight: UIFontWeightBold)
        static let RedFontColor = UIColor(red:213.0/255.0, green:34.0/255.0, blue:42.0/255.0, alpha:1.0)
        static let BlueFontColor = UIColor(red:127.0/255.0, green:199.0/255.0, blue:226.0/255.0, alpha:1.0)

        // 127, 199, 226 - blue
        static let NewNotificationCounterFontSize = UIFont.systemFontOfSize(17, weight: UIFontWeightBold)
//        static let NewNotificationCounterFontColor = UIColor(red:85.0/255.0, green:85.0/255.0, blue:85.0/255.0, alpha:1.0)
        static let NewNotificationCounterFontColor = UIColor(red:230.0/255.0, green:0.0/255.0, blue:28.0/255.0, alpha:1.0)
        
        static let Height: CGFloat = 48.0
        static let TitleOffset: CGFloat = 10.0

        static let BackgroundColor = UIColor(red:238.0/255.0, green:238.0/255.0, blue:238.0/255.0, alpha:0.2)
        static let PixelColor = UIColor(red:204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0)

    }
}