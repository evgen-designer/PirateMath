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
    @Published var gameOver = false
    
    func toggleTable(_ table: Int) {
        if selectedTables.contains(table) {
            selectedTables.remove(table)
        } else {
            selectedTables.insert(table)
        }
    }
    
    func generateQuestions() {
        questions = []
        for _ in 0..<numberOfQuestions {
            let table = selectedTables.randomElement() ?? 1
            let multiplier = Int.random(in: 1...12)
            let question = Question(text: "What is \(table) x \(multiplier)?", answer: table * multiplier)
            questions.append(question)
        }
        currentQuestionIndex = 0
        score = 0
        gameOver = false
    }
    
    func checkAnswer() {
        guard currentQuestionIndex < questions.count else { return }
        if Int(userAnswer) == questions[currentQuestionIndex].answer {
            score += 1
        }
        nextQuestion()
    }
    
    func nextQuestion() {
        currentQuestionIndex += 1
        userAnswer = ""
        if currentQuestionIndex >= questions.count {
            gameOver = true
        }
    }
}
