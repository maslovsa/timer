//
//  FirstViewController.swift
//  Timer
//
//  Created by Maslov Sergey on 01.03.16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

class StopWatchViewController: TimerConfigViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.timerStyle = .StopWatch
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

