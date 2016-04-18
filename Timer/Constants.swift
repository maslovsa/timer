//
//  Constants.swift
//  Pangea
//
//  Created by Maslov Sergey on 03.03.16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

struct Constants {
    struct Fonts {
        static let TimeSelectorFontSize = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        static let TimerCellTitleFontSize = UIFont.systemFontOfSize(14, weight: UIFontWeightSemibold)
        static let TimeLabelFontSize = UIFont.systemFontOfSize(44, weight: UIFontWeightSemibold)
        static let TimerCellValueFontSize = UIFont.systemFontOfSize(14, weight: UIFontWeightBold)
        static let TimerCellDescriptionFontSize = UIFont.systemFontOfSize(12, weight: UIFontWeightRegular)
    }
    
    struct Colors {
        static let TimerCellTitleFontColor = UIColor.blackColor()
        static let TimerCellValueFontColor = UIColor(red:127.0/255.0, green:199.0/255.0, blue:226.0/255.0, alpha:1.0)
        static let BlueThemeColor = UIColor(red:127.0/255.0, green:199.0/255.0, blue:226.0/255.0, alpha:1.0)
        //static let BlueThemeColor = UIColor(red:135.0/255.0, green:153.0/255.0, blue:189.0/255.0, alpha:1.0)
        static let TimerCellDescriptionFontColor = UIColor.darkGrayColor()
        static let RedFontColor = UIColor(red:213.0/255.0, green:34.0/255.0, blue:42.0/255.0, alpha:1.0)
    }
    
    struct Picker {
        static let FontSize = UIFont.systemFontOfSize(20, weight: UIFontWeightRegular)
        static let FontColor = UIColor.blackColor()
        
        static let DescriptionFontSize = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
        static let DescriptionFontColor = UIColor.grayColor()
    }
    
    struct CustomCell {
        static let Height: CGFloat = 40.0
    }
    
    struct UserDefaultsKeys {
        static let UseActionIcons = "UserDefaultsKeyUseActionIcons"
    }
    
}