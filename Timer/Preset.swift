//
//  Preset.swift
//  Timer
//
//  Created by Maslov Sergey on 03.03.16.
//  Copyright © 2016 Home. All rights reserved.
//

import Foundation

struct IntPreset {
    var value: Int = 0
    var low: Int = 0
    var high: Int = 0
    init() {
        self.value = 0
        self.low = 0
        self.high = 0
    }
    
    init(value: Int, low: Int, high: Int) {
        self.value = value
        self.low = low
        self.high = high
    }
    
    var length: Int {
        return high - low + 1
    }
    
    var valueForRow: Int {
        return value - low
    }
    
    static func MinutePreset() -> IntPreset {
        return IntPreset(value: 5, low: 0, high: 90)
    }
    
    static func Minute60Preset() -> IntPreset {
        return IntPreset(value: 0, low: 0, high: 60)
    }
    
    static func SecondPreset() -> IntPreset {
        return IntPreset(value: 0, low: 0, high: 59)
    }
}

enum PresetType {
    case intType(unit: IntPreset)
    case timeType(min: IntPreset, sec: IntPreset)
}

struct Preset {
    var type = PresetType.intType(unit: IntPreset(value: 0, low: 0, high: 0))
    var title: String = ""
    var description: String = ""
    var units: String = ""
    var image: String? = nil
    var value: Int {
        switch type {
        case .intType(let unit):
            return unit.value
        case .timeType(let min, let sec):
            return min.value * 60 + sec.value
        }
    }
    
    static func preparePreset() -> Preset {
        var preset = Preset()
        preset.type = PresetType.intType(unit: IntPreset(value: 3, low: 3, high: 59))
        preset.title = "Prepare"
        preset.description = "Countdown before you start"
        preset.units = "sec"
        preset.image = "Meditation"
        return preset
    }
    
    static func timeCapPreset() -> Preset {
        var preset = Preset()
        preset.type = PresetType.timeType(min: IntPreset.MinutePreset(), sec: IntPreset.SecondPreset())
        //preset.type = PresetType.TimeType(min: IntPreset(value: 0, low: 0, high: 90), sec: IntPreset(value: 5, low: 0, high: 59))
        
        preset.title = "Time Cap"
        preset.description = "Clock will stop at this time"
        preset.image = "Run"
        return preset
    }
    
    static func startTimePreset() -> Preset {
        var preset = Preset()
        preset.type = PresetType.timeType(min: IntPreset.MinutePreset(), sec: IntPreset.SecondPreset())
        //preset.type = PresetType.TimeType(min: IntPreset(value: 0, low: 0, high: 90), sec: IntPreset(value: 5, low: 0, high: 59))
        preset.title = "Start time"
        preset.description = "Total duration of workout"
        preset.image = "Weightlift"
        return preset
    }
    
    static func workPreset() -> Preset {
        var preset = Preset()
        preset.type = PresetType.timeType(min: IntPreset(value: 0, low: 0, high: 10), sec: IntPreset(value: 4, low: 0, high: 59))
        preset.title = "Work"
        preset.description = "Do exercise for this long"
        preset.image = "Paddling"
        return preset
    }
    
    static func restPreset() -> Preset {
        var preset = Preset()
        preset.type = PresetType.timeType(min: IntPreset(value: 0, low: 0, high: 10), sec: IntPreset(value: 3, low: 0, high: 59))
        preset.title = "Rest"
        preset.description = "Rest for this long"
        preset.image = "Walking"
        return preset
    }
    
    static func roundsPreset() -> Preset {
        var preset = Preset()
        preset.type = PresetType.intType(unit: IntPreset(value: 2, low: 1, high: 90))
        preset.title = "Rounds"
        preset.description = "One round is Work + Rest"
        preset.image = "WorkRest"
        return preset
    }
    
    static func cyclesPreset() -> Preset {
        var preset = Preset()
        preset.type = PresetType.intType(unit: IntPreset(value: 6, low: 1, high: 90))
        preset.title = "Cycles"
        preset.description = "One cycle in several rounds"
        preset.image = "Cicles"
        return preset
    }
    
    static func restBetweenCyclesPreset() -> Preset {
        var preset = Preset()
        preset.type = PresetType.timeType(min: IntPreset(value: 0, low: 0, high: 10), sec: IntPreset(value: 5, low: 0, high: 59))
        preset.title = "Rest between Cycles"
        preset.description = "Recovery Interval"
        preset.image = "Drink"
        return preset
    }
}
