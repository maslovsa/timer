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

let prepareIndex = 0
let workIndex = 1
let restIndex = 2
let roundsIndex = 3
let cyclesIndex = 4
let restBetweenIndex = 5

struct TabataPreset {
    var isWork = true
    var title = ""
    var seconds = 0
    var round = 0
    var cycle = 0
}

class TimerConfig {
    
    var presets = [Preset]()
    var style = TimerStyle.StopWatch
    var title = ""
    
    
    var tabataPresets: [TabataPreset] {
        var result = [TabataPreset]()
        if self.style != .Tabata {
            return result
        }
        
        let maxCycle = presets[cyclesIndex].value
        for cycleIndex in 1...maxCycle {
            let maxRound = presets[roundsIndex].value
            for roundIndex in 1...maxRound {
                let presetWork = TabataPreset(isWork: true, title: "Work", seconds: presets[workIndex].value, round: roundIndex, cycle: cycleIndex)
                result.append(presetWork)
                
                let presetRest = TabataPreset(isWork: false, title: "Rest", seconds: presets[restIndex].value, round: roundIndex, cycle: cycleIndex)
                result.append(presetRest)
                
            }
            if cycleIndex != maxCycle {
                let presetRecovery = TabataPreset(isWork: false, title: "Recovery", seconds: presets[restBetweenIndex].value, round: maxRound, cycle: cycleIndex)
                result.append(presetRecovery)
            }
        }
        return result
    }
    
    var prefCount: Int {
        return presets.count
    }
    
    func getPreviewValue() -> Int {
        switch self.style {
        case .StopWatch:
        return presets[workIndex].value
        case .AMRAP:
        return presets[workIndex].value
        case .Tabata: // (W+R)*Rounds*Cycles + (Cycles-1)*RestBetween
            let totalWork = (presets[workIndex].value + presets[restIndex].value) * (presets[roundsIndex].value) * (presets[cyclesIndex].value)
            return totalWork + (presets[cyclesIndex].value - 1) * presets[restBetweenIndex].value
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