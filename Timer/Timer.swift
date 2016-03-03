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

class Timer {
    var presets = [Preset]()
    var style = TimerStyle.StopWatch
    var title = ""
    var prefCount: Int {
        return presets.count
    }
    
    class func createStopWatch() -> Timer{
        let timer = Timer()
        timer.title = "StopWatch"
        timer.style = TimerStyle.StopWatch
        timer.presets = [Preset.preparePreset(), Preset.timeCapPreset()]
        return timer
    }
    
    class func createAMRAP() -> Timer{
        let timer = Timer()
        timer.title = "AMRAP"
        timer.style = TimerStyle.AMRAP
        timer.presets = [Preset.preparePreset(), Preset.startTimePreset()]
        return timer
    }
    
    class func createTabata() -> Timer{
        let timer = Timer()
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