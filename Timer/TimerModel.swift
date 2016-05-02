//
//  TimerModel.swift
//  Timer
//
//  Created by Maslov Sergey on 02.05.16.
//  Copyright © 2016 Home. All rights reserved.
//

import Foundation

protocol TimerModelProtocol: class {
    func didStateChanged()
    func didTickTimer()
    //    func didSelectPostImage(cell:BaseCell)
    //    func didSelectUserProfile(cell:BaseCell, userProfile: UserProfile)
}

class TimerModel: NSObject {
    let timerTickInterval = 0.5
    
    var timerConfig: TimerConfig
    var tickTimer: NSTimer? = nil
    var delegate: TimerModelProtocol?
    
    var isActive = false
    var timerCoundownValue = 0.0
    var timerMaxValue = 1
    
    init(timerConfig: TimerConfig) {
        self.timerConfig = timerConfig
    }
    
    deinit {
        print("deinit TimerModel")
        
        tickTimer?.invalidate()
        tickTimer = nil
    }
    
    func startStop() {
        switch timerConfig.style {
        case .StopWatch, .AMRAP:

            if timerConfig.isActive {
                timerConfig.isActive = false
                tickTimer?.invalidate()
            } else {
                timerConfig.isActive = true

                //restartTimer()
            }

            
        case .Tabata:
            print("stop")
            
        }
    }
    
    func reset() {
        
    }

//    func restartTimer() {
//        tickTimer?.invalidate()
//
//        if timerCoundownValue == 0 {
//            timerCoundownValue = timerConfig.state == .Prepare ? timerConfig.presets[0].seconds : timerConfig.presets[1].seconds
//            timerMaxValue = timerCoundownValue
//        }
//
//        self.tickTimer = NSTimer.scheduledTimerWithTimeInterval(timerTickInterval, target: self, selector: #selector(TimerModel.updateTime), userInfo: nil, repeats: true)
//
//    }
    
    func updateTime() {
                dispatch_async(dispatch_get_main_queue()) {
        
                    if self.timerCoundownValue <= 0 {
                        self.tickTimer?.invalidate()
                        self.tickTimer = nil
        
//                        self.timerConfig.state = .Workout
//                        self.initWorkout()
//                        self.restartTimer()
                    }
                    self.timerCoundownValue -= self.timerTickInterval
        
                    
                    
                }
    }
}