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
    let timerTickInterval: Double = 0.5
    
    var timerConfig: TimerConfig
    var tickTimer: NSTimer? = nil
    weak var delegate: TimerModelProtocol?
    
    var isActive = false
    var isPaused = false
    
    var state = TimerState.Reset
    
    var countdownValue: Double = 0.0
    var countdownMaxValue: Double = 1.0
    
    private var tabataPresets = [TabataPreset]()
    private var tabataIndex = 0
    
    init(timerConfig: TimerConfig) {
        self.timerConfig = timerConfig
        if timerConfig.style == .Tabata {
            self.tabataPresets = timerConfig.tabataPresets
        }
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
            return (countdownValue)
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
            return ""
        case .Workout:
            if timerConfig.style != .Tabata {
                return timerConfig.title
            }
            return tabataPresets[tabataIndex].title
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
    
    var roundsValue: Int {
        guard timerConfig.style == .Tabata else {
            return 0
        }
        let roundsValue = tabataPresets[tabataIndex].round
        let roundsMaxValue = timerConfig.presets[roundsIndex].value
        return roundsMaxValue - roundsValue + 1
    }

    var circleValue: Int {
        guard timerConfig.style == .Tabata else {
            return 0
        }
        let circleValue = tabataPresets[tabataIndex].cycle
        let circleMaxValue = timerConfig.presets[cyclesIndex].value
        return circleMaxValue - circleValue + 1
    }
    
    var progressRoundsToShow: Double {
        guard timerConfig.style == .Tabata else {
            return 0.0
        }
        let roundsValue = tabataPresets[tabataIndex].round
        let roundsMaxValue = timerConfig.presets[roundsIndex].value
        return degreesOnCircle * ( 1 - Double(roundsValue - 1) / Double(roundsMaxValue) )
    }

    var progressCyclesToShow: Double {
        guard timerConfig.style == .Tabata else {
            return 0.0
        }
        let circleValue = tabataPresets[tabataIndex].cycle
        let circleMaxValue = timerConfig.presets[cyclesIndex].value
        return degreesOnCircle * ( 1 - Double(circleValue - 1) / Double(circleMaxValue) )
    }
    
    var isCriticalTimer: Bool {
        return countdownValue / countdownMaxValue < 0.25
    }
    
    var isWork: Bool {
        if timerConfig.style != .Tabata {
            return true
        } else {
            return tabataPresets[tabataIndex].isWork
        }
    }
    
    private var directSeconds: Double {
        return degreesOnCircle * ( countdownValue / countdownMaxValue )
    }
    
    private var unDirectSeconds: Double {
        return degreesOnCircle * ( 1 - countdownValue / countdownMaxValue )
    }
    
    func startStop() {
        if state == .Reset {
            tabataIndex = 0
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
        print("Reset")
        isActive = false
        isPaused = false
        state = .Reset
        tabataIndex = 0
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
            if timerConfig.style == .Tabata {
                if state == .Prepare {
                    let seconds = timerConfig.presets[prepareIndex].value
                    countdownMaxValue = Double(seconds)
                    countdownValue = Double(seconds)
                } else {
                    let tabataPreset = tabataPresets[tabataIndex]
                    print("set timer \(tabataPreset.title) - \(tabataPreset.seconds)")
                    countdownMaxValue = Double(tabataPreset.seconds)
                    countdownValue = Double(tabataPreset.seconds)
                }
            } else {
                let seconds = state == .Prepare ? timerConfig.presets[prepareIndex].value : timerConfig.presets[workIndex].value
                countdownMaxValue = Double(seconds)
                countdownValue = Double(seconds)
            }
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
                    print("Workout")
                    self.state = .Workout
                    self.restartTimer()
                    self.delegate?.didStateChanged()
                case .Workout:
                    if self.timerConfig.style != .Tabata {
                        self.state = .Finished
                        self.delegate?.didStateChanged()
                    } else {
                        self.tabataIndex += 1
                        
                        if self.tabataIndex < self.tabataPresets.count {
                            print(self.tabataPresets[self.tabataIndex].title)
                            self.restartTimer()
                            self.delegate?.didStateChanged()
                        } else {
                            self.state = .Finished
                            self.delegate?.didStateChanged()
                        }
                    }
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