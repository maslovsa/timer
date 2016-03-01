//
//  TimerConfigViewController.swift
//  Timer
//
//  Created by Maslov Sergey on 01.03.16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

enum TimerStyle {
    case StopWatch
    case AMRAP
    case Tabata
}

class TimerConfigViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var timerStyle = TimerStyle.StopWatch
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let nib = UINib(nibName: kMyCell, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: kMyCell)
    }
    
    override func viewWillAppear(animated: Bool) {
        var title = String()
        switch timerStyle {
        case .StopWatch :
            title = "StopWatch"
        case .AMRAP:
            title = "AMRAP"
        case .Tabata:
            title = "Tabata"
        }
        navigationController?.navigationBar.topItem!.title = title
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension TimerConfigViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch timerStyle {
        case .StopWatch, .AMRAP:
            return 2
        case .Tabata:
            return 5
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellRaw = tableView.dequeueReusableCellWithIdentifier(kMyCell, forIndexPath: indexPath)
        if let cell = cellRaw as? MyCell {
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "Prepare"
                cell.descriptionLabel.text = "Countdown before you start"
                cell.valueLabel.text = ":00"

            case 1:
                cell.titleLabel.text = "Time Cap"
                cell.descriptionLabel.text = "Clock will stop at this time"
                cell.valueLabel.text = ":00"
                
            default:
                cell.titleLabel.text = "TITLE"
                cell.descriptionLabel.text = "DESCRIPTION"
                cell.valueLabel.text = "00:00"

                
            }
            return cell
        }
        
        
        return cellRaw
    }
}

extension TimerConfigViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.bounds = self.view.frame
        datePickerView.datePickerMode = UIDatePickerMode.Time
        datePickerView.locale = NSLocale(localeIdentifier: "da_DK")
        
        //sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
    }
}

