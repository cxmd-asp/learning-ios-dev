//
//  ViewController.swift
//  Quizzler-iOS13
//
//  Created by Angela Yu on 12/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!    
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!
    
   
    var quizBrain = QuizBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        questionLabel.text = quizBrain.getQuestionText()
        
    }

    @IBAction func answerButtonPressed(_ sender: UIButton) {
     
        
        if quizBrain.checkAnswer(userAnswer: sender.currentTitle!) {
            sender.backgroundColor = UIColor.green
        } else {
            sender.backgroundColor = UIColor.red
        }

        quizBrain.nextQuestion()
        
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
        
    }
    
    @objc func updateUI() {
  
        questionLabel.text = quizBrain.getQuestionText()
        
        trueButton.backgroundColor = UIColor.clear
        falseButton.backgroundColor = UIColor.clear
        
        progressBar.progress = quizBrain.getProgress()
    }
    
}

