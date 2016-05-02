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
}

enum TimerState {
    case Prepare
    case Workout
}

class TimerModel: NSObject {
    let timerTickInterval = 0.5
    
    var timerConfig: TimerConfig
    var tickTimer: NSTimer? = nil
    var delegate: TimerModelProtocol?
    
    var isActive = false
    var isPaused = false
    var state = TimerState.Prepare
    
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

            if isActive {
                isActive = false
                isPaused = true
                
                delegate?.didStateChanged()
                tickTimer?.invalidate()
            } else {
                isActive = true
                isPaused = false
                
                delegate?.didStateChanged()
                restartTimer()
            }

            
        case .Tabata:
            print("stop")
            
        }
    }
    
    func reset() {
        
    }

    func restartTimer() {
        tickTimer?.invalidate()

        if !isPaused {
            //timerCoundownValue = state == .Prepare ? timerConfig.presets[0].seconds : timerConfig.presets[1].seconds
//            timerMaxValue = timerCoundownValue
        }
        
        


        tickTimer = NSTimer.scheduledTimerWithTimeInterval(timerTickInterval, target: self, selector: #selector(TimerModel.updateTime), userInfo: nil, repeats: true)

    }
    
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
                    self.delegate?.didTickTimer()
                    
                    
                }
    }
}