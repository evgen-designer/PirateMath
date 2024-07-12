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
            
            if showsFront {
                Image("skull-icon")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.5)
                    .frame(width: 60, height: 60)
            } else {
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.black.opacity(0.5))
                    .frame(width: 60, height: 60)
            }
        }
        .rotation3DEffect(.degrees(rotationDegrees), axis: (x: 0, y: 1, z: 0))
    }
}

struct ResultView: View {
    let isWin: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(isWin ? Color(red: 0.1059, green: 0.7412, blue: 0.4431) : Color.red)
            
            Text(isWin ? "YOU WON" : "YOU LOST")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(width: 100, height: 40)
    }
}

struct SkullIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        
        path.move(to: CGPoint(x: 0.80446*width, y: 0.7247*height))
        path.addCurve(to: CGPoint(x: 0.93839*width, y: 0.66219*height), control1: CGPoint(x: 0.84312*width, y: 0.71191*height), control2: CGPoint(x: 0.88931*width, y: 0.69664*height))
        path.addCurve(to: CGPoint(x: 0.80675*width, y: 0.05424*height), control1: CGPoint(x: 1.07963*width, y: 0.56351*height), control2: CGPoint(x: 0.9446*width, y: 0.18206*height))
        path.addCurve(to: CGPoint(x: 0.18076*width, y: 0.10391*height), control1: CGPoint(x: 0.7028*width, y: -0.04179*height), control2: CGPoint(x: 0.29941*width, y: 0.0006*height))
        path.addCurve(to: CGPoint(x: 0.00167*width, y: 0.54762*height), control1: CGPoint(x: 0.05816*width, y: 0.21053*height), control2: CGPoint(x: -0.01189*width, y: 0.43835*height))
        path.addCurve(to: CGPoint(x: 0.11037*width, y: 0.65902*height), control1: CGPoint(x: 0.00872*width, y: 0.60384*height), control2: CGPoint(x: 0.05874*width, y: 0.63099*height))
        path.addCurve(to: CGPoint(x: 0.22199*width, y: 0.75497*height), control1: CGPoint(x: 0.15565*width, y: 0.6836*height), control2: CGPoint(x: 0.20216*width, y: 0.70885*height))
        path.addLine(to: CGPoint(x: 0.73397*width, y: 0.75497*height))
        path.addCurve(to: CGPoint(x: 0.80446*width, y: 0.7247*height), control1: CGPoint(x: 0.75234*width, y: 0.74194*height), control2: CGPoint(x: 0.77642*width, y: 0.73397*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.71863*width, y: 0.7947*height))
        path.addLine(to: CGPoint(x: 0.23081*width, y: 0.7947*height))
        path.addCurve(to: CGPoint(x: 0.20687*width, y: 0.88503*height), control1: CGPoint(x: 0.22779*width, y: 0.81561*height), control2: CGPoint(x: 0.21715*width, y: 0.85091*height))
        path.addLine(to: CGPoint(x: 0.20687*width, y: 0.88504*height))
        path.addCurve(to: CGPoint(x: 0.19263*width, y: 0.93371*height), control1: CGPoint(x: 0.20169*width, y: 0.90223*height), control2: CGPoint(x: 0.1966*width, y: 0.91912*height))
        path.addCurve(to: CGPoint(x: 0.18528*width, y: 0.97212*height), control1: CGPoint(x: 0.18811*width, y: 0.95093*height), control2: CGPoint(x: 0.18472*width, y: 0.96483*height))
        path.addCurve(to: CGPoint(x: 0.52314*width, y: 0.98073*height), control1: CGPoint(x: 0.18585*width, y: 0.99*height), control2: CGPoint(x: 0.47681*width, y: 0.98338*height))
        path.addLine(to: CGPoint(x: 0.52539*width, y: 0.98073*height))
        path.addCurve(to: CGPoint(x: 0.535*width, y: 0.97675*height), control1: CGPoint(x: 0.52878*width, y: 0.98029*height), control2: CGPoint(x: 0.53199*width, y: 0.97897*height))
        path.addCurve(to: CGPoint(x: 0.54799*width, y: 0.95689*height), control1: CGPoint(x: 0.54008*width, y: 0.97278*height), control2: CGPoint(x: 0.5446*width, y: 0.9655*height))
        path.addCurve(to: CGPoint(x: 0.54969*width, y: 0.95358*height), control1: CGPoint(x: 0.54837*width, y: 0.95556*height), control2: CGPoint(x: 0.54894*width, y: 0.95446*height))
        path.addCurve(to: CGPoint(x: 0.55873*width, y: 0.92113*height), control1: CGPoint(x: 0.55308*width, y: 0.94364*height), control2: CGPoint(x: 0.5559*width, y: 0.93238*height))
        path.addCurve(to: CGPoint(x: 0.55986*width, y: 0.91517*height), control1: CGPoint(x: 0.55911*width, y: 0.91936*height), control2: CGPoint(x: 0.55948*width, y: 0.91738*height))
        path.addCurve(to: CGPoint(x: 0.56042*width, y: 0.9145*height), control1: CGPoint(x: 0.56024*width, y: 0.91517*height), control2: CGPoint(x: 0.56042*width, y: 0.91495*height))
        path.addCurve(to: CGPoint(x: 0.56212*width, y: 0.90457*height), control1: CGPoint(x: 0.56118*width, y: 0.91142*height), control2: CGPoint(x: 0.56174*width, y: 0.90811*height))
        path.addCurve(to: CGPoint(x: 0.56438*width, y: 0.89464*height), control1: CGPoint(x: 0.56287*width, y: 0.90148*height), control2: CGPoint(x: 0.56362*width, y: 0.89817*height))
        path.addCurve(to: CGPoint(x: 0.5672*width, y: 0.88073*height), control1: CGPoint(x: 0.56551*width, y: 0.88978*height), control2: CGPoint(x: 0.56645*width, y: 0.88515*height))
        path.addCurve(to: CGPoint(x: 0.57059*width, y: 0.86417*height), control1: CGPoint(x: 0.56833*width, y: 0.87499*height), control2: CGPoint(x: 0.56946*width, y: 0.86947*height))
        path.addCurve(to: CGPoint(x: 0.57116*width, y: 0.86219*height), control1: CGPoint(x: 0.57097*width, y: 0.86329*height), control2: CGPoint(x: 0.57116*width, y: 0.86263*height))
        path.addCurve(to: CGPoint(x: 0.57285*width, y: 0.85623*height), control1: CGPoint(x: 0.57191*width, y: 0.85998*height), control2: CGPoint(x: 0.57247*width, y: 0.85799*height))
        path.addCurve(to: CGPoint(x: 0.58133*width, y: 0.83967*height), control1: CGPoint(x: 0.57568*width, y: 0.84762*height), control2: CGPoint(x: 0.57794*width, y: 0.84232*height))
        path.addCurve(to: CGPoint(x: 0.59037*width, y: 0.85026*height), control1: CGPoint(x: 0.58528*width, y: 0.83636*height), control2: CGPoint(x: 0.58811*width, y: 0.84099*height))
        path.addCurve(to: CGPoint(x: 0.5915*width, y: 0.85755*height), control1: CGPoint(x: 0.59075*width, y: 0.85248*height), control2: CGPoint(x: 0.59112*width, y: 0.8549*height))
        path.addCurve(to: CGPoint(x: 0.59638*width, y: 0.90538*height), control1: CGPoint(x: 0.59357*width, y: 0.87018*height), control2: CGPoint(x: 0.59495*width, y: 0.88753*height))
        path.addLine(to: CGPoint(x: 0.59638*width, y: 0.90538*height))
        path.addLine(to: CGPoint(x: 0.59638*width, y: 0.90538*height))
        path.addCurve(to: CGPoint(x: 0.60788*width, y: 0.98073*height), control1: CGPoint(x: 0.59885*width, y: 0.93622*height), control2: CGPoint(x: 0.60144*width, y: 0.96857*height))
        path.addCurve(to: CGPoint(x: 0.60901*width, y: 0.98272*height), control1: CGPoint(x: 0.60826*width, y: 0.98162*height), control2: CGPoint(x: 0.60863*width, y: 0.98228*height))
        path.addLine(to: CGPoint(x: 0.61014*width, y: 0.98404*height))
        path.addCurve(to: CGPoint(x: 0.61862*width, y: 0.98868*height), control1: CGPoint(x: 0.61165*width, y: 0.98581*height), control2: CGPoint(x: 0.61447*width, y: 0.98735*height))
        path.addCurve(to: CGPoint(x: 0.77963*width, y: 0.98404*height), control1: CGPoint(x: 0.65477*width, y: 1.00126*height), control2: CGPoint(x: 0.77624*width, y: 0.99464*height))
        path.addCurve(to: CGPoint(x: 0.77511*width, y: 0.96285*height), control1: CGPoint(x: 0.7802*width, y: 0.98139*height), control2: CGPoint(x: 0.7785*width, y: 0.97411*height))
        path.addCurve(to: CGPoint(x: 0.74784*width, y: 0.8818*height), control1: CGPoint(x: 0.76908*width, y: 0.94293*height), control2: CGPoint(x: 0.75853*width, y: 0.91256*height))
        path.addLine(to: CGPoint(x: 0.74784*width, y: 0.88179*height))
        path.addLine(to: CGPoint(x: 0.74784*width, y: 0.88179*height))
        path.addCurve(to: CGPoint(x: 0.71863*width, y: 0.7947*height), control1: CGPoint(x: 0.73651*width, y: 0.84921*height), control2: CGPoint(x: 0.72503*width, y: 0.81618*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.59093*width, y: 0.15888*height))
        path.addCurve(to: CGPoint(x: 0.59489*width, y: 0.42841*height), control1: CGPoint(x: 0.53161*width, y: 0.20126*height), control2: CGPoint(x: 0.53952*width, y: 0.36749*height))
        path.addCurve(to: CGPoint(x: 0.85647*width, y: 0.34563*height), control1: CGPoint(x: 0.67398*width, y: 0.51583*height), control2: CGPoint(x: 0.89206*width, y: 0.51451*height))
        path.addCurve(to: CGPoint(x: 0.59093*width, y: 0.15888*height), control1: CGPoint(x: 0.82201*width, y: 0.1847*height), control2: CGPoint(x: 0.64969*width, y: 0.11715*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.41353*width, y: 0.42841*height))
        path.addCurve(to: CGPoint(x: 0.14517*width, y: 0.4761*height), control1: CGPoint(x: 0.39206*width, y: 0.46484*height), control2: CGPoint(x: 0.20562*width, y: 0.5198*height))
        path.addCurve(to: CGPoint(x: 0.33726*width, y: 0.18868*height), control1: CGPoint(x: 0.08584*width, y: 0.43305*height), control2: CGPoint(x: 0.19319*width, y: 0.18868*height))
        path.addCurve(to: CGPoint(x: 0.41353*width, y: 0.42841*height), control1: CGPoint(x: 0.45703*width, y: 0.18868*height), control2: CGPoint(x: 0.4446*width, y: 0.37676*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.5141*width, y: 0.59596*height))
        path.addCurve(to: CGPoint(x: 0.49715*width, y: 0.45623*height), control1: CGPoint(x: 0.49997*width, y: 0.5847*height), control2: CGPoint(x: 0.48641*width, y: 0.45888*height))
        path.addCurve(to: CGPoint(x: 0.59376*width, y: 0.59133*height), control1: CGPoint(x: 0.51579*width, y: 0.45159*height), control2: CGPoint(x: 0.61353*width, y: 0.57543*height))
        path.addCurve(to: CGPoint(x: 0.5141*width, y: 0.59596*height), control1: CGPoint(x: 0.57455*width, y: 0.60722*height), control2: CGPoint(x: 0.52822*width, y: 0.60788*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.48641*width, y: 0.45888*height))
        path.addCurve(to: CGPoint(x: 0.39376*width, y: 0.58205*height), control1: CGPoint(x: 0.48641*width, y: 0.44696*height), control2: CGPoint(x: 0.38867*width, y: 0.54894*height))
        path.addCurve(to: CGPoint(x: 0.47342*width, y: 0.58934*height), control1: CGPoint(x: 0.39884*width, y: 0.61451*height), control2: CGPoint(x: 0.45082*width, y: 0.61053*height))
        path.addCurve(to: CGPoint(x: 0.48673*width, y: 0.46518*height), control1: CGPoint(x: 0.49284*width, y: 0.57066*height), control2: CGPoint(x: 0.48812*width, y: 0.48923*height))
        path.addCurve(to: CGPoint(x: 0.48641*width, y: 0.45888*height), control1: CGPoint(x: 0.48654*width, y: 0.46194*height), control2: CGPoint(x: 0.48641*width, y: 0.45974*height))
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    SpinCoin()
}
