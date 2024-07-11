//
//  StartButton.swift
//  PirateMath
//
//  Created by Mac on 10/07/2024.
//

import SwiftUI

struct StartButton: View {
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: {
            if !isDisabled {
                action()
            }
        }) {
            Text("START GAME")
                .font(.title3.bold())
                .frame(minWidth: 200)
                .padding()
                .background(Color.mint)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .opacity(isDisabled ? 0.4 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isDisabled)
    }
}
