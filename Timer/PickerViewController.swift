//
//  PickerViewController.swift
//  Timer
//
//  Created by Maslov Sergey on 01.03.16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import SnapKit

typealias completionHandler =  (String) -> Void

class PickerViewController: UIViewController {
    var titleLabel = UILabel()
    var descriptionLabel = UILabel()
    
    var applyButton = UIButton()
    var picker = UIPickerView()

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
        applyButton.addTarget(self, action: "applyClicked:", forControlEvents: .TouchDown)
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
            if let value = preset.value {
                if let i = Int(value) {
                    picker.selectRow(i, inComponent: 0, animated: true)
                }
            }
        }
    }
    
    func applyClicked(sender: AnyObject) {
        let index = picker.selectedRowInComponent(0)
        completion?(String(index))
        self.dismissViewControllerAnimated(true, completion: nil)
   }
}

extension PickerViewController: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if let highLimit = preset?.highLimit, let lowLimit = preset?.lowLimit {
            if let high = Int(highLimit), let low = Int(lowLimit){
                return high - low + 1
            }
        }
        return 0
    }
    
}

extension PickerViewController: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 33.0
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var value = ""
        if let highLimit = preset?.highLimit, let lowLimit = preset?.lowLimit {
            if let high = Int(highLimit), let low = Int(lowLimit){
                let lowFixed = low ?? 0
                value = "\(row + lowFixed)"
            }
        }
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
        return "sdfsdfdsf"
    }

    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
    

}
