//
//  ContentView.swift
//  PirateMath
//
//  Created by Mac on 10/07/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    
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
                        options: [("5", 5), ("10", 10), ("20", 20)],
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
            HStack {
                Button(action: {
                    viewModel.showStopGameAlert = true
                }) {
                    Text("Exit game")
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                HStack(spacing: 10) {
                    // Green circle for correct answers
                    ZStack {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 30, height: 30)
                        Text("\(viewModel.score)")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .bold))
                    }
                    
                    // Red circle for incorrect answers
                    ZStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 30, height: 30)
                        Text("\(viewModel.questions.count - viewModel.score)")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .bold))
                    }
                }
            }
            .padding()
            
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    .fill(Color.white.opacity(0.1))
                    .shadow(radius: 5)
                
                VStack {
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
                        .frame(width: 160, height: 50)
                        .background(backgroundColor)
                        .cornerRadius(10)
                }
            }
            .padding()
            
            NumberPad(enteredAmount: $viewModel.userAnswer) {
                viewModel.checkAnswer()
            }
            
            Spacer()
        }
        .padding()
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
            return Color.green
        case .incorrect:
            return Color.red
        }
    }
    
    var gameOverView: some View {
        VStack(spacing: 20) {
            Text("Game Over!")
                .font(.title)
            Text("Your score: \(viewModel.score) / \(viewModel.questions.count)")
            
            Button("Play Again") {
                viewModel.questions = []
            }
        }
    }
}

class ViewModel: ObservableObject {
    @Published var numberOfQuestions = 5
}

#Preview {
    ContentView()
}
