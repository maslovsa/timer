//
//  TimePickerView.swift
//  Timer
//
//  Created by Maslov Sergey on 02.03.16.
//  Copyright © 2016 Home. All rights reserved.
//
import UIKit

class TimePickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    var hour:Int = 0
    var minute:Int = 0
    
    init() {
        super.init(frame: CGRect.zero)
        self.setup()
    }
//    init() {
//        super.init()
//        self.setup()
//    }
    
    required internal init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup(){
        self.delegate = self
        self.dataSource = self
        
        let height = CGFloat(20)
        let offsetX = self.frame.size.width / 3
        let offsetY = self.frame.size.height/2 - height/2
        let marginX = CGFloat(42)
        let width = offsetX - marginX
        
        let hourLabel = UILabel(frame: CGRect(x: marginX, y: offsetY, width: width, height: height))
        hourLabel.text = "hour"
        self.addSubview(hourLabel)
        
        let minsLabel = UILabel(frame: CGRect(x: marginX + offsetX, y: offsetY, width: width, height: height))
        minsLabel.text = "min"
        self.addSubview(minsLabel)
    }
    
    func updatePicker() {
        
        if minute != 0 {
            self.selectRow(minute, inComponent: 0, animated: true)
        }

    }
    
    func getDate() -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: String(format: "%02d", self.hour) + ":" + String(format: "%02d", self.minute))
        return date!
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.hour = row
        case 1:
            self.minute = row
        default:
            print("No component with number \(component)")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 24
        }
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30 
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if let view = view as? UILabel {
            view.text = String(format:"%02lu", row)
            return view
        }
        let columnView = UILabel(frame: CGRect(x: 35, y: 0, width: self.frame.size.width/3 - 35, height: 30))
        columnView.text = String(format:"%02lu ", row)
        columnView.textAlignment = NSTextAlignment.center
        
        return columnView
    }
    //
//    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
//        if let view = view as? UILabel {
//            view.text = String(format:"%02lu", row)
//            return view
//        }
//        let columnView = UILabel(frame: CGRectMake(35, 0, self.frame.size.width/3 - 35, 30))
//        columnView.text = String(format:"%02lu", row)
//        columnView.textAlignment = NSTextAlignment.Center
//        
//        return columnView
//    }
    
}
