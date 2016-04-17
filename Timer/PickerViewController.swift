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
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(picker)
        picker.delegate = self
        picker.dataSource = self
        picker.showsSelectionIndicator = true
        self.view.addSubview(picker)
        picker.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
            make.height.equalTo(self.view).dividedBy(1.2)
            make.width.equalTo(self.view)
        }
        
        applyButton.layer.cornerRadius = 10
        applyButton.layer.masksToBounds = true
        applyButton.clipsToBounds = true
        applyButton.titleLabel!.font = Constants.Picker.FontSize
        applyButton.backgroundColor = Constants.HeaderCell.BlueFontColor
        applyButton.titleLabel?.textColor = UIColor.whiteColor()
        applyButton.setTitle("OK", forState: .Normal)
        applyButton.addTarget(self, action: #selector(PickerViewController.applyClicked(_:)), forControlEvents: .TouchDown)
        self.view.addSubview(applyButton)
        applyButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.bottom.equalTo(self.view).offset(-20)
            make.height.equalTo(44)
        }

        titleLabel.font = Constants.Picker.FontSize
        titleLabel.textAlignment = .Center
        titleLabel.textColor = Constants.HeaderCell.RedFontColor
        self.view.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.top.equalTo(self.view).offset(44)
            make.height.equalTo(44)
        }
        
        descriptionLabel.font = Constants.Picker.DescriptionFontSize
        descriptionLabel.textAlignment = .Center
        descriptionLabel.textColor = Constants.Picker.DescriptionFontColor
        self.view.addSubview(descriptionLabel)
        descriptionLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.top.equalTo(self.view).offset(44+44)
            make.height.equalTo(44)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if let preset = preset {
            titleLabel.text = preset.title
            descriptionLabel.text = preset.description
            
            switch preset.type {
            case .IntType(let unit):
               picker.selectRow(unit.value, inComponent: 0, animated: true)
            case .TimeType(let min, let sec ):
                picker.selectRow(min.value, inComponent: 0, animated: true)
                picker.selectRow(sec.value, inComponent: 1, animated: true)
            }
            
            
            
        }
    }
    
    func applyClicked(sender: AnyObject) {
        guard var preset = preset else {
            return
        }
        
        let indexFirst = picker.selectedRowInComponent(0)

        switch preset.type {
        case .IntType(let unit):
            preset.type = PresetType.IntType(unit: IntPreset(value: indexFirst, low: unit.low, high: unit.high))
            
        case .TimeType(let min, let sec ):
            let indexSecond = picker.selectedRowInComponent(1)

            let minPreset = IntPreset(value: indexFirst, low: min.low, high: min.high)
            let secPreset = IntPreset(value: indexSecond, low: sec.low, high: sec.high)
            
            preset.type = PresetType.TimeType(min: minPreset, sec: secPreset)
        }
        
        completion?(preset)
        self.dismissViewControllerAnimated(true, completion: nil)
   }
}

extension PickerViewController: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        guard let type = preset?.type else {
            return 1
        }
        switch type {
        case .IntType(_):
            return 1
        case .TimeType(_, _):
            return 2
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let type = preset?.type else {
            return 1
        }
        switch type {
        case .IntType(let unit):
            return unit.length
        case .TimeType(let min, let sec):
            if component == 0 {
                return min.length
            }
            return sec.length
        }
    }
    
    private func calculateValue(row: Int, component: Int) -> String {
        guard let type = preset?.type else {
            return "no value"
        }
        
        switch type {
        case .IntType(let unit):
            return "\(row + unit.low)"
        case .TimeType(let min, let sec):
            if component == 0 {
                return NSString(format: "%02d", row + min.low) as String
            }
            return NSString(format: "%02d", row + sec.low) as String
        }
    }
}

extension PickerViewController: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 33.0
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let value = calculateValue(row, component: component)
        pickerView.subviews[1].hidden = false
        pickerView.subviews[2].hidden = false
        pickerView.subviews[1].backgroundColor = Constants.HeaderCell.BlueFontColor
        pickerView.subviews[2].backgroundColor = Constants.HeaderCell.BlueFontColor
        pickerView.subviews[2].bounds = CGRect(x: 0, y:  0, width: pickerView.subviews[2].bounds.width, height: 1)
        
        
        if let view = view as? UILabel {
            view.text = value
            return view
        }
        
        let columnView = UILabel(frame: CGRectMake(350, 0, 150, 44))
        columnView.font = Constants.Picker.FontSize
        columnView.textColor = Constants.Picker.FontColor
        columnView.text = value
        columnView.textAlignment = NSTextAlignment.Center
        
        return columnView
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "!!!!"
    }

    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
}
