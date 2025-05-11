//
//  Helper.swift
//  App
//
//  Created by Ali An Nuur on 11/05/25.
//

import Foundation

func logScalePercentage(value: Double, ymin: Double = 1, ymax: Double = 200, base: Double = 20) -> Double {
    guard value > 0 else { return 0 }

    let logVal = log(value) / log(base)
    let logYMin = log(ymin) / log(base)
    let logYMax = log(ymax) / log(base)

    let percentage = (logVal - logYMin) / (logYMax - logYMin) * 100
    return percentage
}
