//
//  Helper.swift
//  App
//
//  Created by Ali An Nuur on 11/05/25.
//

import Foundation
import SwiftUI

func logScalePercentage(value: Double, ymin: Double = 1, ymax: Double = 200, base: Double = 20) -> Double {
    guard value > 0 else { return 0 }
    
    let logVal = log(value) / log(base)
    let logYMin = log(ymin) / log(base)
    let logYMax = log(ymax) / log(base)
    
    let percentage = (logVal - logYMin) / (logYMax - logYMin) * 100
    return percentage
}

struct EnableSwipeBack: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        DispatchQueue.main.async {
            vc.navigationController?.interactivePopGestureRecognizer?.delegate = context.coordinator
            vc.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
        return vc
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    func makeCoordinator() -> Coordinator { Coordinator() }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    }
}



func styledText(from string: String) -> Text {
    var result = Text("")
    var current = string[...]
    
    while let rangeStart = current.range(of: "<b>"),
          let rangeEnd = current.range(of: "</b>") {
        
        // Plain text before the <b>
        let before = current[..<rangeStart.lowerBound]
        result = result + Text(String(before))
        
        // Bold text inside <b>...</b>
        let bold = current[rangeStart.upperBound..<rangeEnd.lowerBound]
        result = result + Text(String(bold)).bold()
        
        // Move to next chunk
        current = current[rangeEnd.upperBound...]
    }
    
    // Append any remaining plain text
    result = result + Text(String(current))
    
    return result
}
