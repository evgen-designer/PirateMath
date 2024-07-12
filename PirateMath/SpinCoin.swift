//
//  SpinCoin.swift
//  PirateMath
//
//  Created by Mac on 11/07/2024.
//

import SwiftUI

struct SpinCoin: View {
    @State private var rotationDegrees = 0.0
    @State private var isSpinning = false
    @State private var showsFront = true
    @State private var showResult = false
    @State private var isWin = false
    @State private var hasSpun = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [.red, .blue, .green, .yellow]),
                        center: .center,
                        startRadius: 50,
                        endRadius: 150
                    )
                )
                .frame(width: 200, height: 200)
                .blur(radius: 30)
            
            VStack(spacing: -10) {
                ZStack {
                    CoinView(rotationDegrees: $rotationDegrees, showsFront: $showsFront)
                        .padding(50)
                        .onTapGesture {
                            if !isSpinning && !hasSpun {
                                spinCoin()
                            }
                        }
                    
                    if showResult {
                        ResultView(isWin: isWin)
                            .offset(y: -65)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        RadialGradient(gradient: Gradient(colors: [Color.black.opacity(0.5), Color.black.opacity(0)]), center: .center, startRadius: 0, endRadius: 70)
                    )
                    .frame(width: 150, height: 5)
            }
        }
    }
    
    func spinCoin() {
        isSpinning = true
        showResult = false
        let spinCount = Int.random(in: 5...10)
        let totalRotation = Double(spinCount) * 180
        
        withAnimation(.easeInOut(duration: 2).repeatCount(1, autoreverses: false)) {
            rotationDegrees += totalRotation
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isWin = Bool.random()
            showsFront = !isWin
            isSpinning = false
            hasSpun = true
            
            withAnimation(.easeInOut(duration: 0.5)) {
                showResult = true
            }
        }
    }
}

struct CoinView: View {
    @Binding var rotationDegrees: Double
    @Binding var showsFront: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.yellow)
                .frame(width: 150, height: 150)
            
            Circle()
                .fill(Color.orange)
                .frame(width: 120, height: 120)
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.3), lineWidth: 4)
                        .blur(radius: 1)
                        .offset(x: 0, y: 0)
                        .mask(Circle().fill(LinearGradient(gradient: Gradient(colors: [Color.black, Color.clear]), startPoint: .topLeading, endPoint: .bottomTrailing)))
                )
            
            Image(systemName: showsFront ? "crown.fill" : "star.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.secondary)
                .frame(width: 60, height: 60)
        }
        .rotation3DEffect(.degrees(rotationDegrees), axis: (x: 0, y: 1, z: 0))
    }
}

struct ResultView: View {
    let isWin: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(isWin ? Color.mint : Color.red)
            
            Text(isWin ? "YOU WON" : "YOU LOST")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(width: 100, height: 40)
    }
}

#Preview {
    SpinCoin()
}
