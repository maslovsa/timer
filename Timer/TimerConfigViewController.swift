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
    lazy var timer = Timer.createStopWatch()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .None
        tableView.registerClass(TimerCell.self, forCellReuseIdentifier: TimerCellIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.topItem!.title = timer.title
        
        let button: UIButton = UIButton(type: UIButtonType.System)
        button.contentMode = .ScaleAspectFit
        button.tintColor = Constants.Colors.BlueThemeColor
        button.setImage(UIImage(named: "Exercise"), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(TimerConfigViewController.clickGo), forControlEvents: .TouchUpInside)
        button.frame = CGRectMake(0, 0, 44, 44)
        
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clickGo() {
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

