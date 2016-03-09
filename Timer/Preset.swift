//
//  Preset.swift
//  Timer
//
//  Created by Maslov Sergey on 03.03.16.
//  Copyright © 2016 Home. All rights reserved.
//

import Foundation

struct Preset {
    
    var title: String = ""
    var description: String = ""
    
    var value: String? = nil
    var isTime = false
    var units: String = ""
    var lowLimit: String = "0"
    var highLimit: String = "10"
    var defaultValue: String = "00"
    
    
    static func preparePreset() -> Preset {
        var preset = Preset()
        preset.title = "Prepare"
        preset.description = "Countdown before you start"
        preset.isTime = false
        preset.units = "sec"
        preset.lowLimit = "0"
        preset.highLimit = "59"
        preset.defaultValue = "10"
        return preset
    }
    
    static func timeCapPreset() -> Preset {
        var preset = Preset()
        preset.title = "Time Cap"
        preset.description = "Clock will stop at this time"
        preset.isTime = true
        preset.lowLimit = "00:00"
        preset.highLimit = "90:59"
        preset.defaultValue = "30:00"
        return preset
    }
    
    static func startTimePreset() -> Preset {
        var preset = Preset()
        preset.title = "Start time"
        preset.description = "Total duration of workout"
        preset.isTime = true
        preset.lowLimit = "00:00"
        preset.highLimit = "90:59"
        preset.defaultValue = "30:00"
        return preset
    }
    
    static func workPreset() -> Preset {
        var preset = Preset()
        preset.title = "Work"
        preset.description = "Do exercise for this long"
        preset.isTime = true
        preset.lowLimit = "00:00"
        preset.highLimit = "90:59"
        preset.defaultValue = "30:00"
        return preset
    }
    
    static func restPreset() -> Preset {
        var preset = Preset()
        preset.title = "Rest"
        preset.description = "Rest for this long"
        preset.isTime = true
        preset.lowLimit = "00:00"
        preset.highLimit = "90:59"
        preset.defaultValue = "30:00"
        return preset
    }
    
    static func roundsPreset() -> Preset {
        var preset = Preset()
        preset.title = "Rounds"
        preset.description = "One round is Work + Rest"
        preset.lowLimit = "1"
        preset.highLimit = "90"
        preset.defaultValue = "1"
        return preset
    }
    
    static func cyclesPreset() -> Preset {
        var preset = Preset()
        preset.title = "Cycles"
        preset.description = "One cycle in %d round"
        preset.lowLimit = "1"
        preset.highLimit = "90"
        preset.defaultValue = "1"
        return preset
    }
    
    static func restBetweenCyclesPreset() -> Preset {
        var preset = Preset()
        preset.title = "Rest between Cycles"
        preset.description = "Recovery Interval"
        preset.isTime = true
        preset.lowLimit = "00:00"
        preset.highLimit = "60:59"
        preset.defaultValue = "00:00"
        return preset
    }
}
