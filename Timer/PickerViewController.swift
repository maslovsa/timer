//
//  PickerViewController.swift
//  Timer
//
//  Created by Maslov Sergey on 01.03.16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import SnapKit

typealias completionHandler =  (Preset) -> Void

class PickerViewController: UIViewController {
    let titleLabelVerticalOffset = 22
    let titleHeight = 22
    let defaultOffset = 22
    
    let verticalCorrection = -1
    let unitsHeight = 30
    let unitsWidth = 60
    
    lazy var titleLabel = UILabel()
    lazy var descriptionLabel = UILabel()
    
    lazy var firstLabel = UILabel()
    lazy var secondLabel = UILabel()
    
    
    lazy var applyButton = UIButton()
    lazy var picker = UIPickerView()

    var preset: Preset?
    var completion: completionHandler? = nil
    
    var isTimePicker = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(picker)
        picker.delegate = self
        picker.dataSource = self
        picker.showsSelectionIndicator = true
        self.view.addSubview(picker)
        picker.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
            make.height.equalTo(self.view).dividedBy(1.2)
            make.width.equalTo(self.view)
        }
        
        applyButton.layer.cornerRadius = 10
        applyButton.layer.masksToBounds = true
        applyButton.clipsToBounds = true
        applyButton.titleLabel!.font = Constants.Picker.TitleFontSize
        applyButton.backgroundColor = Constants.Colors.MainThemeColor
        applyButton.titleLabel?.textColor = UIColor.white
        applyButton.setTitle("OK", for: UIControlState())
        applyButton.addTarget(self, action: #selector(PickerViewController.applyClicked(_:)), for: .touchDown)
        self.view.addSubview(applyButton)
        applyButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(defaultOffset)
            make.right.equalTo(self.view).offset(-defaultOffset)
            make.bottom.equalTo(self.view).offset(-defaultOffset)
            make.height.equalTo(44)
        }

        titleLabel.font = Constants.Picker.FontSize
        titleLabel.textAlignment = .center
        titleLabel.textColor = Constants.Picker.FontColor
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(defaultOffset)
            make.right.equalTo(self.view).offset(-defaultOffset)
            make.top.equalTo(self.view).offset(titleLabelVerticalOffset)
            make.height.equalTo(titleHeight)
        }
        
        descriptionLabel.font = Constants.Picker.DescriptionFontSize
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = Constants.Picker.DescriptionFontColor
        self.view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(defaultOffset)
            make.right.equalTo(self.view).offset(-defaultOffset)
            make.top.equalTo(self.view).offset(titleLabelVerticalOffset + titleHeight)
            make.height.equalTo(titleHeight)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let preset = preset {
            titleLabel.text = preset.title
            descriptionLabel.text = preset.description
            
            switch preset.type {
            case .intType(let unit):
                picker.selectRow(unit.valueForRow, inComponent: 0, animated: true)
                
                self.view.addSubview(firstLabel)
                
                firstLabel.backgroundColor = UIColor.clear
                firstLabel.text = preset.units
                firstLabel.font = Constants.Picker.TitleFontSize
                firstLabel.textAlignment = .left
                firstLabel.textColor = Constants.Colors.MainThemeColor
                firstLabel.snp.makeConstraints { (make) -> Void in
                    make.centerX.equalTo(self.view).offset(50)
                    make.centerY.equalTo(self.view).offset(verticalCorrection)
                    make.height.equalTo(unitsHeight)
                    make.width.equalTo(unitsWidth)
                }
                
            case .timeType(let min, let sec ):
                picker.selectRow(min.valueForRow, inComponent: 0, animated: true)
                picker.selectRow(sec.valueForRow, inComponent: 1, animated: true)
                
                self.view.addSubview(firstLabel)
                firstLabel.backgroundColor = UIColor.clear
                firstLabel.text = "min"
                firstLabel.font = Constants.Picker.TitleFontSize
                firstLabel.textAlignment = .left
                firstLabel.textColor = Constants.Colors.MainThemeColor
                firstLabel.snp.makeConstraints { (make) -> Void in
                    make.centerX.equalTo(self.view).offset(0)
                    make.centerY.equalTo(self.view).offset(verticalCorrection)
                    make.height.equalTo(unitsHeight)
                    make.width.equalTo(unitsWidth)
                }
                
                self.view.addSubview(secondLabel)
                secondLabel.backgroundColor = UIColor.clear
                secondLabel.text = "sec"
                secondLabel.font = Constants.Picker.TitleFontSize
                secondLabel.textAlignment = .left
                secondLabel.textColor = Constants.Colors.MainThemeColor
                secondLabel.snp.makeConstraints { (make) -> Void in
                    make.centerX.equalTo(self.view).offset(110)
                    make.centerY.equalTo(self.view).offset(verticalCorrection)
                    make.height.equalTo(unitsHeight)
                    make.width.equalTo(unitsWidth)
                }
            }
        }
    }
    
    func applyClicked(_ sender: AnyObject) {
        guard var preset = preset else {
            return
        }
        
        let indexFirst = picker.selectedRow(inComponent: 0)

        switch preset.type {
        case .intType(let unit):
            preset.type = PresetType.intType(unit: IntPreset(value: indexFirst + unit.low, low: unit.low, high: unit.high))
            
        case .timeType(let min, let sec ):
            let indexSecond = picker.selectedRow(inComponent: 1)

            let minPreset = IntPreset(value: indexFirst + min.low, low: min.low, high: min.high)
            let secPreset = IntPreset(value: indexSecond + sec.low, low: sec.low, high: sec.high)
            
            preset.type = PresetType.timeType(min: minPreset, sec: secPreset)
        }
        
        completion?(preset)
        self.dismiss(animated: true, completion: nil)
   }
}

extension PickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard let type = preset?.type else {
            return 1
        }
        switch type {
        case .intType(_):
            return 1
        case .timeType(_, _):
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let type = preset?.type else {
            return 1
        }
        switch type {
        case .intType(let unit):
            return unit.length
        case .timeType(let min, let sec):
            if component == 0 {
                return min.length
            }
            return sec.length
        }
    }
    
    fileprivate func calculateValue(_ row: Int, component: Int) -> String {
        guard let type = preset?.type else {
            return "no value"
        }
        switch type {
        case .intType(let unit):
            return "\(row + unit.low)"
        case .timeType(let min, let sec):
            if component == 0 {
                return NSString(format: "%02d", row + min.low) as String
            }
            return NSString(format: "%02d", row + sec.low) as String
        }
    }
}

extension PickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let value = calculateValue(row, component: component)
        pickerView.subviews[1].isHidden = false
        pickerView.subviews[2].isHidden = false
        pickerView.subviews[1].backgroundColor = Constants.Colors.MainThemeColor
        pickerView.subviews[2].backgroundColor = Constants.Colors.MainThemeColor
        
        pickerView.subviews[1].bounds = CGRect(x: 0, y:  0, width: pickerView.subviews[2].bounds.width, height: 1)
        pickerView.subviews[2].bounds = CGRect(x: 0, y:  0, width: pickerView.subviews[2].bounds.width, height: 1)
        
        
        if let view = view as? UILabel {
            view.text = value
            return view
        }
        
        let columnView = UILabel(frame: CGRect(x: 150, y: 0, width: 150, height: 50))
        columnView.font = Constants.Picker.FontSize
        columnView.textColor = Constants.Picker.FontColor
        columnView.text = value
        columnView.textAlignment = NSTextAlignment.center
        
        return columnView
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "!!!!"
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100.0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
}
