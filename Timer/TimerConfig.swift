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



class TimerConfig {
    var presets = [Preset]()
    var style = TimerStyle.StopWatch
    var title = ""
    
    var prefCount: Int {
        return presets.count
    }
    
    func getPreviewValue() -> Int {
        switch self.style {
        case .StopWatch:
        return presets[1].seconds
        case .AMRAP:
        return presets[1].seconds
        case .Tabata:
        return 0
        }
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