//
//  SecondViewController.swift
//  Timer
//
//  Created by Maslov Sergey on 01.03.16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

class AMRAPViewContoller: TimerConfigViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.timer = Timer.createAMRAP()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

