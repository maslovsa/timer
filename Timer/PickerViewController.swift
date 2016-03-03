//
//  PickerViewController.swift
//  Timer
//
//  Created by Maslov Sergey on 01.03.16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

protocol PickerProtocol {
    func valueApplied(string: String)
}

class PickerViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var dateTimePicker: TimePickerView!

    var delegate : PickerProtocol?
    var preset: Preset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if let preset = preset {
            let value = preset.value ?? preset.defaultValue
            let showIDasInt = NSNumberFormatter().numberFromString(value) ?? 0
            dateTimePicker.minute = showIDasInt.integerValue
            dateTimePicker.updatePicker()
        }
    }
    
    @IBAction func datePickerChanged(sender: AnyObject) {
    
    }

    @IBAction func applyClicked(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let strDate = dateFormatter.stringFromDate(dateTimePicker.getDate())

        delegate?.valueApplied(strDate)
        self.dismissViewControllerAnimated(true, completion: nil)
   }
    
}
