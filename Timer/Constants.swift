//
//  Constants.swift
//  Pangea
//
//  Created by Maslov Sergey on 03.03.16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

let squareFont = "SquareSansSerif7"
let digitalFont = "Digital-7"
let trsFont = "TRSMillion-Regular"
let digiFont = "DS-Digital-Bold"

let degreesOnCircle = 360.0

struct Constants {
    struct Fonts {
        static let TimeSelectorFontSize = UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular)
        static let TimerCellTitleFontSize = UIFont.systemFont(ofSize: 16, weight: UIFontWeightSemibold)
        
        
        static let TimeLabelFontSize = UIFont.monospacedDigitSystemFont(ofSize: 85, weight: UIFontWeightRegular)
        static let RoundsLabelFontSize = UIFont.monospacedDigitSystemFont(ofSize: 40, weight: UIFontWeightRegular)
        
        
        //static let TimeLabelFontSize =  UIFont(name: digiFont, size: 66) ?? UIFont.systemFontOfSize(66, weight: UIFontWeightMedium)

        static let TimeLabelInfoFontSize = UIFont.systemFont(ofSize: 35, weight: UIFontWeightMedium)
        
        static let ClockLabelFontSize =  UIFont.systemFont(ofSize: 35, weight: UIFontWeightMedium)
        
        static let TimerCellValueFontSize = UIFont.systemFont(ofSize: 20, weight: UIFontWeightBold)
        static let TimerCellDescriptionFontSize = UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular)
    }
    
    struct Colors {
        static let TimerCellTitleFontColor = UIColor.black
        static let TimerCellValueFontColor = UIColor(red:127.0/255.0, green:199.0/255.0, blue:226.0/255.0, alpha:1.0)
        static let MainThemeColor = UIColor(red:0.310, green:0.525, blue:0.969, alpha:1.0)
            ///UIColor.purpleColor()
        //static let BlueThemeColor = UIColor(red:127.0/255.0, green:199.0/255.0, blue:226.0/255.0, alpha:1.0)
        //static let BlueThemeColor = UIColor(red:135.0/255.0, green:153.0/255.0, blue:189.0/255.0, alpha:1.0)
        static let TimerCellDescriptionFontColor = UIColor.darkGray
        static let RedFontColor = UIColor(red:213.0/255.0, green:34.0/255.0, blue:42.0/255.0, alpha:1.0)
    }
    
    struct Picker {
        static let FontSize = UIFont.systemFont(ofSize: 30, weight: UIFontWeightRegular)
        static let TitleFontSize = UIFont.systemFont(ofSize: 25, weight: UIFontWeightRegular)
        static let FontColor = UIColor.black
        
        static let DescriptionFontSize = UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)
        static let DescriptionFontColor = UIColor.gray
    }
    
    struct CustomCell {
        static let Height: CGFloat = 40.0
    }
    
    struct UserDefaultsKeys {
        static let UseActionIcons = "UserDefaultsKeyUseActionIcons"
        static let UseActionVibrations = "UseActionVibrations"
    }
    
}
