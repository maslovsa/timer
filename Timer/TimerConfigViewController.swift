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
            
            switch preset.type {
            case .IntType(let unit):
                cell.valueLabel.text = NSString(format: ":%.2d", unit.value) as String
                
            case .TimeType(let min, let sec):
                cell.valueLabel.text = NSString(format: "%.2d:%.2d", min.value, sec.value) as String
            }
            return cell
        }
        return cellRaw
    }
}

extension TimerConfigViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = PickerViewController()
        vc.preset = timer.presets[indexPath.row]
        vc.completion = { [weak self](newValue) -> Void in
            self?.timer.presets[indexPath.row] = newValue
            self?.tableView.reloadData()
        }
        self.presentViewController(vc, animated: true, completion: nil)
    }
}

