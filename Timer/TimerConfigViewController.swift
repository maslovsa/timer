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

        tableView.separatorStyle = .None
        tableView.registerClass(TimerCell.self, forCellReuseIdentifier: TimerCellIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.topItem!.title = timer.title
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start", style: .Plain, target: self, action: #selector(TimerConfigViewController.addTapped))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTapped(){
        
        let controller =  UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CoundownViewController") as! CoundownViewController
        controller.modalTransitionStyle = .CrossDissolve
        controller.timer = timer
        self.presentViewController(controller, animated: true, completion: nil)
    }
}

extension TimerConfigViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timer.prefCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TimerCellIdentifier, forIndexPath: indexPath) as! TimerCell
        let preset = timer.presets[indexPath.row]
        cell.configure(preset)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54.0
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

