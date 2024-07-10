//
//  Question.swift
//  PirateMath
//
//  Created by Mac on 10/07/2024.
//

import Foundation

struct Question: Identifiable {
    let id = UUID()
    let text: String
    let answer: Int
}
