//
//  HeartRateView.swift
//  App
//
//  Created by Muhammad Abid on 05/05/25.
//

import SwiftUI

struct SegmentControl: View {
    @State private var selected = "HR"
    let options = ["HR", "RHR", "HRV"]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                Text(option)
                    .fontWeight(.medium)
                    .foregroundColor(selected == option ? .white : .white.opacity(0.6))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selected == option ? Color.red : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .onTapGesture {
                        selected = option
                    }
            }
        }
        .padding(4)
        .background(Color.gray.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}


public struct HeartRateView: View {
    public var body: some View {
        
        VStack() {
            Text("Heart Rate")
            .padding()
            
            SegmentControl()
            Spacer()
        }
        
        
    }
}

#Preview {
    HeartRateView()
}
