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
    func didActivityChanged()
    func didTickTimer()
}

enum TimerState {
    case Prepare
    case Workout
}

class TimerModel: NSObject {
    let timerTickInterval = 0.02
    
    var timerConfig: TimerConfig
    var tickTimer: NSTimer? = nil
    weak var delegate: TimerModelProtocol?
    
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
                
                tickTimer?.invalidate()
            } else {
                isActive = true
                
                restartTimer()
                isPaused = false
            }

            
        case .Tabata:
            print("stop")
            
        }
        
        
        delegate?.didActivityChanged()

    }
    
    func reset() {
        isActive = false
        isPaused = false
        state = .Prepare
        tickTimer?.invalidate()
        delegate?.didStateChanged()
    }
    
    func stopTimer() {
        tickTimer?.invalidate()
        tickTimer = nil
    }
    
    func restartTimer() {
        tickTimer?.invalidate()

        if !isPaused {
            let seconds = state == .Prepare ? timerConfig.presets[0].seconds : timerConfig.presets[1].seconds
            timerMaxValue = seconds
            timerCoundownValue = Double(seconds)
        }
        tickTimer = NSTimer.scheduledTimerWithTimeInterval(timerTickInterval, target: self, selector: #selector(TimerModel.updateTime), userInfo: nil, repeats: true)
    }
    
    func updateTime() {
                dispatch_async(dispatch_get_main_queue()) {
        
                    if self.timerCoundownValue <= 0 {
                        self.tickTimer?.invalidate()
                        self.tickTimer = nil
        
                        self.state = .Workout
                        self.delegate?.didStateChanged()
                        self.restartTimer()
                    }
                    self.timerCoundownValue -= self.timerTickInterval
                    self.delegate?.didTickTimer()
                    
                    
                }
    }
}