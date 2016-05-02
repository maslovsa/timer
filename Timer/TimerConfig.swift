//
//  Timer.swift
//  Timer
//
//  Created by Maslov Sergey on 03.03.16.
//  Copyright © 2016 Home. All rights reserved.
//

import Foundation

enum TimerStyle {
    case StopWatch
    case AMRAP
    case Tabata
}

enum TimerState {
    case Prepare
    case Workout
}

class TimerConfig {
    var presets = [Preset]()
    var style = TimerStyle.StopWatch
    var title = ""
    // 2remove
    var state = TimerState.Prepare
    var isActive = false
    
    var prefCount: Int {
        return presets.count
    }
    
    class func createStopWatch() -> TimerConfig{
        let timer = TimerConfig()
        timer.title = "StopWatch"
        timer.style = TimerStyle.StopWatch
        timer.presets = [Preset.preparePreset(), Preset.timeCapPreset()]
        return timer
    }
    
    class func createAMRAP() -> TimerConfig{
        let timer = TimerConfig()
        timer.title = "AMRAP"
        timer.style = TimerStyle.AMRAP
        timer.presets = [Preset.preparePreset(), Preset.startTimePreset()]
        return timer
    }
    
    class func createTabata() -> TimerConfig{
        let timer = TimerConfig()
        timer.title = "Tabata"
        timer.style = TimerStyle.Tabata
        timer.presets = [Preset.preparePreset(),
            Preset.workPreset(),
            Preset.restPreset(),
            Preset.roundsPreset(),
            Preset.cyclesPreset(),
            Preset.restBetweenCyclesPreset()
        ]
        return timer
    }
}