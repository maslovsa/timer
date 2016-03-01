//
//  TabataViewController.swift
//  Timer
//
//  Created by Maslov Sergey on 01.03.16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

class TabataViewController: TimerConfigViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timerStyle = .Tabata
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
