//
//  NumberPad.swift
//  PirateMath
//
//  Created by Mac on 10/07/2024.
//

import SwiftUI

struct NumberPad: View {
    @Binding var enteredAmount: String
    var onSubmit: () -> Void
    
    let buttons: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["", "0", "⌫"]
    ]
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { button in
                        if button == "" {
                            SubmitButton(action: onSubmit, isDisabled: enteredAmount.isEmpty)
                        } else {
                            NumberButton(title: button, action: {
                                self.buttonTapped(button)
                            })
                        }
                    }
                }
            }
        }
    }
    
    private func buttonTapped(_ button: String) {
        switch button {
        case "⌫":
            if !enteredAmount.isEmpty {
                enteredAmount.removeLast()
            }
        default:
            if enteredAmount == "0" {
                enteredAmount = button
            } else {
                enteredAmount += button
            }
        }
    }
}

struct NumberButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title)
                .frame(width: 70, height: 70)
                .background(Color.white.opacity(0.2))
                .foregroundColor(.white)
                .cornerRadius(35)
        }
    }
}

struct SubmitButton: View {
    let action: () -> Void
    let isDisabled: Bool
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "checkmark")
                .font(.title)
                .frame(width: 70, height: 70)
                .background(Color(red: 0.1059, green: 0.7412, blue: 0.4431))
                .foregroundColor(.white)
                .cornerRadius(35)
        }
        .opacity(isDisabled ? 0.4 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isDisabled)
    }
}
