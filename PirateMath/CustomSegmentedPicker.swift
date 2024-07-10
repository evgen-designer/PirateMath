//
//  CustomSegmentedPicker.swift
//  PirateMath
//
//  Created by Mac on 10/07/2024.
//

import SwiftUI

struct CustomSegmentedPicker: View {
    @Binding var selection: Int
    let options: [(String, Int)]
    
    let chosenTextColor: Color
    let chosenBackgroundColor: Color
    let unchosenTextColor: Color
    let unchosenBackgroundColor: Color
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options, id: \.1) { option in
                Button(action: {
                    selection = option.1
                }) {
                    Text(option.0)
                        .font(.title2.bold())
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selection == option.1 ? chosenBackgroundColor : unchosenBackgroundColor)
                        .foregroundColor(selection == option.1 ? chosenTextColor : unchosenTextColor)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(unchosenBackgroundColor, lineWidth: 1)
        )
    }
}
