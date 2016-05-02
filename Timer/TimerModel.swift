//
//  TimerModel.swift
//  Timer
//
//  Created by Maslov Sergey on 02.05.16.
//  Copyright © 2016 Home. All rights reserved.
//

import Foundation

class TimerModel: NSObject {
    var timer: TimerConfig
    var tickTimer: NSTimer? = nil
    
    init(timer: TimerConfig) {
        self.timer = timer
    }
    
    deinit {
        print("deinit TimerModel")
    }
}