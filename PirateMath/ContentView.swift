//
//  ContentView.swift
//  PirateMath
//
//  Created by Mac on 10/07/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var showPerfectScorePopup = false
    
    let images = [
        "01", "02", "03", "04", "05", "06",
        "07", "08", "09", "10", "11", "12"
    ]
    
    let imagesSelected = [
        "01-selected", "02-selected", "03-selected", "04-selected", "05-selected", "06-selected",
        "07-selected", "08-selected", "09-selected", "10-selected", "11-selected", "12-selected"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [.indigo, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [.red, .blue, .mint, .yellow]),
                                center: .center,
                                startRadius: 50,
                                endRadius: 150
                            )
                        )
                        .frame(width: 300, height: 300)
                        .blur(radius: 30)
                        .opacity(0.3)
                    
                        .offset(y: -40)
                    
                    Spacer()
                }
                
                VStack {
                    if viewModel.questions.isEmpty {
                        setupView
                    } else if !viewModel.gameOver {
                        gameView
                    } else {
                        gameOverView
                    }
                }
            }
        }
    }
    
    var setupView: some View {
        VStack(spacing: 30) {
            VStack {
                HStack {
                    Image("pirate-math").resizable()
                        .scaledToFit()
                        .frame(height: 120)
                }
                .padding(30)
                
                VStack(spacing: 20) {
                    Text("Select number of questions:")
                        .foregroundStyle(.white)
                    
                    CustomSegmentedPicker(
                        selection: $viewModel.numberOfQuestions,
                        options: [("5", 5), ("10", 10), ("15", 15)],
                        chosenTextColor: .black,
                        chosenBackgroundColor: .white.opacity(0.7),
                        unchosenTextColor: .white,
                        unchosenBackgroundColor: .white.opacity(0.2)
                    )
                    .padding(.horizontal, 4)
                }
            }
            
            VStack(spacing: 20) {
                Text("Select multiplication table:")
                    .foregroundStyle(.white)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                    ForEach(1...12, id: \.self) { table in
                        CustomGridButton(
                            number: table,
                            isSelected: viewModel.selectedTable == table,
                            action: { viewModel.selectTable(table) },
                            image: images[table - 1],
                            imageSelected: imagesSelected[table - 1]
                        )
                    }
                }
                .frame(maxWidth: .infinity)
            }
            
            StartButton(isDisabled: viewModel.isStartGameDisabled) {
                viewModel.generateQuestions()
            }
        }
        .padding()
    }
    
    var gameView: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    .fill(Color.white.opacity(0.1))
                    .shadow(radius: 5)
                
                VStack {
                    HStack(alignment: .top) {
                        Button(action: {
                            viewModel.showStopGameAlert = true
                        }) {
                            Text("Exit game")
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.1059, green: 0.7412, blue: 0.4431))
                                    .frame(width: 30, height: 30)
                                Text("\(viewModel.score)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                            }
                            
                            ZStack {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 30, height: 30)
                                Text("\(viewModel.incorrectScore)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    if let selectedTable = viewModel.selectedTable {
                        Image(imagesSelected[selectedTable - 1])
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                    }
                    
                    Text(viewModel.questions[viewModel.currentQuestionIndex].text)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                    
                    Text(viewModel.userAnswer)
                        .font(.title2)
                        .foregroundColor(.black)
                        .frame(width: 160, height: 50)
                        .background(backgroundColor)
                        .cornerRadius(10)
                }
            }
            .padding()
            .frame(height: 360)
            
            Spacer()
            
            NumberPad(enteredAmount: $viewModel.userAnswer) {
                viewModel.checkAnswer()
            }
            .padding(.bottom)
            
            Spacer()
            
        }
        .alert(isPresented: $viewModel.showStopGameAlert) {
            Alert(
                title: Text("Exit game"),
                message: Text("Are you sure you want to stop the game and exit?"),
                primaryButton: .destructive(Text("Yes")) {
                    viewModel.stopGame()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    var backgroundColor: Color {
        switch viewModel.answerStatus {
        case .neutral:
            return Color.white.opacity(0.4)
        case .correct:
            return Color(red: 0.1059, green: 0.7412, blue: 0.4431)
        case .incorrect:
            return Color.red
        }
    }
    
    var gameOverView: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Game over!")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Text("Your score: \(viewModel.score) / \(viewModel.questions.count)")
                        .font(.body.bold())
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(backgroundColor)
                        .cornerRadius(10)
                    
                    Divider()
                        .background(Color.white)
                    
                    ForEach(viewModel.questions) { question in
                        HStack {
                            Text(question.text)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            if let userAnswer = question.userAnswer {
                                Text("Your answer: \(userAnswer)")
                                    .foregroundColor(.white)
                                
                                Rectangle()
                                    .frame(width: 1)
                                    .foregroundColor(Color.white.opacity(0.25))
                                    .padding(.horizontal, 4)
                                
                                ZStack {
                                    Circle()
                                        .fill(question.isCorrect ? Color(red: 0.1059, green: 0.7412, blue: 0.4431) : Color.red)
                                        .frame(width: 24, height: 24)
                                    Image(systemName: question.isCorrect ? "checkmark" : "xmark")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .bold))
                                }
                            } else {
                                Text("Unanswered")
                                    .foregroundColor(.yellow)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                    }
                    
                    Spacer().frame(height: 70)
                }
                .padding()
            }
            
            Button(action: {
                viewModel.resetGame()
            }) {
                Text("PLAY AGAIN")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .padding()
                    .frame(minWidth: 200)
                    .background(Color(red: 0.0745, green: 0.5961, blue: 1))
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .onAppear {
            if viewModel.score == viewModel.questions.count {
                withAnimation(.easeInOut) {
                    showPerfectScorePopup = true
                }
            }
        }
        .overlay(
            Group {
                if showPerfectScorePopup {
                    perfectScorePopup
                        .animation(.easeInOut, value: showPerfectScorePopup)
                }
            }
        )
    }
    
    var perfectScorePopup: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Perfect score: Tap coin!")
                    .font(.title.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding()
                
                Text("Congratulations! You answered all questions correctly. Now try your luck by tapping the coin.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                SpinCoin()
                    .padding(.top, -20)
                
                Button(action: {
                    showPerfectScorePopup = false
                }) {
                    Text("OK")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .padding()
                        .frame(minWidth: 100)
                        .background(Color(red: 0.0745, green: 0.5961, blue: 1))
                        .cornerRadius(10)
                }
                .padding(.bottom, 20)
            }
            .padding()
            .background(Color.indigo)
            .cornerRadius(20)
            .padding(40)
        }
        .transition(.opacity)
    }
}

class ViewModel: ObservableObject {
    @Published var numberOfQuestions = 5
}

#Preview {
    ContentView()
}
