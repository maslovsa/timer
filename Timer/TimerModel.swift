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
    case reset
    case prepare
    case workout
    case finished
}

class TimerModel: NSObject {
    let timerTickInterval: Double = 0.5
    
    var timerConfig: TimerConfig
    var tickTimer: Foundation.Timer? = nil
    weak var delegate: TimerModelProtocol?
    
    var isActive = false
    var isPaused = false
    
    var state = TimerState.reset
    
    var countdownValue: Double = 0.0
    var countdownMaxValue: Double = 1.0
    
    fileprivate var tabataPresets = [TabataPreset]()
    fileprivate var tabataIndex = 0
    
    init(timerConfig: TimerConfig) {
        self.timerConfig = timerConfig
        if timerConfig.style == .tabata {
            self.tabataPresets = timerConfig.tabataPresets
        }
    }
    
    deinit {
        print("deinit TimerModel")
        
        tickTimer?.invalidate()
        tickTimer = nil
    }
    
    var secondsToShow: Double {
        if state == .prepare {
            return ceil(countdownValue)
        }
        
        switch timerConfig.style {
        case .stopWatch:
            return (countdownMaxValue - countdownValue)
        case .amrap:
            return (countdownValue)
        case .tabata:
            return (countdownValue)
        }
    }
    
    var informationString: String {
        if isPaused {
            return "paused"
        }
        switch self.state {
        case .prepare:
            return "prepare"
        case .reset:
            return ""
        case .workout:
            if timerConfig.style != .tabata {
                return timerConfig.title
            }
            return tabataPresets[tabataIndex].title
        case .finished:
            return "finished"
        }
    }
    
    var progressToShow: Double {
        if state == .prepare {
            return directSeconds
        }
        
        switch timerConfig.style {
        case .stopWatch:
            return unDirectSeconds
        case .amrap:
            return directSeconds
        case .tabata:
            return directSeconds
        }
    }
    
    var roundsValue: Int {
        guard timerConfig.style == .tabata else {
            return 0
        }
        let roundsValue = tabataPresets[tabataIndex].round
        let roundsMaxValue = timerConfig.presets[roundsIndex].value
        return roundsMaxValue - roundsValue + 1
    }

    var circleValue: Int {
        guard timerConfig.style == .tabata else {
            return 0
        }
        let circleValue = tabataPresets[tabataIndex].cycle
        let circleMaxValue = timerConfig.presets[cyclesIndex].value
        return circleMaxValue - circleValue + 1
    }
    
    var progressRoundsToShow: Double {
        guard timerConfig.style == .tabata else {
            return 0.0
        }
        let roundsValue = tabataPresets[tabataIndex].round
        let roundsMaxValue = timerConfig.presets[roundsIndex].value
        return degreesOnCircle * ( 1 - Double(roundsValue - 1) / Double(roundsMaxValue) )
    }

    var progressCyclesToShow: Double {
        guard timerConfig.style == .tabata else {
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
        if timerConfig.style != .tabata {
            return true
        } else {
            return tabataPresets[tabataIndex].isWork
        }
    }
    
    fileprivate var directSeconds: Double {
        return degreesOnCircle * ( countdownValue / countdownMaxValue )
    }
    
    fileprivate var unDirectSeconds: Double {
        return degreesOnCircle * ( 1 - countdownValue / countdownMaxValue )
    }
    
    func startStop() {
        if state == .reset {
            tabataIndex = 0
            state = .prepare
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
        state = .reset
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
            if timerConfig.style == .tabata {
                if state == .prepare {
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
                let seconds = state == .prepare ? timerConfig.presets[prepareIndex].value : timerConfig.presets[workIndex].value
                countdownMaxValue = Double(seconds)
                countdownValue = Double(seconds)
            }
        }
        
        tickTimer = Foundation.Timer.scheduledTimer(timeInterval: timerTickInterval, target: self, selector: #selector(TimerModel.updateTime), userInfo: nil, repeats: true)
    }
    
    func updateTime() {
        DispatchQueue.main.async {
            if self.countdownValue <= 0 {
                self.tickTimer?.invalidate()
                self.tickTimer = nil
            
                switch self.state {
                case .prepare, .reset:
                    print("Workout")
                    self.state = .workout
                    self.restartTimer()
                    self.delegate?.didStateChanged()
                case .workout:
                    if self.timerConfig.style != .tabata {
                        self.state = .finished
                        self.delegate?.didStateChanged()
                    } else {
                        self.tabataIndex += 1
                        
                        if self.tabataIndex < self.tabataPresets.count {
                            print(self.tabataPresets[self.tabataIndex].title)
                            self.restartTimer()
                            self.delegate?.didStateChanged()
                        } else {
                            self.state = .finished
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
