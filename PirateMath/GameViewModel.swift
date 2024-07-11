//
//  GameViewModel.swift
//  PirateMath
//
//  Created by Mac on 10/07/2024.
//

import Foundation

class GameViewModel: ObservableObject {
    @Published var selectedTables: Set<Int> = []
    @Published var numberOfQuestions = 10
    @Published var questions: [Question] = []
    @Published var currentQuestionIndex = 0
    @Published var userAnswer = ""
    @Published var score = 0
    @Published var incorrectScore = 0
    @Published var gameOver = false
    @Published var answerStatus: AnswerStatus = .neutral
    @Published var selectedTable: Int? = nil
    @Published var showStopGameAlert = false
    
    enum AnswerStatus {
        case neutral, correct, incorrect
    }
    
    func toggleTable(_ table: Int) {
        if selectedTables.contains(table) {
            selectedTables.remove(table)
        } else {
            selectedTables.insert(table)
        }
    }
    
    func selectTable(_ table: Int) {
        if selectedTable == table {
            selectedTable = nil
        } else {
            selectedTable = table
        }
    }
    
    var isStartGameDisabled: Bool {
        return selectedTable == nil
    }
    
    func generateQuestions() {
            guard let selectedTable = selectedTable else {
                print("No table selected")
                return
            }
            
            questions = []
            for _ in 0..<numberOfQuestions {
                let multiplier = Int.random(in: 1...12)
                let question = Question(text: "What is \(selectedTable) x \(multiplier)?", answer: selectedTable * multiplier)
                questions.append(question)
            }
            currentQuestionIndex = 0
            score = 0
            incorrectScore = 0
            gameOver = false
        }
    
    func checkAnswer() {
        guard currentQuestionIndex < questions.count, !userAnswer.isEmpty else { return }
            questions[currentQuestionIndex].userAnswer = Int(userAnswer)
        if Int(userAnswer) == questions[currentQuestionIndex].answer {
            score += 1
            answerStatus = .correct
        } else {
            incorrectScore += 1
            answerStatus = .incorrect
        }
        
        // Reset answer status after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.answerStatus = .neutral
            self.nextQuestion()
        }
    }
    
    func nextQuestion() {
        currentQuestionIndex += 1
        userAnswer = ""
        if currentQuestionIndex >= questions.count {
            gameOver = true
        }
    }
    
    func stopGame() {
            questions = []
            currentQuestionIndex = 0
            userAnswer = ""
            score = 0
            incorrectScore = 0
            gameOver = false
            selectedTable = nil
        }
    
    func resetGame() {
        questions = []
        currentQuestionIndex = 0
        userAnswer = ""
        score = 0
        incorrectScore = 0
        gameOver = false
        selectedTable = nil
    }
}
