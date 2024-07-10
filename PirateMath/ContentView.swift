//
//  ContentView.swift
//  PirateMath
//
//  Created by Mac on 10/07/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.questions.isEmpty {
                    setupView
                } else if !viewModel.gameOver {
                    gameView
                } else {
                    gameOverView
                }
            }
            .navigationTitle("Pirate Math")
        }
    }
    
    var setupView: some View {
        VStack(spacing: 20) {
            Text("Select multiplication tables:")
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                ForEach(1...12, id: \.self) { table in
                    Button(action: { viewModel.toggleTable(table) }) {
                        Text("\(table)")
                            .frame(width: 50, height: 50)
                            .background(viewModel.selectedTables.contains(table) ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            
            Picker("Number of questions", selection: $viewModel.numberOfQuestions) {
                Text("5").tag(5)
                Text("10").tag(10)
                Text("20").tag(20)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Button("Start Game") {
                viewModel.generateQuestions()
            }
            .disabled(viewModel.selectedTables.isEmpty)
        }
        .padding()
    }
    
    var gameView: some View {
        VStack(spacing: 20) {
            Text(viewModel.questions[viewModel.currentQuestionIndex].text)
                .font(.title)
            
            TextField("Your answer", text: $viewModel.userAnswer)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .frame(width: 100)
            
            Button("Submit") {
                viewModel.checkAnswer()
            }
            
            Text("Score: \(viewModel.score)")
        }
        .padding()
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

#Preview {
    ContentView()
}
