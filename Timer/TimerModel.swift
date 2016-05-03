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
    case Reset
    case Prepare
    case Workout
    case Finished
}

class TimerModel: NSObject {
    let timerTickInterval = 0.02
    
    var timerConfig: TimerConfig
    var tickTimer: NSTimer? = nil
    weak var delegate: TimerModelProtocol?
    
    var isActive = false
    var isPaused = false
    var state = TimerState.Reset
    
    var countdownValue = 0.0
    var countdownMaxValue = 1.0
    
    var roundsValue = 0
    var roundsMaxValue = 1
    
    var circleValue = 0
    var circleMaxValue = 1
    
    init(timerConfig: TimerConfig) {
        self.timerConfig = timerConfig
    }
    
    deinit {
        print("deinit TimerModel")
        
        tickTimer?.invalidate()
        tickTimer = nil
    }
    
    var secondsToShow: Double {
        if state == .Prepare {
            return ceil(countdownValue)
        }
        
        switch timerConfig.style {
        case .StopWatch:
            return (countdownMaxValue - countdownValue)
        case .AMRAP:
            return (countdownValue)
        case .Tabata:
            return countdownValue
        }
    }
    
    var informationString: String {
        if isPaused {
            return "paused"
        }
        switch self.state {
        case .Prepare:
            return "prepare"
        case .Reset:
            return "ready?"
        case .Workout:
            return timerConfig.title
        case .Finished:
            return "finished"
        }
    }
    
    var progressToShow: Double {
        if state == .Prepare {
            return directSeconds
        }
        
        switch timerConfig.style {
        case .StopWatch:
            return unDirectSeconds
        case .AMRAP:
            return directSeconds
        case .Tabata:
            return directSeconds
        }
    }
    
    var progressRoundsToShow: Double {
        return 360 * ( Double(roundsValue) / Double(roundsMaxValue) )
    }

    
    var isCriticalTimer: Bool {
        return countdownValue / countdownMaxValue < 0.25
    }
    
    private var directSeconds: Double {
        return 360 * ( countdownValue / countdownMaxValue )
    }
    
    private var unDirectSeconds: Double {
        return 360 * ( 1 - countdownValue / countdownMaxValue )
    }
    
    func startStop() {
        if state == .Reset {
            state = .Prepare
            delegate?.didStateChanged()
        }
        
        if isActive {
            isActive = false
            isPaused = true
            
            tickTimer?.invalidate()
        } else {
            isActive = true
            
            restartTimer()
            isPaused = false
        }

        delegate?.didActivityChanged()
    }
    
    func reset() {
        isActive = false
        isPaused = false
        state = .Reset
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
            countdownMaxValue = Double(seconds)
            countdownValue = Double(seconds)
        }
        tickTimer = NSTimer.scheduledTimerWithTimeInterval(timerTickInterval, target: self, selector: #selector(TimerModel.updateTime), userInfo: nil, repeats: true)
    }
    
    func updateTime() {
        dispatch_async(dispatch_get_main_queue()) {
            if self.countdownValue <= 0 {
                self.tickTimer?.invalidate()
                self.tickTimer = nil
            
                switch self.state {
                case .Prepare, .Reset:
                    self.state = .Workout
                    self.restartTimer()
                    self.delegate?.didStateChanged()
                case .Workout:
                    self.state = .Finished
                    self.delegate?.didStateChanged()
                default:
                    break
                }
                
                return
            }
            self.countdownValue -= self.timerTickInterval
            self.delegate?.didTickTimer()
        }
    }
}