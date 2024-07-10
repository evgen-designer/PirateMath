//
//  CustomGridButton.swift
//  PirateMath
//
//  Created by Mac on 10/07/2024.
//

import SwiftUI

struct CustomGridButton: View {
    let number: Int
    let isSelected: Bool
    let action: () -> Void
    let image: String
    let imageSelected: String
    
    var body: some View {
        Button(action: action) {
                    if isSelected {
                        Image("\(imageSelected)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                    } else {
                        Image("\(image)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                    }
                }
                .frame(width: 110, height: 70)
                .background(isSelected ? Color.white.opacity(0.5) : Color.white.opacity(0.2))
                .foregroundColor(isSelected ? .black : .white)
                .cornerRadius(10)
    }
}
