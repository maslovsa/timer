//
//  TimerConfigViewController.swift
//  Timer
//
//  Created by Maslov Sergey on 01.03.16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit


class TimerConfigViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var timer = Timer.createStopWatch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let nib = UINib(nibName: kMyCell, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: kMyCell)
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.topItem!.title = timer.title
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension TimerConfigViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timer.prefCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellRaw = tableView.dequeueReusableCellWithIdentifier(kMyCell, forIndexPath: indexPath)
        if let cell = cellRaw as? MyCell {
            let preset = timer.presets[indexPath.row]
            cell.titleLabel.text = preset.title
            cell.descriptionLabel.text = preset.description
            let value = preset.value ?? preset.defaultValue
            cell.valueLabel.text = ":\(value)"
            return cell
        }
        return cellRaw
    }
}

extension TimerConfigViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PickerViewController") as! PickerViewController
        vc.preset = timer.presets[indexPath.row]
        self.presentViewController(vc, animated: true, completion: nil)
    }
}

extension TimerConfigViewController: PickerProtocol {
    func valueApplied(value: String) {
        
    }
}

