//
//  StatusConditional.swift
//  App
//
//  Created by Muhammad Abid on 11/05/25.
//

import SwiftUI

func trainingLoadStatus(lastTrainingLoad: Int?) -> String {
    guard let load = lastTrainingLoad else {
        return "Missing"
    }
    
    // Define TRIMP thresholds for categorizing training load
    if load >= 100 {
        return "Hard"
    } else if load >= 50 {
        return "Normal"
    } else if load > 0 {
        return "Light"
    } else {
        return "Rest"
    }
}

func restingHeartRateStatus(currentHR: Int?, avgHR: Double?) -> String {
    guard let current = currentHR, let avgHR = avgHR else {
        return "Missing"
    }
    
    let avg = Int(avgHR)
    
    if current >= avg - 10 && current <= avg + 10 {
        return "Normal"
    } else if current > avg + 10 && current <= avg + 20 {
        return "Slightly High"
    } else if current > avg + 20 {
        return "High"
    } else {
        return "Missing"
    }
}


func SleepStatus(SleepAmount: Double?) -> String {
    guard let sleepamount = SleepAmount else {
        return "Missing"
    }
  
    if sleepamount < 21600.0 {
        return "Less"
    } else {
        return "Normal"
    }
}
