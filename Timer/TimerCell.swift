//
//  TimerCell.swift
//  Timer
//
//  Created by Maslov Sergey on 17.04.16.
//  Copyright © 2016 Home. All rights reserved.
//


import UIKit

let TimerCellIdentifier = "TimerCellIdentifier"

protocol TimerCellProtocol: class {
    //    func didSelectPostImage(cell:BaseCell)
    //    func didSelectUserProfile(cell:BaseCell, userProfile: UserProfile)
}

class TimerCell: UITableViewCell {
    let leftOffset = 10
    let topOffset = 8
    let imageIconSize = 30
    
    
    var isLast: Bool = false {
        didSet {
            self.onePixelLineBottom.hidden = true
        }
    }
    lazy var labelTitle = UILabel()
    lazy var labelDescription = UILabel()
    lazy var labelValue = UILabel()
    lazy var imageViewIcon = UIImageView()
    
    lazy var onePixelLineBottom = UIView()
    
    var preset: Preset?
    weak var delegate: TimerCellProtocol?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        localInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        localInit()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.localInit()
    }
    
    func localInit() {
        
        
        self.backgroundColor = UIColor.whiteColor()
        
        onePixelLineBottom.backgroundColor = UIColor.lightGrayColor()
        
        self.addSubview(onePixelLineBottom)
        onePixelLineBottom.snp_makeConstraints {
            (make) -> Void in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(self).offset(0)
            make.height.equalTo(1)
        }
        
        labelTitle.textColor = Constants.Colors.TimerCellTitleFontColor
        labelTitle.font = Constants.Fonts.TimerCellTitleFontSize
        labelTitle.textAlignment = .Left
        self.addSubview(labelTitle)
        labelTitle.snp_makeConstraints {
            (make) -> Void in
            make.left.equalTo(self).offset(Utilites.isUseIcons() ? 2*leftOffset + imageIconSize: leftOffset)
            make.top.equalTo(self).offset(topOffset)
            make.width.equalTo(200)
            make.height.equalTo(20)
        }

        labelDescription.textColor = Constants.Colors.TimerCellDescriptionFontColor
        labelDescription.font = Constants.Fonts.TimerCellDescriptionFontSize
        labelDescription.textAlignment = .Left
        self.addSubview(labelDescription)
        labelDescription.snp_makeConstraints {
            (make) -> Void in
            make.left.equalTo(self).offset(Utilites.isUseIcons() ? 2*leftOffset + imageIconSize : leftOffset)
            make.bottom.equalTo(self).offset(-topOffset)
            make.width.equalTo(200)
            make.height.equalTo(20)
        }
        
        labelValue.textColor = Constants.Colors.BlueThemeColor
        labelValue.font = Constants.Fonts.TimerCellValueFontSize
        labelValue.textAlignment = .Right
        self.addSubview(labelValue)
        labelValue.snp_makeConstraints {
            (make) -> Void in
            make.right.equalTo(self).offset(-30)
            make.centerY.equalTo(self)
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
        
        imageViewIcon.tintColor = Constants.Colors.BlueThemeColor
        imageViewIcon.contentMode = .ScaleAspectFit
        self.addSubview(imageViewIcon)
        imageViewIcon.snp_makeConstraints {
            (make) -> Void in
            make.left.equalTo(self).offset(leftOffset)
            make.centerY.equalTo(self)
            make.width.equalTo(imageIconSize)
            make.height.equalTo(imageIconSize)
        }
        
    }
    
    func configure(preset: Preset) {
        self.preset = preset
        self.accessoryType = .DisclosureIndicator
        labelTitle.text = preset.title
        labelDescription.text = preset.description
        
        switch preset.type {
        case .IntType(let unit):
            labelValue.text = NSString(format: ":%.2d", unit.value) as String
            
        case .TimeType(let min, let sec):
            labelValue.text = NSString(format: "%.2d:%.2d", min.value, sec.value) as String
        }
        
        let useIcons = Utilites.isUseIcons()
        
        if useIcons {
            if let imageName = preset.image, let image = UIImage(named: imageName) {
                imageViewIcon.image = image.imageWithRenderingMode(.AlwaysTemplate)
            }
        }
        imageViewIcon.hidden = !useIcons
            
        labelTitle.snp_updateConstraints {
            (make) in
            make.left.equalTo(self).offset(useIcons ? 2*leftOffset + imageIconSize: leftOffset)
        }
        labelDescription.snp_updateConstraints {
            (make) in
            make.left.equalTo(self).offset(useIcons ? 2*leftOffset + imageIconSize: leftOffset)
        }
    }
}

