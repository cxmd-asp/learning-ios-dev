//
//  Question.swift
//  Quizzler-iOS13
//
//  Created by user238979 on 6/16/23.
//  Copyright © 2023 The App Brewery. All rights reserved.
//

import Foundation

struct Question {
    var question: String
    var answer: String
    
    init(q: String, a: String) {
        question = q
        answer = a
    }
}
